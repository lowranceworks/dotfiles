function fish_user_key_bindings
    # Prevent ctrl+d from exiting the shell (EOF).
    # Instead, make it delete the character under the cursor.
    # This avoids accidentally closing tmux panes.
    bind \cd delete-char
    bind -M insert \cd delete-char
end
