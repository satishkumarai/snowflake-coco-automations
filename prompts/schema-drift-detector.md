# Schema Drift Detector

Query SNOWFLAKE.ACCOUNT_USAGE.COLUMNS for the ANALYTICS database.

Compare today's column inventory (table_name, column_name, data_type, ordinal_position)
against yesterday's snapshot stored in /workspace/columns-snapshot.csv.

If /workspace/columns-snapshot.csv does not exist, create it from today's data and exit
with status: SNAPSHOT_CREATED (first run, no comparison possible).

If it exists, diff the two sets and report:
- New columns added (table_name, column_name, data_type)
- Columns removed (table_name, column_name)
- Data type changes (table_name, column_name, old_type, new_type)

Write drift results to /workspace/schema-drift-report.md with:
- Report date (UTC)
- Database and schema scope
- Sections for additions, removals, and type changes
- A count summary at the top

Overwrite /workspace/columns-snapshot.csv with today's data for the next run.

This run is unattended. Do not ask follow-up questions.
End with a one-line status: NO_DRIFT if no changes, DRIFT_DETECTED with count if changes found.
