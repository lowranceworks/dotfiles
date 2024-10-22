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

        # Add Fish to /etc/shells
        environment.shells = [
          "/opt/homebrew/bin/fish"
        ];

        environment.loginShell = "/opt/homebrew/bin/fish";  
        environment.systemPackages = with pkgs; [
          vim
          direnv
        ];

        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";

        users.users.josh = {
          home = "/Users/josh";
          shell = "/opt/homebrew/bin/fish"; # Set fish as the default shell (not working) - WARN: not working
        };

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 4;
        security.pam.enableSudoTouchIdAuth = true;

        home-manager.backupFileExtension = "backup";
        nix.configureBuildUsers = true;
        nix.useDaemon = true;

        system.defaults = {
          dock.orientation = "right"; # Set the dock to the right side of the screen.
          dock.autohide = true; # Automatically hide the dock.
          dock.mru-spaces = false; # ?
          dock.persistent-apps = [ # Applications that should always be in the dock.
            "/Applications/WezTerm.app/"
            "/Applications/Arc.app/"
            "/Applications/Inkdrop.app"
            "/System/Applications/Calendar.app/"
            "/Applications/Bitwarden.app/"
            "/Applications/draw.io.app/"
            "/System/Applications/Launchpad.app/"
            # "/System/Applications/Utilities/Terminal.app"
          ];

          loginwindow.LoginwindowText = "Let's Go!";
          screensaver.askForPasswordDelay = 10; # How long to wait before asking for a password.

          finder.ShowPathbar = true; # Show path breadcrumbs in finder windows.
          finder.AppleShowAllFiles = true; # Always show hidden files.
          finder.FXPreferredViewStyle = "clmv"; # Change the default finder view to Column view.
          finder.AppleShowAllExtensions = true; # Whether to always show file extensions. The default is false.

          NSGlobalDomain.AppleInterfaceStyle = "Dark"; # Enable dark mode.
          NSGlobalDomain.InitialKeyRepeat = 17; # How long you must hold down the key before it starts repeating.
          NSGlobalDomain.KeyRepeat = 2; # How fast it repeats once it starts.
          NSGlobalDomain._HIHideMenuBar = true; # Hide the menu bar.
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
          # "fisher"
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
