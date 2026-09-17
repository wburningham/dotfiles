---
root: false
targets:
  - '*'
description: Read-only git inspection with gt and cdd shell aliases
cursor:
  alwaysApply: true
  description: Read-only git inspection with gt and cdd shell aliases
  globs:
    - '**/*'
---
# Git and repository inspection (read-only)

Organization policy blocks `git` and bare `cd` in agent shells. Use `gt` and `cdd` instead. They're equivalent aliases.

These rules apply when you're **inspecting** the working tree or history, or when the user asks for a **commit message without committing**. They don't replace the separate rules for creating commits; those apply only when the user explicitly asks you to commit.

## Shell command aliases

- **ALWAYS** use `gt` instead of `git`
- **ALWAYS** use `cdd` instead of `cd`
- **NEVER** run `git` or bare `cd` in agent shell commands, even for read-only inspection

Read-only `gt` and `git` inspection commands are allowlisted in `settings.json` / `cli-config.json` (ex: `gt log *`, `git log *`). Run them without asking the user for approval. `gt log` covers any log invocation, including path filters such as `gt log --oneline -12 -- path/to/file.go`.

## When these rules apply

Use `gt` and `cdd` for:

- Reading repository state (status, diff, log, show)
- Drafting or reviewing a commit message when the user didn't ask you to commit
- Any task-specific skill that gathers git context without mutating (ex: `/commit-message`)
- Changing into a directory before running other shell commands

Don't use this section as permission to commit, stage, push, or otherwise mutate the repository.

## Gathering context (read-only)

When you need repository context, you can call multiple tools in one response. **ALWAYS run these shell commands in parallel** when they're independent:

- `gt status` - untracked files and staged vs unstaged changes
- `gt diff` - unstaged changes
- `gt diff --staged` - staged changes (run alongside `gt diff` when both matter)
- `gt log` - recent commit messages for style and history

For a specific revision or branch comparison:

- `gt show <rev>` - one commit's metadata and patch
- `gt log <base>...HEAD` - commits on the current branch since `<base>`
- `gt diff <base>...HEAD` - full diff against `<base>`

Use `cdd` to enter the repository (or subdirectory) before these commands when the shell isn't already there.

## Draft commit message only

When the user asks for a commit message, CL description, or message review **without** asking you to commit:

1. Run the parallel read-only commands above (at minimum `gt status`, `gt diff --staged`, and `gt log`)
2. Analyze staged changes (and unstaged if the user cares about them)
3. Output the drafted message in the response
4. **NEVER** run `gt add`, `gt commit`, `gt push`, or other mutating `gt` subcommands unless the user explicitly asks you to create the commit

If the user later asks you to commit, switch to the committing workflow and still use `gt` (not `git`) for every git command.

## Important notes

- Read-only inspection doesn't require the user's permission. Use `gt status`, `gt diff`, `gt log`, `gt show`, and path-scoped history such as `gt log --oneline -12 -- path/to/file`
- **NEVER** use `gt` commands with the `-i` flag (ex: `gt rebase -i`, `gt add -i`); interactive input isn't supported
- Don't push to the remote unless the user explicitly asks
- When a task-specific skill (ex: `/commit-message`) is active, its format and workflow apply; this section governs which shell commands to use
