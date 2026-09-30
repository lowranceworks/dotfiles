function "qa!" --description "vim habit: quit lazygit when run via its : prompt; no-op elsewhere"
    set -l parent (ps -o ppid= -p $fish_pid | string trim)
    if ps -o comm= -p $parent | string match -q '*lazygit*'
        kill $parent
    end
end
