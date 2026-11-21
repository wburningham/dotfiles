# How the github remote behaves

Read this when a request through Artifactory fails, returns 404, or looks stale.

## Repos

- **`github`** is a remote repo for `https://github.com/`. Request through it. It serves cached files and fetches uncached ones from GitHub.
- **`github-cache`** is the `github` remote's storage. Artifactory names a remote's storage `<key>-cache`. A request to it never reaches GitHub, so an uncached file returns 404 `File not found`. That looks like a missing artifact, but it only means nobody fetched it yet. Retry through `github`.

## Inspect the cache

The storage API answers without credentials:

- `https://artifactory.eng.qops.net/artifactory/api/storage/github-cache/<path>` shows a cached file's `created`, `lastUpdated`, `createdBy`, `remoteUrl`, and checksums.
- The same URL on a folder lists its children (ex: `<owner>/<repo>/releases/download/` lists cached tags). The list holds only cached entries, never the full set upstream.
- `https://artifactory.eng.qops.net/artifactory/api/repositories?type=remote` lists every remote repo and its upstream URL. Check it before you assume a host has no mirror.

## Failures

| Response | Meaning |
| --- | --- |
| 404 `File not found` from `github-cache` | Not cached. Use `github` |
| 404 from `github` | Wrong path, tag, or asset name upstream. Check the name against the release's checksums file or the repo tree |
| 302 | An HTML page (ex: `/releases`). Artifactory doesn't serve it. Use `releases.atom` |
| `sandbox_violations` naming api.github.com or mise-versions.jdx.dev | A tool asked GitHub's API for versions or release data. Artifactory can't help. Pin an exact version with a direct URL (see [MISE.md](MISE.md)) |

## Open question: feed freshness

Unverified as of 2026-11-20: whether Artifactory re-fetches a cached `releases.atom` or serves the first copy forever. A stale feed makes `latest` stick on an old version.

To check, read `lastUpdated` for `api/storage/github-cache/nao1215/atago/releases.atom` after atago publishes a newer release. Its first value was `2026-11-21T02:01:58.758Z` (UTC). Then replace this section with the answer.
