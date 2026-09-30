---
name: atlassian
description: Search Jira and Confluence via REST using the Atlassian API token (basic auth)
---

# Atlassian (Jira + Confluence)

One API token covers both, via basic auth with the user's email. Config:
`ATLASSIAN_USERNAME`, `ATLASSIAN_URL`, `ATLASSIAN_API_TOKEN`, and
`ATLASSIAN_BOARD` (the user's default board path). If any is unset, tell
the user — don't improvise.

Build the auth header per call:

```sh
AUTH=$(/usr/bin/python3 -c "import base64,os; print(base64.b64encode((os.environ['ATLASSIAN_USERNAME']+':'+os.environ['ATLASSIAN_API_TOKEN']).encode()).decode())")
```

## Jira

- My open issues: `curl -s -X POST "$ATLASSIAN_URL/rest/api/3/search/jql" -H "Authorization: Basic $AUTH" -H "Content-Type: application/json" -d '{"jql":"assignee = currentUser() AND status != Done ORDER BY updated DESC","maxResults":20,"fields":["summary","status","issuetype"]}'`
- Any JQL works: `project = INF AND status = "In Progress"`, `text ~ "deploy"`, etc.
- The user's default board is `$ATLASSIAN_BOARD` (project INF, board id
  00000). Board issues: `curl -s "$ATLASSIAN_URL/rest/agile/1.0/board/00000/issue?jql=assignee = currentUser()" -H "Authorization: Basic $AUTH"`
- Issue detail: `curl -s "$ATLASSIAN_URL/rest/api/3/issue/INF-XXXX?fields=summary,status,description,comment" -H "Authorization: Basic $AUTH"`

## Confluence

- Search pages (CQL): `curl -s "$ATLASSIAN_URL/wiki/rest/api/content/search?cql=text%20~%20%22deploy%22%20and%20type%20=%20page&limit=10" -H "Authorization: Basic $AUTH" | jq '.results[] | {id, title}'`
- Page body: `curl -s "$ATLASSIAN_URL/wiki/rest/api/content/PAGE_ID?expand=body.storage" -H "Authorization: Basic $AUTH"`

## Rules

- Read-first. Creating/updating issues, transitioning status, or posting
  comments only when the user explicitly asks — quote issue key and action.
