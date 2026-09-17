# Daily Warehouse Cost Monitor

Query SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY for the last 24 hours.

Group credit consumption by warehouse name.

Flag any warehouse that consumed more than 50 credits in a single day.

Compare today's total to the 7-day rolling average for each warehouse.

If any warehouse exceeds 150% of its rolling average, mark it as anomalous.

Write a summary table to /workspace/cost-report.md with the following columns:
- warehouse
- credits_today
- rolling_avg_7d
- pct_change
- status (NORMAL, WARNING if > 120%, ANOMALOUS if > 150%)

At the top of the report, include:
- Report date and time (UTC)
- Total credits consumed across all warehouses in the last 24 hours
- Number of warehouses flagged as anomalous

If no anomalies are found, still write the report but note that all warehouses are within normal ranges.
