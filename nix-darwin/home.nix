# home.nix
# home-manager switch

{ config, pkgs, ... }:

let
  dotfilesPath = builtins.path {
    path = "/Users/josh/.config/";
    name = "dotfiles";
  };
in
{
  home.username = "josh";
  home.homeDirectory = "/Users/josh";
  home.stateVersion = "23.05";

  home.packages = [
  ];

  home.file = {
    ".config/wezterm".source = "${dotfilesPath}/wezterm";
    ".config/skhd".source = "${dotfilesPath}/skhd";
    ".config/starship".source = "${dotfilesPath}/starship";
    ".config/nvim".source = "${dotfilesPath}/nvim";
    ".config/nix".source = "${dotfilesPath}/nix";
    ".config/nix-darwin".source = "${dotfilesPath}/nix-darwin";
    ".config/tmux".source = "${dotfilesPath}/tmux";
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
