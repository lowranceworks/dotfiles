# Unified skill installation for Pi

The user approved trying one installer after reviewing the committed-source
trade-off. Move custom definitions to repository-root `skills/<name>/SKILL.md`.
Keep the manifest under `dot_config/skills/`, rendered with an absolute local
Git source derived from `.chezmoi.sourceDir`, plus existing upstream sources.
Target only `agents` (`~/.agents/skills`), which Pi discovers natively.

## Approaches

- **Chosen:** root collection + local Git source + skills CLI for all installs.
  Edit → commit → sync needs no push. The local source follows committed HEAD
  of the configured chezmoi source checkout, not arbitrary dirty/worktree edits.
- Keeping the previous split offers dirty edit → apply, but the user chose one
  installer. Remote-only sourcing would unnecessarily require a push.

## Ownership and safety

Chezmoi deploys the manifest and Pi configuration, not skill definitions or
installed pools. Ignore the root collection and the shared installed pool;
never schedule the latter for removal. Keep Pi config/extensions/agents with
chezmoi. Update global instructions and documentation to describe ownership.

Back up live skills/lockfiles before handoff. Preserve Pi-local additions when
consolidating duplicate skills, retaining existing repository-specific guidance.
Archive shadowing Pi-local copies outside discovery after shared installation.
Keep unrelated non-Pi installations intact; they are no longer sync targets.

Use non-pruning sync by default: skills v0.2.1 can prune previously installed
skills even after a source fails. Make the chezmoi hook notice committed source
updates as well as manifest changes. Keep the existing CLI version.

Carry forward the requested draft-only and workmux-based PR workflow. Test it
before deployment. No real PR, remote push, broad chezmoi apply, or unrelated
configuration changes. Local commits are part of the approved apply workflow.
