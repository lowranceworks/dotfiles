# Inkdrop

Not deployed by chezmoi (Inkdrop keeps config in `~/Library/Application Support/`). Run the setup script manually:

```
~/projects/lowranceworks/dotfiles/inkdrop/setup.sh
```

This symlinks `keymap.json` into `~/Library/Application Support/inkdrop/` and runs `ipm-install.sh` to install plugins.

Verify:

```
eza --all --git --icons --color=always --group-directories-first -Al ~/Library/Application\ Support/inkdrop/keymap.json
```
