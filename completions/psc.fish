set -l psc_subcommands login show-key list-keys
complete --command psc --exclusive --long help --description "Print help"
complete --command psc --exclusive --long version --description "Print version"

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

complete --command psc --exclusive --argument login \
    -n __fish_use_subcommand \
    --description 'Copy login and pass to the clipboard'

complete --command psc --exclusive --argument show-key \
    -n __fish_use_subcommand \
    --description 'Copy value of key to the clipboard'

complete --command psc --exclusive --argument list-keys \
    -n __fish_use_subcommand \
    --description 'List valid keys'

complete --command psc --exclusive --argument "(__fish_pass_print_entries)" \
    -n "__fish_seen_subcommand_from $psc_subcommands"