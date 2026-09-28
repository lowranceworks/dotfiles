---
name: github-triage
description: Triage GitHub issues/PRs via the gh CLI and summarize them in Slack-friendly form
---

# GitHub triage

Use the `bash` tool with the `gh` CLI (already authenticated on the host; in
the container, GH_TOKEN must be provided via env).

- List open PRs: `gh pr list --repo OWNER/REPO --limit 20`
- Issue detail: `gh issue view NUMBER --repo OWNER/REPO`
- Prefer JSON output (`--json`) and `jq` for anything you need to filter.

When summarizing for Slack: bullet points, one line per item, link included.
Offer to schedule recurring triage with cron_add (e.g. `0 9 * * 1-5` for a
weekday morning digest).
