function __psk_echo_help
    echo 'Usage: psk login PASSFILE      Copy username and pass to the clipboard'
    echo '       psk copy PASSFILE KEY   Copy value of the key to the clipboard'
    echo '       psk show PASSFILE KEY   Print value of the key'
    echo '       psk list PASSFILE       List valid keys'
    echo 'Options:'
    echo '       -h/--help               Print this help message'
    echo '       -V/--version            Print version'
    echo 'Variables:'
    echo '       PSK_LOGIN_KEYS          Array of valid keys for passfile username'
    echo '                                Default: \'username\''
end


function psk
    set --local psk_version 0.4

    # set the copy command depending on the platform
    set --local copy_cmd
    if test -n $WAYLAND_DISPLAY
        and command -v wl-copy &> /dev/null
        set copy_cmd wl-copy
    else if test -n $DISPLAY
        and command -v xclip &> /dev/null
        set copy_cmd xclip -selection "$X_SELECTION"
    else if command -v pbcopy &> /dev/null
        set copy_cmd pbcopy
    else
        echo "Could not find valid clipboard program!" >&2
        return 1
    end

    function __psk_copy_value --inherit-variable copy_cmd --argument key passfile
        set --local value (pass show $passfile | tail -n +2 | yq ".[\"$key\"]")
        if test $value = "null"
            return 1
        else
            echo -n $value | $copy_cmd
        end
    end

    function __psk_show_value --argument key passfile
        set --local value (pass show $passfile | tail -n +2 | yq ".[\"$key\"]")
        if test $value = "null"
            return 1
        else
            echo $value
        end
    end

    function __psk_copy_login --argument passfile
        for username in $argv[2..]
            if __psk_copy_value $username $passfile
                echo "Copied $passfile login to clipboard."
                read -p 'echo "Press ENTER to continue "'
                return 0
            end
        end
        return 1
    end

    set --query PSK_LOGIN_KEYS
    or set --local PSK_LOGIN_KEYS username

    set --local options (fish_opt --short=V --long=version)
    set --local options $options (fish_opt --short=h --long=help)

    if not argparse $options -- $argv
        __psk_echo_help >&2
        return 1
    end

    set --local command $argv[1]
    set --local passfile $argv[2]
    set --local key $argv[3]

    if set --query _flag_help
        __psk_echo_help
        return 0
    end

    if set --query _flag_version
        echo "psk (version $psk_version)"
        return 0
    end


    if test -z "$command"
        echo "psk: missing subcommand" >&2
        __psk_echo_help >&2
        return 1
    end

    if test -z "$passfile"
        echo "psk: missing argument PASSFILE" >&2
        return 1
    end

    switch $command
        case login
            if not __psk_copy_login $passfile $PSK_LOGIN_KEYS
                echo "$passfile has no login key"
            end
            pass show -c $passfile

        case copy
            if test -n "$key"
                if __psk_copy_value $key $passfile
                    echo "Copied $passfile key '$key' to clipboard"
                else
                    echo "Key '$key' not found in passfile!" >&2
                    return 1
                end
            else
                echo "psk: missing argument KEY" >&2
                return 1
            end
 
        case show
            if test -n "$key"
                if __psk_show_value $key $passfile
                    return 0
                else
                    echo "Key '$key' not found in passfile!" >&2
                    return 1
                end
            else
                echo "psk: missing argument KEY" >&2
                return 1
            end

        case list
            # TODO: improve error message when yq fails with malformed input
            pass show $passfile | tail -n +2 | yq '. | keys' | cut -c 3- 

        case '*'
            echo "psk: Unknown subcommand '$command'" >&2
            return 1
    end
end
