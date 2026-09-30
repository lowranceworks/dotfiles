# Bash

The bash config lives in `~/.config/bash/` (deployed by chezmoi). Bash does not look there by default, so chezmoi also deploys thin bootstraps:

- `~/.bashrc` (`dot_bashrc`) — sources `~/.config/bash/bashrc`
- `~/.bash_profile` (`dot_bash_profile`) — sources `~/.config/bash/bash_profile`

No manual setup needed — `chezmoi apply` handles it.
