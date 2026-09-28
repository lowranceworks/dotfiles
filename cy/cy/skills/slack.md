---
name: slack
description: Read and post Slack messages via the Web API (curl) using SLACK_BOT_TOKEN
---

# Slack via Web API

No CLI needed — the Slack Web API over `curl` covers Cy's use cases.

## Config

Needs `SLACK_BOT_TOKEN` (xoxb-) in `~/.config/cy/config.local.env`, plus
optionally `SLACK_DEFAULT_CHANNEL` (a channel ID like `C0123456789`).
The token comes from a Slack app — one-time setup with the manifest at
`slack-app-manifest.yaml` in the cy repo (api.slack.com/apps → Create New
App → From a manifest → paste). Recommended bot scopes: `chat:write`,
`channels:read`, `channels:history`, `groups:read`, `groups:history`.

If the token is unset, tell the user — don't improvise.

## Patterns

- Verify: `curl -s -H "Authorization: Bearer $SLACK_BOT_TOKEN" https://slack.com/api/auth.test`
- List channels: `curl -s -H "Authorization: Bearer $SLACK_BOT_TOKEN" "https://slack.com/api/conversations.list?limit=50" | jq '.channels[] | {id, name}'`
- Read history: `curl -s -H "Authorization: Bearer $SLACK_BOT_TOKEN" "https://slack.com/api/conversations.history?channel=CHANNEL_ID&limit=20" | jq -r '.messages[].text'`
- Post: `curl -s -X POST -H "Authorization: Bearer $SLACK_BOT_TOKEN" -H "Content-Type: application/json" -d '{"channel":"CHANNEL_ID","text":"..."}' https://slack.com/api/chat.postMessage`

## Rules

- Reading is default. Post to a channel only when the user explicitly asks
  (or a cron job they approved says to) — and quote which channel.
- Slack API errors come back as `{"ok":false,"error":"..."}` — surface them.
