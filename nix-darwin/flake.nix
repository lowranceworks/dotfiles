{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      ids.gids.nixbld = 350; # NOTE: this is required on my personal MacBook
      environment.systemPackages = [
        # NOTE: Install packages with homebrew as much as possible
        # pkgs.vim
      ];
      services.nix-daemon.enable = true;
      programs.zsh.enable = true;
      programs.fish.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      security.pam.enableSudoTouchIdAuth = true;

      nix.settings.experimental-features = "nix-command flakes";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      system.defaults = {
        dock.orientation = "right";
        dock.autohide = true;
        dock.mru-spaces = false;
        dock.persistent-apps = [
          "/System/Applications/Launchpad.app/"
          "/System/Applications/Calendar.app/"
          "/Applications/Inkdrop.app"
          "/Applications/WezTerm.app/"
          "/Applications/Arc.app/"
          "/Applications/Bitwarden.app/"
          "/Applications/draw.io.app/"
        ];
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "Joshua Lowrance";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
      };

      homebrew.enable = true;
      homebrew.casks = [
        "alfred"
        "bitwarden"
        "brave-browser"
        "chromium"
        "cleanshot"
        "contexts"
        "drawio"
        "fork"
        "google-cloud-sdk"
        "inkdrop"
        "keycastr"
        "meetingbar"
        "mission-control-plus"
        "paintbrush"
        # "podman-desktop"
        # "rectangle-pro"
        # "sensiblesidebuttons"
        # "sf-symbols" # NOTE: commented out because it prompts for password
        "slack"
        "spacelauncher"
        "stats"
        "utm"
        "wezterm"
        "betterdisplay"
        # "homebrew/cask-fonts/font-fontawesome" # WARN: this fails to install because it is deprecated 
        # "homebrew/cask-fonts/font-hack-nerd-font" # WARN: this fails to install because it is deprecated 

      ];
      homebrew.brews = [
        "act"
        "ansible"
        "argocd"
        "awscli"
        "azure-cli"
        "bash"
        "checkov"
        "cryptography"
        "direnv"
        "docker"
        "docker-completion"
        "docker-compose"
        "docutils"
        "dtc"
        "fd"
        "fish"
        "fisher"
        "fontconfig"
        "fzf"
        "gh"
        "gnu-sed"
        "go"
        "go-task"
        "helm"
        "jq"
        "kind"
        "krew"
        "kubectx"
        "kubernetes-cli"
        "kustomize"
        "lazydocker"
        "lazygit"
        "lua"
        "make"
        "neofetch"
        "neovim"
        "node"
        "podman"
        "pre-commit"
        "pyenv"
        "qemu"
        "ripgrep"
        "sops"
        "starship"
        "stern"
        "telnet"
        "terraform-docs"
        "terragrunt"
        "terrascan"
        "tfenv"
        "tflint"
        "tfsec"
        "tfupdate"
        "tldr"
        "tmux"
        "tree"
        "yq"
        "yubikey-agent"
        "zoxide"
        "zsh-autosuggestions"
        "zsh-fast-syntax-highlighting"
        "zsh-vi-mode"
        "zstd"
      ];
    };
  in
  {
    darwinConfigurations."LowranceWorks" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
      ];
    };

    darwinPackages = self.darwinConfigurations."LowranceWorks".pkgs;
  };
}

