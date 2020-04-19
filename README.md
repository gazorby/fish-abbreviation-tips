# fish-abbreviation-tips [![Generic badge](https://img.shields.io/badge/Version-v0.4.0-<COLOR>.svg)](https://shields.io/)

[![asciicast](https://asciinema.org/a/2Cbvv03MZMtZmOBFv4E9qrWMC.svg)](https://asciinema.org/a/2Cbvv03MZMtZmOBFv4E9qrWMC)

Help you remembering abbreviations by displaying tips when you can use them

## 🚀 Install

Install using fisher :

```console
fisher add Gazorby/fish-abbreviation-tips
```
## 🔧 Usage

Just use your shell normally and enjoy abbreviations tips!

### Adding / removing abbreviations
The plugin automatically track changes when adding/removing abbreviations using `abbr` command (see [behind the scenes](#-behind-the-scenes)), so you won't see tips anymore for an abbreviation that has been erased, and you will get new ones for newly added abbreviations

## 🛠 Configuration

Configuration is done through environment variables.

To avoid spamming your `config.fish`, you can set environment variables using `set -U` once, to make them persistent across restarts and share them across fish's instances

### Tips prompt

`ABBR_TIPS_PROMPT`

By default, tips will showing up like this :

```console
💡 ga => git add
```

But you customize it using the prompt environment variable. The plugin will replace `{{ .abbr }}` with the abbreviation and `{{ .cmd }}` with the corresponding command.


This is the default :

`"\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"`

⚠️ tips are displayed using `echo -e` (interpretation of backslash escapes)


### Alias whitelist

`ABBR_TIPS_ALIAS_WHITELIST`

By default, the plugin ignore user defined functions (aliases), because your aliases names are likely to unique, so there wouldn't be an abbreviation with the same name.

But, in some cases, you may write aliases which wrap exisiting commands to add some hooks before/after the actual command execution. In this special case, as your aliases probably don't alter the original command, you may also have abbreviations using these aliases, so you don't want to ignore them.

To do that, just add alias to the environment variable

## 🎥 Behind the scenes
In order to not slow down your prompt, the plugin store abbreviations and their corresponding commands in lists (actually simulating a dictionary, as [fish doesn't support dict yet](https://github.com/fish-shell/fish-shell/issues/390)) to avoid iterating over all abbreviations each time you type a command. So retrieving an abbreviation from a command is fast as it doesn't involve any loop.

The plugin will create lists once during installation by calling `_abbr_tips_init` in background (more precisely in spawned shell, because [fish doesn't put functions in background](https://github.com/fish-shell/fish-shell/issues/238)). Then, lists will get updated when you add or remove abbreviation using `abbr` builtin.

## 👍 Inspiration

Inspired by [zsh-fast-alias-tips](https://github.com/sei40kr/zsh-fast-alias-tips) and [alias-tips](https://github.com/djui/alias-tips) zsh plugins


## 📝 License
[MIT](https://github.com/Gazorby/fish-abbreviation-tips/blob/master/LICENSE)
