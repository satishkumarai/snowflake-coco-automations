# Restricted Session Scope Hierarchy

```mermaid
flowchart TB
    subgraph User["User's Full Privileges"]
        direction TB
        RBAC[RBAC Grants<br/>All roles + secondary roles]
    end

    subgraph RSS["Restricted Session Scope (Ceiling)"]
        direction TB
        PS[Privilege Scopes<br/>data read, data write, program usage]
        RS[Role Scopes<br/>blocked: ACCOUNTADMIN, SYSADMIN]
    end

    subgraph Effective["Effective Agent Privileges"]
        direction TB
        EP[Intersection of<br/>RBAC grants AND RSS ceiling]
    end

    User --> |intersect| Effective
    RSS --> |constrain| Effective

    style User fill:#29B5E8,color:#fff
    style RSS fill:#ffd93d,color:#333
    style Effective fill:#6bcb77,color:#fff
```

## How It Works

```
User's RBAC Privileges:     [READ, WRITE, DDL, GRANT, ACCOUNTADMIN]
RSS Allowed Privileges:     [READ, PROGRAM_USAGE, WRITE(SANDBOX_DB only)]
────────────────────────────────────────────────────────────────────
Effective Agent Privileges: [READ, PROGRAM_USAGE, WRITE(SANDBOX_DB only)]
```

RSS never grants additional privileges. It only removes them. The effective privilege set is the intersection of what the user has through RBAC and what the RSS allows.

## Predefined Scopes

```mermaid
flowchart LR
    DR[SNOWFLAKE$DATA_READ]
    DRAI[SNOWFLAKE$DATA_READ_WITH_AI]
    DRPU[SNOWFLAKE$DATA_READ_PROGRAM_USAGE]

    DR -->|adds agents, UDFs, MCP| DRAI
    DR -->|adds UDFs, stored procs| DRPU

    style DR fill:#ff6b6b,color:#fff
    style DRAI fill:#ffd93d,color:#333
    style DRPU fill:#6bcb77,color:#fff
```
