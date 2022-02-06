function psk --argument command passfile key
    set -l psk_version 0.2
    function __psk_copy_value --argument key passfile
        set --local value (pass show $passfile | tail -n +2 | yq ".[\"$key\"]")
        if test $value = "null"
            return 1
        else
            echo -n $value | pbcopy
        end
    end

    function __psk_copy_login --argument passfile
        for username in $argv[2..]
            if __psk_copy_value $username $passfile
                echo "Copied $passfile username to clipboard."
                read -p 'echo "Press ENTER to continue "'
                return 0
            end
        end
        return 1
    end

    set --query PSK_LOGIN_KEYS
    or set --local PSK_LOGIN_KEYS username

    switch $command
        case -v --version
            echo "psk, version $psk_version"

        case '' -h --help
            echo 'Usage: psk login PASSFILE          Copy username and pass to the clipboard'
            echo '       psk copy-key PASSFILE KEY   Copy value of the key to the clipboard'
            echo '       psk list-keys PASSFILE      List valid keys'
            echo 'Options:'
            echo '       -v | --version              Print version'
            echo '       -h | --help                 Print this help message'
            echo 'Variables:'
            echo '       PSK_LOGIN_KEYS              Array of valid keys for passfile username'
            echo '                                    Default: username'

        case login
            if not __psk_copy_login $passfile $PSK_LOGIN_KEYS
                echo "$passfile has no login key"
            end
            pass show -c $passfile

        case copy-key
            if test -n "$key"
                if __psk_copy_value $key $passfile
                    echo "Copied $passfile key '$key' to clipboard"
                else
                    echo "Key '$key' not found in passfile!" >&2
                    return 1
                end
            else
                echo "Missing required argument: KEY" >&2
                return 1
            end

        case list-keys
            # TODO: improve error message when yq fails with malformed input
            pass show $passfile | tail -n +2 | yq '. | keys' | cut -c 3- 

        case *
            echo "psk: Unknown command: \"$command\"" >&2
            return 1
    end
end
