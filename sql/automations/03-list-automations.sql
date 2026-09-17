-- ============================================================================
-- 03-list-automations.sql
-- List and inspect CoCo Automations (AGENT TASKs) in the user's personal DB.
-- ============================================================================

-- List all CoCo automation tasks in the user's personal database
SHOW TASKS IN SCHEMA USER$.PUBLIC;

-- Filter for CoCo-created automations (prefixed with COCO_ROUTINE_)
SELECT *
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "name" LIKE 'COCO_ROUTINE_%'
ORDER BY "created_on" DESC;

-- View the schedule and state of each automation
SELECT
    "name" AS task_name,
    "state" AS current_state,
    "schedule" AS schedule_expression,
    "definition" AS task_definition,
    "created_on" AS created_at
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))
WHERE "name" LIKE 'COCO_ROUTINE_%';
