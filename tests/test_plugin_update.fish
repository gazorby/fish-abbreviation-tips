source (string join "/" (dirname (status --current-filename)) "common.fish")

# Test that plugin update reset tip keys

setup

@test "plugin update __ABBR_TIPS_KEYS length" (
  set len_keys (count $__ABBR_TIPS_KEYS)
  set -a __ABBR_TIPS_KEYS __wrong_key
  __abbr_tips_update
  test (count $__ABBR_TIPS_KEYS) -eq $len_keys
) "$status" = 0

setup

@test "plugin update __ABBR_TIPS_KEYS value" (
  set last_key "$__ABBR_TIPS_KEYS[-1]"
  set -a __ABBR_TIPS_KEYS __wrong_key
  __abbr_tips_update
  test "$__ABBR_TIPS_KEYS[-1]" = "$last_key"
) "$status" = 0

setup

# Test that plugin update reset tip values

@test "plugin update __ABBR_TIPS_VALUES length" (
  set len_keys (count $__ABBR_TIPS_VALUES)
  set -a __ABBR_TIPS_VALUES __wrong_key
  __abbr_tips_update
  test (count $__ABBR_TIPS_VALUES) -eq $len_keys
) "$status" = 0

setup

@test "plugin update __ABBR_TIPS_VALUES value" (
  set last_key "$__ABBR_TIPS_VALUES[-1]"
  set -a __ABBR_TIPS_VALUES __wrong_key
  __abbr_tips_update
  test "$__ABBR_TIPS_VALUES[-1]" = "$last_key"
) "$status" = 0


teardown
