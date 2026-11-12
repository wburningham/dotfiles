---
root: false
targets:
  - '*'
description: Shell command shapes that match permission allow rules
cursor:
  alwaysApply: true
  description: Shell command shapes that match permission allow rules
  globs:
    - '**/*'
---
# Shell commands: avoid permission prompts

Permission allow rules match commands by prefix. The tool splits chains joined by `&&`, `||`, `;`, and `|` and checks each part on its own. It can't do that for loops or runtime substitution, so those commands always prompt the user. Shape commands so existing allow rules can match them.

- **NEVER** use shell loops (`for`, `while`, `until`), `xargs`, `find -exec`, or `$(...)` to run a command several times
- Issue one Bash tool call per command instead. Send independent calls in parallel in a single response.
- Prefer the Read, Grep, and Glob tools over shell iteration for reading or searching files
- Keep each command a simple invocation that a prefix allow rule can match (ex: `rg -n TODO path/to/file`)

#### Examples

**Incorrect (loop prompts even when `rg` is allowed):**
> `for f in a.go b.go c.go; do rg -n TODO "$f"; done`

**Correct (three parallel Bash tool calls):**
> `rg -n TODO a.go`
> `rg -n TODO b.go`
> `rg -n TODO c.go`
