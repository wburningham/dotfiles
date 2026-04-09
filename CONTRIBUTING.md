# Contributing

Reference for adding new configuration to this repo. Find the category below, follow the steps, and use the listed files as copy-paste-modify starting points.

---

## Homebrew Package

**Files:** `dot_homebrew/Brewfile`

Add a line in the appropriate section group:

```ruby
brew "package-name"           # CLI tool / formula
cask "app-name"               # GUI app
mas "App Name", id: 123456789 # Mac App Store app (find ID via `mas search <name>`)
tap "owner/repo"              # Tap before referencing its packages
```

To get a MAS app ID: `mas search "App Name"` or look it up on the App Store URL.

Apply: `chezmoi apply` then `brew bundle --file ~/.homebrew/Brewfile`

---

## Homebrew Custom Cask

**Files:** `dot_homebrew/casks/fish-theme/fish-theme.rb` (example)

1. Create `dot_homebrew/casks/<name>/<name>.rb`
2. Reference it in the Brewfile: `cask "./casks/<name>/<name>.rb"`

---

## macOS Default (System Preference)

**Files:** `.macos_defaults/*.yaml` — see `global.yaml`, `dock.yaml` for examples

1. Find the domain and key:
   ```sh
   defaults read <domain>          # dump all keys for a domain
   defaults read <domain> <key>    # read a single key
   ```
2. Create or edit `.macos_defaults/<domain-or-appname>.yaml`:
   ```yaml
   ---
   description: com.apple.dock
   sudo: false
   current_host: false
   data:
     com.apple.dock:
       autohide: true
   kill:
     - Dock
   ```
3. `chezmoi apply` will pick up changes via `run_onchange_generate-plists.sh.tmpl`

Fields:
- `sudo: true` — runs `sudo defaults write`
- `current_host: true` — scopes to current hardware (uses `-currentHost`)
- `kill` — list of app names to terminate after applying (so changes take effect)

---

## Launch Agent

**Files:** `.launchagents/chezmoi.wesb.macos-backup.yaml`, `.launchagents/chezmoi.wesb.stm.yaml`

Rules:
- Filename **must** start with `chezmoi.` (controls plist cleanup glob)
- `Label` field **must** start with `chezmoi.` (controls launchctl cleanup)
- Filename (without `.yaml`) is used as the plist filename in `~/Library/LaunchAgents/`

1. Create `.launchagents/chezmoi.<name>.yaml`:
   ```yaml
   Label: chezmoi.<name>
   UserName: wesb
   EnvironmentVariables:
     PATH: /opt/homebrew/bin:/usr/bin:/bin
   StandardOutPath: /tmp/<name>.out.log
   StandardErrorPath: /tmp/<name>.err.log
   ProgramArguments:
     - /bin/sh
     - -c
     - |-
       <your commands here>
   RunAtLoad: true
   StartInterval: 3600        # run every N seconds
   # OR
   StartCalendarInterval:     # run on a schedule
     - Minute: 0
   ThrottleInterval: 3600     # minimum seconds between runs
   ```
2. `chezmoi apply` — generates the plist, stops/starts all `chezmoi.*` agents

To stop manually: `launchctl bootout gui/$(id -u)/chezmoi.<name>`

**Debugging:**

View all generated plist metadata:
```sh
plutil -p ~/Library/LaunchAgents/chezmoi.<name>.plist
```

Check current state of a running agent:
```sh
launchctl list | grep chezmoi.<name>
```

View logs:
```sh
tail -f /tmp/<name>.out.log
tail -f /tmp/<name>.err.log
```

---

## Homebrew Services / Launch Agents

**Files:** `dot_homebrew/Brewfile`

Homebrew services are managed by individual formulae (e.g., `redis`, `postgresql`, `ollama`) and registered via `brew services`. Homebrew generates and maintains the plist automatically — no hand-rolling needed.

**Install a service:**
```ruby
# dot_homebrew/Brewfile
brew "redis"      # Formula that provides a service
brew "postgresql" # Another common service
brew "ollama"     # Example: AI/ML service
```

