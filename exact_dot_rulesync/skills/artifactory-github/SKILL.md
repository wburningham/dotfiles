---
name: artifactory-github
description: >-
  GitHub through Artifactory, for sandboxes that block github.com. Use when
  downloading a release asset or repo file, installing a tool with mise,
  writing a config schema URL, or looking up release versions.
targets:
  - '*'
---
# GitHub through Artifactory

Artifactory's `github` remote is a read-through cache for `https://github.com/`. It fetches uncached release assets, repo files, and release feeds on demand. It needs no credentials.

Request through `github`. Its storage repo `github-cache` only returns files someone already fetched.

## URL mapping

Prefix every path with `https://artifactory.eng.qops.net/artifactory/github/`.

| GitHub URL | Artifactory path |
| --- | --- |
| `https://github.com/<owner>/<repo>/releases/download/<tag>/<asset>` | `<owner>/<repo>/releases/download/<tag>/<asset>` |
| `https://github.com/<owner>/<repo>/blob/<ref>/<path>` | `<owner>/<repo>/raw/<ref>/<path>` |
| `https://raw.githubusercontent.com/<owner>/<repo>/<ref>/<path>` | `<owner>/<repo>/raw/<ref>/<path>` |
| `https://github.com/<owner>/<repo>/releases.atom` | `<owner>/<repo>/releases.atom` |

## What's served

Verified 2026-11-20 with anonymous requests:

| Request | Result |
| --- | --- |
| Release asset | 200 (206 for a range request). Uncached assets are fetched on demand (tested: go-task v3.37.0, goreleaser v2.8.2, atago v0.26.3, shellcheck v0.10.0) |
| `/raw/<ref>/<path>` | 200. Follows GitHub's redirect to the file |
| `releases.atom` | 200. The release feed lists the 10 newest releases |
| `/releases` HTML page | 302. No usable list |
| api.github.com, mise-versions.jdx.dev | Not proxied. No Artifactory remote exists for them |

The feed is the only source of release metadata. There's no API behind it. That means no asset lists, checksums, or release dates.

## Reference

- Writing or fixing a `$schema` or `yaml-language-server` URL: read [SCHEMAS.md](SCHEMAS.md).
- Installing or locking a tool with mise: read [MISE.md](MISE.md).
- A request fails, returns 404, or looks stale: read [ARTIFACTORY.md](ARTIFACTORY.md).
