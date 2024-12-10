# Initialize carapace for fish
set -Ux CARAPACE_BRIDGE fish

# Create completions directory if it doesn't exist
mkdir -p ~/.config/fish/completions

# Function to load completion lazily
function _carapace_lazy
    complete -c $argv[1] -e
    carapace $argv[1] fish | source
    complete --do-complete=(commandline -cp)
end

# Initialize carapace
carapace _carapace | source

# Example commands - adjust this list to your needs
set -l commands git kubectl docker lazygit awk ping
for cmd in $commands
    if command -v $cmd >/dev/null
        complete -c $cmd -f -a "(_carapace_lazy $cmd)"
    end
end
