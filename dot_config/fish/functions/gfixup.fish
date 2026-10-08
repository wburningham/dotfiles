function gfixup --description "Create a fixup commit and autosquash rebase without opening an editor"
    if not set -q argv[1]
        echo "usage: gfixup <sha>" >&2
        return 1
    end

    set -l sha $argv[1]

    git commit -v --fixup $sha
    and env GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash "$sha~"
end
