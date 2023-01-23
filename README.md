# fish-abbreviation-tips [![Generic badge](https://img.shields.io/badge/Version-v0.5.1-<COLOR>.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/fish->=3.1.0-red.svg)](https://shields.io/) [![Generic badge](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://shields.io/)

[![asciicast](https://asciinema.org/a/322043.svg)](https://asciinema.org/a/322043)

It helps you remember abbreviations and aliases by displaying tips when you can use them.

## ✅ Requirements

- [fish](https://github.com/fish-shell/fish-shell) 3.1.0+

## 🚀 Install

Install using [Fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install gazorby/fish-abbreviation-tips
```

## 🔧 Usage

Just use your shell normally and enjoy tips!

### Adding / removing abbreviations or aliases

The plugin automatically track changes when adding/removing abbreviations or aliases using `abbr` or `functions` commands (see [behind the scenes](#-behind-the-scenes)), so you won't see tips anymore for an abbreviation/alias that has been erased, and you will get new ones for newly added abbreviations/aliases

## 🛠 Configuration

Configuration is done through environment variables.

To avoid spamming your `config.fish`, you can set environment variables using `set -U` once to make them persistent across restarts and share them across fish's instances.

### Default configuration

```fish
ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"
ABBR_TIPS_ALIAS_WHITELIST # Not set

ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' '(^( ?\w+){3}).*' '(^( ?\w+){2}).*' '(^( ?\w+){1}).*'
# 1 : Test command with arguments removed
# 2 : Test the firsts three words
# 3 : Test the firsts two words
# 4 : Test the first word
```

### Tips prompt

`ABBR_TIPS_PROMPT`

By default, tips will show up like this :

```console
💡 ga => git add
```

But you can customize it using the prompt environment variable. The plugin will replace `{{ .abbr }}` with the abbreviation/alias and `{{ .cmd }}` with the corresponding command.

⚠️ tips are displayed using `echo -e` (interpretation of backslash escapes)

### Alias whitelist

`ABBR_TIPS_ALIAS_WHITELIST`

By default, if the command is a user-defined function (alias), the plugin won't search for a matching abbreviation because your aliases names are likely to be uniques, so there wouldn't be abbreviations with the same names.

But, in some cases, you may write aliases that wrap existing commands without altering their actual execution (e.g., add some hooks before/after the command execution). In this special case, you may also have abbreviations using these aliases, so you don't want to ignore them.

To do that, add these aliases to the environment variable.

### Regexes

`ABBR_TIPS_REGEXES`

If the command doesn't match an abbreviation/alias exactly, it is tested against some regexes to extract a possible abbreviation/alias.

For example, you could have an abbreviation/alias like this :

```console
gcm => git commit -m
```

So you want a tip when typing `git commit -m "my commit"`, but the command doesn't match exactly `git commit -m`.
To tackle this, we have a default regex that will match commands with arguments removed, so your `git commit -m "my commit"` will be tested as `git commit -m`.

You can add such regexes to the `ABBR_TIPS_REGEXES` list, and they will be tested in the order in which they have been added (see [default configuration](#default-configuration)). Matching is lazy, so if the string extracted with the first regex matches an abbreviation/alias, it won't go further. Remember that only the _first matching group_ will be tested. (so you must have at least one per regex)

## 🎥 Behind the scenes

In order to not slow down your prompt, the plugin store abbreviations/aliases and their corresponding commands in lists (actually simulating a dictionary, as [fish doesn't support dict yet](https://github.com/fish-shell/fish-shell/issues/390)) to avoid iterating over all abbreviations/aliases each time you type a command. So retrieving an abbreviation or an alias from a command is fast as it doesn't involve any loop.

The plugin will create lists once during installation by calling `__abbr_tips_init` in the background (more precisely in spawned shell, because [fish doesn't put functions in background](https://github.com/fish-shell/fish-shell/issues/238)). Then, lists will get updated when you add or remove abbreviation/alias using `abbr` or `functions` builtin.

## 💭 Inspiration

Inspired by [zsh-fast-alias-tips](https://github.com/sei40kr/zsh-fast-alias-tips) and [alias-tips](https://github.com/djui/alias-tips) zsh plugins

## 📝 License

[MIT](https://github.com/Gazorby/fish-abbreviation-tips/blob/master/LICENSE)
