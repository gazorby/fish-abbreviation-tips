source (string join "/" (dirname (status --current-filename)) "common.fish")

setup

# Add alias
@test "add alias tip key simple quotes" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias \'grep -q\''
  contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add alias tip value simple quotes" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias \'grep -q\''
  contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip key double quotes" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add alias tip value double quotes" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip value with =" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias=grep'
  contains "grep" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip key with =" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias=grep'
  contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add alias tip value with = and quotes" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias="grep "'
  contains "grep" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip key with = and quotes" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias="grep "'
  contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

# Remove alias
@test "remove alias tip key" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  __abbr_tips  'functions --erase __abbr_test_alias'
  not contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "remove alias tip value" (
  clear_test_var
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  __abbr_tips 'functions --erase __abbr_test_alias'
  not contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0


teardown
