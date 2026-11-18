# Agent skills management

## One installer, one session pool

The [skills CLI](https://github.com/owainlewis/skills) (v0.2.1) owns all installed
session skills. Pi natively discovers `~/.agents/skills/`; there is no second
copy under `~/.pi/agent/skills/` and no separate Pi target in the manifest.

| Content | Canonical source | Deployed by |
|---|---|---|
| Custom session skills | `skills/<name>/SKILL.md` | skills CLI → `~/.agents/skills/` |
| Upstream session skills | `dot_config/skills/skills.toml.tmpl` entries | same CLI and pool |
| Manifest and Pi config, AGENTS.md, extensions, subagents | `dot_config/skills/`, `dot_pi/` | chezmoi |
| cy's app-owned skills | `dot_config/cy/skills/` | chezmoi → cy's config (not Pi session skills) |

Definitions and a manifest serve different purposes; the manifest declares
which collections to install, not a second copy of their definitions. The root
`skills/` layout lets the CLI discover the entire custom collection with one
entry. Chezmoi ignores that source directory and the installed skill pool.

## Edit and apply

```sh
# In the configured chezmoi source checkout:
$EDITOR skills/open-pr/SKILL.md
git add skills/open-pr/SKILL.md
git commit -m "feat(skills): update PR workflow"
skills sync
```

Then run `/reload` in Pi, or start a new session. `SKILLS_CONFIG` points at
`~/.config/skills/skills.toml`, so bare `skills sync` finds the manifest.

**Commit first.** The local source path is rendered from `.chezmoi.sourceDir`.
The CLI clones that repository's committed HEAD: dirty, staged-but-uncommitted,
and untracked changes are not installed. A local commit is enough; no push is
needed. Do not edit installed copies; sync/update can replace them.

Skill changes on another feature worktree/branch are not automatically used.
Merge them into the configured source checkout, or test with a temporary
manifest containing only that worktree's absolute Git path as a global source
and `default_targets = ["agents"]`. Restore the normal manifest with a normal
`skills sync` afterward. Keep unique skill names across collections.

For manifest or Pi config changes, edit the repository then `chezmoi apply`.
The sync hook notices both the rendered manifest and committed local HEAD.
It does not run just because an uncommitted skill file changed.

## Add and update sources

Custom skill: add `skills/<name>/SKILL.md` (YAML `name` and `description`),
commit, then sync. Supporting scripts/assets live beside the skill.

Upstream collection: edit `dot_config/skills/skills.toml.tmpl`, for example:

```toml
[[skill]]
source = "owner/repo"
skills = ["skill-name"] # omit to install the whole supported collection
scope = "global"
```

Apply the manifest with chezmoi, then sync. `skills update` resolves current
commits for the selected source refs; it can also update upstream skill
behavior. The manifest's sole default target is `agents`, not a list of
harness-specific directories.

## Safe removal and migration

Sync is **non-pruning by default**. v0.2.1 can prune already-installed skills
even when another source fails. Removing a manifest entry alone therefore
leaves its installed copy. Back up pools/lockfiles, run a successful full sync,
inspect the intended removals, and only then opt into `skills sync --prune`
(with the same backup precautions: success on a previous run cannot guarantee
sources will be reachable on the pruning run). Never delete the shared pool or
lockfile to reconcile it, and do not let chezmoi use `exact_` or removal rules
against the pool.

The initial migration backs up installed pools and lockfiles outside skill
search directories. Pi-local guidance is preserved in the canonical collection
before identified duplicates are archived. Old non-Pi harness installations
are left intact but are no longer sync targets; they are not silently deleted.
The migration transfers the existing custom skill directories to CLI ownership.

## Pull request creation

`open-pr` loads automatically for requests to create/open/make a PR. It uses
workmux to create or reuse the task worktree, preserves completed work, runs PR
preparation there, and uses that worktree's branch explicitly as the PR head.
It creates a **draft** (`gh pr create --draft`) and checks `isDraft`, `OPEN`, and
matching head branch before reporting success. Passing tests or urgency never
authorize automatically marking it ready. Pi's global instructions also cover
PRs created through other workflows and tools. `/skill:open-pr` remains the
explicit invocation.

## Verification

```sh
python3 -B -m unittest discover -s docs/tests -v
```

Skill deployment tests use isolated temporary homes and local committed Git
sources; they never modify live installations or contact upstream repositories.
