---
name: context7-docs
description: >-
  Current documentation and code examples for open source libraries,
  frameworks, SDKs, and CLI tools through the ctx7 CLI (Context7). Use when you
  need an API signature, a configuration option, version-specific behavior, a
  migration detail, or anything about a library you aren't sure of. Prefer it
  over web search for library docs. Skip it for general programming concepts
  and for code that doesn't depend on a library API.
targets:
  - '*'
---
# Context7 docs

The `ctx7` CLI searches Context7's index of open source documentation. It's already installed and configured. Don't install it, log in, or pass `--base-url`.

The commands below match `ctx7` 0.12.2. Run `ctx7 <command> --help` if a flag is rejected.

## Workflow

Resolve the library name to a Context7 library ID, then query docs with that ID:

```bash
ctx7 library <name> "<what to look up>"
ctx7 docs <libraryId> "<what to look up>"
```

Skip `library` only when you already have an ID in `/org/project` or `/org/project/version` form.

Run at most 3 `ctx7` commands per question. After 3, answer with the best result you have.

## Resolve a library

```bash
ctx7 library React "How to clean up useEffect with async operations"
ctx7 library "Next.js" "How to set up app router with a proxy"
```

Use the official name with its punctuation: `Next.js` not `nextjs`, `Three.js` not `threejs`. If results look wrong, try another spelling before changing the query. Always pass the query. It ranks the results.

Each result lists a library ID, name, description, code snippet count, source reputation, benchmark score, and indexed versions. Pick the best match in this order:

1. Exact or closest name match
2. Description that fits the question
3. Official sources over forks and mirrors
4. More code snippets, High or Medium reputation, higher benchmark score

If several match equally well, say so and use the most relevant. If none match, say so and suggest a better query.

## Query docs

```bash
ctx7 docs /reactjs/react.dev "How to clean up useEffect with async operations"
ctx7 docs /prisma/prisma "How to define one-to-many relations with cascade delete"
ctx7 docs /websites/twilio "How to send an SMS" --language Ruby
```

`--language` ranks code examples in that language first. `--json` returns structured output.

For a specific version, append a version from the `library` output's `Versions` line to the ID, exactly as listed: `ctx7 docs /react/react/v19.2.8 "..."`. Without a version suffix you get the latest indexed docs.

The output has code snippets (titled, with fenced code) and info snippets (prose with breadcrumbs).

## Search all libraries

`search` answers in one step and picks the libraries itself. Use it when the question spans libraries or you don't know which library covers it.

```bash
ctx7 search "How to stream an OpenAI response from a Next.js route"
ctx7 search "How to stream a response" --library Next.js --library /openai/openai-node
ctx7 search "How to cache a server function" --library Next.js --library-version 15.4.0
```

`--library` takes a name or an ID and repeats up to four times. `--language` and `--json` work as they do for `docs`.

## Write good queries

Describe what to look up in the docs, not the task you're doing. Keep each query to one concept. If a question spans routing, auth, and caching, run one `docs` command per concept unless it's about how they interact.

| Quality | Query |
| --- | --- |
| Good | `"How to set up authentication with JWT in Express.js"` |
| Good | `"React useEffect cleanup function with async operations"` |
| Too vague | `"hooks"` |
| Too broad | `"routing and auth and caching in Next.js"` |

Never put secrets, credentials, personal data, or proprietary code in a query. Queries leave the machine.

## Library source and upgrade guides

To read or grep a library's source at a tag, or to get the breaking changes between two versions, read [references/source-and-upgrades.md](references/source-and-upgrades.md).

## Errors

When a `ctx7` command fails, stop and tell the user in one line what failed and the likely cause:

| Error | Likely cause |
| --- | --- |
| Connection refused, `fetch failed`, `ECONNREFUSED` | The local Context7 proxy isn't running |
| 401 or 403 | The proxy's API key is missing, expired, or wrong |
| 404 on a valid command | The proxy doesn't forward that endpoint |
| 429 or a quota message | Rate limit or quota reached |

Don't retry with `--base-url`, run `ctx7 login`, or switch to web search. Answer from training data only after reporting the error, and say the answer may be out of date.

## Common mistakes

- Library IDs start with `/`: `/reactjs/react.dev`, not `reactjs/react.dev`
- `ctx7 docs react "hooks"` fails because `react` isn't an ID. Run `library` first.
- `docs` has no `--tag` or `--version` flag in 0.12.2. Put the version in the ID.
