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

10. What can't be synced

- Zed editor recent projects switcher (you _may_ be able to copy a sqlite db)
- Stickies (use notes instead)
- I had to manually copu Velja rules. Not sure why they didn't apply
