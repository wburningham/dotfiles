---
root: false
targets:
  - '*'
description: Writing style for all generated text
globs:
  - '**/*'
cursor:
  alwaysApply: true
  description: Writing style for all generated text
  globs:
    - '**/*'
---
# Communication: writing style

## Never use em dashes

- **NEVER** use the em dash character (`—`, U+2014) in any text you generate. This rule has zero exceptions.
- This applies to ALL generated text, including but not limited to:
  - Session responses and chat messages
  - File contents you write or edit (code, prose, markdown, JSON, YAML, etc.)
  - Code comments, docstrings, and inline documentation
  - Commit messages, PR titles, and PR descriptions
  - Tool arguments, command strings, and shell commands
  - Plan files, todo items, and status updates
- **Replacements** (in order of preference):
  1. Restructure the sentence to remove the need for any dash
  2. Use a comma, period, or semicolon
  3. Use parentheses for parenthetical asides
  4. Use a colon for elaboration
- **NEVER** substitute a different dash character to satisfy the rule. The en dash (`–`, U+2013) and double hyphen (`--`) are also prohibited as em dash substitutes. A standard hyphen (`-`) is acceptable only in its normal hyphenation role (ex: "well-known", compound modifiers).
- **Self-check before submitting**: scan your response for `—`, `–`, and `--` and rewrite any occurrences before sending.

#### Examples

**Incorrect (uses em dash):**
> The agent restarted, settings were reloaded — it should work now.
> This directory is outside the project root — add it to `additionalDirectories`.

**Correct (restructured or uses other punctuation):**
> The agent restarted and settings were reloaded, so it should work now.
> This directory is outside the project root, so add it to `additionalDirectories`.
> The agent restarted (settings were reloaded), so it should work now.

## Never use `e.g.`

- **NEVER** use the abbreviation `e.g.` (or `eg`, `eg.`) in any text you generate. Use `ex:` instead.
- This applies to ALL generated text, including session responses, file contents, code comments, commit messages, and PR descriptions.
- **Self-check before submitting**: scan your response for `e.g.` and replace with `ex:`.

**Incorrect:** "Use a permission rule (e.g., `Bash(npm *)`) to allow commands."
**Correct:** "Use a permission rule (ex: `Bash(npm *)`) to allow commands."

## Minimize comma usage

Prefer short declarative sentences over long comma-chained ones. A comma is usually a symptom of a sentence doing too much, so fix the structure and the comma disappears. Aim for fewer commas rather than zero. Serial commas in a list of three or more items and commas that prevent a genuine misreading stay.

Apply these rewrites in order of preference:

1. **Split compound sentences.** Two independent clauses joined by a comma plus a coordinating conjunction (`, and`, `, but`, `, so`, `, yet`) become two sentences.
2. **Lead with the main clause.** Move a dependent opener to the end so it needs no comma. Write `Y because X` instead of `Because X, Y`. This applies to openers like `Because`, `When`, `While`, `If`, `Although`, and `Since`.
3. **Drop conjunctive-adverb openers.** Words like `However`, `Therefore`, `Instead`, `Additionally`, and `Moreover` each drag a trailing comma. Delete them or fold the idea into the sentence.
4. **Cut parenthetical asides.** A phrase set off by paired commas is usually removable. Delete it, fold it into the sentence, or use parentheses.
5. **Prefer restrictive `that` clauses.** A restrictive `that` clause takes no comma. Rewrite a nonrestrictive `which` clause or a comma appositive as a restrictive clause or a separate sentence.

**Self-check before submitting**: scan for any sentence with two or more commas and try to split or restructure it.

#### Examples

**Incorrect (comma-heavy):**
> The storer persists it, and the compiler resolves it, but the deployer limits it.
> Because the array is well-formed, the storer renders it back, so the limit is policy.
> The export tag, which the storer must return later, has a ceiling.

**Correct (restructured):**
> The storer persists it. The compiler resolves it. The deployer limits it.
> The storer renders the well-formed array back. That makes the limit policy.
> The export tag has a ceiling the storer must be able to return later.

## Forbidden words and phrases

Don't use the following words or phrases in any text you generate. This applies to ALL generated text (session responses, file contents, code comments, commit messages, PR descriptions, etc.).

**Forbidden words:**
- `probe`
- `signal`
- `verdict`
- `constituents`
- `land in`
- `the question is`
- `load-bearing`
- `load bearing`

**Self-check before submitting**: scan your response for these words and rewrite using alternatives.

## Sentence-style capitalization

Capitalize the first word of titles and headings; lowercase the rest. Exceptions: proper nouns, and the first word after a colon in a heading.

## Source-level line wrapping

Don't hard-wrap prose. One paragraph = one line; let the renderer wrap. Exceptions: bullets (one item per line, don't wrap inside), code blocks (preserve formatting), tables (one row per line), commit messages.

## Always use contractions

Always use contractions in all generated text: aren't, can't, couldn't, didn't, don't, doesn't, hasn't, haven't, how's, isn't, shouldn't, wasn't, weren't, won't.

**Exceptions:** technical identifiers, direct quotations, legal/regulatory text, RFC 2119 keywords in caps (`MUST NOT`, `SHALL NOT`).
