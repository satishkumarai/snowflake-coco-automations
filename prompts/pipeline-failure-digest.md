# Pipeline Failure Digest

Query SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY for the last 60 minutes.

Filter for runs where state is FAILED or CANCELLED.

For each failure, extract:
- Task name (fully qualified: database.schema.task_name)
- Error code
- Error message (first 500 characters)
- Scheduled time
- Completed time

Group failures by likely root cause pattern:
- Permission/access errors (error messages containing "insufficient privileges", "does not exist or not authorized")
- Timeout errors (error messages containing "timeout", "exceeded")
- Data errors (error messages containing "division by zero", "numeric value", "conversion")
- Other/unknown

Write a structured summary to /workspace/pipeline-failures.md with:
- Total failures in the window
- Failures grouped by root cause category
- Individual failure details sorted by scheduled_time DESC
- A "recommended actions" section with one-line suggestions per category

If no failures are found, write a brief confirmation that all tasks succeeded in the window.
