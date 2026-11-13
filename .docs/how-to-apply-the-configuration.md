# How to apply the configurations

## Starting from scratch

This was tested on a fresh macOS Sequoia installation.

### Install nix

You must install it with `zsh`

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

### Install homebrew

chezmoi installs software from `~/.config/homebrew/Brewfile` with [homebrew](https://brew.sh).

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- You will need to run commands after the installation to add homebrew to your path

### Use nix-shell to clone dotfiles repository

```zsh
nix-shell -p git \
  --run 'git clone https://github.com/lowranceworks/dotfiles.git ~/projects/lowranceworks/dotfiles'
```

### Apply the dotfiles

```zsh
brew install chezmoi
chezmoi init --apply --source="$HOME/projects/lowranceworks/dotfiles"
```

### Apply the macOS settings (nix-darwin)

chezmoi renders the nix-darwin flake from a template into `~/.config/nix`. It
manages macOS settings only, not packages. chezmoi fills in the username and
names the configuration after `scutil --get LocalHostName`, so any Mac gets a
matching configuration. `chezmoi init` asks once for the nix-darwin
`stateVersion`: answer 7 on a new Mac and never change it afterwards.

First run, which bootstraps nix-darwin:

```zsh
sudo nix --extra-experimental-features 'nix-command flakes' \
  run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix
```

After that, deploy changes before activating them:

```zsh
chezmoi apply ~/.config/nix
sudo darwin-rebuild switch --flake ~/.config/nix
```

### Default shell

Activation registers nix-darwin's Fish in `/etc/shells` and sets it as the
current user's login shell. It changes only the shell of the existing account;
it does not add the account to nix-darwin's managed users.

Open a new terminal window after activation. Existing shells and tmux panes
keep running their current shell. Verify the account setting with:

```zsh
dscl . -read "/Users/$(id -un)" UserShell
# UserShell: /run/current-system/sw/bin/fish
```

### Updating Nix inputs

To bump inputs, run `nix flake update --flake ~/.config/nix`. Then run
`chezmoi re-add ~/.config/nix/flake.lock`.
