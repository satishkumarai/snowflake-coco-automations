-- ============================================================================
-- 03-attach-session-policy.sql
-- Create a session policy referencing the RSS and attach it.
-- ============================================================================

USE ROLE SYSADMIN;

-- Create the session policy referencing the custom RSS
CREATE OR REPLACE SESSION POLICY GOVERNANCE_DB.PUBLIC.AUTOMATION_POLICY
  AGENT_RESTRICTED_SESSION_SCOPE = 'GOVERNANCE_DB.PUBLIC.AUTOMATION_SCOPE';

-- ============================================================================
-- Attachment options (choose one):
-- ============================================================================

-- Option A: Account-wide (applies to all users without a user-level override)
ALTER ACCOUNT SET SESSION POLICY GOVERNANCE_DB.PUBLIC.AUTOMATION_POLICY;

-- Option B: Per-user (overrides account-level for this specific user)
-- ALTER USER DATA_ENGINEER_USER SET SESSION POLICY GOVERNANCE_DB.PUBLIC.AUTOMATION_POLICY;

-- ============================================================================
-- Verification
-- ============================================================================

-- Check the active RSS for the current session (run during an agent session)
-- SELECT SYS_CONTEXT('SNOWFLAKE$SESSION', 'ACTIVE_RESTRICTED_SESSION_SCOPES');

-- Show existing session policies
SHOW SESSION POLICIES IN ACCOUNT;

-- ============================================================================
-- Rollback (if needed)
-- ============================================================================
-- ALTER ACCOUNT UNSET SESSION POLICY;
-- DROP SESSION POLICY IF EXISTS GOVERNANCE_DB.PUBLIC.AUTOMATION_POLICY;
-- DROP RESTRICTED SESSION SCOPE IF EXISTS GOVERNANCE_DB.PUBLIC.AUTOMATION_SCOPE;
