---
name: doc-writing-style
description: >-
  This skill should be used when authoring or auditing docs humans read —
  CONTRIBUTING.md, README.md, design docs, guides, RFCs, or skill files
  (SKILL.md). Covers structural decisions: when to merge sections, what to cut,
  when numbered lists beat sub-sections. For sentence-level voice load
  prose-style; for markdown formatting load markdown-style.
targets:
  - '*'
---
# Document writing style

Guidance for structural decisions in docs. Sentence-level voice and formatting lives in [prose-style](../prose-style/SKILL.md).

## Default to terse

When in doubt, cut. A short, dense doc with one example beats a long one with three. Concrete examples (JSON snippet, code block, table) beat prose enumeration of "don't do X". If you can't write a rule in 1-3 sentences, the rule itself needs work, not more elaboration.

## Structural patterns to avoid

### Two-tier TL;DR + detailed reference

If a section has both a summary and a detailed reference the summary points to ("see relevant section below"), the doc has redundant layers. Pick one density. Usually the TL;DR loses: write the detail tightly enough that it IS the summary.

### Motivation that paraphrases a linked source

If the doc links to an RFC, spec, or design doc, point at it for the rationale. Don't paraphrase inline. Replace "Why this matters" sections with a one-line pointer: "See [source] for the rationale."

### Parallel checklists

Author and reviewer checklists that check the same properties belong together as one neutral list. Phrase each item as a positive assertion that works for self-check and spot-check.

Old:

- Author: "Confirmed X is Y."
- Reviewer: "**Bad X.** X is not Y. → Request fix."

New:

- "**Y holds.** X is Y (no Z-violations)."

### H4-per-item for tight rule sets

For N related rules, use a numbered list with one paragraph per item. H4-per-rule is appropriate only when each rule has substantial body (multiple paragraphs, examples, sub-rules). Eight `#### Rule N: ...` sub-sections of 5-15 lines each collapses better into a numbered list of dense one-paragraph items.

### Process rules without enforcement

Outcome rules describe what the artifact must look like ("no redundant representations"). Process rules describe what the author must do ("enumerate equivalence classes first").

Outcome rules are reviewable from the artifact alone. Process rules add overhead but don't add enforcement: the outcome rules already catch what the process step was meant to prevent. Drop process rules unless the process step itself is the deliverable.

### Restated scope inside every rule

State the scope once at the top of the section ("These rules apply only to new fields"). Don't repeat "for new fields" inside each rule.

### Restatement-of-rule closing sentences

Lines like "Bounded shapes shrink `S3`, which is exactly the goal" or "There is no second way to spell the same thing" restate the rule above. Cut them.

## Audit habits

When auditing an existing doc:

1. **Scan structure first.** Two-tier layers? Parallel checklists? Motivation that paraphrases a link? Process rules without enforcement? Propose cuts before tightening prose.
2. **Per-form sweep for word-level issues.** Don't trust a single read. Grep for known offenders (`cannot`, `do not`, em dashes, `e.g.`) one form at a time. See [markdown-style](../markdown-style/SKILL.md) for the contraction audit procedure.
3. **Read the table of contents.** If two headings sound like the same thing, they probably are. Combine them.
4. **Propose structural cuts proactively.** Don't wait for "make it shorter." When you spot a two-tier structure, parallel checklists, or motivation sections that paraphrase a link while doing anything else in a doc, flag it in the same turn.

## What lives elsewhere

- **Sentence-level voice and word choice** (active voice, omitting needless words, no speculation): [prose-style](../prose-style/SKILL.md).
- **Markdown formatting** (headings, contractions, source-line wrapping, checklist patterns): [markdown-style](../markdown-style/SKILL.md).
- **RFC-specific structure** (RFC 2119 keywords, abstract, problem statement): [rfc-author](../rfc-author/SKILL.md).
- **Em dashes and `e.g.`**: global rules in `~/.claude/CLAUDE.md`.
