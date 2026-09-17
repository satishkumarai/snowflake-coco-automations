# Jira Weekly Digest

Use the Jira MCP server to pull engineering progress for the last 7 days.

Retrieve:
1. All issues in the DATA-ENG project that transitioned to "Done" status in the last 7 days.
2. All issues currently "In Progress" that have been in that status for more than 5 days.
3. Any new issues created in the last 7 days that are unassigned.

For completed issues:
- Group by epic (or "No Epic" if unlinked)
- Count story points completed per epic
- List the issue keys and summaries

For stale in-progress issues:
- List the issue key, summary, assignee, and days in current status

For unassigned new issues:
- List the issue key, summary, priority, and creation date

Write the digest to /workspace/jira-digest.md with:
- Reporting period (last 7 days, with start and end dates)
- Total story points completed
- Completed work grouped by epic
- Stale issues section (if any)
- Unassigned issues section (if any)
- A brief "health summary" line at the top: e.g., "42 points completed, 3 stale items, 2 unassigned"
