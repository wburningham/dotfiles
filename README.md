# wburningham/dotfiles

## Steps for fresh install:

1. Get ssh keys, age key file and chezmoi config

_You should know how_

2. Add with phasephrase stored in Keychain

```
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

3. Install Xcode command-line developer tools and rosetta:

```
xcode-select --install
softwareupdate --install-rosetta --agree-to-license
```

4. Install [`twpayne/chezmoi`](https://github.com/twpayne/chezmoi)

```
sh -c "$(curl -fsLS get.chezmoi.io)"
```

5. Set up a new machine with a single command

```
chezmoi init --apply git@github.com:wburningham/dotfiles.git
```

6. Sync code

An unoptimized high fidelity sync takes ~7-9h. Plug in and prevent from sleeping:

```
cafeinate -d
```

Use `rsync` to sync over the code:

```
mkdir -p /Users/$USER/code/go/src/

rsync -a --delete\
  --exclude='.DS_Store' \
  --exclude='node_modules/' \
  --exclude='vendor/' \
  --exclude='dist/' \
  --exclude='build/' \
  --exclude='venv/' \
  --exclude='.venv/' \
  --exclude='__pycache__/' \
  --exclude='*.pyc' \
  --exclude='target/debug/' \
  $USER@<old machine ip address>:/Users/$USER/code/go/src/ /Users/$USER/code/go/src/
```

6. Sign into apple account

This will sync icloud and all passwords

7. Manually setup internet accounts

System Preferences -> Internet Accounts

8. Misc manual copy

- mcfly sqllite db `~/Library/Application Support/McFly/history.db`
- fish shell history `~/.local/share/fish/fish_history`
- 3D printing slicer software
- Chrome sync didn't work for history so had to run:
  - `scp $USER@<ip>>:/Users/$USER/Library/Application\ Support/Google/Chrome/<profile>/History ~/Library/Application\ Support/Google/Chrome/<profile may be different>/`
- work shell config (for now I don't have time to encrypt and deal with security design to put in dotfiles)
- `rsync -a --delete --progress $USER@<ip>:/Applications/Pandabar.app/ /Applications/Pandabar.app/`
- personal ssh config
- rclone config
- ~/Movies dir
- Finder settings

9. Manual setup

- Enable Touch ID for sudo
  - Add `auth sufficient pam_tid.so` to the top of the `/etc/pam.d/sudo_local` file
    - Note the `_local_` suffix. This file is persisted and update safe
    - You could also modify `/etc/pam.d/sudo` for good measure
- Apple Home shortcuts/widgets in control center
- Alfred
  - Paste Powerpack key
  - set sync dir to the git repo
  - manually check Features -> Web Bookmarks -> Safari
- Work 
  - Disable Privileges.app requests: paste serial # in #remove-demoter
- Docker: start and copy settings from old machine
- Download Dash License from email and manually apply in Dash settings
- Karabiner-Elements
  - Open and accept all the permissions
- SublimeText
  - copy paste settings
  - install package control
  - install PlainTasks, EasyDiff, Increment Selection

10. What can't be synced

- Zed editor recent projects switcher (you _may_ be able to copy a sqlite db)
- Stickies (use notes instead)
- I had to manually copu Velja rules. Not sure why they didn't apply

## Agent rules and permissions (rulesync)

One set of sources in this repo compiles into per-tool config for Claude Code and Codex CLI. Never edit the generated files; the next run overwrites them.

### Inputs (chezmoi-managed)

| Source | Target | Format |
| --- | --- | --- |
| `rulesync.jsonc` | `~/rulesync.jsonc` | JSONC: `targets`, `features`, `delete`, optional `sources` |
| `rulesync.lock` | `~/rulesync.lock` | Pinned refs and integrity hashes for declarative `sources` |
| `exact_dot_rulesync/exact_rules/*.md` | `~/.rulesync/rules/*.md` | Markdown with YAML frontmatter (`root`, `targets`, `description`) |
| `exact_dot_rulesync/permissions.json` | `~/.rulesync/permissions.json` | JSON: `permission.{bash,webfetch,Skill}` maps a glob to `allow`/`deny`. A `claudecode` block carries `additionalDirectories`, `sandbox`, `env`, and `model` |
| `exact_dot_rulesync/skills/*/` | `~/.rulesync/skills/*/` | Local skill dirs (`SKILL.md` plus `references/`, `resources/`, `scripts/`). Not `exact_`: leaves room for `skills/.curated/` from `rulesync install` |

Exactly one rule sets `root: true` (`agents.md`). It becomes each tool's top-level instruction file. The rest are topic rules that generate one output file each.

### The source is authoritative

The `exact_` prefix on `exact_rules/` makes chezmoi reconcile `~/.rulesync/rules/` against the repo on every apply. Local skills under `skills/` are deployed without `exact_` so `rulesync install` can write git-fetched skills to `~/.rulesync/skills/.curated/` without chezmoi deleting them. `.chezmoiignore` also excludes `.curated/` trees.

Declarative `sources` in `rulesync.jsonc` are fetched by `rulesync install` (not `generate`). Install writes to `.curated/`; generate merges local and curated inputs when writing tool outputs.

To pull new commits from a git source, run `cupdate` (or `cupdate-locks` from any directory), commit the updated lockfiles in chezmoi source, then `capply`. Apply fetches those pins and regenerates tool outputs.

### Outputs (generated)

`run_onchange_rulesync-generate.tmpl` wipes `.curated/`, runs `rulesync install --frozen` (fetch at the lock-pinned refs without rewriting the lock), then a single `rulesync generate --global` with `cwd` set to `~`. It re-runs whenever `rulesync.jsonc`, `rulesync.lock`, `permissions.json`, a rule file, or a local skill file changes, tracked by the hash comments at the top of the script.

During `chezmoi apply --interactive`, approve the `rulesync-generate` onchange script when prompted. Skipping it deploys config files but leaves `~/.rulesync/skills/.curated/` and generated skill dirs stale.

| Feature | Claude Code | Codex CLI |
| --- | --- | --- |
| rules | `~/.claude/CLAUDE.md`, `~/.claude/rules/*.md` | `~/.codex/AGENTS.md` |
| skills | `~/.claude/skills/*/` | `~/.agents/skills/*/` |
| permissions | `~/.claude/settings.json` | `~/.codex/config.toml`, `~/.codex/rules/rulesync.rules` |
| hooks | `~/.claude/settings.json` | `~/.codex/hooks.json` |
| mcp | `~/.claude.json` | `~/.codex/config.toml` |

`--global` is required. Project scope writes `~/CLAUDE.md` and `~/AGENTS.md` instead of the user-level paths each tool reads.

### Stale output

`delete: true` in `rulesync.jsonc` makes generate reap its own outdated outputs, so no `--delete` flag is needed in the script. Deletion is scoped to the configured targets, features, and global scope. Nothing reaches a file outside that scope.

Deleting a local rule or skill from the source cleans up end to end. `exact_` drops rules from `~/.rulesync/rules/`; local skills are removed from `~/.rulesync/skills/` on apply. The changed hash re-fires the script, and `delete: true` drops the matching generated outputs under `~/.claude/`, `~/.agents/`, and `~/.codex/`. To drop a git-fetched skill, remove it from `sources` (or narrow the skill list) and commit the updated `rulesync.lock`.

`.chezmoiremove` handles those leftovers. It drops `~/AGENTS.md` and `~/CLAUDE.md`, both written before generate gained `--global`. Moving Codex back to project scope means removing the `AGENTS.md` entry first, otherwise chezmoi keeps deleting the file.
