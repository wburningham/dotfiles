---
root: true
targets:
  - claudecode
  - codexcli
description: User-level agent instructions overview
---
# User-level agent instructions

Rules for Claude Code and Codex CLI. Sources live in `~/.rulesync/rules/` (chezmoi-managed). The run script executes `rulesync generate --global` from `~`, which writes the user config paths below.

## How rules load

Topic rules are separate files under `~/.rulesync/rules/`. Don't repeat them here; rulesync generates them per tool.

| Tool        | Overview (this file)  | Detail rules                     |
| ---         | ---                   | ---                              |
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/rules/*.md`           |
| Codex CLI   | `~/.codex/AGENTS.md`  | merged into `~/.codex/AGENTS.md` |

Claude Code loads `~/.claude/rules/*.md` in every project.

## Expectations

Follow user, tool, system, and skill instructions precisely. When a skill may apply, read `SKILL.md` first, then `skill.json` if needed. Load referenced instruction files lazily based on the task at hand.
