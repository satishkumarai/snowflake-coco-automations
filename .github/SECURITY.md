# Security Policy

## Reporting a Vulnerability

This repository contains SQL patterns, automation prompts, and configuration examples for Snowflake CoCo Automations. It does not contain application code that accepts external input.

If you discover a security issue in the patterns or SQL provided:

1. **Do not open a public issue.**
2. Email the maintainer directly with a description of the issue.
3. Include:
   - Which file contains the vulnerability
   - The nature of the issue (e.g., excessive privilege, credential exposure pattern)
   - A suggested fix if you have one

## Scope

This policy covers:

- SQL files in `sql/` that may contain insecure privilege patterns
- Prompt files in `prompts/` that may instruct the agent to perform unsafe operations
- Hook configurations that may expose secrets or create security risks
- Scripts that may handle credentials insecurely

## Out of Scope

- Snowflake platform vulnerabilities (report to Snowflake directly)
- CoCo CLI vulnerabilities (report to Snowflake directly)
- Issues in third-party dependencies

## Response

The maintainer will acknowledge the report within 72 hours and provide a fix or mitigation within 14 days for confirmed issues.
