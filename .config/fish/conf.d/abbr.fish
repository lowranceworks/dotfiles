# cSpell:disable
# NOTE: manage fish abbreviations
# https://fishshell.com/docs/current/cmds/abbr.html

abbr bi "brew install"
abbr bic "brew install --cask"
abbr bin "brew info"
abbr binc "brew info --cask"
abbr bl "brew leaves"
abbr blr "brew leaves --installed-on-request"
abbr blp "brew leaves --installed-as-dependency"
abbr bs "brew search"

abbr c clear
abbr cl clear
abbr claer clear
abbr clera clear
abbr cx "chmod +x"

abbr dc "docker compose"
abbr dcd "docker compose down"
abbr dcdv "docker compose down -v"
abbr dcr "docker compose restart"
abbr dcu "docker compose up -d"
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"

abbr e exit

abbr fi "fisher install"
abbr fr "fisher refresh"
abbr fu "fisher update"

abbr g git
abbr ga "git add ."
abbr gaa "git add --all"
abbr gb "git branch -v"
abbr gc "git commit"
abbr gcmsg "git commit --message"
abbr gca "git commit -av"
abbr gcl "git clone"
abbr gco "git checkout"
abbr gcb "git checkout -b"
abbr gcom "~/bin/git-to-master-cleanup-branch.sh"
abbr gd "nvim +DiffviewOpen"
abbr gbD "git branch -D"
abbr gbd "git branch -d"
abbr gf "git fetch --all"
abbr gl "git pull"
abbr glr "git pull --rebase"
abbr glog "git log --oneline --decorate --graph"
abbr gma "git merge --abort"
abbr gmc "git merge --continue"
abbr gp "git push"
abbr gpsup "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)"
abbr gpom "git pull origin main"
abbr gpr "gh pr create"
abbr gpum "git pull upstream master"
abbr gr "git remote"
abbr grs "git restore"
abbr grst "git restore --staged"
abbr grhs "git reset --soft"
abbr grhh "git reset --hard"
abbr gra "git remote add"
abbr grc "git rebase --continue"
abbr grao "git remote add origin"
abbr grau "git remote add upstream"
abbr grv "git remote -v"
abbr gs "git status"
abbr gst "git status"
abbr gsta "git stash push"
abbr gstaa "git stash apply"
abbr gstall "git stash --all"
abbr gstc "git stash clear"
abbr gstd "git stash drop"
abbr gstl "git stash list"
abbr gstp "git stash pop"
abbr gsts "git stash show --text"

abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"

abbr k kubectl
abbr kc kubectx
abbr ka "kubectl apply -f"
abbr kg "kubectl get"
abbr kd "kubectl describe"
abbr kdel "kubectl delete"
abbr kl "kubectl logs"
abbr kgpo "kubectl get pod"
abbr kgd "kubectl get deployments"
abbr kc kubectx
abbr kns kubens
abbr kl "kubectl logs -f"
abbr ke "kubectl exec -it"
abbr kcns "kubectl config set-context --current --namespace"

abbr l "lsd  --group-dirs first -A"
abbr ld lazydocker
abbr lg lazygit
# abbr ll "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"

abbr mt "man tmux"
abbr mf "man fzf"
abbr mz "man zoxide"

abbr nb "npm run build"
abbr nd "npm run dev"
abbr ne "nvim .env"
abbr nf neofetch
abbr ni "npm install"
abbr nt "npm run test"

abbr o "open ."

abbr p podman

abbr rmr "rm -rf"

abbr sf "source ~/.config/fish/config.fish"
abbr st "tmux source ~/.config/tmux/tmux.conf"

abbr t tmux
abbr ta "tmux a"
abbr tat "tmux attach -t"
abbr td "t dotfiles"
abbr tk "tmux kill-server"
abbr tks "tmux kill-server"
abbr tn "tmux new -s (basename (pwd))"
abbr tt "touch .t && chmod +x .t && echo -e '#!/usr/bin/env bash\n' > .t && nvim .t"

abbr tf terraform
abbr tfa "terraform apply"
abbr tfd "terraform destroy"
abbr tff "terraform format"
abbr tfi "terraform init"
abbr tfm "terraform format"
abbr tfo "terraform output"
abbr tfp "terraform plan"
abbr tfr "terraform refresh"
abbr tfs "terraform state"
abbr tfsl "terraform state list"
abbr tfss "terraform state show"
abbr tfv "terraform validate"

abbr tg terragrunt

abbr vim nvim
abbr v "nvim ."

abbr za "zoxide add"
abbr ze "zoxide edit"

abbr :GoToCommand fzf-history-widget
abbr :GoToFile "nvim +GoToFile"
abbr :SmartGoTo "nvim +SmartGoTo"
abbr :Grep "nvim +Grep"
abbr :bd exit
abbr :q "tmux kill-server"
abbr :qa! "tmux kill-server"
