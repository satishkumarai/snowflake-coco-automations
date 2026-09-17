-- ============================================================================
-- 01-verify-default-role.sql
-- Verify the user's default role before deploying automations.
-- CoCo Automations run under the user's DEFAULT_ROLE, not the session role.
-- ============================================================================

-- Show the current user's default role
SHOW PARAMETERS LIKE 'DEFAULT_ROLE' IN USER;

-- Show all roles granted to the current user
SHOW GRANTS TO USER CURRENT_USER();

-- If the default role is PUBLIC or incorrect, update it:
-- ALTER USER <username> SET DEFAULT_ROLE = 'DATA_ENGINEER';

-- Verify the default role has the required privileges
-- Switch to the default role and test access
-- USE ROLE <your_default_role>;

-- Check default warehouse (automations use this for SQL execution)
SHOW PARAMETERS LIKE 'DEFAULT_WAREHOUSE' IN USER;
