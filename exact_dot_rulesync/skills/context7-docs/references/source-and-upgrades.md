# Library source and upgrade guides

Both commands take a library ID from `ctx7 library`. They count toward the limit of 3 `ctx7` commands per question.

## Search a library's source

`ctx7 code` greps and reads the source of a library built from a Git repository. It works like ripgrep. IDs under `/websites/` or `/llmstxt/` have no source.

```bash
ctx7 code /colinhacks/zod "safeParse"
ctx7 code /colinhacks/zod "ZodError" -F -C 3 -g '*.ts'
ctx7 code /colinhacks/zod --op list --path packages/zod/src
ctx7 code /colinhacks/zod --op read --path packages/zod/src/types.ts#L10-L40
ctx7 code /colinhacks/zod safeParse --op definition
ctx7 code /colinhacks/zod safeParse --op references
ctx7 code /colinhacks/zod --op outline --path packages/zod/src/types.ts
ctx7 code /colinhacks/zod "safeParse" --tag v3.24.2
```

| Flag | Effect |
| --- | --- |
| `--op <op>` | `grep` (default), `definition`, `references`, `outline`, `read`, or `list` |
| `-F` | Treat the pattern as plain text |
| `-i` | Ignore case |
| `-g <glob>` | Only matching files. Start with `!` to exclude. Repeat for more. |
| `-C <n>` | Lines of context, 0 to 10 |
| `-l` / `-c` | Print only matching paths / match counts per file |
| `--path <path>` | A folder or file. For `read`, a file with `#L10-L40`. |
| `--head-limit <n>` | Maximum results, 1 to 500 |
| `--offset <n>` | Skip results for paging |
| `--tag <tag>` | A git tag or commit. Defaults to the commit the docs were built from. |

The first request for a library or tag can take up to a minute while Context7 indexes it. If the command reports that indexing is in progress, wait the time it gives and run it once more.

## Get an upgrade guide

`ctx7 get-upgrade-guide` lists breaking changes, codemods, deprecations, and API changes between two versions.

```bash
ctx7 get-upgrade-guide /vercel/next.js 14.2.35 16
ctx7 get-upgrade-guide /vercel/next.js 14
ctx7 get-upgrade-guide /vercel/next.js 14 16 --page 2
```

- `fromVersion` is the version the project uses now. A bare major means the oldest release of that line.
- `toVersion` defaults to the latest major. A bare major means the newest release of that line.
- Long guides are paged. Each page names the next one. Fetch further pages only when the current one doesn't answer the question.

If the guide is still being prepared, the command says so. Wait the time it gives and run it once more.
