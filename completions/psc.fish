set -l psc_subcommands login show-key list-keys
complete -f -c psc

# pass completions from
#  https://git.zx2c4.com/password-store/tree/src/completion/pass.fish-completion
function __fish_pass_get_prefix
    if set -q PASSWORD_STORE_DIR
        realpath -- "$PASSWORD_STORE_DIR"
    else
        echo "$HOME/.password-store"
    end
end

function __fish_pass_print_entries
    set -l ext '.gpg'
    set -l prefix (__fish_pass_get_prefix)
    set -l matches $prefix/**$ext
    printf '%s\n' $matches | sed "s#$prefix/\(.*\)$ext#\1#"
end

complete -c psc -a login \
    -n __fish_use_subcommand \
    -d 'Copy login and pass to the clipboard'

complete -c psc -a show-key \
    -n __fish_use_subcommand \
    -d 'Copy value of key to the clipboard'

complete -c psc -a list-keys \
    -n __fish_use_subcommand \
    -d 'List valid keys'

complete -c psc -a "(__fish_pass_print_entries)" \
    -n "__fish_seen_subcommand_from $psc_subcommands"
