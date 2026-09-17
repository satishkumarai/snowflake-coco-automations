-- ============================================================================
-- 02-check-object-access.sql
-- Validate that the default role can access all objects required by automations.
-- Run these checks BEFORE deploying any automation.
-- ============================================================================

-- Test access to ACCOUNT_USAGE (required for cost and pipeline monitors)
SELECT COUNT(*) AS row_check
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD('hour', -1, CURRENT_TIMESTAMP());

-- Test access to INFORMATION_SCHEMA task history (required for pipeline digest)
-- Note: SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY supports max 7-day lookback.
SELECT COUNT(*) AS row_check
FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.TASK_HISTORY(
    SCHEDULED_TIME_RANGE_START => DATEADD('hour', -1, CURRENT_TIMESTAMP())
));

-- Test access to specific tables referenced in data freshness prompts
-- Replace with your actual target tables:
-- SELECT MAX(LAST_ALTERED) FROM <database>.<schema>.<table>;

-- Verify EXECUTE AGENT TASK privilege is available
SELECT
    privilege,
    granted_on,
    granted_to,
    grantee_name
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE privilege = 'EXECUTE AGENT TASK'
    AND deleted_on IS NULL
ORDER BY grantee_name;
