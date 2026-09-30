# ███████╗███████╗██╗  ██╗
# ╚══███╔╝██╔════╝██║  ██║
#   ███╔╝ ███████╗███████║
#  ███╔╝  ╚════██║██╔══██║
# ███████╗███████║██║  ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝
# The Z Shell
# https://www.zsh.org/

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Source tools
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)" # https://starship.rs/
fi

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)" # https://github.com/ajeetdsouza/zoxide
fi

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)" # https://direnv.net/
fi

# Locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor configuration
export EDITOR=nvim # 'neovim/neovim' text editor
export VISUAL=nvim

# FZF configuration
export FZF_DEFAULT_COMMAND="fd -H -E '.git'" # Use fd for fzf, showing hidden files but excluding .git

# Go configuration with goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$HOME/go/bin:$PATH" # User's Go workspace binaries
export PATH="$GOENV_ROOT/shims:$PATH" # goenv shims
export PATH="$GOENV_ROOT/bin:$PATH" # goenv command itself

# Custom scripts
export PATH="$HOME/.scripts:$PATH"

# Starship config
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Yabai config
export YABAI_CONFIG="$HOME/.config/yabai/yabairc"

# Skhd config
export SKHD_CONFIG="$HOME/.config/skhd/skhdrc"

# Erase leaked API keys from environment
unset ANTHROPIC_API_KEY
unset CLAUDE_CODE_OAUTH_TOKEN

# Load carapace shell completions
if [ -f "$HOME/.config/zsh/conf.d/carapace.zsh" ]; then
    source "$HOME/.config/zsh/conf.d/carapace.zsh"
fi

# Portable PATH configuration (works across machines)
export PATH="$HOME/.local/bin:$PATH" # pipx installations
export PATH="/Library/TeX/texbin:$PATH" # pandoc/xelatex

# K9s config directory
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# Radicle
export PATH="$PATH:$HOME/.radicle/bin"
