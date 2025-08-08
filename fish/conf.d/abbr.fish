# cSpell:disable
# NOTE: manage fish abbreviations
# https://fishshell.com/docs/current/cmds/abbr.html

abbr da "direnv allow"

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

abbr da "direnv allow"

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
abbr gbD "git branch -D"
abbr gbd "git branch -d"
abbr gc "git commit"
abbr gca "git commit -av"
abbr gcb "git checkout -b"
abbr gcl "git clone"
abbr gcmsg "git commit --message"
abbr gco "git checkout"
abbr gcom "git checkout main"
abbr gd "git diff"
abbr gds "git diff --staged"
abbr gf "git fetch --all"
abbr gi "git init"
abbr gl "git pull"
abbr glog "git log --oneline --decorate --graph"
abbr glr "git pull --rebase"
abbr gma "git merge --abort"
abbr gmc "git merge --continue"
abbr gp "git push"
abbr gpom "git pull origin main"
abbr gpr "gh pr create"
abbr gpsup "git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)"
abbr gpum "git pull upstream master"
abbr gr "git remote"
abbr gra "git rebase abort"
abbr grao "git remote add origin"
abbr grau "git remote add upstream"
abbr grc "git rebase --continue"
abbr grhh "git reset --hard"
abbr grhs "git reset --soft"
abbr grro "git remote remove origin"
abbr grs "git restore"
abbr grst "git restore --staged"
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

abbr gcsp "gcloud config set project"

abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"

abbr k kubectl
abbr ka "kubectl apply -f"
abbr kc kubectx
abbr kcns "kubectl config set-context --current --namespace"
abbr kd "kubectl describe"
abbr kdel "kubectl delete"
abbr ke "kubectl exec -it"
abbr kg "kubectl get"
abbr kgd "kubectl get deployments"
abbr kgpo "kubectl get pod"
abbr kl "kubectl logs -f"
abbr kl "kubectl logs"
abbr kns kubens

abbr l "eza --group-directories-first -Al"
abbr ld lazydocker
abbr lg lazygit
abbr ll "eza --all --git --icons --color=always --group-directories-first -Al"
abbr lt "eza --group-directories-last --tree"
abbr lta "eza --group-directories-last --tree --all"
abbr ltd "eza --group-directories-last --tree --only-dirs"

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
abbr pfr "pip3 freeze > ./requirements.txt"

abbr rgi "rg -i"
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
abbr tfaa "terraform apply --auto-approve"
abbr tfd "terraform destroy"
abbr tfda "terraform destroy --auto-approve"
abbr tff "terraform fmt"
abbr tffr "terraform fmt --recursive"
abbr tfi "terraform init"
abbr tfiu "terraform init --upgrade"
abbr tfm "terraform format"
abbr tfo "terraform output"
abbr tfp "terraform plan"
abbr tfpr "terraform plan --refresh-only"
abbr tfr "terraform refresh"
abbr tfs "terraform state"
abbr tfsl "terraform state list"
abbr tfss "terraform state show"
abbr tfv "terraform validate"
abbr tg terragrunt
abbr tgaa "terragrunt run-all apply"
abbr tgaaa "terragrunt run-all apply --auto-approve"
abbr tgad "terragrunt run-all destroy"
abbr tgada "terragrunt run-all destroy --auto-approve"
abbr tgaf "terragrunt run-all fmt"
abbr tgai "terragrunt run-all init"
abbr tgaiu "terragrunt run-all init --upgrade"
abbr tgap "terragrunt run-all plan"
abbr tgav "terragrunt run-all validate"

abbr vim nvim
abbr v "nvim ."
abbr venv "python3 -m venv .venv && source .venv/bin/activate.fish"

abbr za "zoxide add"
abbr ze "zoxide edit"

abbr :GoToCommand fzf-history-widget
abbr :GoToFile "nvim +GoToFile"
abbr :SmartGoTo "nvim +SmartGoTo"
abbr :Grep "nvim +Grep"
abbr :bd exit
# abbr :q "tmux kill-server"
# abbr :qa! "tmux kill-server"
