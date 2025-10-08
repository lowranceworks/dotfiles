# Joshua Lowrance's Dotfiles

<!-- add screenshot of your terminal -->

This repository contains my personal dotfiles, which are configuration files used to customize various applications and tools on my computer, with a focus on terminal-based utilities.

## Stack

- **Terminal**: [Wezterm](https://wezfurlong.org/wezterm)
- **Font**: [Monaspace](https://monaspace.githubnext.com/)
- **Color scheme**: [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)
- **Shell**: [Fish](https://fishshell.com)
- **Prompt**: [Starship](https://starship.rs)
- **Multiplexer**: [tmux](https://github.com/tmux/tmux/wiki)
  - Session manager: [sesh](https://github.com/joshmedeski/sesh) / [sessionx](https://github.com/omerxx/tmux-sessionx)
- **Editor**: [Neovim](https://neovim.io)
  - Configuration: [LazyVim](https://www.lazyvim.org/)
- **Git TUI**: [lazygit](https://github.com/jesseduffield/lazygit)
- **System Info**: [Neofetch](https://github.com/dylanaraps/neofetch)
- **Window Manager**: [Aerospace](https://github.com/nikitabobko/AeroSpace)
- **Menu Bar**: [SketchyBar](https://github.com/FelixKratz/SketchyBar)
- **Hotkeys**: [skhd](https://github.com/koekeishiya/skhd)
- **Automation**: [Hammerspoon](https://www.hammerspoon.org/)
- **Launcher**: [Raycast](https://www.raycast.com/)
- **Browser Extensions**: [Vimium](https://vimium.github.io/)
- **Package Managers**: 
  - macOS: [Homebrew](https://brew.sh)
  - Nix: [Nix](https://nixos.org/) / [nix-darwin](https://github.com/LnL7/nix-darwin)
- **Alternative Shell**: [Nushell](https://www.nushell.sh/)
- **Dotfile Manager**: [GNU Stow](https://www.gnu.org/software/stow/)

## Installation

1. **Install Homebrew**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install GNU Stow**
   ```bash
   brew install stow
   ```

3. **Clone this repository**
   ```bash
   mkdir -p ~/Projects/lowranceworks/
   git clone https://github.com/lowranceworks/dotfiles.git ~/Projects/lowranceworks/dotfiles/
   ```

4. **Stow the dotfiles**
   ```bash
   cd ~/Projects/lowranceworks/dotfiles/
   stow .
   ```

This will symlink all configuration files to `~/.config/` as defined in `.stowrc`.

## Uninstallation

To remove all symlinked dotfiles:

```bash
cd ~/Projects/lowranceworks/dotfiles/
stow -D .
```

## Structure

Each directory in this repository represents a separate application's configuration:

- `fish/` - Fish shell configuration
- `nvim/` - Neovim configuration with LazyVim
- `tmux/` - tmux configuration and plugins
- `wezterm/` - Wezterm terminal configuration
- `lazygit/` - lazygit TUI configuration
- `starship/` - Starship prompt configuration
- `aerospace/` - Aerospace window manager configuration
- `sketchybar/` - SketchyBar menu bar configuration and plugins
- `skhd/` - skhd hotkey daemon configuration and AppleScripts
- `hammerspoon/` - Hammerspoon automation scripts and Spoons
- `brew/` - Homebrew bundle file
- `sesh/` - sesh tmux session manager configuration
- `raycast/` - Raycast launcher extensions and settings
- `nushell/` - Nushell alternative shell configuration
- `nix/` - Nix package manager configuration
- `nix-darwin/` - nix-darwin macOS configuration
- `neofetch/` - Neofetch system info configuration
- `vimium/` - Vimium browser extension settings
