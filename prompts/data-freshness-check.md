# Data Freshness SLA Check

Check the freshness of critical tables by comparing their last modification time
against defined SLA thresholds.

Query the following tables and check their freshness:
1. Use INFORMATION_SCHEMA.TABLES to get the LAST_ALTERED timestamp for tables
   in the databases and schemas that your role can access.
2. Focus on tables that were expected to refresh within the last 24 hours.

For each table, calculate:
- Hours since last refresh (LAST_ALTERED)
- SLA status:
  - FRESH: refreshed within the last 6 hours
  - WARNING: refreshed between 6 and 12 hours ago
  - STALE: refreshed between 12 and 24 hours ago
  - CRITICAL: not refreshed in more than 24 hours

Write a report to /workspace/freshness-report.md with:
- Report timestamp (UTC)
- Summary counts: how many tables are FRESH, WARNING, STALE, CRITICAL
- A table listing all checked tables with their status, sorted by staleness (most stale first)
- For any CRITICAL tables, add a note about potential downstream impact

If all tables are FRESH, confirm that all SLAs are met.