**Manage with `brew services`:**
```sh
brew services start redis           # Start and enable on login
brew services stop redis            # Stop
brew services restart redis         # Restart
brew services list                  # View all services and status
```

**How it works:**
- Homebrew generates a plist at `~/Library/LaunchAgents/homebrew.mxcl.<name>.plist`
- `brew services` is a thin wrapper over `launchctl` — it starts/stops the service and enables auto-restart on login
- You can inspect the plist: `plutil -p ~/Library/LaunchAgents/homebrew.mxcl.<name>.plist`
- Logs: `log stream --predicate 'process == "<name>"' --info`

**Customizing environment variables:**

If you need to override env vars (e.g., `OLLAMA_HOST`, `REDIS_PORT`), don't edit Homebrew's plist directly — it gets overwritten on updates. Instead, create a custom plist in `.launchagents/`:

```sh
cp ~/Library/LaunchAgents/homebrew.mxcl.ollama.plist ~/.local/share/chezmoi/.launchagents/chezmoi.homebrew-override-ollama.yaml
```

Then manually convert it to YAML and edit, or use a custom launch agent (see [Launch Agent](#launch-agent) section).

**When to use each:**
- Use **Homebrew services** for standard tools (Redis, PostgreSQL, Ollama, etc.) — Homebrew handles plist generation and updates
- Use **custom launch agents** (`.launchagents/chezmoi.*.yaml`) for personal scripts, backups, app-specific automation, or when you need tight control over environment variables

---

## Mac App (Non-Homebrew, Encrypted Archive)

**Files:** `.mac_apps/`, `.chezmoiexternal.toml`

Use when an app is not on Homebrew or the Mac App Store.

1. Archive and encrypt the `.app`:
   ```sh
   tar -czvf AppName.tar.gz AppName.app/
   chezmoi encrypt AppName.tar.gz --output AppName.tar.gz.age
   mv AppName.tar.gz.age ~/.local/share/chezmoi/.mac_apps/
   ```
2. Add an entry to `.chezmoiexternal.toml`:
   ```toml
   ["Applications/AppName.app"]
     type = "archive"
     encrypted = true
     url = '{{ joinPath "file://" .chezmoi.sourceDir ".mac_apps/AppName.tar.gz.age" }}'
     stripComponents = 0
   ```
3. `chezmoi apply`

---

## Environment Variable

**Files:** `.env_files/*.env`

Add to an existing file or create a new one:
- `core.env` — general shell variables
- `golang.env` — Go toolchain
- `homebrew.env` — Homebrew flags
- `docker.env`, `k9s.env`, `mcfly.env`, `taskfiles.env` — tool-specific

New `.env` files in `.env_files/` are automatically included by `dot_env.tmpl`. No registration needed.

---

## Fish Plugin

**Files:** `dot_config/fish/fish_plugins`

Add the plugin slug (owner/repo[@version]) to `fish_plugins`, then:
```sh
chezmoi apply
```
The `run_onchange_install-fish-plugins.sh.tmpl` script runs `fisher update` automatically when `fish_plugins` changes.

---

## Dotfile (Editor, Terminal, CLI Tool)

**Files:** `dot_<name>`, `dot_config/<tool>/`

- Single file: create `dot_<name>` — chezmoi applies it as `~/.<name>`
- Config directory: create `dot_config/<tool>/` — applied as `~/.config/<tool>/`
- Template: use `.tmpl` extension if the file needs chezmoi template variables

No registration needed — chezmoi picks up all managed files automatically.

---

## Git Config

**Files:** `dot_gitconfig`, `dot_config/git/message`

- Global settings: edit `dot_gitconfig` directly
- Commit template: edit `dot_config/git/message`
- Work-specific overrides use a `[includeIf "gitdir:..."]` block in `dot_gitconfig` pointing to a separate (git-ignored) file

---

## Encrypted File

For any sensitive file (credentials, tokens, private config):

```sh
chezmoi encrypt <file> --output encrypted_<file>.age
```

Chezmoi decrypts automatically on apply. The `.age` file is safe to commit.
