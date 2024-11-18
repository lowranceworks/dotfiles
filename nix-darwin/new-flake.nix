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

        # Enable Nix daemon and configuration
        services.nix-daemon.enable = true;
        services.activate-system.enable = true;
        
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
          trusted-users = [ "@admin" "josh" ];
          auto-optimise-store = true;
        };

        environment.shells = [
          "${pkgs.fish}/bin/fish"
        ];

        environment.loginShell = "${pkgs.fish}/bin/fish";
        
        # Environment variables with updated PATH
        environment.variables = {
          SHELL = "${pkgs.fish}/bin/fish";
          PATH = [ 
            "/run/current-system/sw/bin" 
            "/nix/var/nix/profiles/default/bin"
            "/opt/homebrew/bin"
            "$PATH" 
          ];
        };

        # Add shell integration
        programs.fish.enable = true;

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

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 4;
        security.pam.enableSudoTouchIdAuth = true;

        home-manager.backupFileExtension = "backup";
        nix.configureBuildUsers = true;
        nix.useDaemon = true;

        system.defaults = {
          dock.orientation = "bottom";
          dock.autohide = true;
          dock.mru-spaces = false;
          dock.persistent-apps = [
            "/Applications/WezTerm.app/"
            "/Applications/SigmaOS.app/"
            "/Applications/Inkdrop.app"
            "/System/Applications/Calendar.app/"
            "/Applications/Bitwarden.app/"
            "/Applications/draw.io.app/"
            "/System/Applications/Launchpad.app/"
          ];

          spaces.spans-displays = true;

          loginwindow.LoginwindowText = "Let's Go!";
          screensaver.askForPasswordDelay = 10;

          finder.ShowPathbar = true;
          finder.AppleShowAllFiles = true;
          finder.FXPreferredViewStyle = "clmv";
          finder.AppleShowAllExtensions = true;

          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.InitialKeyRepeat = 17;
          NSGlobalDomain.KeyRepeat = 2;
          NSGlobalDomain._HIHideMenuBar = true;
        };

        homebrew = {
          enable = true;
          onActivation = {
            autoUpdate = true;
            upgrade = true;
          };
          global = {
            brewfile = true;
            lockfiles = true;
          };
          taps = [
            "homebrew/services"
            "FelixKratz/formulae"
          ];
          # Add Homebrew ARM settings
          brewPrefix = "/opt/homebrew";
          installation = {
            quieter = true;
            onCustomLocation = true;
            method = "custom";
            path = "/opt/homebrew";
          };
          casks = [
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
          brews = [
            "sketchybar"
            "neovim"
            "docker-completion"
            "fontconfig"
            "krew"
            "terrascan"
            "tfenv"
            "tfsec"
          ];
        };

        # Add system activation scripts
        system.activationScripts.postActivation.text = ''
          # Reload launchd services
          /bin/launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
          /bin/launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
        '';
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
          home-manager.users.josh = { pkgs, ... }: {
            home.stateVersion = "23.11";
            
            programs.fish = {
              enable = true;
              interactiveShellInit = ''
                # Add Nix paths to fish
                fish_add_path /run/current-system/sw/bin
                fish_add_path /nix/var/nix/profiles/default/bin
                fish_add_path /opt/homebrew/bin

                # Initialize carapace for Fish
                ${pkgs.carapace}/bin/carapace _carapace fish | source
              '';
            };

            # Explicitly enable carapace in home-manager
            programs.carapace = {
              enable = true;
              enableFishIntegration = true;
            };
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."LowranceWorks".pkgs;
  };
}