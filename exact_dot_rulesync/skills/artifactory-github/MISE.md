# Installing tools with mise through Artifactory

Read this when you install, pin, or lock a tool with mise in a sandbox that blocks GitHub. All patterns below were tested on 2026-11-20 with mise 2026.11.10, a fresh `MISE_DATA_DIR`, and an empty `MISE_GLOBAL_CONFIG_FILE`. Isolate your own tests the same way so cached installs and personal settings don't hide a failure.

## Pick a pattern

| Situation | Pattern |
| --- | --- |
| A shared or published task that declares its own tools | A. Per-platform URLs |
| A repo's own `[tools]` that wants the newest release | B. `latest` from the release feed |
| Existing `aqua:` or `github:` pins with a `mise.lock` | C. `url_replacements` |
| None of the above fits | D. Custom backend plugin (unexplored) |

## A. Per-platform URLs

The `http:` backend takes a URL and checksum per platform. It works in a file task's `#MISE tools` header. The download location then travels with the task and consumers set nothing.

```bash
#MISE tools={"http:atago"={version="0.26.3", platforms={macos-arm64={url="https://artifactory.eng.qops.net/artifactory/github/nao1215/atago/releases/download/v0.26.3/atago_0.26.3_darwin_arm64.tar.gz", checksum="sha256:fbb4356e888ca3f810142335df42f29e6489fa0c1a8fff7e62f760fccf66c4b5"}, linux-x64={url="https://artifactory.eng.qops.net/artifactory/github/nao1215/atago/releases/download/v0.26.3/atago_0.26.3_linux_amd64.tar.gz", checksum="sha256:8ed153b9bf7b85e0442b0f253e8ec284422ec66b682a60dcfcc440cef504536c"}}}}
```

- Cover every platform consumers run. In a repo with `lockfile_platforms`, match that list.
- Give every platform a checksum. `http:` has no registry, and it drops the checksums and GitHub attestations that `aqua:` verifies. mise enforces the value: a wrong one fails the install with `Checksum mismatch`. Take values from the release's checksums file or an existing `mise.lock` entry.
- If the binary sits in a subdirectory of the archive, confirm mise finds it. Set `bin_path` or `strip_components` if it doesn't.

## B. `latest` from the release feed

```toml
[tools."http:atago"]
version = "latest"
version_list_url = "https://artifactory.eng.qops.net/artifactory/github/nao1215/atago/releases.atom"
version_regex = '/releases/tag/v(\d+\.\d+\.\d+)"'
version_order = "semver"
url = "https://artifactory.eng.qops.net/artifactory/github/nao1215/atago/releases/download/v{{ version }}/atago_{{ version }}_{{ os(macos=\"darwin\") }}_{{ arch(x64=\"amd64\") }}.tar.gz"
```

- The regex matches `vX.Y.Z` tag links in the feed. It skips other tags like go-task's `nightly`.
- An older fuzzy version (ex: `2.14`) won't resolve once it drops out of the feed's 10 entries.
- mise warns `has no release date`. The minimum release age check is skipped, so a release published minutes ago installs.
- `os(macos="darwin")` and `arch(x64="amd64")` rename mise's platform names to the ones most release assets use.
- Whether the cached feed refreshes is unverified (see [ARTIFACTORY.md](ARTIFACTORY.md)).

## Templates in a file-task header

mise renders a file task's header with Tera before it reads the tool options. A `{{ version }}` in a URL then fails with `Variable 'version' is not defined`. Wrap the template in a raw block so it reaches the backend intact:

```bash
#MISE tools={"http:atago"={version="0.26.3", url="https://artifactory.eng.qops.net/artifactory/github/nao1215/atago/releases/download/v{% raw %}{{ version }}/atago_{{ version }}_{{ os(macos=\"darwin\") }}_{{ arch(x64=\"amd64\") }}{% endraw %}.tar.gz"}}
```

Pattern A needs no template, which is one reason to prefer it in headers.

## C. `url_replacements`

```toml
[settings]
url_replacements = { "https://github.com" = "https://artifactory.eng.qops.net/artifactory/github" }
```

The env form is `MISE_URL_REPLACEMENTS='{"https://github.com":"https://artifactory.eng.qops.net/artifactory/github"}'`. It rewrites download URLs and keeps `aqua:` and `github:` backends working.

- It works only for tools with a `mise.lock` entry that holds the URL. Without one, mise asks api.github.com for release data and fails.
- `mise lock` needs the API. Run it somewhere that can reach GitHub.
- It works in a project `mise.toml` (verified 2026-11-21). That fits a repo's own tools, where no consumer has to remember it.
- Every consumer has to set it. That rules it out for shared tasks.

## D. Custom backend plugin

Not explored. Test it in isolation before relying on it.
