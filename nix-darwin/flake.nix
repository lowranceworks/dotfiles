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
        environment.systemPath = [
          "/opt/homebrew/bin"
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ];

        environment.pathsToLink = [ "/Applications" "/bin" ];

        environment.profiles = [
          "/nix/var/nix/profiles/default"
          "/run/current-system/sw"
          "/etc/profiles/per-user/josh"
        ];

        environment.shells = [
          "${pkgs.fish}/bin/fish"
        ];

        environment.loginShell = "${pkgs.fish}/bin/fish";

        users.users.josh = {
          home = "/Users/josh";
          shell = "${pkgs.fish}/bin/fish";
        };

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

          finder = {
            ShowPathbar = true;
            AppleShowAllFiles = true;
            FXPreferredViewStyle = "clmv";
            AppleShowAllExtensions = true;
          };

          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            InitialKeyRepeat = 17;
            KeyRepeat = 2;
            _HIHideMenuBar = true;
          };
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
          brews = [
            "act"
            "ansible"
            "argocd"
            "atuin"
            "carapace"
            "checkov"
            "direnv"
            "docker"
            "docker-completion"
            "docker-compose"
            "fd"
            "fish"
            "fontconfig"
            "fzf"
            "gh"
            "gnumake"
            "gnused"
            "go"
            "go-task"
            "google-cloud-sdk"
            "jq"
            "kind"
            "kubectl"
            "kubectx"
            "kustomize"
            "krew"
            "lazydocker"
            "lazygit"
            "lsd"
            "lua"
            "neofetch"
            "neovim"
            "nodejs"
            "nushell"
            "podman"
            "pre-commit"
            "qemu"
            "ripgrep"
            "sketchybar"
            "sops"
            "starship"
            "stern"
            "stow"
            "terraform-docs"
            "terragrunt"
            "terrascan"
            "tfenv"
            "tflint"
            "tfsec"
            "tfupdate"
            "tldr"
            "tmux"
            "vim"
            "yq"
            "yubikey-agent"
            "zoxide"
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
            "zsh-vi-mode"
            "zstd"
          ];
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
        };
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
