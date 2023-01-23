source (string join "/" (dirname (status --current-filename)) "common.fish")

setup

# Add abbreviation
@test "add abbreviation tip key" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test grep -q'
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add abbreviation tip value" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test grep -q'
  contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add abbreviation tip key with simple quotes" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test \'grep -q\''
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add abbreviation tip value with simple quotes" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test \'grep -q\''
  contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add abbreviation tip key with double quotes" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test "grep -q"'
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add abbreviation tip value with double quotes" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test "grep -q"'
  contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0


# Remove abbreviation
@test "remove abbreviation tip key" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test ps'
  __abbr_tips 'abbr -e __abbr_test'
  not contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "remove abbreviation tip value" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test ps'
  __abbr_tips 'abbr -e __abbr_test'
  not contains "ps" $__ABBR_TIPS_VALUES
) "$status" = 0


teardown
