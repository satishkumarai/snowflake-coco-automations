-- ============================================================================
-- 01-restrict-execute-agent-task.sql
-- Restrict who can create and run CoCo Automations.
-- EXECUTE AGENT TASK is granted to PUBLIC by default.
-- For production, revoke from PUBLIC and grant to specific roles.
-- ============================================================================

-- CAUTION: This revokes automation capability from ALL users
-- except those with the explicitly granted roles below.
-- Test in a non-production account first.

USE ROLE SECURITYADMIN;

-- Revoke from PUBLIC (removes default access for all users)
REVOKE EXECUTE AGENT TASK ON ACCOUNT FROM ROLE PUBLIC;

-- Grant to specific roles that should be allowed to create automations
GRANT EXECUTE AGENT TASK ON ACCOUNT TO ROLE DATA_ENGINEER;
GRANT EXECUTE AGENT TASK ON ACCOUNT TO ROLE PLATFORM_ADMIN;

-- Verify the grants
SELECT
    privilege,
    granted_on,
    granted_to,
    grantee_name
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE privilege = 'EXECUTE AGENT TASK'
    AND deleted_on IS NULL
ORDER BY grantee_name;
