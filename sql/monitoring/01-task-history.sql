-- ============================================================================
-- 01-task-history.sql
-- Monitor CoCo Automation runs via Snowflake task history.
--
-- Two sources are available:
--   SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY — max 7-day lookback, no latency
--   SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY     — up to 365 days, ~45 min latency
-- ============================================================================

-- Recent runs for a specific automation (last 7 days)
-- Uses INFORMATION_SCHEMA for zero-latency results
SELECT
    name,
    state,
    scheduled_time,
    completed_time,
    DATEDIFF('second', scheduled_time, completed_time) AS duration_seconds,
    error_code,
    error_message,
    query_id
FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'COCO_ROUTINE_DAILY_COST_MONITOR',
    SCHEDULED_TIME_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
))
ORDER BY scheduled_time DESC;

-- All CoCo automation runs across all automations (last 24 hours)
SELECT
    name,
    state,
    scheduled_time,
    completed_time,
    DATEDIFF('second', scheduled_time, completed_time) AS duration_seconds,
    error_code,
    error_message
FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY(
    SCHEDULED_TIME_RANGE_START => DATEADD('day', -1, CURRENT_TIMESTAMP())
))
WHERE name LIKE 'COCO_ROUTINE_%'
ORDER BY scheduled_time DESC;

-- Failure rate by automation (last 30 days)
-- Uses ACCOUNT_USAGE view for longer lookback (up to 45 min latency)
SELECT
    name AS automation_name,
    COUNT(*) AS total_runs,
    COUNT_IF(state = 'SUCCEEDED') AS succeeded,
    COUNT_IF(state = 'FAILED') AS failed,
    ROUND(COUNT_IF(state = 'FAILED') / NULLIF(COUNT(*), 0) * 100, 2) AS failure_pct
FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY
WHERE name LIKE 'COCO_ROUTINE_%'
    AND scheduled_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY name
ORDER BY failure_pct DESC;

-- Average duration trend by day (last 14 days)
-- Uses ACCOUNT_USAGE for the longer window
SELECT
    name AS automation_name,
    DATE_TRUNC('day', scheduled_time) AS run_date,
    COUNT(*) AS runs,
    ROUND(AVG(DATEDIFF('second', scheduled_time, completed_time)), 1) AS avg_duration_sec,
    MAX(DATEDIFF('second', scheduled_time, completed_time)) AS max_duration_sec
FROM SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY
WHERE name LIKE 'COCO_ROUTINE_%'
    AND state = 'SUCCEEDED'
    AND scheduled_time >= DATEADD('day', -14, CURRENT_TIMESTAMP())
GROUP BY name, run_date
ORDER BY automation_name, run_date DESC;
