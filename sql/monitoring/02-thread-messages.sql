-- ============================================================================
-- 02-thread-messages.sql
-- Inspect Cortex thread transcripts from automation runs.
-- Each automation run creates a Cortex thread containing all agent messages,
-- tool calls, results, and error traces.
--
-- SNOWFLAKE.CORTEX.THREAD_MESSAGES() returns a JSON string (not a table).
-- Use TRY_PARSE_JSON() to convert the result to a VARIANT for querying.
-- ============================================================================

-- Query all messages in a thread
-- Replace 12345 with the actual thread ID (integer, not string)
SELECT
    TRY_PARSE_JSON(
        SNOWFLAKE.CORTEX.THREAD_MESSAGES(12345)
    ) AS messages;

-- Paginated retrieval (50 messages at a time)
-- Replace 12345 with thread_id, 67890 with last_message_id from previous page
-- SELECT
--     TRY_PARSE_JSON(
--         SNOWFLAKE.CORTEX.THREAD_MESSAGES(12345, 50, 67890)
--     ) AS messages;

-- Find threads associated with a specific automation
-- The thread_id is linked to the agent task run via the query_id in task history.
-- Use the query_id from 01-task-history.sql results to trace back to the thread.

-- Example: Get the most recent failed run's details
SELECT
    name,
    state,
    scheduled_time,
    error_code,
    error_message,
    query_id
FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'COCO_ROUTINE_DAILY_COST_MONITOR',
    SCHEDULED_TIME_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
))
WHERE state = 'FAILED'
ORDER BY scheduled_time DESC
LIMIT 5;
