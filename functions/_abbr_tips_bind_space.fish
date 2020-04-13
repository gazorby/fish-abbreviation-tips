function _abbr_tips_bind_space
    commandline -i " "
    if test $_abbr_tips_used != 1
        if abbr -q (string trim (commandline))
            set -g _abbr_tips_used 1
        else
            set -g _abbr_tips_used 0
        end
    end
    commandline -f 'expand-abbr'
end
