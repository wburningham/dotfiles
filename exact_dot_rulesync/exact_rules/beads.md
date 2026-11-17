---
root: false
targets:
  - '*'
description: Beads (bd) memory writes require explicit approval
---
# Beads memory writes

Some projects use Beads (`bd`) for ticket and issue tracking. Beads memories persist across sessions and agents, so a bad entry misleads future work.

- **NEVER** run `bd remember` without the user's explicit approval for that specific memory
- Propose the exact text you want to store and wait for the user to approve it before writing
- Approval for one memory doesn't extend to later ones
