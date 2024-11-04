# Common commands
alias c = clear
alias cl = clear
alias claer = clear
alias clera = clear
alias cx = chmod +x

# Docker
alias dc = docker compose
alias dcd = docker compose down
alias dcdv = docker compose down -v
alias dcr = docker compose restart
alias dcu = docker compose up -d
alias dps = docker ps --format "table {{.Names}}\t{{.Status}}"
alias e = exit

# Git
alias g = git
alias ga = git add .
alias gaa = git add --all
alias gb = git branch -v
alias gc = git commit
alias gcmsg = git commit --message
alias gca = git commit -av
alias gcl = git clone
alias gco = git checkout
alias gcb = git checkout -b
alias gcom = ~/bin/git-to-master-cleanup-branch.sh
alias gd = git diff
alias gds = git diff --staged
alias gbD = git branch -D
alias gbd = git branch -d
alias gf = git fetch --all
alias gl = git pull
alias glr = git pull --rebase
alias glog = git log --oneline --decorate --graph
alias gma = git merge --abort
alias gmc = git merge --continue
alias gp = git push
alias gpsup = git push --set-upstream origin (git rev-parse --abbrev-ref HEAD)
alias gpom = git pull origin main
alias gpr = gh pr create
alias gpum = git pull upstream master
alias gr = git remote
alias grs = git restore
alias grst = git restore --staged
alias grhs = git reset --soft
alias grhh = git reset --hard
alias gra = git remote add
alias grc = git rebase --continue
alias grao = git remote add origin
alias grro = git remote remove origin
alias grau = git remote add upstream
alias grv = git remote -v
alias gs = git status
alias gst = git status
alias gsta = git stash push
alias gstaa = git stash apply
alias gstall = git stash --all
alias gstc = git stash clear
alias gstd = git stash drop
alias gstl = git stash list
alias gstp = git stash pop
alias gsts = git stash show --text

# Google Cloud
alias gcsp = gcloud config set project

# Kubernetes
alias k = kubectl
alias kc = kubectx
alias ka = kubectl apply -f
alias kg = kubectl get
alias kd = kubectl describe
alias kdel = kubectl delete
alias kl = kubectl logs
alias kgpo = kubectl get pod
alias kgd = kubectl get deployments
alias kns = kubens
alias kl = kubectl logs -f
alias ke = kubectl exec -it
alias kcns = kubectl config set-context --current --namespace

# File listing
alias l = lsd --group-dirs first -A
alias ld = lazydocker
alias lg = lazygit
alias lt = lsd --group-dirs last -A --tree

# Man pages
alias mt = man tmux
alias mf = man fzf
alias mz = man zoxide

# System
alias o = open .
alias p = podman
alias rmr = rm -rf

# Tmux
alias t = tmux
alias ta = tmux a
alias tat = tmux attach -t
alias td = t dotfiles
alias tk = tmux kill-server
alias tks = tmux kill-server
alias tn = tmux new -s (basename (pwd))

# Terraform
alias tf = terraform
alias tfa = terraform apply
alias tfd = terraform destroy
alias tff = terraform fmt
alias tfi = terraform init
alias tfm = terraform format
alias tfo = terraform output
alias tfp = terraform plan
alias tfr = terraform refresh
alias tfs = terraform state
alias tfsl = terraform state list
alias tfss = terraform state show
alias tfv = terraform validate

# Terragrunt
alias tg = terragrunt

# Editors
alias vim = nvim
alias v = nvim .

# Zoxide
alias za = zoxide add
alias ze = zoxide edit
