#!/usr/bin/env bash
# ============================================================================
# validate-default-role.sh
# Validate that the current user's default role can access required objects.
# Run this before deploying automations to catch permission issues early.
# ============================================================================

set -euo pipefail

echo "=== Default Role Validation ==="
echo ""

echo "[1] Checking default role..."
snowsql -q "SHOW PARAMETERS LIKE 'DEFAULT_ROLE' IN USER;" -o output_format=plain

echo ""
echo "[2] Checking default warehouse..."
snowsql -q "SHOW PARAMETERS LIKE 'DEFAULT_WAREHOUSE' IN USER;" -o output_format=plain

echo ""
echo "[3] Testing ACCOUNT_USAGE access (required for cost monitor)..."
if snowsql -q "SELECT COUNT(*) FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY WHERE START_TIME >= DATEADD('hour', -1, CURRENT_TIMESTAMP());" -o output_format=plain 2>/dev/null; then
    echo "    ACCOUNT_USAGE access: OK"
else
    echo "    ACCOUNT_USAGE access: FAILED — default role may lack IMPORTED PRIVILEGES on SNOWFLAKE database"
fi

echo ""
echo "[4] Testing INFORMATION_SCHEMA task history (required for pipeline digest)..."
if snowsql -q "SELECT COUNT(*) FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(SCHEDULED_TIME_RANGE_START => DATEADD('hour', -1, CURRENT_TIMESTAMP())));" -o output_format=plain 2>/dev/null; then
    echo "    Task history access: OK"
else
    echo "    Task history access: FAILED"
fi

echo ""
echo "[5] Checking EXECUTE AGENT TASK privilege..."
snowsql -q "
SELECT privilege, grantee_name
FROM SNOWFLAKE.ACCOUNT_USAGE.GRANTS_TO_ROLES
WHERE privilege = 'EXECUTE AGENT TASK'
    AND deleted_on IS NULL
ORDER BY grantee_name;
" -o output_format=plain

echo ""
echo "=== Validation complete ==="
