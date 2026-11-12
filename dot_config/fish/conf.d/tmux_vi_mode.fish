# Publish fish's vi mode to its tmux pane (pane option @vi_mode). The pane's
# top border (pane-border-format in tmux.conf) shows it as an INSERT / NORMAL /
# VISUAL / REPLACE tag, like the VISUAL tag of tmux copy-mode. Cleared while a
# command runs, so full-screen apps (nvim, pi) own the mode display.
status is-interactive; or return
set -q TMUX TMUX_PANE; or return
# A fish inside nvim's :terminal inherits nvim's pane; leave that pane to nvim.
set -q NVIM; and return

function __tmux_vi_mode --on-variable fish_bind_mode --on-event fish_prompt
    set -l label
    switch $fish_bind_mode
        case default
            set label NORMAL
        case insert
            set label INSERT
        case visual
            set label VISUAL
        case replace replace_one
            set label REPLACE
        case '*'
            set label (string upper -- $fish_bind_mode)
    end
    command tmux set -p -t $TMUX_PANE @vi_mode $label 2>/dev/null
end

function __tmux_vi_mode_clear --on-event fish_preexec --on-event fish_exit
    command tmux set -pu -t $TMUX_PANE @vi_mode 2>/dev/null
end
