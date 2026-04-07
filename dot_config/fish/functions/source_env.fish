function source_env --description "Source POSIX env file into fish"
    set -l file $argv[1]
    if not test -f "$file"
        return
    end

    # Run POSIX shell, dump env after sourcing
    set -l tmp (mktemp)

    # Use 'export' instead of just 'env' to ensure we only get exported vars
    bash -c "
        set -a
        source \"$file\" >/dev/null 2>&1
        env
    " > $tmp

    while read -l line
        set -l kv (string split -m1 "=" -- $line)
        set -l key $kv[1]
        set -l val $kv[2]

        # skip problematic/read-only vars
        # Added '_' to the list to prevent the read-only error
        switch "$key"
            case PWD SHLVL _
                continue
            case '*'
                if test -n "$key"
                    set -gx $key $val
                end
        end
    end < $tmp

    rm $tmp
end
