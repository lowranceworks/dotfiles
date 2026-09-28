---
name: atlassian
description: Search Jira and Confluence via REST using the Atlassian API token (basic auth)
---

# Atlassian (Jira + Confluence)

One API token covers both, via basic auth with the user's email. Config
lives in `~/.config/cy/config.local.env`: `ATLASSIAN_BASE_URL`,
`ATLASSIAN_EMAIL`, `ATLASSIAN_API_TOKEN`. If any is unset, tell the user —
don't improvise.

Build the auth header per call:

```sh
AUTH=$(/usr/bin/python3 -c "import base64,os; print(base64.b64encode((os.environ['ATLASSIAN_EMAIL']+':'+os.environ['ATLASSIAN_API_TOKEN']).encode()).decode())")
```

## Jira

- My open issues: `curl -s -X POST "$ATLASSIAN_BASE_URL/rest/api/3/search/jql" -H "Authorization: Basic $AUTH" -H "Content-Type: application/json" -d '{"jql":"assignee = currentUser() AND status != Done ORDER BY updated DESC","maxResults":20,"fields":["summary","status","issuetype"]}'`
- Any JQL works: `project = INF AND status = "In Progress"`, `text ~ "deploy"`, etc.
- Board issues: `curl -s "$ATLASSIAN_BASE_URL/rest/agile/1.0/board/BOARD_ID/issue?jql=..." -H "Authorization: Basic $AUTH"`
- Issue detail: `curl -s "$ATLASSIAN_BASE_URL/rest/api/3/issue/INF-4968?fields=summary,status,description,comment" -H "Authorization: Basic $AUTH"`
- The board the user works from: INF (project), board id 11336 —
  https://baseball.atlassian.net/jira/software/c/projects/INF/boards/11336

## Confluence

- Search pages (CQL): `curl -s "$ATLASSIAN_BASE_URL/wiki/rest/api/content/search?cql=text%20~%20%22deploy%22%20and%20type%20=%20page&limit=10" -H "Authorization: Basic $AUTH" | jq '.results[] | {id, title}'`
- Page body: `curl -s "$ATLASSIAN_BASE_URL/wiki/rest/api/content/PAGE_ID?expand=body.storage" -H "Authorization: Basic $AUTH"`

## Rules

- Read-first. Creating/updating issues, transitioning status, or posting
  comments only when the user explicitly asks — quote issue key and action.
