# Config schemas through Artifactory

Validators like cfv (config-file-validator) fetch the URL in a `# yaml-language-server: $schema=` line. A blocked URL fails that file.

## Find the URL

1. Find the schema's source file in the tool's GitHub repo. Do this even when the tool's docs link a static-site URL (ex: golangci-lint.run, goreleaser.com, mise.jdx.dev). The site usually publishes a file from the repo.
2. Pick the ref. Prefer the release tag of the tool version you pin. The schema then matches the binary. `main` can describe options the pinned version doesn't have. Bump a tag-pinned URL with the tool.
3. Build the URL from the `/raw/` row of the mapping in [SKILL.md](SKILL.md).
4. Fetch it with curl and confirm a 200 with JSON before you write it into a file. Paths move between releases.

In YAML, put the URL on the first line: `# yaml-language-server: $schema=<url>`. Editors and cfv both read it.

## Verified URLs

All returned 200 with a valid JSON Schema on 2026-11-20. Prefix each with `https://artifactory.eng.qops.net/artifactory/github/`.

| Tool | Release tag | `main` |
| --- | --- | --- |
| golangci-lint | `golangci/golangci-lint/raw/v2.15.0/jsonschema/golangci.jsonschema.json` | `golangci/golangci-lint/raw/main/jsonschema/golangci.jsonschema.json` and `golangci/golangci-lint/raw/main/jsonschema/golangci.v2.14.jsonschema.json` |
| goreleaser | `goreleaser/goreleaser/raw/v2.8.2/www/docs/static/schema.json` | `goreleaser/goreleaser/raw/main/www/static/schema.json` |
| mise | `jdx/mise/raw/v2026.11.10/schema/mise.json` | `jdx/mise/raw/main/schema/mise.json` |
| atago | `nao1215/atago/raw/v0.26.3/schema/atago.schema.json` | `nao1215/atago/raw/main/schema/atago.schema.json` |
| Taskfile (go-task) | `go-task/task/raw/v3.44.0/website/static/schema.json` | `go-task/task/raw/main/website/src/public/schema.json` |

cfv v3.0.0 validates through these URLs inside the sandbox. Against the golangci-lint v2.15.0 URL it passed a valid config and rejected an unknown `gofumpt` key.

## Path quirks

- **goreleaser** moved its schema from `www/docs/static/schema.json` to `www/static/schema.json` after v2.8.2.
- **go-task** moved its schema from `website/static/schema.json` (v3.44.0) to `website/src/public/schema.json` on `main`. Check the path at the tag you pin.
- **golangci-lint** publishes versioned files on `main` that lag releases. No `golangci.v2.15.jsonschema.json` exists on `main` or at `v2.15.0`. Use the tag's `golangci.jsonschema.json`.

## Schemas not on GitHub

A schema that only lives on a static site still needs network access. Artifactory has no remote for those hosts. Ask the user before you add a URL you can't fetch.
