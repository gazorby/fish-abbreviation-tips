bind " " '__abbr_tips_bind_space'
bind \n '__abbr_tips_bind_newline'
bind \r '__abbr_tips_bind_newline'

set -g __abbr_tips_used 0
if not set -q ABBR_TIPS_PROMPT; set -gx ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"; end
if not set -q ABBR_TIPS_AUTO_UPDATE; set -gx ABBR_TIPS_AUTO_UPDATE 'background'; end

# Regexes used to find abbreviation inside command
# Only the first matching group will be tested as an abbr
if not set -q ABBR_TIPS_REGEXES
    set -gx ABBR_TIPS_REGEXES
    set -a ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)'
    set -a ABBR_TIPS_REGEXES '(^(\s?(\w-?)+){3}).*'
    set -a ABBR_TIPS_REGEXES '(^(\s?(\w-?)+){2}).*'
    set -a ABBR_TIPS_REGEXES '(^(\s?(\w-?)+){1}).*'
end

function __abbr_tips --on-event fish_postexec -d "Abbreviation reminder for the current command"
    set -l command (string split ' ' "$argv")
    set -l cmd (string replace -r -a '\\s+' ' ' "$argv" )

    # Update abbreviations lists when adding/removing abbreviations
    if test "$command[1]" = "abbr"
        if string match -q -r '^--append|-a$' -- "$command[2]"
           and not contains -- "$command[3]" $__ABBR_TIPS_KEYS
                set -a __ABBR_TIPS_KEYS "$command[3]"
                set -a __ABBR_TIPS_VALUES  "$command[4..-1]"
        else if string match -q -r '^--erase|-e$' -- "$command[2]"
            and set -l abb (contains -i -- "$command[3]" $__ABBR_TIPS_KEYS)
                set -e __ABBR_TIPS_KEYS[$abb]
                set -e __ABBR_TIPS_VALUES[$abb]
        end
    end

    # Exit in the following cases :
    #  - abbreviation has been used
    #  - command is already an abbreviation
    #  - command not found
    #  - or it's a function (alias)
    if test $__abbr_tips_used = 1
        set -g __abbr_tips_used 0
        return
    else if abbr -q "$cmd"
       or not type -q "$command[1]"
       return
    else if test (type -t "$command[1]") = 'function'
       and not contains "$command[1]" $ABBR_TIPS_ALIAS_WHITELIST
       return
    end

    set -l abb
    if not set abb (contains -i -- "$cmd" $__ABBR_TIPS_VALUES)
        for r in $ABBR_TIPS_REGEXES
            if set abb (contains -i -- (string replace -r -a -- "$r" '$1' "$cmd") $__ABBR_TIPS_VALUES)
                break
            end
        end
    end

    if test -n "$abb"
        echo -e (string replace -a '{{ .cmd }}' "$__ABBR_TIPS_VALUES[$abb]" \
                (string replace -a '{{ .abbr }}' "$__ABBR_TIPS_KEYS[$abb]" "$ABBR_TIPS_PROMPT"))
    end

    return
end

function __abbr_tips_uninstall --on-event abbr_tips_uninstall
    bind --erase \n
    bind --erase \r
    bind --erase " "
    set --erase __abbr_tips_used
    set --erase __abbr_tips_run_once
    set --erase __ABBR_TIPS_VALUES
    set --erase __ABBR_TIPS_KEYS
    set --erase ABBR_TIPS_PROMPT
    set --erase ABBR_TIPS_AUTO_UPDATE
    set --erase ABBR_TIPS_ALIAS_WHITELIST
    set --erase ABBR_TIPS_REGEXES
    functions --erase __abbr_tips_init
    functions --erase __abbr_tips_bind_newline
    functions --erase __abbr_tips_bind_space
    functions --erase __abbr_tips
end

# Locking mechanism
# Prevent this file to spawn more than one subshell
if test "$USER" != 'root'
   and not set -q __abbr_tips_run_once
    set -Ux __abbr_tips_run_once 1
    fish -c '__abbr_tips_init' &
end
