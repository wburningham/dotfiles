# === theme/prompt ===
fish_config theme choose "catppuccin-mocha"
# set -U -e tide_right_prompt_items
# Not sure, but this is needed to remove the items
# set -U -e _tide_right_items
set -g tide_character_vi_icon_default '❯'
set -g tide_character_vi_icon_normal  '❯'
set -g tide_character_vi_icon_visual  '❯'
set -g tide_character_vi_icon_replace '❯'


# === secrets ===
# Source secrets not committed to VCS
if test -f ~/.localrc.fish
    source ~/.localrc.fish
end
if test -f ~/.work.localrc.fish
    source ~/.work.localrc.fish
end

# === paths ===
fish_add_path $GOBIN
fish_add_path /opt/homebrew/bin
fish_add_path $(brew --prefix rustup)/bin
fish_add_path $(brew --prefix ruby)/bin

# === sourcing ===
status is-interactive; and begin
    if command -sq fnm
        fnm env --use-on-cd | source
    end
end
status is-interactive; and begin
    if command -sq zoxide
        zoxide init fish | source
    end
end
status is-interactive; and begin
    if command -sq try
        mcfly init fish | source
    end
end

# === abbreviations ===
status is-interactive; and begin
    abbr --add -- copy pbcopy
    abbr --add -- paste pbpaste
    abbr --add -- pasta pbpaste
    abbr --add -- gocm gcom
    abbr --add -- dinspect 'docker buildx imagetools inspect'
    abbr --add -- dpull 'd pull'
    abbr --add -- gglp 'git pull origin (__git.current_branch) --prune && git branch --merged | grep -v (__git.current_branch) | xargs git branch -d'
    abbr --add -- grbai 'git rebase --autosquash --interactive'
    abbr --add -- gs 'git status'
    abbr --add -- hgrep 'history | grep'
    abbr --add -- ts 'tig status'
    abbr --add -- tscan 'trivy image --quiet --skip-version-check --pkg-types os,library'

    # Started as aliases, but trying about as abbreviations
    abbr --add -- ls lsd
    abbr --add -- la 'lsd -A'
    abbr --add -- ll 'lsd -l'
    abbr --add -- lla 'lsd -lA'
    abbr --add -- llt 'lsd -l --tree'
    abbr --add -- lt 'lsd --tree'
end

# === aliases ===
status is-interactive; and begin
    alias c chezmoi
    alias d docker
    alias allow 'direnv allow .'
    alias deny 'direnv deny .'
    alias dp podman
    alias h history
    alias nvm fnm
    # Use alias instead of abbreviation since ctrl+r doesn't work well w/ multi-line commands
    alias gcopy 'git rev-parse HEAD | tr -d '\''
'\'' | pbcopy'

    # Started as aliases, but trying about as abbreviations
    #alias ls lsd
    #alias la 'lsd -A'
    #alias ll 'lsd -l'
    #alias lla 'lsd -lA'
    #alias llt 'lsd -l --tree'
    #alias lt 'lsd --tree'

    # Easier navigation: .., ..., ...., .....
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'
    alias ..... 'cd ../../../..'

    alias mergepdf '/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

    # macOS hashing tools have different names; alias to the correct ones
    if not command -sq md5sum; and command -sq md5
        alias md5sum md5
    end
    if not command -sq sha1sum; and command -sq shasum
        alias sha1sum 'shasum -a 1'
    end

end

# === completions ===
status is-interactive; and begin
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
end

# === misc ===
# -U and -x are independent flags that control different things:
# -U (universal): Makes the variable persistent across all Fish shell sessions and survives restarts
# -x (export): Makes the variable available to child processes (shows up in printenv)

set sponge_purge_only_on_exit true
