# scripts

## workmux-menu.sh

- Bound to `prefix + w` via `tmux.workmux.conf`
- Opens a tmux menu with workmux actions: dashboard, sidebar, list, add, open, merge, remove

## ide.sh

- Determines if you're already in tmux
- Gets the current session name if none is provided
- Finds the highest window index already in use
- Creates new windows with index numbers that don't conflict with existing ones
- Optionally switches to the first new window it created
