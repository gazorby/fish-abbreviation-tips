# Use with jorgebucaran/fishtape to run tests
# i.e. fishtape test/fish-abbreviation-tips.fish

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
  set -e __ABBR_TIPS_KEYS
  __abbr_tips_init
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "initial tip value" (
  abbr -a __abbr_test ps
  set -e __ABBR_TIPS_VALUES
  __abbr_tips_init
  contains "ps" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add abbreviation tip key" (
  __abbr_tips 'abbr -a __abbr_test ps'
  contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add abbreviation tip value" (
  __abbr_tips 'abbr -a __abbr_test ps'
  contains "ps" $__ABBR_TIPS_VALUES
) "$status" = 0


@test "remove abbreviation tip key" (
  __abbr_tips 'abbr -a __abbr_test ps'
  __abbr_tips 'abbr -e __abbr_test'
  not contains "__abbr_test" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "remove abbreviation tip value" (
  __abbr_tips 'abbr -a __abbr_test ps'
  __abbr_tips 'abbr -e __abbr_test'
  not contains "ps" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip key" (
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "add alias tip value" (
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip value with =" (
  __abbr_tips  'alias __abbr_test_alias=grep"'
  contains "grep" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "add alias tip key with =" (
  __abbr_tips  'alias __abbr_test_alias=grep"'
  contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0


@test "remove alias tip key" (
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  __abbr_tips  'functions --erase __abbr_test_alias'
  not contains "a____abbr_test_alias" $__ABBR_TIPS_KEYS
) "$status" = 0

@test "remove alias tip value" (
  __abbr_tips  'alias __abbr_test_alias "grep -q"'
  __abbr_tips 'functions --erase __abbr_test_alias'
  not contains "grep -q" $__ABBR_TIPS_VALUES
) "$status" = 0

@test "abbreviation tip match" (
  __abbr_tips 'abbr -a __abbr_test ps'
  echo (__abbr_tips 'ps')
) = "__abbr_test => ps"

@test "alias tip match" (
  alias __abbr_test_alias "grep -q"
  __abbr_tips 'alias __abbr_test_alias "grep -q"'
  echo (__abbr_tips 'grep -q')
) = "__abbr_test_alias => grep -q"
