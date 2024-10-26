function export --description 'Set environment variables, compatible with bash export syntax'
    if test -z "$argv"
        # If no arguments are provided, behave like bash's export command
        # and show all exported variables
        set -x
        return 0
    end

    # Initialize variables
    set -l var
    set -l value
    set -l delimiter "="

    for arg in $argv
        # Check if the argument contains an equals sign
        if string match -q "*$delimiter*" -- $arg
            # Split on first equals sign only
            set var (string split -m 1 $delimiter $arg)[1]
            set value (string split -m 1 $delimiter $arg)[2]

            # Remove quotes if they exist
            set value (string trim -c '"' (string trim -c "'" $value))

            # Set the variable
            set -gx $var $value
        else
            # Handle case where export is used just to mark as exported
            set -gx $arg $$arg
        end
    end
end
