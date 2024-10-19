# How to apply the configurations

## Starting from scratch

This was tested on a fresh macOS Sequoia installation.

### Install nix

You must install it with `zsh`

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

### Install nix-darwin

This command could take awhile to complete...

```zsh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
```

- Select `no` when prompted if you want to edit the default configuration file
- Select `yes` when prompted if you want to manage darwin with a nix-channel

### Install homebrew

The nix configuration depends on [homebrew]() to install software.

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- You will need to run commands after the installation to add homebrew to your path

### Use nix-shell to clone dotfiles repository

```zsh
nix-shell -p git \
  --run 'git clone https://github.com/lowranceworks/dotfiles.git ~/projects/lowranceworks/dotfiles'
```

### Apply the configuration (part 1)

This will take a long time to complete.

```zsh
nix run nix-darwin \
  --extra-experimental-features 'nix-command flakes' \
  -- switch \
  --flake ~/projects/lowranceworks/dotfiles/nix-darwin/#"LowranceWorks"
```

### Apply the configuration (part 2)

```zsh
cd ~/projects/lowranceworks/dotfiles
stow .
```
