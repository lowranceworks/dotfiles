# Unified skills management for Pi

## Scope and answer

Source inspection of **skills v0.2.1** (`e4eaff353236ca69b5db633f1e77ec411128a6e3`); installed `skills --version` returned `0.2.1`. Provisioning specifies that version but only installs when missing, rather than enforcing an existing binary’s version (`.chezmoiscripts/run_onchange_after_15-skills-sync.sh.tmpl`). No installation/reconciliation experiments were run.

**Answer:** the CLI can own homegrown and upstream **Git-committed** skills, including locally committed, unpushed ones. It cannot provide a native **dirty edit → apply** loop. [Parser][P] · [Clone][G] · [Engine][C]

## Verified facts

### 1. Local sources: accepted, but always cloned

`source.Parse` recognizes `/…`, `./…`, `../…`, and `file://…`, passing them unchanged to Git without inferring a subpath. These are **local Git repository sources**, not arbitrary skill-directory imports. Relative paths inherit the invocation’s working directory, not the manifest’s directory; the parser does not expand `~`. [P] · [G]

The install path is `clone` → `source.Parse` → `gitx.Clone` → `skill.Discover` → `installToTargets`. `gitx.Clone` creates a fresh temporary directory and runs `git clone --depth 1 --quiet`; branch/tag refs use `--branch`, SHA-like refs use fetch/checkout. Cleanup removes the temporary checkout: **no persistent source cache or direct working-tree-copy branch exists**. [C] · [G]

Git clones refs/objects and checks out a commit, not the source working tree. Consequently, dirty, staged-but-uncommitted, and untracked skill edits are not imported. A local repository needs a commit but **not a push**; a GitHub source needs that commit available remotely. [G] · [git]

`sync` and `update` share the reconciliation engine and resolve the latest commit for the selected ref; the lockfile records installed state rather than pinning future syncs. An existing destination with the same recorded commit is considered unchanged without content comparison. Installed edits can therefore survive an unchanged commit, then disappear on replacement. [S] · [U] · [C]

### 2. Dotfiles sources, paths, and refs

**Important limitation:** `Discover(root, subPath)` requires `subPath/SKILL.md`. Without a path, discovery checks the repository root, immediate child directories, and `skills/*/` only. It does not recursively discover arbitrary collections. [D]

Therefore `source = "lowranceworks/dotfiles/dot_agents/skills"` **does not select the collection**. Neither does `path = "dot_agents/skills"`. With the existing layout, one entry per skill works, for example: [P] · [D]

```toml
[[skill]]
source = "lowranceworks/dotfiles"
path = "dot_agents/skills/open-pr"
# ref = "<branch, tag, or commit>"  # omit for source HEAD
scope = "global"
targets = ["agents"]
```

A proposed repository-root `skills/<name>/SKILL.md` layout permits one collection entry with **no `path`**. A separate skills repository with that layout also works. A local source names the absolute **repository root**, retaining the same path rules. [P] · [D] · [G]

For remote sources the loop is edit → commit → push → `skills sync`/`update`; for local Git sources it is edit → commit → sync/update. A fixed commit/tag does not follow later edits. The existing chezmoi hook hashes only `dot_config/skills/skills.toml`, so editing or committing homegrown content alone does **not** trigger that sync hook (`.chezmoiscripts/run_onchange_after_15-skills-sync.sh.tmpl`). [G] · [S] · [U]

### 3. Ownership, collisions, and pruning

Installation replaces an existing same-name directory **even if absent from the CLI lockfile**. Locks are keyed only by skill name; names come from frontmatter, falling back to directory names. Duplicate sources are not namespaced or rejected: later entries can overwrite earlier ones, while same-commit checks can skip replacement regardless of source/path. [I] · [L] · [D] · [C]

`sync --prune` removes lock-recorded names absent from successful installation results, including installations in dropped built-in targets. Unrecorded directories are not pruning candidates. **Failure hazard:** source clone/discovery failures increment an error counter but do not prevent pruning; previously installed skills from that failed source can be removed before the command reports failure. [S]

