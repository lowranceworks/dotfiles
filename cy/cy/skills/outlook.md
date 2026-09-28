---
name: outlook
description: Read and send Outlook mail via the m365 CLI (Microsoft 365) — or Graph REST as fallback
---

# Outlook via m365 CLI

The `m365` CLI (v11+) is installed and handles auth. If `m365 status` says
"Logged out", tell the user to run `m365 login` (one-time device-code
consent in the browser) — do not improvise around auth.

## Patterns (all support `--output json` for jq filtering)

- Auth check: `m365 status`
- Recent mail: `m365 outlook message list --folderName inbox --top 10 --output json | jq '.[] | {subject, from: .from.emailAddress.address, receivedDateTime, isRead}'`
- Other folders: `--folderName "Sent Items"`, `archive`, `junkemail`, etc.
- Read one message: `m365 outlook message get --id MESSAGE_ID --output json`
- Search: `m365 search --queryText "subject:deploy" --output json` (or
  `m365 outlook message list --folderName inbox --output json` + jq filter)
- Send: `m365 outlook mail send --to someone@mlb.com --subject "..." --bodyContents "..."`

## Fallback: Graph REST (if m365 ever breaks)

`TOKEN=$(bin/cy msgraph-token)` then curl `https://graph.microsoft.com/v1.0/me/...`
— see git history of this skill for the full patterns. Requires
CY_MSGRAPH_CLIENT_ID; the m365 path needs none of that.

## Rules

- Reading is default. Sending mail only when the user explicitly asks —
  always confirm recipient, subject, and body before sending.
- Permission errors (401/403): surface them with the exact fix
  (`m365 login`, or admin consent for the scope) — don't retry blindly.
