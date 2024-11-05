function venv
    if test -d .venv
        source .venv/bin/activate.fish
    else
        echo "No .venv directory found in current location"
    end
end
