# Bash

After running `stow .` from the dotfiles root, the bash config files are symlinked to `~/.config/bash/`. Bash does not look there by default, so you need to bootstrap it.

## Setup

Create these two files on the target machine:

```bash
echo '[ -f ~/.config/bash/bash_profile ] && source ~/.config/bash/bash_profile' >> ~/.bash_profile
echo '[ -f ~/.config/bash/bashrc ] && source ~/.config/bash/bashrc' >> ~/.bashrc
```

Then source to apply:

```bash
source ~/.bash_profile
```
