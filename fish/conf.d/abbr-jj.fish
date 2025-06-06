# jj abbreviations for fish shell

# Setup and initialization
abbr jji "jj git init" # Initialize a jj repo
abbr jjic "jj git init --colocate" # Init jj in existing git repo
abbr jjgc "jj git clone" # Clone a git repo

# Basic operations - Note: Fixed the recursive jj definition
abbr jjd "jj diff" # Show changes in working copy
abbr jjds "jj diff --staged" # Show staged changes
abbr jjst "jj status" # Show status
abbr jjl "jj log" # Show log
abbr jjla "jj log --all" # Show all commits in log
abbr jjlg "jj log --graph" # Show log with graph

# Working with changes
abbr jjn "jj new" # Create a new commit
abbr jjc "jj commit" # Finalize current working copy
abbr jjcm "jj commit -m" # Commit with message
abbr jjdesc "jj describe" # Edit commit message
abbr jjdm "jj describe -m" # Set commit message
abbr jjsq "jj squash" # Squash changes into parent
abbr jjsp "jj split" # Split a commit 
abbr jjr "jj restore" # Restore files
abbr jjrs "jj restore --source" # Restore from specific revision

# Branching and navigation
abbr jjco "jj checkout" # Checkout a revision
abbr jjcob "jj new -r" # Create new commit based on revision (like git checkout -b)
abbr jjcom "jj new -r main" # Create new commit based on main
abbr jjbm "jj bookmark" # Work with bookmarks (similar to branches)
abbr jjbmc "jj bookmark create" # Create a bookmark
abbr jjbmd "jj bookmark delete" # Delete a bookmark
abbr jjbmm "jj bookmark move" # Move a bookmark

# Syncing
abbr jjf "jj git fetch" # Fetch from remote
abbr jjgpl "jj git pull" # Pull from remote
abbr jjgps "jj git push" # Push to remote
abbr jjgpsa "jj git push --all" # Push all bookmarks
abbr jjgpsnew "jj git push --allow-new" # Push, allowing new bookmarks
abbr jjrb "jj rebase -d" # Rebase onto destination

# Advanced operations
abbr jju "jj undo" # Undo last operation
abbr jjua "jj abandon" # Abandon a change
abbr jjob "jj obslog" # Show operation log
abbr jjh "jj help" # Show help

# GitHub workflow
abbr jjpr "jj describe --edit && jj git push --change @" # Prepare and push PR
