#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install Bash 4.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh
brew install screen

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install git
# brew install go # couldn't get this to show up in the path correctly
brew install git
brew install imagemagick
brew install nvm
brew install tig
brew install tree

# Install some awesome QuickLook plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode # Preview source code files with syntax highlighting
brew cask install qlstephen # Preview plain text files without or with unknown file extension. 
# brew cask install quicklook-json # Preview JSON files
brew cask install qlimagesize # Display image size and resolution

# Remove outdated versions from the cellar.
brew cleanup
