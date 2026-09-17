# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

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
