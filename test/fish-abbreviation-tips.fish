# Use with jorgebucaran/fishtape to run tests
# i.e. fishtape tests/fish-abbreviation-tips.fish

function setup
    # Source plugin
    source functions/__abbr_tips_init.fish
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

# Tests
@test "initial tip key" (
  abbr -a __abbr_test ps
  set -e "$__ABBR_TIPS_KEYS[-1]"
  __abbr_tips_init
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "initial tip value" (
  abbr -a __abbr_test ps
  set -e "$__ABBR_TIPS_VALUES[-1]"
  __abbr_tips_init
  contains "ps" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add tip key" (
  __abbr_tips 'abbr -a __abbr_test ps'
) "$__ABBR_TIPS_KEYS[-1]" = "__abbr_test"

@test "add tip value" (
  __abbr_tips 'abbr -a __abbr_test ps'
) "$__ABBR_TIPS_VALUES[-1]" = "ps"

@test "remove tip key" (
  __abbr_tips 'abbr -a __abbr_test ps'
  __abbr_tips 'abbr -e __abbr_test'
) "$__ABBR_TIPS_KEYS[-1]" != "__abbr_test"

@test "remove tip value" (
  __abbr_tips 'abbr -a __abbr_test ps'
  __abbr_tips 'abbr -e __abbr_test'
) "$__ABBR_TIPS_VALUES[-1]" != "__abbr_test"

@test "tip match" (
  __abbr_tips 'abbr -a __abbr_test ps'
  echo (__abbr_tips 'ps')
) = "__abbr_test => ps"
