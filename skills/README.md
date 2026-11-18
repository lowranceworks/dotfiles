# Custom skills

This is the canonical source collection for personal session skills. Each
`<name>/SKILL.md` declares a unique name and a description describing when to
use it. Supporting assets stay beside the skill.

The `skills` CLI installs this collection and upstream collections from the
chezmoi-rendered `~/.config/skills/skills.toml` into `~/.agents/skills/`, which
Pi discovers natively. Chezmoi does not copy these definitions to `$HOME`.

Edit → commit → `skills sync` → `/reload` in Pi. The local source is the
configured chezmoi checkout's committed HEAD, not uncommitted edits or an
unmerged feature branch. No push is needed.

See [the management guide](../docs/skills.md) for sources, migration backups,
feature-worktree testing, explicit pruning, and adding/updating skills.
