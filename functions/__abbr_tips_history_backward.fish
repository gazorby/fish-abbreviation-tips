function __abbr_tips_history_backward -d "history-search-backward wrapper for the fish-abbreviation-tips plugin"
    set -g __abbr_tips_used 1
    commandline -f history-search-backward
end
