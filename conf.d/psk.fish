function __psk_install --on-event psk_install
    for cmd in fd pass
        if not which $cmd &> /dev/null
            set_color yellow; echo "Warning: cannot find command '$cmd'. See https://github.com/alexrutar/psk#dependencies for more details."; set_color normal
        end
    end
end


function __psk_uninstall --on-event psk_uninstall
    functions --erase psk __psk_echo_help __psk_install __psk_uninstall
end
