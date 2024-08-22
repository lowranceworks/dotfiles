# Demonstraing the power of `stow` and `git` with `cowsay`

I created this directory and document to demonstrate the power of [stow]() and [git]() with a silly example.

## DISCLAIMER - CREATE A BACKUP OF YOUR DOTFILES

Before we get started, please back up your dotfiles.

```bash
cp -rf ~/.config/ ~/.config.bak/
ls -la ~/.config.bak/
```

## Getting started

[git](https://git-scm.com/) should already be installed on your machine, but you will need to install these tools:

```bash
brew install cowsay
brew install stow
```

## Demonstration

### Clone the dotfiles repository

```bash
mkdir ~/demo/
git clone https://github.com/lowranceworks/dotfiles.git ~/demo/dotfiles/
```

### See the directory structure of this repository

```bash
tree ~/demo/dotfiles/ -d
```

```STDOUT
/Users/josh/demo/dotfiles/
├── aerospace
├── cowsay <--- This is the directory we are interested in
├── fish
│   ├── completions
│   ├── conf.d
│   ├── functions
│   └── themes
├── neofetch
├── nvim
│   ├── lua
│   │   ├── config
│   │   └── plugins
│   └── plugin
├── skhd
├── starship
├── tmux
│   └── scripts
├── vimium
└── wezterm
    ├── utils
    └── wallpapers
        ├── nvim
        └── sessions
            └── dotfiles
                └── _config

25 directories
```

### Check the contents of `~/.config/`

Review the contents in your ~/.config/ directory.

```bash
ls -la ~/.config/
```

```STDOUT
total 0
drwx------   27 josh  staff   864 Aug 22 10:28 ./
drwxr-x---+ 167 josh  staff  5344 Aug 17 06:54 ../
drwxr-xr-x   15 josh  staff   480 Apr 14 07:34 gcloud/
drwxr-x--x@   4 josh  staff   128 Apr 14 07:34 gh/
drwxr-xr-x    3 josh  staff    96 Aug 12 12:32 gh-dash/
drwx------@   4 josh  staff   128 Apr 14 07:34 github-copilot/
drwxr-xr-x@   4 josh  staff   128 Apr 14 07:34 helm/
drwxr-xr-x    3 josh  staff    96 May 13 21:17 iterm2/
drwxr-xr-x@   8 josh  staff   256 Aug 17 14:09 zed/
```

### Creating the symlinks with `stow`

Change into the `dotfiles` directory and run the stow command

```bash
cd ~./demo/dotfiles/
stow .
```

#### Check the contents of `~/.config/` and notice the symlinks

You will find `symlinks` to respective directories, including the `cowsay` directory.

```bash
ls -la ~/.config/
```

```STDOUT
total 0
drwx------   27 josh  staff   864 Aug 22 10:28 ./
drwxr-x---+ 167 josh  staff  5344 Aug 17 06:54 ../
lrwxr-xr-x    1 josh  staff    41 Aug 22 10:28 cowsay@ -> ../demo/dotfiles/cowsay <--- This is the symlink for cowsay
drwxr-xr-x@   3 josh  staff    96 Apr 14 07:34 expressvpn/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:31 fish@ -> ../demo/dotfiles/fish
drwxr-xr-x   15 josh  staff   480 Apr 14 07:34 gcloud/
drwxr-x--x@   4 josh  staff   128 Apr 14 07:34 gh/
drwxr-xr-x    3 josh  staff    96 Aug 12 12:32 gh-dash/
drwx------@   4 josh  staff   128 Apr 14 07:34 github-copilot/
drwxr-xr-x@   4 josh  staff   128 Apr 14 07:34 helm/
drwxr-xr-x    3 josh  staff    96 May 13 21:17 iterm2/
lrwxr-xr-x    1 josh  staff    38 Aug 13 13:43 k9s@ -> ../demo/dotfiles/k9s
lrwxr-xr-x    1 josh  staff    43 Aug 10 23:16 neofetch@ -> ../demo/dotfiles/neofetch
drwxr-xr-x@   5 josh  staff   160 Aug  5 22:42 nix-darwin/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:25 nvim@ -> ../demo/dotfiles/nvim
drwxr-xr-x    8 josh  staff   256 Jul 11 22:01 sketchybar/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:25 skhd@ -> ../demo/dotfiles/skhd
lrwxr-xr-x    1 josh  staff    43 Aug 10 23:29 starship@ -> ../demo/dotfiles/starship
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:30 tmux@ -> ../demo/dotfiles/tmux
lrwxr-xr-x    1 josh  staff    42 Aug 10 23:31 wezterm@ -> ../demo/dotfiles/wezterm
lrwxr-xr-x    1 josh  staff    40 Aug 12 10:03 yabai@ -> ../demo/dotfiles/yabai
drwxr-xr-x@   8 josh  staff   256 Aug 17 14:09 zed/
```

### Verifying the results

We can now pipe the contents to `cowsay` to verify our symlink is working.

```bash
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< foo >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Managing the symlinked file with git

#### Make cow say "bar" instead of "foo" (v0.1.0)

Update the `~/.config/cowsay/speak.txt` file and run the command again.

```bash
sed -i '' 's/foo/bar/g' ~/.config/cowsay/speak.txt
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< bar >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Save the changes with git.

```bash
git add ~/.config/cowsay/speak.txt
git commit --message 'feat!: cow says "bar" instead of "foo"'
git tag v0.1.0
```

#### Make cow say "baz" instead of "bash" (v0.2.0)

Update the `~/.config/cowsay/speak.txt` file again and run the command again.

```bash
sed -i '' 's/bar/baz/g' ~/.config/cowsay/speak.txt
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< baz >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Save the changes with git

```bash
git add cowsay/speak.txt
git commit -m 'feat!: make cow say "baz" instead of "bar"'
git tag v0.2.0
```

### Traversing through git history with semnatic version tags

#### Go back in time to when the cow said "bar" (v0.1.0)

```bash
git checkout v0.1.0
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< bar >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

#### Go to the latest version in the main branch (v0.2.0)

```bash
git checkout main
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< baz >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Reverting the latest changes (v0.2.0 -> v0.1.0)

```bash
git revert v0.2.0
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< bar >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Removing the symlinks with `stow`

Change into the `dotfiles` directory and run the stow command

```bash
cd ~./demo/dotfiles/
stow -D .
```

#### Check the contents of `~/.config/`

You will find that the `symlinks` are gone, but the directories are still there with their previously linked content.

```bash
ls -la ~/.config/
```

```STDOUT
total 0
drwx------   27 josh  staff   864 Aug 22 10:28 ./
drwxr-x---+ 167 josh  staff  5344 Aug 17 06:54 ../
lrwxr-xr-x    1 josh  staff    41 Aug 22 10:28 cowsay/
drwxr-xr-x@   3 josh  staff    96 Apr 14 07:34 expressvpn/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:31 fish/
drwxr-xr-x   15 josh  staff   480 Apr 14 07:34 gcloud/
drwxr-x--x@   4 josh  staff   128 Apr 14 07:34 gh/
drwxr-xr-x    3 josh  staff    96 Aug 12 12:32 gh-dash/
drwx------@   4 josh  staff   128 Apr 14 07:34 github-copilot/
drwxr-xr-x@   4 josh  staff   128 Apr 14 07:34 helm/
drwxr-xr-x    3 josh  staff    96 May 13 21:17 iterm2/
lrwxr-xr-x    1 josh  staff    38 Aug 13 13:43 k9s/
lrwxr-xr-x    1 josh  staff    43 Aug 10 23:16 neofetch/
drwxr-xr-x@   5 josh  staff   160 Aug  5 22:42 nix-darwin/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:25 nvim/
drwxr-xr-x    8 josh  staff   256 Jul 11 22:01 sketchybar/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:25 skhd/
lrwxr-xr-x    1 josh  staff    43 Aug 10 23:29 starship/
lrwxr-xr-x    1 josh  staff    39 Aug 10 23:30 tmux/
lrwxr-xr-x    1 josh  staff    42 Aug 10 23:31 wezterm/
lrwxr-xr-x    1 josh  staff    40 Aug 12 10:03 yabai/
drwxr-xr-x@   8 josh  staff   256 Aug 17 14:09 zed/
```

#### What does the cow say now?

```bash
cat ~/.config/cowsay/speak.txt | cowsay
```

```STDOUT
 _____
< baz >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
