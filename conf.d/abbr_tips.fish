bind " " '_abbr_tips_bind_space'
bind \n '_abbr_tips_bind_newline'
bind \r '_abbr_tips_bind_newline'

set -l uninstall (basename (status -f) .fish){_uninstall}

set -g _abbr_tips_is_abbr 0

function abbr_fish --on-event fish_postexec -d "Abbreviation reminder for the current command"
    set -l command (string split ' ' "$argv")
    set -l cmd (string replace -r -a '\\s+' ' ' "$argv" )

    # Exit if either command is already an abbreviation
    # or not found
    # or it's a function
    if abbr -q "$cmd"
       or ! type -q "$command[1]"
       or test $_abbr_tips_is_abbr = 1
       return
    end
    if test (type -t "$command[1]") = 'function'
       and ! contains "$command[1]" $ABBR_TIPS_ALIAS_WHITELIST
       return
    end

    # Test the command against multiple regexes :
    # First test the command as is
    # Then try with arguments removed           (ex : git commit -m "mucommit"  => git commit -m)
    # Then try with the first two words         (ex : git add a.txt b.txt       => git add)
    # Finally trey with the first three words   (ex : docker volume rm myvolume => docker volume rm)
    if set -l abb (contains -i -- "$cmd" $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '((-{1,2})\\w+)(\\s\\S+)' '$1' "$cmd") $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '(^( ?\\w+){2}).*' '$1' "$cmd") $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '(^( ?\\w+){3}).*' '$1' "$cmd") $_ABBR_TIPS_VALUES)
        set -g _abbr_tips_is_abbr 0
        echo -e "\n💡 \e[1m$_ABBR_TIPS_KEYS[$abb]\e[0m => $_ABBR_TIPS_VALUES[$abb]"
        return
    end
end

function $uninstall --on-event $uninstall
    bind --erase \n
    bind --erase \r
    bind --erase " "
end

# Locking mechanism
# Prevent this file to spawn more than one subshell
begin
flock -n 99; or exit
fish -c 'abbr_tips_update' &
end 99>/tmp/abbr_fish_lock
