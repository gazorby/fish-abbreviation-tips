# Use with jorgebucaran/fishtape to run tests
# i.e. fishtape test/fish-abbreviation-tips.fish

function setup
    # Source plugin
    source functions/__abbr_tips_init.fish
    source functions/__abbr_tips_clean.fish
    source conf.d/abbr_tips.fish
    source functions/__abbr_tips_bind_newline.fish
    source functions/__abbr_tips_bind_space.fish
    # Backup settings variables
    set -g tmp_keys $__ABBR_TIPS_KEYS
    set -g tmp_values $__ABBR_TIPS_VALUES
    set -g tmp_tips_prompt $ABBR_TIPS_PROMPT
    set -g ABBR_TIPS_PROMPT "{{ .abbr }} => {{ .cmd }}"
end

function teardown
    # Restore variables
    set __ABBR_TIPS_KEYS $tmp_keys
    set __ABBR_TIPS_VALUES $tmp_values
    set ABBR_TIPS_PROMPT "$tmp_tips_prompt"
end

function clear_test_var
    # Clear variables to prevent the results
    # of each unit test from affecting each other
    set -g __ABBR_TIPS_KEYS
    set -g __ABBR_TIPS_VALUES
    abbr -e __abbr_test
    abbr -e __abbr_test_one
    abbr -e __abbr_test_two
end
