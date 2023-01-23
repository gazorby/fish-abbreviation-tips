source (string join "/" (dirname (status --current-filename)) "common.fish")

setup

# Initialization
@test "initial tip key" (
  clear_test_var
  abbr -a __abbr_test ps
  set -e __ABBR_TIPS_KEYS
  __abbr_tips_init
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "initial tip value" (
  clear_test_var
  abbr -a __abbr_test ps
  set -e __ABBR_TIPS_VALUES
  __abbr_tips_init
  contains "ps" $__ABBR_TIPS_VALUES
) "$status" = 0

teardown
