# hunk abbreviations for fish shell

abbr hk hunk # Terminal diff viewer
abbr hd "hunk diff" # Review working tree changes
function __hunk_diff_default_branch
    set -l branch (git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | string replace -r '^origin/' '')
    # origin/HEAD is unset in repos created with `git init` rather than cloned
    test -n "$branch"; or set branch main
    echo "hunk diff $branch"
end
abbr hdd --function __hunk_diff_default_branch # Review changes against the default branch
abbr hds "hunk diff --staged" # Review staged changes
abbr hs "hunk show" # Review the last commit
abbr hst "hunk stash show" # Review a stash entry
abbr hp "hunk patch" # Review a patch file or stdin
