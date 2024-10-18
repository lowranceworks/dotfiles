{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "path:/Users/josh/Projects/lowranceworks/dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, dotfiles }:
  let
    configuration = { pkgs, ... }: {
      ids.gids.nixbld = 350; # NOTE: this is required on my personal MacBook
      environment.systemPackages = [
        # pkgs.vim
        # pkgs.direnv
        # pkgs.age
        # pkgs.sshs
        # pkgs.atac
        # pkgs.termshark
        # pkgs.portal
        # pkgs.glow
      ];
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;
      programs.fish.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      security.pam.enableSudoTouchIdAuth = true;

      users.users.josh.home = "/Users/josh";
      home-manager.backupFileExtension = "backup";
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
          "/Applications/Zen Browser.app/"
          "/Applications/Bitwarden.app/"
          "/Applications/draw.io.app/"
          # "/System/Applications/Utilities/Terminal.app"
        ];
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = "Joshua Lowrance";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;
      };

      homebrew.enable = true;
      homebrew.casks = [
        "google-chrome"
        "alfred"
        "bitwarden"
        "brave-browser"
        # "choosy"
        "chromium"
        "cleanshot"
        "contexts"
        "drawio"
        "fork"
        "google-chrome"
        "google-cloud-sdk"
        "inkdrop"
        "keycastr"
        # "logitech-options"
        "meetingbar"
        # "microsoft-auto-update"
        # "microsoft-excel"
        # "microsoft-outlook"
        # "microsoft-teams"
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
        "homebrew/cask-fonts/font-fontawesome"
        "homebrew/cask-fonts/font-hack-nerd-font"
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
        "yq"
        "yubikey-agent"
        "zoxide"
        "zsh-autosuggestions"
        "zsh-fast-syntax-highlighting"
        "zsh-vi-mode"
        "zstd"
        "federico-terzi/espanso/espanso" # not found, tap it and try again
        "minamijoyo/hcledit/hcledit" # not found, tap it and try again
      ];
    };
  in
  {
    darwinConfigurations."LowranceWorks" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.josh = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit dotfiles; };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."LowranceWorks".pkgs;
  };
}
