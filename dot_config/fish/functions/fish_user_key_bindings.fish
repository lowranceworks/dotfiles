function fish_user_key_bindings
    # Prevent ctrl+d from exiting the shell (EOF).
    # Instead, make it delete the character under the cursor.
    # This avoids accidentally closing tmux panes.
    bind \cd delete-char
    bind -M insert \cd delete-char

    # Ghostty's cmd+backspace sends ctrl-alt-u (tmux turns it into ctrl-u,
    # which fish already binds); this covers fish running outside tmux.
    bind ctrl-alt-u backward-kill-line
    bind -M insert ctrl-alt-u backward-kill-line
end
