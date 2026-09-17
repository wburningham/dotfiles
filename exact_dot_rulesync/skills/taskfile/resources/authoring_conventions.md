# Taskfile Authoring Conventions

Practical patterns and pitfalls learned from maintaining real Taskfiles. These complement the schema and templating references with opinionated guidance on *how* to write tasks well.

## Templating over Shell Logic

Prefer **Task's Go template** (`{{if}}` / `{{else}}` / `{{end}}`, `eq`, `default`, `list`, `join`, etc.) to choose commands or arguments when inputs are already known Task variables. Prefer **task `vars`** for URLs, paths, and flags; avoid assigning values inside shell with `VAR=...` when those values can live in `vars` and be expanded with `{{.VAR}}`.

When a **precondition** already guarantees a small set of outcomes (for example only `curl` or `wget`), use template conditionals for the two branches instead of POSIX `case` / shell `if` chains, unless there is a strong reason to keep logic in the shell.

## Paths and Working Directory

Do not use **`dir:`** for a directory that the task must create first; Task may try to change into it before it exists. Use `ROOT_DIR` (and `list`/`join` or `dir` on a path variable) plus an explicit `mkdir -p` instead.

**Build paths in templates** with `list` and `join` instead of concatenating `"{{.BASE}}/segment"` by hand. Use `{{ list .ROOT_DIR "/" <relative parts> | join "" }}` for repo-root paths, and the same pattern with another base (for example a temp dir var) when the path is not under `ROOT_DIR`. This keeps separators consistent and matches how `status` and `cmd` lines reference the same locations.

```yaml
# Artifact under the repo
{{ list .ROOT_DIR "/" .TASKBIN_EGET | join "" }}

# File next to a dynamic directory (e.g. mktemp)
{{ list ._TMP_DIR "/" "eget.sh" | join "" }}
```

Quote templated paths when they might contain spaces.

## HTTP Client Detection

Assume at least one of **`curl` or `wget`** may be present; do not assume a specific one. Use a shared detection snippet (for example `_HTTP_TOOL_GET_SH`) and a single enum-style variable (`_HTTP_TOOL_GET`) so both **preconditions** and commands stay consistent.

Use **`command -v`** for detection; it is a POSIX shell builtin and does not rely on a separate `/usr/bin/command` binary.

Silence **`wget`** carefully: `-q` alone may not suppress everything; `-o /dev/null` (wget's log file) and redirecting stderr are often needed in addition.

## YAML Quoting for Templates

When a template line contains **`|`** (for example `| join`), quote the whole string in YAML so `|` is not parsed as a literal block scalar.

## Command Output (`silent`)

Set **`silent: true`** on commands that are **scaffolding**: work the user does not need to follow line-by-line in Task's log. Typical examples are **`mkdir -p`**, **`defer:`** cleanup, or anything that only prepares the environment.

Leave **`silent` unset (or false)** on the **core** commands — the ones a reader might copy into their own shell to reproduce the important part of the task (for example `go install …`, `curl …`, `shasum … | grep …`, version checks).

```yaml
- cmd: mkdir -p {{ dir .TASKBIN_GORELEASER_V1 }}
  silent: true
- cmd: >-
    GOBIN={{ list .ROOT_DIR "/" ( dir .TASKBIN_GORELEASER_V1 ) | join "" }}
    go install github.com/goreleaser/goreleaser@{{.TASKBIN_GORELEASER_V1_VERSION}}
```

Here the install line stays visible; the directory creation does not.

## Formatting `cmd` Entries

Prefer a **single-line** `cmd: …` when it stays readable and does not fight YAML quoting.

**Quote** the whole value when required: templates that include **`|`** (pipes or `| join`), strings that start with **`{`**, or anything where unquoted YAML would misparse. Use **single quotes** around the whole `cmd` so inner double quotes behave predictably in the shell command.

When a command is **long**, wraps naturally, or carries **multi-line Go template** (`{{if}}` / `{{else}}` / `{{end}}`), prefer a **folded block** with **`>-`** so the template can breathe and stay valid YAML without one huge escaped line.

```yaml
- cmd: >-
    {{if eq ._HTTP_TOOL_GET "curl"}}
    curl -sSfL -o "{{._EGET_SH_PATH}}" "{{._EGET_SH_URL}}"
    {{else}}
    wget -q -O "{{._EGET_SH_PATH}}" -o /dev/null "{{._EGET_SH_URL}}" 2>/dev/null
    {{end}}
```

## Naming Conventions

A leading **`_` on variable names** signals that a variable is **internal** to a task or workflow — not a stable, documented contract for callers (for example `_EGET_SH_PATH` or `_HTTP_TOOL_GET`). Taskfile does not assign special meaning to `_`; it is not part of the Taskfile schema or `go-task` behavior.
