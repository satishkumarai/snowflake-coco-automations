#!/usr/bin/env bash
# ============================================================================
# deploy-automations.sh
# Deploy all five production automations from prompt files.
# Run this after completing the governance setup and role verification.
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
PROMPTS_DIR="$REPO_DIR/prompts"

# Default timezone — override with AUTOMATION_TZ environment variable
TZ="${AUTOMATION_TZ:-America/Los_Angeles}"

echo "=== CoCo Automation Deployment ==="
echo "Prompt directory: $PROMPTS_DIR"
echo "Timezone: $TZ"
echo ""

# 1. Daily Warehouse Cost Anomaly Detector
echo "[1/5] Creating wh_cost_anomaly..."
cortex automation create \
  --name wh_cost_anomaly \
  --prompt-file "$PROMPTS_DIR/daily-cost-monitor.md" \
  --schedule "daily at 7am" \
  --timezone "$TZ" \
  --model auto

# 2. Dynamic Table Refresh Lag Monitor
echo "[2/5] Creating dt_lag_monitor..."
cortex automation create \
  --name dt_lag_monitor \
  --prompt-file "$PROMPTS_DIR/dt-lag-monitor.md" \
  --schedule "every 2 hours" \
  --model auto

# 3. Data Freshness SLA Check
echo "[3/5] Creating freshness_sla..."
cortex automation create \
  --name freshness_sla \
  --prompt-file "$PROMPTS_DIR/data-freshness-check.md" \
  --schedule "every Tuesday at 8am and every Thursday at 3pm" \
  --timezone America/New_York \
  --model auto

# 4. Sprint Velocity Report (requires MCP server — uncomment and configure)
echo "[4/5] Skipping sprint_velocity (requires Jira MCP server)..."
# cortex automation create \
#   --name sprint_velocity \
#   --prompt-file "$PROMPTS_DIR/jira-weekly-digest.md" \
#   --schedule "every Monday at 8:30am" \
#   --timezone America/Chicago \
#   --mcp PLATFORM_DB.MCP.JIRA_CONNECTOR \
#   --model auto

# 5. Schema Drift Detector
echo "[5/5] Creating schema_drift..."
cortex automation create \
  --name schema_drift \
  --prompt-file "$PROMPTS_DIR/schema-drift-detector.md" \
  --schedule "daily at 5am" \
  --timezone UTC \
  --model auto

echo ""
echo "=== Deployment complete ==="
echo "Run 'cortex automation list' to verify."
