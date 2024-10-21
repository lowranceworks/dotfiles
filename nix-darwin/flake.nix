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
      # TODO: find a way to do this without hardcoding the user
      url = "path:/Users/josh/projects/lowranceworks/dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, dotfiles }:
  let
    configuration = { pkgs, ... }: {
      ids.gids.nixbld = 350; # NOTE: this is required on my personal MacBook
      environment.systemPackages = with pkgs; [
        vim
        direnv
        # age
        # sshs
        # atac
        # termshark
        # portal
        # glow
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
          "/Applications/WezTerm.app/"
          "/Applications/Arc.app/"
          "/Applications/Inkdrop.app"
          "/System/Applications/Calendar.app/"
          "/Applications/Bitwarden.app/"
          "/Applications/draw.io.app/"
          "/System/Applications/Launchpad.app/"
          # "/System/Applications/Utilities/Terminal.app"
        ];

        loginwindow.LoginwindowText = "DevOps Engineer";
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 10;

        # Whether to show the full POSIX filepath in the window title. The default is false.
        finder._FXShowPosixPathInTitle = true;

        # Show path breadcrumbs in finder windows. The default is false.
        finder.ShowPathbar = true;

        # Whether to always show hidden files. The default is false
        finder.AppleShowAllFiles = true;

        # Change the default finder view. “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View The default is icnv.
        finder.FXPreferredViewStyle = "clmv";

        # Whether to always show file extensions. The default is false.
        finder.AppleShowAllExtensions = true;

        # Set to ‘Dark’ to enable dark mode, or leave unset for normal mode.
        NSGlobalDomain.AppleInterfaceStyle = "Dark";

        # Whether to use 24-hour or 12-hour time. The default is based on region settings.
        NSGlobalDomain.AppleICUForce24HourTime = false;

        # This sets how long you must hold down the key before it starts repeating.
        NSGlobalDomain.InitialKeyRepeat = 2;

        # This sets how fast it repeats once it starts.
        NSGlobalDomain.KeyRepeat = 2;
 
      };

      homebrew.enable = true;
      homebrew.casks = [
        "arc"
        "alfred"
        "bitwarden"
        # "brave-browser"
        # "choosy"
        # "chromium"
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
