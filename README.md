# wburningham/dotfiles

## Steps for fresh install:

1. Get ssh keys

_You should know how_

2. Add with phasephrase stored in Keychain

```
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

3. Install Xcode command-line developer tools:

```
xcode-select --install
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

An unoptimized high fidelity sync takes ~2h. Plug in and prevent from sleeping:

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
