# Dynamic Table Refresh Lag Monitor

Query SNOWFLAKE.ACCOUNT_USAGE.DYNAMIC_TABLE_REFRESH_HISTORY for the last 2 hours.

For each dynamic table that had a refresh in the window:
- Get the configured TARGET_LAG from SNOWFLAKE.ACCOUNT_USAGE.DYNAMIC_TABLE_GRAPH_HISTORY
  or INFORMATION_SCHEMA.DYNAMIC_TABLES
- Calculate the actual refresh lag as the time between the last successful refresh
  and the current timestamp
- Flag any table where actual lag exceeds 2x the configured target_lag

Include in the report:
- Fully qualified table name (database.schema.table)
- Configured target_lag
- Actual lag (in minutes)
- Ratio (actual_lag / target_lag)
- Last refresh time
- Refresh state (SUCCEEDED, FAILED, etc.)

Write results to /workspace/dt-lag-report.md with:
- Report timestamp (UTC)
- Summary: total dynamic tables checked, count within threshold, count exceeding threshold
- Table of all results sorted by lag ratio descending (worst first)
- For any failed refreshes, include the error message

This run is unattended. Do not ask follow-up questions.
End with a one-line status: HEALTHY if all within threshold, DEGRADED if any exceeded 2x target.
