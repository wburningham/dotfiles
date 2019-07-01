# wburningham's dotfiles

Based on mathiasbynens/dotfiles

## Installation

### Using Git and the bootstrap script

The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/wburningham/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

### Git-free install

To install these dotfiles without Git:

```bash
cd; curl -#L https://github.com/wburningham/dotfiles/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,bootstrap.sh,LICENSE-MIT.txt}
```

To update later on, just run that command again.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/wburningham/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here’s an example `~/.path` file that adds `~/utils` to the `$PATH`:

```bash
export PATH="$HOME/utils:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Mathias Bynens"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="mathias@mailinator.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/wburningham/dotfiles/fork) instead, though.

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.osx
```


## Setups to take when migrating to a new computer

Note: to scp/ssh to your computer (not from) you need to enable remote login in the settings. (search `ssh` in system preferences)

- copy ~/.ssh folder
- run `git config --global user.name "John Doe"` (will prompt to install OSX dev tools so run TWICE)
- run `git config --global user.email johndoe@example.com`
- git clone dotfiles
- bootstrap dotfiles
- install homebrew
- copy ~/.aws folder
- copy ~/.awscred file
- make .bash_history unique and copy
- copy ~/.extra file
- copy ~/.netrc file
- copy ~/.npmrc file
- copy ~/.srvrrc file
- copy ~/.path file
- copy PandaBar.app
- copy TrashMe.app
- copy Quinn.app
- copy over wifi networks and passwords
- audit code in /Code
- enable tap to click for trackpad
- copy over apps that launch on login
- redownload Dash docsets or sync
- Active Dash license file
- enable "Turn off my video when joining meeting" in zoomus
- enable "Mute microphone when joining meeting" in zoomus
- Setup printers
- Disable siri (and remove from touchbar)
- enable show bluetooth icon in menubar
