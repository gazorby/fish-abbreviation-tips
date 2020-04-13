# abbr-tips

[![asciicast](https://asciinema.org/a/2Cbvv03MZMtZmOBFv4E9qrWMC.svg)](https://asciinema.org/a/2Cbvv03MZMtZmOBFv4E9qrWMC)

Help you remembering abbreviations by displaying tips when you can use them

## 🚀 Install

Install using fisher :

```console
fisher add Gazorby/abbr-tips
```
## 🔧 Usage

Just use your shell normally and enjoy abbreviations tips!

### Adding new abbreviations
Tips are updated at every shell startup (see [behind the scenes](#-behind-the-scenes)), so closing and repoening your shell is enough to get tips updated. But you can also invoke `abbr_tips_update` to manually update tips.

## 🛠 Configuration

### Alias whitelist

By default, the plugin ignore user defined functions (aliases), because your aliases names are likely to unique, so there wouldn't be an abbreviation with the same name.

But, in some cases, you may write aliases which wrap exisiting commands to add some hooks before/after the actual command execution. In this special case, as your aliases probably don't alter the original command, you may also have abbreviations using these aliases, so you don't want to ignore them.

To do that, just add alias to the `ABBR_TIPS_ALIAS_WHITELIST` environment variable

## 🎥 Behind the scenes
In order to not slow down your prompt, the plugin store abbreviations in lists (actually simulating a dictionary, as [fish doesn't support dict yet](https://github.com/fish-shell/fish-shell/issues/390)) to avoid iterating over all abbreviations each time you type a command. So retrieving an abbreviation from a command is fast as it doesn't involve any loop.

The plugin update lists at every shell startup by calling `abbr_tips_update` in background (more precisely in spawned shell, because [fish doesn't put functions in background](https://github.com/fish-shell/fish-shell/issues/238))

## 👍 Inspiration

Inspired by [zsh-fast-alias-tips](https://github.com/sei40kr/zsh-fast-alias-tips) and [alias-tips](https://github.com/djui/alias-tips) zsh plugins

## 📝 License
[MIT](https://github.com/Gazorby/abbr-tips/blob/master/LICENSE)
