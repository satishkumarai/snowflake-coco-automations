# Hooks

Pre-run and post-run hooks for CoCo Automations.

## Overview

Hooks are bash commands that the sandbox runs before and after the agent loop. They execute deterministically and do not consume an agent turn.

## Usage

### Inline hooks (CLI flags)

```bash
cortex automation create \
  --name my_automation \
  --prompt-file prompts/my-prompt.md \
  --schedule "daily at 6am" \
  --pre-run-hook "pip install pandas==2.2.0 --quiet" \
  --pre-run-timeout 120 \
  --post-run-hook "echo done > /workspace/last-run.txt" \
  --post-run-timeout 30
```

### File-based hooks (workspace config)

```bash
cortex automation create \
  --name my_automation \
  --prompt-file prompts/my-prompt.md \
  --schedule "daily at 6am" \
  --hooks-config-path hooks/hooks-config.json
```

The `--hooks-config-path` must be relative to `/workspace`. It cannot be combined with inline hook flags.

## Limitations

- A failing pre-run hook does **not** fail the run. The sandbox becomes unavailable, tool calls fail, but the agent still produces a response.
- A failing post-run hook does **not** fail the run. If the hook publishes output (e.g., `git push`), the output is lost while the run reports success.
- Hooks run as an unprivileged user. Their working directory is **not** `/workspace` — use absolute paths.
- The workspace stage does not support file append (`>>` fails on existing files).
- Hooks do not run for subagents started by the main run.

## Best Practices

- Always inspect the Cortex thread transcript to verify hook behavior.
- Use pre-run hooks for deterministic setup (package installs, file downloads).
- Use post-run hooks for cleanup or output publishing.
- Overwrite files instead of appending — `echo output > /workspace/file.txt` works; `echo output >> /workspace/file.txt` does not (on existing files).
