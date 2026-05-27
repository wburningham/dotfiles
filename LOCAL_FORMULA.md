# Local Homebrew formula workaround

Steps for pinning a Homebrew formula to a previous version (or installing a locally forked version) via a private tap. Used when an upstream release has a bug. The example uses `vale` pinned to `3.14.1`.

## Set up the pinned formula

### 1. Tap homebrew/core

`brew extract` needs `homebrew/core` cloned locally, so tap it explicitly:

```sh
brew tap homebrew/core --force
```

### 2. Create a local tap

```sh
brew tap-new wesb/local
```

Creates `$(brew --repository)/Library/Taps/wesb/homebrew-local/`.

### 3. Extract the desired version

```sh
brew extract --version=3.14.1 vale wesb/local
```

Generates `Library/Taps/wesb/homebrew-local/Formula/vale@3.14.1.rb`.

### 4. Patch the extracted formula (Go programs)

`brew extract` copies the original `install do` block verbatim. For Go formulae that rely on `std_go_args`, this breaks because `std_go_args` defaults `-o` to `#{bin}/#{name}` and `name` is now the versioned form (`vale@3.14.1`). The build produces a binary literally named `vale@3.14.1` instead of `vale`, which then gets symlinked into PATH under the wrong name.

Edit `$(brew --repository)/Library/Taps/wesb/homebrew-local/Formula/vale@3.14.1.rb` and pin the output name:

```ruby
# Before
system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"

# After
system "go", "build", *std_go_args(output: bin/"vale", ldflags: ldflags), "./cmd/vale"
```

The same pattern applies to any other Go formula extracted this way: pass `output: bin/"<command-name>"` to `std_go_args`.

### 5. Edit the Brewfile

Edit `dot_homebrew/Brewfile` and replace the unversioned entry with the tap-qualified one:

```ruby
# Before
brew "vale"

# After
brew "wesb/local/vale@3.14.1"
```

Don't add a `tap "wesb/local"` line. The local tap has no git remote, so the directive would try to clone `github.com/wesb/homebrew-local` and fail. `brew bundle` finds the formula because the tap directory already exists from `tap-new`.

### 6. Apply `chezmoi` and run bundle

```sh
chezmoi apply
brew bundle install -g --cleanup
```

`--cleanup` uninstalls the unversioned `vale` keg and installs the pinned version.

### 7. Verify

```sh
which vale
vale --version
```

### 8. Drop the homebrew/core tap

Now that the formula is extracted, the core tap is no longer needed. Drop it to save a few hundred MB and quiet the API noise:

```sh
brew untap homebrew/core
```

## Revert once upstream is fixed

### 1. Edit the Brewfile

Edit `dot_homebrew/Brewfile` and swap the tap-qualified entry back to the plain name:

```ruby
brew "vale"
```

### 2. Apply chezmoi and run bundle

```sh
chezmoi apply
brew bundle install -g --cleanup
```

Uninstalls `wesb/local/vale@3.14.1` and installs the current official `vale`.

### 3. Drop the local tap

```sh
brew untap wesb/local
```

`untap` refuses to remove a tap while any of its formulae are still installed, which is why this step comes after `--cleanup` has uninstalled the pinned version.
