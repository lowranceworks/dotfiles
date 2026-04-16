#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/

# Theme is set once via: fish_config theme choose "Catppuccin Mocha"
# Do not run fish_config on every startup -- it writes universal variables.

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

set -g fish_greeting "" # disable the default fish greeting for a cleaner startup
set -g fish_key_bindings fish_vi_key_bindings
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# set -gx BAT_THEME Catppuccin-latte # 'sharkdp/bat' cat clone
set -gx EDITOR nvim # 'neovim/neovim' text editor
set -gx FZF_DEFAULT_COMMAND "fd -H -E '.git'" # Use fd for fzf, showing hidden files but excluding .git

set -gx VISUAL nvim

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
# set -x CLAUDE_CODE_OAUTH_TOKEN (read -s < ~/.keys/anthropic/claude/api.key)

# Erase leaked API keys from environment (global only; universal cleanup done once manually)
set -eg ANTHROPIC_API_KEY
set -eg CLAUDE_CODE_OAUTH_TOKEN

# Load carapace shell completions
if test -f ~/.config/fish/conf.d/carapace.fish
    source ~/.config/fish/conf.d/carapace.fish
end

# Portable PATH configuration (works across machines)
# Using fish_add_path instead of setting PATH directly ensures deduplication
fish_add_path $HOME/.local/bin # pipx installations
fish_add_path /Library/TeX/texbin # pandoc/xelatex

# Set environment variable to override K9s config directory
set -gx K9S_CONFIG_DIR ~/.config/k9s

# Added by Radicle.
export PATH="$PATH:/Users/josh/.radicle/bin"
