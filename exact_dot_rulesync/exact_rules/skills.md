---
root: false
targets:
  - '*'
description: Skill loading conventions and continuous skill improvement protocol
globs:
  - '**/*'
cursor:
  alwaysApply: true
  description: Skill loading conventions and continuous skill improvement protocol
  globs:
    - '**/*'
---
# Skills

When loading skill metadata, always attempt to read `SKILL.md` first. If `SKILL.md` is not found, then attempt to read `skill.json`.

## Continuous skill improvement

**Your goal is to harden your core logic for all future interactions. This protocol is the engine of skill evolution.**

When the user requests a skill review or improvement, follow this protocol:

### Phase 0: Session analysis (internal reflection)

Review every turn of the conversation, from the initial user request up to this command. Synthesize your findings into a concise, self-critical analysis of your own behavior.

**Output (keep in chat only; do not include in final file changes):**
- Produce a bulleted list of key behavioral insights
- Focus on:
  - **Successes:** What core principles or patterns led to an efficient and correct outcome?
  - **Failures & user corrections:** Where did your approach fail? What was the root cause? Pinpoint the user's feedback that corrected your behavior.
  - **Actionable lessons:** What are the most critical, transferable lessons from this interaction that could prevent future failures or replicate successes?

### Phase 1: Lesson distillation and abstraction

Filter and abstract only the most valuable insights into **durable, universal principles.** Be ruthless in your filtering.

**Quality filter (a lesson is durable ONLY if it meets ALL criteria):**
- **Universal & reusable:** Applies to many future tasks across different projects, not a one-off fix
- **Abstracted:** A general principle (ex: "Always verify an environment variable exists before use"), not tied to specific session details
- **High-impact:** Prevents a critical failure, enforces a crucial safety pattern, or significantly improves efficiency

**Categorization:** Once a lesson passes the filter, determine its destination:
- **Global config:** Timeless engineering principle applicable to ANY project
- **Project config:** Best practice specific to the current project's technology, architecture, or workflow
- **Skill instructions:** Best practice or modification specific to a skill that was used

### Phase 2: Skill integration

Integrate the distilled lessons into the appropriate skill or config file.

**Integration protocol:**
1. **Read** the target skill file or resource to understand its structure
2. **Locate** the most logical section for your new rule
3. **Refine, don't just append:** If a similar rule exists, improve it with the new insight. If not, add it while matching the established formatting, tone, and style of the document
