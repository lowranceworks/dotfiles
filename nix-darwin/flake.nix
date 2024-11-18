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
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
        ids.gids.nixbld = 350; # NOTE: this is required on my personal MacBook

        environment.shells = [
          "${pkgs.fish}/bin/fish"
        ];

        environment.loginShell = "${pkgs.fish}/bin/fish";

        users.users.josh = {
          home = "/Users/josh";
          shell = "${pkgs.fish}/bin/fish";
        };

        environment.systemPackages = with pkgs; [
          # awscli2
          # azure-cli
          # bash
          # helm
          # pyenv
          # telnet
          act
          ansible
          argocd
          atuin
          carapace # A multi-shell completion library and binary
          checkov
          direnv
          docker
          docker-compose
          fd
          fish
          fzf
          gh
          gnumake
          gnused
          go
          go-task
          google-cloud-sdk
          jq
          kind
          kubectl
          kubectx
          kustomize
          lazydocker
          lazygit
          lsd
          lua
          neofetch
          # neovim
          nodejs
          nushell
          nushell
          podman
          pre-commit
          qemu
          ripgrep
          sops
          starship
          stern
          stow
          terraform-docs
          terragrunt
          tflint
          tfupdate
          tldr
          tmux
          vim
          yq
          yubikey-agent
          zoxide
          zsh-autosuggestions
          zsh-syntax-highlighting
          zsh-vi-mode
          zstd
        ];

        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";

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
            "/Applications/SigmaOS.app/"
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
          NSGlobalDomain._HIHideMenuBar = false; # Do not hide the menu bar.
        };

        homebrew = {
          enable = true;
          onActivation = {
            autoUpdate = true;
            # cleanup = "zap"; # Remove brew apps that are not defined here
            upgrade = true;
          };
          global = {
            brewfile = true;
            lockfiles = true;
          };
        };

        homebrew.casks = [
          # Keep GUI applications in Homebrew
          "SigmaOS"
          "alfred"
          "bitwarden"
          "cleanshot"
          "contexts"
          "drawio"
          "google-chrome"
          "inkdrop"
          "keycastr"
          "meetingbar"
          "mission-control-plus"
          "paintbrush"
          "slack"
          "spacelauncher"
          "stats"
          "wezterm"
        ];

        homebrew.brews = [
          # Keep only what's not available or better managed through Homebrew
          # "betterdisplay"
          "neovim" # Neovim - better through homebrew
          "docker-completion"
          "fontconfig"
          "krew" # Kubectl plugin manager - better through Homebrew
          "terrascan" # Not in nixpkgs or better managed through Homebrew
          "tfenv" # Better through Homebrew for version management
          "tfsec" # Not in nixpkgs or better managed through Homebrew
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
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."LowranceWorks".pkgs;
  };
}