The repo combines chezmoi-owned `dot_agents/skills/` with CLI-managed upstream installs; `dot_config/skills/skills.toml` declares four targets. Existing directories are not `exact_` directories, and `.chezmoiremove` does not list the skills pool. Chezmoi’s `exact_` attribute would remove unmanaged entries. [chez-attributes]

### 4. Pi target choice

**v0.2.1 already includes `pi`**, resolving globally to `~/.pi/agent/skills`; `agents` resolves to `~/.agents/skills`. Targets are directory mappings, independent of the source’s author or installed agent binaries. Upstream skills can use `agents` without a Pi-specific target. [A] · [C]

Installed Pi **1.5.0** discovers both directories; name collisions keep the first discovered skill and warn. `/reload` refreshes skills after edits. Source: installed `@earendil-works/pi-coding-agent/docs/skills.md` under `/opt/homebrew/Cellar/pi-coding-agent/1.5.0/libexec/lib/node_modules/`.

## Recommendations — not executed

1. **Preferred: keep the split, one front door.** Edit homegrown definitions here and apply with chezmoi; keep upstream declarations in this repo’s manifest. This preserves uncommitted edit → apply without commits/pushes. It is one user-facing apply tool, **not one installer**. For Pi-only installations, favor only `agents`, retaining the existing shared pool; do not duplicate names under Pi’s native directory. Dropping other targets with pruning intentionally removes their CLI-managed copies. [S] · [A]
2. **If one installer is mandatory:** transfer homegrown destinations to the CLI and use a local Git repository source. Accept commit → sync, without push. Existing layout needs per-skill entries; root `skills/` permits one collection entry. Remote sourcing adds a push, useful for distribution but worse for rapid edits. Do not rely on source ordering for name overrides. [P] · [D] · [G] · [C]

**Safe handoff for approach 2:** preserve pending source edits and back up affected installed directories and lockfiles outside discovery. Make committed sources available first. Exclude `.agents/skills` and `.agents/skills/**` from chezmoi management using target-path ignore rules, retaining definitions in Git; likewise ignore any proposed non-deployed source directory. Preview the chezmoi diff before applying. Do not delete the pool/lockfile, use `exact_`, or schedule `.chezmoiremove` against it. First reconcile **without pruning** and verify sources/names before restoring pruning—the current apply hook prunes automatically. Archive only identified stale duplicates outside Pi’s discovery paths. [chez-ignore] · [chez-attributes] · [chez-remove] · [I] · [S]

## Remaining limits / dead ends

Direct dirty-directory imports and collection-valued `path` are unsupported in the traced code. Runtime local-clone behavior was not exercised. GitHub’s latest-release API identifies v0.2.1; inspected main `e8cadb3` does not change these parser/clone/discovery/reconciliation implementations, so no upgrade-based solution was found. [latest] · [compare]

[P]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/source/source.go
[G]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/gitx/gitx.go
[C]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/command/command.go
[S]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/command/sync.go
[U]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/command/update.go
[D]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/skill/skill.go
[I]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/installer/installer.go
[L]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/config/lock.go
[A]: https://github.com/owainlewis/skills/blob/v0.2.1/internal/agents/agents.go
[git]: https://git-scm.com/docs/git-clone
[chez-ignore]: https://www.chezmoi.io/reference/special-files/chezmoiignore/
[chez-attributes]: https://www.chezmoi.io/reference/source-state-attributes/
[chez-remove]: https://www.chezmoi.io/reference/special-files/chezmoiremove/
[latest]: https://api.github.com/repos/owainlewis/skills/releases/latest
[compare]: https://github.com/owainlewis/skills/compare/e4eaff353236ca69b5db633f1e77ec411128a6e3...e8cadb3786b5a54eeaa3568c905b41bd5640ec3d
