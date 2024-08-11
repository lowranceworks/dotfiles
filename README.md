# Joshua Lowrance's Dotfiles

<!-- add screenshot of your terminal -->

This is the home of all my dotfiles. These are files that add custom configurations to my computer and applications, primarily the terminal.

```
- Terminal: [Wezterm](https://wezfurlong.org/wezterm)
- Font: [Monaspace](https://monaspace.githubnext.com/)
- Colors: [catppuccin-mocha](https://github.com/catppuccin/catppuccin)
- Shell: [fish](https://fishshell.com)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
  - Session manager: [smart-tmux-session-manager]()
- Editor: [Neovim](https://neovim.io)
  - Configuration: [LazyVim](https://www.lazyvim.org/)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- macOS package manager: [Homebrew](https://brew.sh)
```

## How to install

You can install all of my dotfiles with [GNU Stow](https://www.gnu.org/software/stow/).

1. Install [homebrew](https://brew.sh/): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. Install [GNU Stow](https://www.gnu.org/software/stow/): `brew install stow`
3. Clone this repository: `mkdir -p ~/Projects/lowranceworks/ && git clone https://github.com/lowranceworks/dotfiles.git ~/Projects/lowranceworks/dotfiles/`
4. Change directory: `cd ~/Projects/lowranceworks/dotfiles/`
5. Run stow command: `stow .`

## How to uninstall

You can uninstall all of my dotfiles with [GNU Stow](https://www.gnu.org/software/stow/).

1. Change directory: `cd ~/Projects/lowranceworks/dotfiles/`
2. Run stow command: `stow -D .`
