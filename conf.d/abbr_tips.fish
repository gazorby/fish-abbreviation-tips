function abbr_fish --on-event fish_postexec -d "Abbreviation reminder for the current command"
    set -l command (string split ' ' "$argv")
    # Exit if either command is already an abbreviation
    # or not found
    # or it's a function
    if abbr -q "$argv"
       or ! type -q "$command[1]"
       return
    end
    if test (type -t "$command[1]") = 'function'
       and ! contains "$command[1]" $ABBR_TIPS_ALIAS_WHITELIST
       return
    end

    # Retrieve abbreviation
    if set -l i (contains -i -- "$argv" $_ABBR_TIPS_VALUES)
        echo -e "\n💡 \e[1m$_ABBR_TIPS_KEYS[$i]\e[0m => $_ABBR_TIPS_VALUES[$i]"
    end
end

# Locking mechanism
# Prevent this file to spawn more than one subshell
begin
flock -n 99; or exit
fish -c 'abbr_tips_update' &
end 99>/tmp/abbr_fish_lock
