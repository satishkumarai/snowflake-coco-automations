# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- Hook failure detection queries (`sql/monitoring/04-hook-failure-detection.sql`):
  - Duration anomaly detector — flags SUCCEEDED runs under 30s or below 2σ baseline
  - Zero query activity detector — cross-references TASK_HISTORY against QUERY_HISTORY
  - Thread transcript scanner — pattern-matches agent messages for tool failure phrases
  - Daily aggregated summary for operational dashboards
- Native Snowflake task for daily hook failure monitoring (`sql/monitoring/05-hook-failure-daily-task.sql`):
  - Creates `GOVERNANCE_DB.MONITORING.HOOK_FAILURE_DAILY_SUMMARY` landing table
  - Creates `SP_DETECT_HOOK_FAILURES()` stored procedure
  - Creates `TASK_HOOK_FAILURE_DAILY` task (8 AM PT, suspended by default)
  - Uses native task (not CoCo automation) to avoid circular monitoring dependency
- Live DEFAULT_ROLE verification script (`sql/automations/04-live-default-role-verification.sql`):
  - 11-step pre-deployment check covering all 5 automation prompt access patterns
  - Tests ACCOUNT_USAGE, INFORMATION_SCHEMA, EXECUTE AGENT TASK, and DEFAULT_WAREHOUSE
  - Each step returns PASS/FAIL with diagnostic context
  - Combined access matrix for team documentation

### Fixed

- DT lag monitor verification query: corrected `START_TIME` to `REFRESH_START_TIME` (ACCOUNT_USAGE.DYNAMIC_TABLE_REFRESH_HISTORY)
- DT metadata query: corrected from nonexistent `ACCOUNT_USAGE.DYNAMIC_TABLES` view to `INFORMATION_SCHEMA.DYNAMIC_TABLES()` table function

## [1.0.0] - 2026-09-16

### Added

- Medium article: "A Production Architecture for Snowflake CoCo Automations"
- Five production automation prompts:
  - Daily warehouse cost monitor
  - Pipeline failure digest (hourly)
  - Data freshness SLA check (bi-weekly)
  - Jira weekly digest (MCP-connected)
  - Repository maintenance (GitHub-connected)
- Governance SQL:
  - EXECUTE AGENT TASK privilege restriction
  - Restricted Session Scope (RSS) creation
  - Session policy attachment
- Monitoring SQL:
  - Task history queries
  - Cortex thread inspection
  - Cost attribution (task billing + CoCo tokens)
- Automation verification SQL:
  - Default role verification
  - Object access validation
  - Automation listing
- Hook configuration examples (JSON and inline)
- Mermaid architecture diagrams:
  - Before/After architecture
  - AGENT TASK execution flow
  - RSS hierarchy
- Deployment and validation scripts
- GitHub CI workflows (structure validation, SQL lint)
- Issue templates (bug report, feature request)
- PR template
- CODEOWNERS
- Security policy
- Code of Conduct (Contributor Covenant 2.1)
- Contributing guidelines
- Dual licensing (Apache 2.0 for code, CC BY 4.0 for content)
