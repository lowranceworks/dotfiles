---
name: outlook
description: Read and send Outlook mail via Microsoft Graph REST using the cached device-code token
---

# Outlook via Microsoft Graph

Mail access is plain Graph REST. The access token comes from
`bin/cy msgraph-token` (caches and self-refreshes; initial consent is
`bin/cy msgraph-auth` — if that errors, tell the user to run it).

## Config (one-time, user does this)

- `CY_MSGRAPH_CLIENT_ID` in `~/.config/cy/config.env` — from an Entra app
  registration (Accounts in any org directory, **public client flows
  enabled**, no secret needed)
- Optional: `CY_MSGRAPH_TENANT` (default `common`)

## Patterns

Get a token first (run from the cy repo, or use the absolute path to bin/cy):

```sh
TOKEN=$(bin/cy msgraph-token)
```

- Unread count: `curl -s -H "Authorization: Bearer $TOKEN" "https://graph.microsoft.com/v1.0/me/mailFolders/inbox?$select=unreadItemCount"`
- Recent mail: `curl -s -H "Authorization: Bearer $TOKEN" "https://graph.microsoft.com/v1.0/me/mailFolders/inbox/messages?$top=10&$select=subject,from,receivedDateTime,isRead" | jq '.value[] | {subject, from: .from.emailAddress.address, receivedDateTime, isRead}'`
- Read one message: `curl -s -H "Authorization: Bearer $TOKEN" "https://graph.microsoft.com/v1.0/me/messages/MESSAGE_ID?$select=subject,bodyPreview,body"`
- Search: `curl -s -H "Authorization: Bearer $TOKEN" "https://graph.microsoft.com/v1.0/me/messages?$search=%22query%22&$top=10&$select=subject,from,receivedDateTime" | jq '.value'`
- Send: `curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"message":{"subject":"...","body":{"contentType":"Text","content":"..."},"toRecipients":[{"emailAddress":{"address":"someone@mlb.com"}}]}}' https://graph.microsoft.com/v1.0/me/sendMail`

## Rules

- Reading is default. Sending mail only when the user explicitly asks —
  always confirm recipient, subject, and body before sending.
- Token/permission errors (401/403): tell the user the exact fix
  (`bin/cy msgraph-auth` or consent for the scope) — don't retry blindly.
