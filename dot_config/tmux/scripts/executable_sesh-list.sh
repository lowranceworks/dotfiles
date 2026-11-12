#!/usr/bin/env bash
# Rows for the prefix+/ sesh picker (tmux.sesh.conf), one per line:
#
#   <target>\t<display>
#
# fzf shows and matches only <display> (--with-nth 2) and returns <target>
# (--accept-nth 1), so a shortened label never reaches `sesh connect`.
# <display> drops the ~/projects/ prefix: the part after it is what you
# type and need to see. <target> is the bare session name (no icon), which
# `sesh connect`, `sesh preview`, and `tmux kill-session` all accept.
#
#   sesh-list.sh [sesh list flags]   sesh sessions (icons, duplicates hidden)
#   sesh-list.sh --find              directories two levels under ~ (fd)
set -euo pipefail

# Worktree sessions are named "<repo> <glyph> <branch>" (git_namer_use_worktree_root
# in sesh.toml). The display prefixes the repo's parent directory, taken from
# the session path (<parent>/<repo>__worktrees/<wt>), so it reads
# "<parent>/<repo> <glyph> <branch>" like plain repo rows; the target keeps the
# real session name. The branch glyph + branch are painted Catppuccin Mocha
# Mauve so they stand out from plain repo sessions. Glyph (nf-md-source_branch, U+F062C) as
# UTF-8 bytes so the script stays ASCII.
branch_glyph=$(printf '\363\260\230\254')
mauve=$'\e[38;2;203;166;247m'
reset=$'\e[39m'

if [[ "${1:-}" == "--find" ]]; then
  fd -H -d 2 -t d -E .Trash . "$HOME" |
    awk -v home="$HOME" -v OFS='\t' '{ d = $0; sub("^" home, "~", d); print $0, d }'
else
  sesh list --icons --hide-duplicates --format $'{session}\t{name}\t{path}' "$@"
fi | awk -F'\t' -v OFS='\t' -v glyph="$branch_glyph" -v on="$mauve" -v off="$reset" '
  {
    sub(/~\/projects\//, "", $2)
    i = index($2, " " glyph " ")
    if (i && $3 != "") {
      d = $3; sub(/\/+$/, "", d); sub(/\/[^\/]*$/, "", d)  # dir holding the worktree
      if (d ~ /__worktrees$/) sub(/__worktrees$/, "", d)     # <repo>__worktrees -> <repo>
      else if (d ~ /\/\.[^\/]*$/) sub(/\/[^\/]*$/, "", d)    # <repo>/.worktrees -> <repo>
      sub(/\/[^\/]*$/, "", d)                              # <repo> -> its parent
      n = split(d, a, "/"); s = index($2, $1)
      if (n && a[n] != "" && s) $2 = substr($2, 1, s - 1) a[n] "/" substr($2, s)
      i = index($2, " " glyph " ")
    }
    if (i) $2 = substr($2, 1, i) on substr($2, i + 1) off
    print $1, $2
  }'
