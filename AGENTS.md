# Chezmoi source repo

This repo is the chezmoi source for the home directory. This file applies only to work in this repo. `.chezmoiignore` keeps it out of `~`.

## Permissions (`exact_dot_rulesync/permissions.json`)

rulesync generates Claude Code and Codex CLI permissions from this file. chezmoi deploys it to `~/.rulesync/permissions.json`. `rulesync generate --global` then writes `~/.claude/settings.json` and `~/.codex/rules/rulesync.rules`.

### Duplicate every shared bash rule into the Claude Code override

When you add, change, or remove an entry in `permission.bash`, make the same change in `claudecode.permission.bash`.

rulesync merges `claudecode.permission` over the shared `permission` block one category at a time. A category in the override replaces the shared category wholesale. Because `claudecode.permission.bash` exists, Claude Code never sees `permission.bash`. A rule added only to the shared block reaches Codex but silently disappears from Claude Code.

- Keep the shared entries first in `claudecode.permission.bash` in the same order as `permission.bash`. Claude-only rules go after them.
- Put Claude-only rules (ex: the `rg` denies) only in `claudecode.permission.bash`. Don't move them to the shared block. Codex can't express mid-pattern wildcards like `rg *--pre*` and drops them, even denies. A shared `rg *` allow would then auto-approve `rg --pre` in Codex.
- The same replacement applies to `webfetch`. The shared block uses bare domains and the Claude override uses `domain:` prefixes, so update both when you add a domain.

Run `mise lint` after editing the file. It fails and lists any shared bash entries that are missing from the Claude override or differ there.

### Don't edit generated files

Don't edit `~/.claude/settings.json` or `~/.codex/rules/rulesync.rules` directly. Change `permissions.json` and ask the user to run `chezmoi apply`.
