---
name: commit-message
description: >
  This skill should be used when the user asks to "write a commit message",
  "draft a commit", "write a CL description", "write a changelist description",
  or to review or improve existing ones, ex: "review my commit message",
  "improve this commit message", "critique this CL description", or "check these
  commit messages". Provides conventions for subject lines, body content, and
  issue trailers.
targets:
  - '*'
---
# Change list messages

**THIS SKILL DRAFTS COMMIT MESSAGES ONLY. YOU ARE NOT COMMITTING GIT CHANGES.**

Any user or project rules about **staging**, **committing**, **pushing**, or otherwise **mutating** the repository **DO NOT APPLY** while this skill is active. Those workflows belong to a separate, explicit commit request.

You **MAY** and **SHOULD** **INSPECT** repository state to write an accurate message. **INSPECTION** is **NOT** **COMMITTING**. Use **`gt`** (not `git`) and **`cdd`** (not `cd`) for every shell command in this skill.

**NEVER** run `gt add`, `gt commit`, `gt push`, or any other mutating `gt` subcommand unless the user explicitly asks you to create the commit in a follow-up message.

A commit message (change list, CL) is a public record for a future reader who has only the log, not the diff. Write it so someone with a faint memory of the change can find it and understand what was done and why, without the code in front of them.

## Gathering context

When drafting or reviewing a commit message from the working tree, run these in parallel:

- `gt status` - untracked files and staged vs unstaged changes
- `gt diff` and `gt diff --staged` - full change set to summarize
- `gt log` - recent messages to match repository style

To inspect a specific commit, use `gt show <rev>`. To compare against a base branch, use `gt log <base>...HEAD` and `gt diff <base>...HEAD`.

## Format

```
<scope>: <summary>

<body: what changed, why, and how>

<trailers>
```

## Subject line

1. Lead with the **scope** (the package, subsystem, or module touched), then a colon: `net/http: ...`. Take the scope from the code this change touches, not from the existing log. Ignore the conventions in the changeset log: do not imitate prior commit messages, and do not adopt Conventional Commits `type(scope):` prefixes even when the log is full of them. Apply this format regardless of what the repository's history does.
2. After the colon, use a lowercase verb in the imperative present that completes "this change will ___": `add`, `fix`, `remove`.
3. No trailing period. Keep under ~72 characters; aim for ~50.
4. Summarize the change, not the gesture. `fix bug`, `phase 1`, and `move code from A to B` say nothing.

Leave one blank line between the subject and the body.

## Body

Write full sentences in plain English and explain:

- **What** the change does.
- **Why** it is needed: the problem or motivation.
- **How** it works, when the mechanism is non-obvious.

Include the context a reader cannot reconstruct from the code: issue numbers, benchmark results for performance changes, and links to design docs. If the change is generated or mechanical, say so; if it is mechanical except for one file, say which file is hand-written.

Refer to code by stable names such as functions, types, or files, not by line numbers. Line numbers go stale as soon as the file changes and mislead the future reader.

Wrap the body at ~72 characters. Skip markdown formatting such as headings, bold, and bullet styling, with one exception: backticks may delimit literal values such as identifiers, flags, or the accepted members of a set (`enabled`, `disabled`). Do not add `Signed-off-by` lines.

## Trailers

Place issue references on their own lines after a blank line below the body:

- `Fixes #123` closes an issue the change fully resolves.
- `Updates #123` (or `For #123`) references an issue without closing it, ex: partial progress. Either form is fine; do not be pedantic about which.

When moving code between repositories, record the source repository and commit hash so history stays traceable.

## Example

Bad:

```
fix bug
```

Good:

```
auth: reject JWTs that declare the "none" algorithm

The verifier accepted tokens whose header set alg to "none", so a
client could forge any claims and bypass authentication. Reject such
tokens before the signature check and add a regression test for the
empty-signature case.

Fixes #482
```
