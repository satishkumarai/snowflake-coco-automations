-- ============================================================================
-- 02-create-restricted-session-scope.sql
-- Create Restricted Session Scope (RSS) objects for CoCo Automations.
-- RSS is GA as of September 3, 2026.
-- RSS is a privilege ceiling — it limits what an agent can do on behalf of
-- a user without changing their roles.
-- ============================================================================

USE ROLE SYSADMIN;

-- Create a governance database if it does not exist
CREATE DATABASE IF NOT EXISTS GOVERNANCE_DB;
CREATE SCHEMA IF NOT EXISTS GOVERNANCE_DB.PUBLIC;

-- ============================================================================
-- Option A: Custom RSS — Read everywhere, write only to sandbox + personal DB
-- ============================================================================
CREATE OR ALTER RESTRICTED SESSION SCOPE GOVERNANCE_DB.PUBLIC.AUTOMATION_SCOPE AS $$
privilege_scopes:
  allowed_privileges:
    - privileges: [data read, program usage, object discovery, compute usage]
      account: [all]
    - privileges: [data write]
      databases: [SANDBOX_DB, USER$]
role_scopes:
  blocked_roles: [ACCOUNTADMIN, SYSADMIN, SECURITYADMIN]
  allow_role_switching: false
$$;

-- ============================================================================
-- Option B: Read-only RSS using predefined scope (simplest)
-- Use this for automations that only query and report.
-- ============================================================================
-- CREATE SESSION POLICY GOVERNANCE_DB.PUBLIC.READONLY_AUTOMATION_POLICY
--   AGENT_RESTRICTED_SESSION_SCOPE = 'SNOWFLAKE$DATA_READ_WITH_AI';

-- ============================================================================
-- Option C: Read + AI scope (allows agents, UDFs, MCP servers)
-- Does NOT allow stored procedures.
-- ============================================================================
-- CREATE SESSION POLICY GOVERNANCE_DB.PUBLIC.AI_AUTOMATION_POLICY
--   AGENT_RESTRICTED_SESSION_SCOPE = 'SNOWFLAKE$DATA_READ_WITH_AI';

-- Verify the RSS object
DESCRIBE RESTRICTED SESSION SCOPE GOVERNANCE_DB.PUBLIC.AUTOMATION_SCOPE;
