function abbr_tips_update -d "Update abbreviations variables for fish-abbr-tips"
    set -e _ABBR_TIPS_KEYS
    set -e _ABBR_TIPS_VALUES
    set -Ux _ABBR_TIPS_KEYS
    set -Ux _ABBR_TIPS_VALUES

    set -l i 1
    set -l abb (string replace -r '.*-- ' '' (abbr -s))
    while test $i -le (count $abb)
        set -l current_abb (string split -m1 ' ' "$abb[$i]")
        set -a _ABBR_TIPS_KEYS "$current_abb[1]"
        set -a _ABBR_TIPS_VALUES  (string trim -c '\'' "$current_abb[2]")
        set i (math $i + 1)
    end
end