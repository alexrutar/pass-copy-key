function _psk_install --on-event psk_install
    for cmd in fd pass
        if not which $cmd &> /dev/null
            set_color yellow; echo "Warning: cannot find command '$cmd'. See https://github.com/alexrutar/psk for more details."; set_color normal
        end
    end
end

function _psk_uninstall --on-event psk_uninstall
    functions --erase psk
    functions --erase __psk_get_match
end

