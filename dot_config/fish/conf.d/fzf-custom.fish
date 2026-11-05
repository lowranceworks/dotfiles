set -Ux FZF_DEFAULT_OPTS "\
--reverse \
--border rounded \
--no-info \
--pointer='👉' \
--marker=' ' \
--ansi \
--color='bg+:#313244,spinner:#f5e0dc,hl:#f38ba8,gutter:-1' \
--color='fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc' \
--color='marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8' \
--color='selected-bg:#45475a,border:#6c7086,label:#cdd6f4,header:italic'"
# Catppuccin Mocha, from catppuccin/fzf (themes/catppuccin-fzf-mocha.fish),
# minus its bg:#1e1e2e so ghostty's translucent background shows through
# (the theme's own advice for transparent terminals); gutter:-1 likewise.

set -Ux FZF_TMUX_OPTS "-p 55%,60%"

set -Ux FZF_CTRL_R_OPTS "--border-label=' history ' \
--prompt='  '"
