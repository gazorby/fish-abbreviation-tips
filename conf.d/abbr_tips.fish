bind " " '_abbr_tips_bind_space'
bind \n '_abbr_tips_bind_newline'
bind \r '_abbr_tips_bind_newline'

set -g _abbr_tips_used 0
if ! set -q ABBR_TIPS_PROMPT; set -gx ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"; end
if ! set -q ABBR_TIPS_AUTO_UPDATE; set -gx ABBR_TIPS_AUTO_UPDATE 'background'; end

# Regexes used to find abbreviation inside command
# Only the first matching group will be tested as an abbr
if not set -q ABBR_TIPS_REGEXES
    set -gx ABBR_TIPS_REGEXES
    set -a ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)'
    set -a ABBR_TIPS_REGEXES '(^( ?\w+){3}).*'
    set -a ABBR_TIPS_REGEXES '(^( ?\w+){2}).*'
    set -a ABBR_TIPS_REGEXES '(^( ?\w+){1}).*'
end

function _abbr_tips --on-event fish_postexec -d "Abbreviation reminder for the current command"
    set -l command (string split ' ' "$argv")
    set -l cmd (string replace -r -a '\\s+' ' ' "$argv" )

    # Update abbreviations lists when adding/removing abbreviations
    if test "$command[1]" = "abbr"
        if string match -q -r '^--append|-a$' -- "$command[2]"
           and ! contains -- "$command[3]" $_ABBR_TIPS_KEYS
                set -a _ABBR_TIPS_KEYS "$command[3]"
                set -a _ABBR_TIPS_VALUES  "$command[4..-1]"
        else if string match -q -r '^--erase|-e$' -- "$command[2]"
            and set -l abb (contains -i -- "$command[3]" $_ABBR_TIPS_KEYS)
                set -e _ABBR_TIPS_KEYS[$abb]
                set -e _ABBR_TIPS_VALUES[$abb]
        end
    end

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

    set -l abb
    if not set abb (contains -i -- "$cmd" $_ABBR_TIPS_VALUES)
        for r in $ABBR_TIPS_REGEXES
            if set abb (contains -i -- (string replace -r -a -- "$r" '$1' "$cmd") $_ABBR_TIPS_VALUES)
                break
            end
        end
    end

    if test -n "$abb"
        echo -e (string replace -a '{{ .cmd }}' "$_ABBR_TIPS_VALUES[$abb]" \
                (string replace -a '{{ .abbr }}' "$_ABBR_TIPS_KEYS[$abb]" "$ABBR_TIPS_PROMPT"))
    end

    return
end

function __abbr_tips_uninstall --on-event abbr_tips_uninstall
    bind --erase \n
    bind --erase \r
    bind --erase " "
    set --erase _abbr_tips_used
    set --erase _abbr_tips_run_once
    set --erase _ABBR_TIPS_VALUES
    set --erase _ABBR_TIPS_KEYS
    set --erase ABBR_TIPS_PROMPT
    set --erase ABBR_TIPS_AUTO_UPDATE
    set --erase ABBR_TIPS_ALIAS_WHITELIST
    set --erase ABBR_TIPS_REGEXES
    functions --erase _abbr_tips_init
    functions --erase _abbr_tips_bind_newline
    functions --erase _abbr_tips_bind_space
    functions --erase _abbr_tips
end

# Locking mechanism
# Prevent this file to spawn more than one subshell
if test "$USER" != 'root'
   and ! set -q _abbr_tips_run_once
    set -Ux _abbr_tips_run_once 1
    fish -c '_abbr_tips_init' &
end
