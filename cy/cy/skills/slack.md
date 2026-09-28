---
name: slack
description: Read/monitor Slack channels and post messages via slack-cli (slack api) with the user's token
---

# Slack via slack-cli

The official `slack` CLI (v4+) is installed and handles API calls via
`slack api <method>`. Auth: `SLACK_USER_TOKEN` in
`~/.config/cy/config.local.env` (minted via the slack-cli auth-ticket
flow). The CLI also reads SLACK_USER_TOKEN itself, so `slack api` works
once it's exported. If calls return `not_authed` / `invalid_auth`, tell the
user the token needs refreshing — don't improvise.

## Watched channels (user's defaults)

| Channel | ID | Notes |
|---|---|---|
| #infra-eng-tdc-private | C055FDHLP32 | private team channel |
| #infra-eng-tdc-engage | C054K508X9U | engagement/intake channel |

## Patterns

- Verify: `slack api auth.test`
- Recent messages: `slack api conversations.history --json '{"channel":"C055FDHLP32","limit":20}' | jq -r '.messages[] | .ts + " " + (.user // .bot_id // "?") + ": " + .text'`
- New since last check (monitoring): add `"oldest":"<last_ts>"` to the
  history call. Track last-seen ts per channel in
  `~/obsidian-vaults/TDC-MLB/30 Wiki/Cy/slack-monitor.json` (create if
  missing; never in repos).
- Channel list: `slack api conversations.list --json '{"limit":50,"types":"public_channel,private_channel"}' | jq '.channels[] | {id, name}'`
- Post: `slack api chat.postMessage --json '{"channel":"C055FDHLP32","text":"..."}'`
- DM groups: `slack api conversations.list --json '{"types":"mpim,im","limit":50}'` then history on the conversation ID.

## Monitoring workflow (when asked or on the slack-monitor cron)

1. Read `slack-monitor.json` for last-seen ts per channel.
2. Fetch new messages per watched channel (oldest = last ts).
3. Update last ts in the file.
4. If nothing new, stay quiet. Otherwise summarize what matters — questions
   to the team, incidents, deploys, decisions; skip bot noise and routine
   chatter — and notify the user (iMessage). Always link/quote channel name.

## Rules

- Reading/monitoring is default. Post to a channel ONLY when the user
  explicitly asks (or an approved cron job says to) — quote the channel.
- The user token sees exactly what the user sees. Never relay private
  channel content to unallowlisted destinations.
