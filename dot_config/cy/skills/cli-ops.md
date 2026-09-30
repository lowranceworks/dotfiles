---
name: cli-ops
description: Use the infra CLIs installed on this Mac — terraform, argocd, awx, gh, oci, gcloud — safely and read-first
---

# Infrastructure CLIs

All run via the `bash` tool on this Mac. General rules:

- **Read-first**: get/list/describe/plan/show. Never apply, destroy, delete,
  sync, or modify without the user explicitly asking for that exact action.
- Cap output: pipe through `head`, or use `-o json` + `jq` to filter.
- Auth notes per tool below; if a tool reports auth failure, tell the user
  exactly which env var or login command fixes it — don't retry blindly.

## gh (GitHub)

Authed to `github.mlbam.net` (GHE) via keyring — works as-is.

- `gh api /user` — verify auth
- `gh pr list -R OWNER/REPO --limit 20`, `gh issue view N -R OWNER/REPO`
- `gh search prs --owner ORG "query"`
- Prefer `gh api` with `--jq` for anything you need to filter.

## terraform (Terraform Enterprise)

TFE is `terraform.mlbinfra.net`; token already in
`~/.terraform.d/credentials.tfrc.json`.

- `terraform plan -no-color` is the heaviest default action — and only in a
  directory the user named. NEVER `apply`/`destroy` without confirmation.
- API alternative: `curl -H "Authorization: Bearer $(jq -r '.credentials["terraform.mlbinfra.net"].token' ~/.terraform.d/credentials.tfrc.json)" https://terraform.mlbinfra.net/api/v2/PATH`

## argocd (Argo CD on Akuity)

Context configured: `mlb.cd.akuity.cloud`. Always pass `--grpc-web`.

- `argocd account get-user-info --grpc-web` — verify auth
- `argocd app list --grpc-web`, `argocd app get APP --grpc-web`
- Sync only when the user explicitly asks.

## awx (Ansible Automation Platform)

CLI at `~/.local/bin/awx`. Needs env (tell the user to add to
`~/.config/cy/config.local.env` if unset): `CONTROLLER_HOST`, `CONTROLLER_TOKEN`.

- `awx me`, `awx job_templates list`, `awx jobs list`
- REST fallback: `curl -H "Authorization: Bearer $CONTROLLER_TOKEN" $CONTROLLER_HOST/api/v2/PATH`

## oci (Oracle Cloud)

Profile in `~/.oci/config` (default).

- `oci iam region list`, `oci os ns get`
- Most calls need a compartment OCID — ask the user or use
  `export OCI_COMPARTMENT_ID=...` if they've set one.

## gcloud (Google Cloud)

TWO accounts configured; the ACTIVE one is the personal account — for
MLB work check and switch first:

- `gcloud config get-value account; gcloud config get-value project`
- `gcloud config set account "$WORK_ACCOUNT"` (and set the right
  project) before MLB operations — confirm with the user before switching.
