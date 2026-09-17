-- ============================================================================
-- 03-cost-attribution.sql
-- Track costs from CoCo Automations.
-- During preview: standard task billing + CoCo token consumption.
--
-- Two cost streams:
--   1. SERVERLESS_TASK_HISTORY — compute credits for AGENT TASK runs
--   2. CORTEX_AI_FUNCTIONS_USAGE_HISTORY — CoCo model inference credits
--
-- Note: ACCOUNT_USAGE views have up to 3 hours of latency.
-- ============================================================================

-- Serverless task credit consumption (last 30 days)
-- AGENT TASKs are serverless — no warehouse required
SELECT
    DATE_TRUNC('day', start_time) AS usage_date,
    task_name,
    SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.SERVERLESS_TASK_HISTORY
WHERE task_name LIKE 'COCO_ROUTINE_%'
    AND start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY usage_date, task_name
ORDER BY usage_date DESC, total_credits DESC;

-- Daily aggregate cost across all automations
SELECT
    DATE_TRUNC('day', start_time) AS usage_date,
    COUNT(DISTINCT task_name) AS unique_automations,
    COUNT(*) AS total_runs,
    SUM(credits_used) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.SERVERLESS_TASK_HISTORY
WHERE task_name LIKE 'COCO_ROUTINE_%'
    AND start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY usage_date
ORDER BY usage_date DESC;

-- CoCo token and credit consumption (via Cortex AI Functions usage)
-- The CORTEX_AI_FUNCTIONS_USAGE_HISTORY view tracks per-function, per-model usage.
-- The METRICS column contains a JSON array with token breakdowns.
-- The CREDITS column contains the billed credits per row.
SELECT
    DATE_TRUNC('day', start_time) AS usage_date,
    function_name,
    model_name,
    SUM(credits) AS total_credits
FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_AI_FUNCTIONS_USAGE_HISTORY
WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
GROUP BY usage_date, function_name, model_name
ORDER BY usage_date DESC, total_credits DESC;

-- Combined cost view: task compute + Cortex AI credits
-- Use this for chargeback or FinOps reporting
SELECT
    t.usage_date,
    t.total_task_credits,
    COALESCE(c.total_cortex_credits, 0) AS total_cortex_credits,
    t.total_task_credits + COALESCE(c.total_cortex_credits, 0) AS total_credits
FROM (
    SELECT
        DATE_TRUNC('day', start_time) AS usage_date,
        SUM(credits_used) AS total_task_credits
    FROM SNOWFLAKE.ACCOUNT_USAGE.SERVERLESS_TASK_HISTORY
    WHERE task_name LIKE 'COCO_ROUTINE_%'
        AND start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
    GROUP BY usage_date
) t
LEFT JOIN (
    SELECT
        DATE_TRUNC('day', start_time) AS usage_date,
        SUM(credits) AS total_cortex_credits
    FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_AI_FUNCTIONS_USAGE_HISTORY
    WHERE start_time >= DATEADD('day', -30, CURRENT_TIMESTAMP())
    GROUP BY usage_date
) c ON t.usage_date = c.usage_date
ORDER BY t.usage_date DESC;
