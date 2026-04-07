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

```
mkdir -p /Users/$USER/code/go/src/

rsync -a --delete\
  --exclude='.DS_Store' \
  --exclude='node_modules' \
  --exclude='vendor' \
  --exclude='dist' \
  --exclude='build' \
  $USER@<old machine ip address>:/Users/$USER/code/go/src/ /Users/$USER/code/go/src/
```
