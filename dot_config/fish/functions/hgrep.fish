function hgrep --description "Search history with chained grep filters"
    if not set -q argv[1]
        history search
        return
    end

    if not command -sq rg
        echo "hgrep: ripgrep (rg) is required; install with: brew install ripgrep" >&2
        return 1
    end

    set -l results (builtin history search)
    for filter in $argv
        set results (printf '%s\n' $results | grep -F -- $filter)
        if test (count $results) -eq 0
            return 1
        end
    end

    set -l rg_args -F --passthru
    isatty stdout; and set -a rg_args --color=always

    for filter in $argv
        set -a rg_args -e $filter
    end

    printf '%s\n' $results | rg $rg_args
end
