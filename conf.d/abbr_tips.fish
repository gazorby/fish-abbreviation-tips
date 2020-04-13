bind " " '_abbr_tips_bind_space'
bind \n '_abbr_tips_bind_newline'
bind \r '_abbr_tips_bind_newline'

set -l uninstall (basename (status -f) .fish){_uninstall}

set -g _abbr_tips_used 0
if ! set -q ABBR_TIPS_PROMPT; set -Ux ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"; end
if ! set -q ABBR_TIPS_AUTO_UPDATE; set -Ux ABBR_TIPS_AUTO_UPDATE 'background'; end

function abbr_fish --on-event fish_postexec -d "Abbreviation reminder for the current command"
    set -l command (string split ' ' "$argv")
    set -l cmd (string replace -r -a '\\s+' ' ' "$argv" )

    # Exit in the following cases :
    #  - abbreviation has been used
    #  - command is already an abbreviation
    #  - command not found
    #  - or it's a function (alias)
    if test $_abbr_tips_used = 1
        set -g _abbr_tips_used 0
        return
    else if abbr -q "$cmd"
       or ! type -q "$command[1]"
       return
    else if test (type -t "$command[1]") = 'function'
       and ! contains "$command[1]" $ABBR_TIPS_ALIAS_WHITELIST
       return
    end

    # Test the command against multiple regexes :
    #  - First test the command as is
    #  - Then try with arguments removed           (ex : git commit -m "mucommit"  => git commit -m)
    #  - Then try with the first two words         (ex : git add a.txt b.txt       => git add)
    #  - Finally trey with the first three words   (ex : docker volume rm myvolume => docker volume rm)
    if set -l abb (contains -i -- "$cmd" $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '((-{1,2})\\w+)(\\s\\S+)' '$1' "$cmd") $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '(^( ?\\w+){3}).*' '$1' "$cmd") $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '(^( ?\\w+){2}).*' '$1' "$cmd") $_ABBR_TIPS_VALUES)
       or set -l abb (contains -i -- (string replace -r -a '(^( ?\\w+){1}).*' '$1' "$cmd") $_ABBR_TIPS_VALUES)
        echo -e (string replace -a '{{ .cmd }}' "$_ABBR_TIPS_VALUES[$abb]" \
                (string replace -a '{{ .abbr }}' "$_ABBR_TIPS_KEYS[$abb]" "$ABBR_TIPS_PROMPT"))
        return
    end
end

function $uninstall --on-event $uninstall
    bind --erase \n
    bind --erase \r
    bind --erase " "
    set --erase _abbr_tips_used
    set --erase _ABBR_TIPS_VALUES
    set --erase _ABBR_TIPS_KEYS
    set --erase ABBR_TIPS_PROMPT
    set --erase ABBR_TIPS_AUTO_UPDATE
end

# Locking mechanism
# Prevent this file to spawn more than one subshell
if test "$USER" != 'root'
   and test $ABBR_TIPS_AUTO_UPDATE = 'background'
    begin
    flock -n 99; or exit
    fish -c 'abbr_tips_update' &
    end 99>/tmp/abbr_fish_lock
else if test $ABBR_TIPS_AUTO_UPDATE = 'normal'
    abbr_tips_update
end
