#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/

fish_config theme choose "Catppuccin Mocha"

eval (/opt/homebrew/bin/brew shellenv)

# source tools
if type -q starship
    starship init fish | source # https://starship.rs/
end

if type -q zoxide
    zoxide init fish | source # https://github.com/ajeetdsouza/zoxideend
end

if type -q direnv
    direnv hook fish | source # https://direnv.net/
end

set -g direnv_fish_mode eval_on_arrow # trigger direnv at prompt, and on every arrow-based directory change (default)

set -U fish_greeting "" # disable the default fish greeting for a cleaner startup
set -U fish_key_bindings fish_vi_key_bindings
set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8

# set -Ux BAT_THEME Catppuccin-latte # 'sharkdp/bat' cat clone
set -Ux EDITOR nvim # 'neovim/neovim' text editor
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'" # Use fd for fzf, showing hidden files but excluding .git

set -Ux VISUAL nvim

# go configuration with goenv
set -gx GOENV_ROOT $HOME/.goenv
set -gx PATH $HOME/go/bin $PATH # User's Go workspace binaries
set -gx PATH $GOENV_ROOT/shims $PATH # goenv shims
set -gx PATH $GOENV_ROOT/bin $PATH # goenv command itself
# status --is-interactive; and source (goenv init -|psub) # Without this line, goenv wouldn't be able to properly manage different Go versions - you'd have the goenv command available, but it wouldn't actually be able to switch between Go versions effectively.

# custom scripts
fish_add_path $HOME/.scripts

# starship config
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml

# yabai config
set -x YABAI_CONFIG "$HOME/.config/yabai/yabairc"

# skhd config
set -x SKHD_CONFIG "$HOME/.config/skhd/skhdrc"

# api keys 
# set -x OPENAI_API_KEY (read -s < ~/.keys/openai-chatgpt/api.key)
set -x ANTHROPIC_API_KEY (read -s < ~/.keys/anthropic/claude/api.key)

# nix
if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

# required for nix
if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

# required for nix installed packages
fish_add_path /run/current-system/sw/bin
fish_add_path /nix/var/nix/profiles/default/bin

set -x NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH
set -x NIX_PATH darwin=$HOME/.nix-defexpr/channels/darwin $NIX_PATH
set -x NIX_PATH darwin-config=$HOME/.nixpkgs/darwin-configuration.nix $NIX_PATH

eval "$(/opt/homebrew/bin/brew shellenv)"

# Load carapace shell completions
if test -f ~/.config/fish/conf.d/carapace.fish
    source ~/.config/fish/conf.d/carapace.fish
end

# Created by `pipx` on 2025-02-03 15:15:55
set PATH $PATH /Users/Joshua.lowrance/.local/bin
