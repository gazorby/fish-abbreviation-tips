# fish-abbr-tips

Help you remembering abbreviations by displaying them when you can use it

## 🚀 Install

Install using fisher :

```console
fisher add Gazorby/fish-abbr-tips
```

## 🔧 Configuration

### Alias whitelist

By default, the plugin ignore user defined functions (aliases), because your aliases names are likely to unique, so there wouldn't be an abbreviation with the same name.

But, in some cases, you may write aliases which wrap exisiting commands to add some hooks before/after the actual command execution. In this special case, as your aliases probably don't alter the original command, you may also have abbreviations using these aliases, so you don't want to ignore them.

To do that, just add alias to the `ABBR_TIPS_ALIAS_WHITELIST` environment variable

## License
[MIT](https://github.com/Gazorby/fish-abbr-tips/blob/master/LICENSE)
