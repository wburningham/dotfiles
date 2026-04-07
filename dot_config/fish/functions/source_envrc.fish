function source_envrc --description "Source POSIX env file into fish"
    set -l file $argv[1]
    if not test -f $file
        return
    end

    # Run POSIX shell, dump env after sourcing
    set -l tmp (mktemp)

    bash -c "
        set -a
        source \"$file\" >/dev/null 2>&1
        env
    " > $tmp

    for line in (cat $tmp)
        set -l key (string split -m1 "=" $line)[1]
        set -l val (string split -m1 "=" $line)[2]

        # skip problematic vars
        if test "$key" = "PWD" -o "$key" = "SHLVL"
            continue
        end

        set -gx $key $val
    end

    rm $tmp
end
