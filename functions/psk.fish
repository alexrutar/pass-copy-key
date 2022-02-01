function psk --argument command passfile key
    set -l psk_version 0.1
    function __psk_get_match --argument regex --inherit-variable passfile
        set -l username (pass show $passfile | tail -n +2 | string match -r $regex | head -n 2 | tail -n 1)
        if test -n "$username"
            echo -n "$username" | pbcopy
            return 0
        else
            return 1
        end
    end

    switch $command
        case -v --version
            echo "psk, version $psk_version"

        case '' -h --help
            echo 'Usage: psk login PASSFILE          Copy login and pass to the clipboard'
            echo '       psk show-key PASSFILE KEY   Copy value of the key to the clipboard'
            echo '       psk list-keys PASSFILE      List valid keys'
            echo 'Options:'
            echo '       -v | --version              Print version'
            echo '       -h | --help                 Print this help message'

        case login
            if __psk_get_match ".+:\ (.+)"
                echo "Copied $passfile login to clipboard."
                read -p 'echo "Press ENTER to continue "'
            else
                echo "$passfile has no login"
            end
            pass show -c $passfile

        case show-key
            if test -n "$key"
                if __psk_get_match "$key:\ (.+)"
                    echo "Copied $passfile key '$key' to clipboard"
                else
                    echo "Key '$key' not found in passfile!" >&2
                    return 1
                end
            else
                echo "Missing required argument 'key'" >&2
                return 1
            end

        case list-keys
            pass show $passfile | tail -n +2 | string match -r "(.+):\ .+" | sed -n 'n;p'

        case *
            echo "psk: Unknown command: \"$command\"" >&2
            return 1
    end
end
