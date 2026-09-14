---
root: true
targets:
  - cursor
  - claudecode
  - codexcli
description: User-level agent instructions overview
globs:
  - '**/*'
cursor:
  alwaysApply: true
  description: User-level agent instructions overview
  globs:
    - '**/*'
---
# User-level agent instructions

Rules for Cursor, Claude Code, and Codex CLI. Sources live in `~/.rulesync/rules/` (chezmoi-managed). The run script executes `rulesync generate` from `~`, which writes user config paths below.

## How rules load

Topic rules are separate files under `~/.rulesync/rules/`. Do not repeat them here; rulesync generates them per tool.

| Tool        | Overview (this file)                                           | Detail rules                        |
| ---         | ---                                                            | ---                                 |
| Claude Code | `~/.claude/CLAUDE.md`                                          | `~/.claude/rules/*.md`              |
| Cursor      | `~/.cursor/rules/agents.mdc`                                   | `~/.cursor/rules/*.mdc`             |
| Codex CLI   | `~/.codex/AGENTS.md`                                           | merged into `~/.codex/AGENTS.md`    |

Claude Code loads `~/.claude/rules/*.md` in every project. Cursor loads `~/.cursor/rules/` the same way.

## Expectations

Follow user, tool, system, and skill instructions precisely. When a skill may apply, read `SKILL.md` first, then `skill.json` if needed. Load referenced instruction files lazily based on the task at hand.
