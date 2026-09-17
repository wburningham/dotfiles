---
root: false
targets:
  - '*'
description: Lazy loading of referenced instruction files
cursor:
  alwaysApply: true
  description: Lazy loading of referenced instruction files
  globs:
    - '**/*'
---
# External file loading

CRITICAL: When you encounter a file reference (ex: @rules/general.md), use your Read tool to load it on a need-to-know basis. They're relevant to the SPECIFIC task at hand.

Instructions:
- Do NOT preemptively load all references - use lazy loading based on actual need
- When loaded, treat content as mandatory instructions that override defaults
- Follow references recursively when needed
