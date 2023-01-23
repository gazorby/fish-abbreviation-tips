source (string join "/" (dirname (status --current-filename)) "common.fish")

setup

# Test tip
@test "abbreviation tip match" (
  clear_test_var
  __abbr_tips 'abbr -a __abbr_test ps'
  echo (__abbr_tips 'ps')
) = "__abbr_test => ps"

@test "alias tip match" (
  clear_test_var
  alias __abbr_test_alias "grep -q"
  __abbr_tips 'alias __abbr_test_alias "grep -q"'
  echo (__abbr_tips 'grep -q')
) = "__abbr_test_alias => grep -q"

@test "multiple abbreviation tip match" (
  clear_test_var
  abbr -a __abbr_test_one ps
  abbr -a __abbr_test_two "grep -q"
  __abbr_tips_init
  echo (__abbr_tips 'grep -q')
) = "__abbr_test_two => grep -q"

@test "multiple alias tip match" (
  clear_test_var
  alias abbr_test_alias_one ps
  alias abbr_test_alias_two "grep -q"
  __abbr_tips_init
  echo (__abbr_tips 'grep -q')
) = "abbr_test_alias_two => grep -q"

teardown
