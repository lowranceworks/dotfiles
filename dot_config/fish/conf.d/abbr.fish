# NOTE: manage fish abbreviations
# https://fishshell.com/docs/current/cmds/abbr.html

# Auto-source all abbreviation files from abbr/ directory
for file in ~/.config/fish/abbr/*.fish
    source $file
end
