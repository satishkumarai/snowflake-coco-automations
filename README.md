# Snowflake CoCo Automations — Production Architecture

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Content License: CC BY 4.0](https://img.shields.io/badge/Content-CC_BY_4.0-lightgrey.svg)](LICENSE-CC-BY-4.0)
[![Snowflake](https://img.shields.io/badge/Snowflake-CoCo_Automations-29B5E8.svg)](https://docs.snowflake.com/en/user-guide/cortex-code/cortex-code-automations)
[![Status](https://img.shields.io/badge/Status-Public_Preview_(Aug_2026)-orange.svg)](https://docs.snowflake.com/en/release-notes/2026/other/2026-08-21-cortex-code-automations-preview)

Production-grade implementation patterns for Snowflake CoCo Automations — AGENT TASKs, Restricted Session Scope, hooks, MCP integration, and operational monitoring.

## Overview

CoCo Automations ([Public Preview, August 21, 2026](https://docs.snowflake.com/en/release-notes/2026/other/2026-08-21-cortex-code-automations-preview)) turn a natural-language prompt into a recurring, unattended CoCo run stored as an AGENT TASK in Snowflake. This repository provides:

- **Five production automation patterns** with tested prompts
- **Governance configuration** including Restricted Session Scope (GA)
- **Monitoring SQL** for task history, thread inspection, and cost attribution
- **Hook examples** for setup and teardown
- **Architecture diagrams** in Mermaid format
- **Deployment scripts** and checklist
- **Test suite** validating all SQL against a live Snowflake account

## Automation Patterns

| # | Name | Schedule | What It Does |
|---|---|---|---|
| 1 | Warehouse Cost Anomaly | Daily 7am | Flags warehouses exceeding 150% of 7-day rolling avg credits |
| 2 | Dynamic Table Lag Monitor | Every 2 hours | Detects DT refresh lag exceeding 2x configured target_lag |
| 3 | Data Freshness SLA | Tue/Thu | Classifies tables as FRESH/WARNING/STALE/CRITICAL by refresh age |
| 4 | Sprint Velocity Report | Weekly Mon | MCP-connected Jira digest with story points and stale issues |
| 5 | Schema Drift Detector | Daily 5am UTC | Diffs ACCOUNT_USAGE.COLUMNS snapshots to catch unexpected DDL |

## Repository Structure

```
snowflake-coco-automations/
├── docs/
│   └── blog-coco-automations.md       # Full Medium article
├── sql/
│   ├── automations/                    # Pre-deployment verification
│   ├── governance/                     # RBAC + RSS setup
│   ├── monitoring/                     # Task history, threads, cost
│   └── test_suite.sql                  # Comprehensive test suite
├── prompts/                            # Automation prompt files
│   ├── daily-cost-monitor.md
│   ├── dt-lag-monitor.md
│   ├── data-freshness-check.md
│   ├── jira-weekly-digest.md
│   ├── schema-drift-detector.md
│   └── ...
├── hooks/                              # Hook config + documentation
├── diagrams/                           # Mermaid architecture diagrams
├── scripts/
│   ├── deploy-automations.sh
│   └── validate-default-role.sh
├── .github/                            # CI, issue templates, CODEOWNERS
├── LICENSE                             # Apache 2.0 (code and SQL)
├── LICENSE-CC-BY-4.0                   # CC BY 4.0 (article content)
└── ...
```

## Quick Start

### Prerequisites

- Snowflake account on AWS, Azure, or GCP (commercial region)
- CoCo CLI installed or Snowsight access
- `EXECUTE AGENT TASK` privilege (granted to `PUBLIC` by default)
- Default role with access to target objects

### 1. Verify Your Default Role

```sql
SHOW PARAMETERS LIKE 'DEFAULT_ROLE' IN USER;
-- If wrong: ALTER USER <you> SET DEFAULT_ROLE = 'DATA_ENGINEER';
```

### 2. Deploy Governance Controls

```bash
snowsql -f sql/governance/01-restrict-execute-agent-task.sql
snowsql -f sql/governance/02-create-restricted-session-scope.sql
snowsql -f sql/governance/03-attach-session-policy.sql
```

### 3. Create Your First Automation

```bash
cortex automation create \
  --name wh_cost_anomaly \
  --prompt-file prompts/daily-cost-monitor.md \
  --schedule "daily at 7am" \
  --timezone America/Los_Angeles
```

### 4. Monitor Runs

```bash
cortex automation list
cortex automation doctor wh_cost_anomaly --limit 5
```

## Feature Status

| Feature | Status | Date |
|---|---|---|
| CoCo Automations | [Public Preview](https://docs.snowflake.com/en/release-notes/2026/other/2026-08-21-cortex-code-automations-preview) | August 21, 2026 |
| Restricted Session Scope | GA | September 3, 2026 |
| AGENT TASK (underlying) | GA | — |
| MCP Server Attachment | Public Preview | 2026 |
| Hooks (pre-run/post-run) | Public Preview | 2026 |

## Preview Limits

- Minimum schedule frequency: **1 hour**
- Thread and run history retention: **2 months**
- Schedules: **time-based only** (no event-based triggers)
- No mid-run attachment or interactive resume

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

- **Code and SQL:** [Apache License 2.0](LICENSE)
- **Article and documentation content:** [CC BY 4.0](LICENSE-CC-BY-4.0)

## Attribution

Snowflake Chronicles — Satish Kumar

Provided "as is" for educational purposes. Validate and test all examples before using them in production.
