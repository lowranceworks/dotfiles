# Joshua Lowrance's Dotfiles

<!-- add screenshot of your terminal -->

This is the home of all my dotfiles. These are files that add custom configurations to my computer and applications, primarily the terminal.

## How to install

You have a couple of options to install my dotfiles. You can install them manually, with Stow, or with Ansible.

### Install with Stow

You can install all of my dotfiles with [GNU Stow](https://www.gnu.org/software/stow/).

1. Install [homebrew](https://brew.sh/)
2. Install [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)
3. Clone this repository
4. Run stow command

```sh
stow . -t ~ --adopt
```

### Install with Ansible

You can install all of my dotfiles with Ansible using my [macbook-config](https://github.com/lowranceworks/macbook-config) project.

1. Install [homebrew](https://brew.sh/)
2. Install [Ansible](https://www.ansible.com/) (`brew install ansible`)
3. Clone the [macbook-config](https://github.com/lowranceworks/macbook-config) repository
4. Run `ansible-playbook ./restore.yaml` --tags dotfiles

```## Software

- Terminal: [Wezterm](https://wezfurlong.org/wezterm)
- Font: [Monaspace](https://monaspace.githubnext.com/)
- Colors: [catppuccin-mocha](https://github.com/catppuccin/catppuccin)
- Shell: [fish](https://fishshell.com)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
  - Session manager: [sesh](https://github.com/joshmedeski/sesh)
- Editor: [Neovim](https://neovim.io)
  - Configuration: [LazyVim](https://www.lazyvim.org/)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- macOS package manager: [Homebrew](https://brew.sh)
```
