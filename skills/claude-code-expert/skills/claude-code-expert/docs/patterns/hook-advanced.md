# Advanced Hook Patterns

> **Source**: Official Claude Code Documentation + Community Best Practices
> **Source URLs**:
> - https://code.claude.com/docs/en/hooks.md
> - https://gist.github.com/alexfazio/653c5164d726987569ee8229a19f451f
> **Last Updated**: 2026-01-09
> **Requires**: Claude Code v2.1.0+

This document covers advanced hook patterns including prompt-based hooks, agent hooks, and sophisticated automation workflows. For basic hook concepts, see [hook-creation.md](hook-creation.md).

## Hook Types Overview

Claude Code supports three hook types:

| Type | Decision Maker | Best For | Performance |
|------|---------------|----------|-------------|
| **Command** | Shell script | Deterministic checks, formatting | Fast (~10ms) |
| **Prompt** | LLM reasoning | Context-aware decisions, complex validation | Slower (~1-5s) |
| **Agent** | Subagent | Multi-step workflows, sophisticated analysis | Slowest (~5-30s) |

### When to Use Each Type

**Command Hooks** (Covered in [hook-creation.md](hook-creation.md)):
- File formatting (prettier, gofmt)
- Simple pattern blocking (*.env files)
- Logging and auditing
- Git operations

**Prompt Hooks** (This document):
- Security analysis requiring context
- Code quality decisions
- Complex validation logic
- Natural language processing

**Agent Hooks** (This document):
- Multi-file analysis
- Architectural validation
- Complex refactoring checks
- Integration testing triggers

## Prompt-Based Hooks

Prompt hooks use LLM reasoning for decisions that require understanding context rather than simple pattern matching.

### Configuration Format

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if this edit is safe and follows project conventions",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Prompt Hook Fields

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `type` | Yes | - | Must be `"prompt"` |
| `prompt` | Yes | - | Instructions for the LLM to evaluate |
| `timeout` | No | 60 | Max seconds before timeout |
| `model` | No | inherit | Model to use (haiku/sonnet/opus) |

### Variable Substitution

Prompt hooks can access context via variables:

| Variable | Available In | Description |
|----------|--------------|-------------|
| `$TOOL_NAME` | All events | Name of the tool being called |
| `$TOOL_INPUT` | All events | JSON-encoded tool parameters |
| `$FILE_PATH` | Edit/Write | Target file path |
| `$OLD_STRING` | Edit | Content being replaced |
| `$NEW_STRING` | Edit | New content |
| `$CONTENT` | Write | File content being written |
| `$COMMAND` | Bash | Command being executed |

### Example: Security-Aware Edit Validation

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "You are a security reviewer. Analyze this file edit:\n\nFile: $FILE_PATH\nNew content snippet: $NEW_STRING\n\nCheck for:\n1. Hardcoded secrets (API keys, passwords, tokens)\n2. SQL injection vulnerabilities\n3. Command injection risks\n4. Unsafe file path handling\n\nRespond with ONLY 'APPROVE' or 'BLOCK: <reason>'",
            "timeout": 15,
            "model": "haiku"
          }
        ]
      }
    ]
  }
}
```

### Example: Code Quality Gate

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Review this code change for quality:\n\nFile: $FILE_PATH\nChange: $OLD_STRING -> $NEW_STRING\n\nCheck:\n- Does it follow DRY principles?\n- Are there obvious bugs?\n- Is error handling appropriate?\n\nRespond 'APPROVE' or 'BLOCK: <specific issue>'",
            "timeout": 20
          }
        ]
      }
    ]
  }
}
```

### Prompt Hook Response Format

For `PreToolUse` hooks that need to block operations:
- Return `APPROVE` (or similar affirmative) to allow
- Return `BLOCK: <reason>` to prevent the operation
- The reason is shown to Claude for context

## Agent Hooks (v2.1.0+)

Agent hooks invoke subagents for complex multi-step analysis.

### Configuration Format

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "agent",
            "agent": "code-reviewer",
            "prompt": "Review the changes made to $FILE_PATH",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### Agent Hook Fields

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `type` | Yes | - | Must be `"agent"` |
| `agent` | Yes | - | Name of subagent to invoke |
| `prompt` | No | - | Additional context for the agent |
| `timeout` | No | 120 | Max seconds for agent execution |

### Example: Architectural Validation

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "agent",
            "agent": "architecture-validator",
            "prompt": "Validate that creating $FILE_PATH follows our architectural patterns. Check import boundaries, folder structure, and naming conventions.",
            "timeout": 45
          }
        ]
      }
    ]
  }
}
```

### Example: Test Coverage Check

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "agent",
            "agent": "test-coverage-analyzer",
            "prompt": "Analyze if $FILE_PATH has adequate test coverage after this change. Suggest any missing test cases.",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

## PermissionRequest Event (v2.1.0+)

The `PermissionRequest` event fires when Claude requests permission for a tool, allowing programmatic control over permission dialogs.

### Configuration

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'ALLOW' # or 'DENY' or 'ASK'"
          }
        ]
      }
    ]
  }
}
```

### Response Values

| Response | Effect |
|----------|--------|
| `ALLOW` | Automatically grant permission |
| `DENY` | Automatically deny permission |
| `ASK` | Show normal permission dialog |

### Example: Auto-Allow Safe Commands

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if [[ $CMD == npm\\ test* ]] || [[ $CMD == npm\\ run\\ lint* ]]; then echo 'ALLOW'; else echo 'ASK'; fi"
          }
        ]
      }
    ]
  }
}
```

### Example: Deny Dangerous Operations

```json
{
  "hooks": {
    "PermissionRequest": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if [[ $CMD == *rm\\ -rf* ]] || [[ $CMD == *--force* ]]; then echo 'DENY'; else echo 'ASK'; fi"
          }
        ]
      }
    ]
  }
}
```

## The `once: true` Option (v2.1.0+)

Run a hook only once per session, useful for initialization or one-time checks.

### Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Session initialized at $(date)'",
            "once": true
          }
        ]
      }
    ]
  }
}
```

### Use Cases

- **Session initialization**: Set up environment once
- **Dependency checks**: Verify tools are installed once
- **Welcome messages**: Show context once per session
- **License validation**: Check once at start

### Example: One-Time Environment Check

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "which jq prettier eslint || echo 'WARNING: Missing required tools'",
            "once": true
          }
        ]
      }
    ]
  }
}
```

## Expanded Matchers (v2.1.0+)

Beyond tool names, v2.1.0 introduces session lifecycle matchers:

| Matcher | Event | Description |
|---------|-------|-------------|
| `startup` | SessionStart | Fresh session start |
| `resume` | SessionStart | Resuming existing session |
| `clear` | SessionEnd | Session cleared by user |
| `compact` | PreCompact | Before context compaction |

### Example: Different Behavior for New vs Resumed Sessions

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "cat .claude/welcome.md"
          }
        ]
      },
      {
        "matcher": "resume",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Welcome back! Last session: '$(cat ~/.claude/last_session.txt)"
          }
        ]
      }
    ]
  }
}
```

## Frontmatter Scoping

Scope hooks to specific paths using YAML frontmatter in hook files.

### File-Based Hook with Frontmatter

Create `.claude/hooks/pre-edit-validate.md`:

```markdown
---
event: PreToolUse
matcher: Edit|Write
paths:
  - src/api/**/*.ts
  - src/lib/**/*.ts
exclude:
  - "**/*.test.ts"
  - "**/*.spec.ts"
---

# API Code Validation Hook

Validate all edits to API code follow security best practices:

1. Check for proper input validation
2. Ensure error handling is present
3. Verify authentication checks exist
4. Confirm no hardcoded secrets
```

### Frontmatter Fields

| Field | Type | Description |
|-------|------|-------------|
| `event` | string | Hook event (PreToolUse, PostToolUse, etc.) |
| `matcher` | string | Tool matcher pattern |
| `paths` | string[] | Glob patterns to include |
| `exclude` | string[] | Glob patterns to exclude |
| `priority` | number | Execution order (higher = earlier) |
| `enabled` | boolean | Enable/disable hook |

## Advanced Patterns

### Multi-Stage Validation

Chain multiple validation steps:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.file_path'); [[ $FILE != *.env* ]] || exit 2"
          },
          {
            "type": "prompt",
            "prompt": "Quick security check for $FILE_PATH: any obvious vulnerabilities in $NEW_STRING? Reply APPROVE or BLOCK.",
            "timeout": 10,
            "model": "haiku"
          },
          {
            "type": "agent",
            "agent": "deep-security-scan",
            "prompt": "Comprehensive security analysis of changes to $FILE_PATH",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

### Hook Chaining via State

Share state between hooks using a state file:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.file_path'); echo \"$FILE\" >> /tmp/claude_edited_files.txt"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "if [ -f /tmp/claude_edited_files.txt ]; then echo 'Files edited this turn:'; cat /tmp/claude_edited_files.txt; rm /tmp/claude_edited_files.txt; fi"
          }
        ]
      }
    ]
  }
}
```

### Dynamic Configuration

Load hook behavior from external config:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); BLOCKED=$(cat .claude/blocked-commands.txt 2>/dev/null || echo ''); echo \"$BLOCKED\" | grep -q \"$CMD\" && exit 2 || exit 0"
          }
        ]
      }
    ]
  }
}
```

### Context-Aware Decisions

Use project context in prompt hooks:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Given this project uses:\n- Framework: $(cat package.json | jq -r '.dependencies | keys[]' | head -5)\n- Style: $(cat .prettierrc 2>/dev/null || echo 'default')\n\nDoes this edit to $FILE_PATH follow project conventions? APPROVE or BLOCK.",
            "timeout": 20
          }
        ]
      }
    ]
  }
}
```

### Cross-Event Workflows

Coordinate behavior across events:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "echo $(date +%s) > /tmp/claude_session_start",
            "once": true
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "COUNT=$(cat /tmp/claude_edit_count 2>/dev/null || echo 0); echo $((COUNT + 1)) > /tmp/claude_edit_count"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "START=$(cat /tmp/claude_session_start); EDITS=$(cat /tmp/claude_edit_count 2>/dev/null || echo 0); DURATION=$(($(date +%s) - START)); echo \"Session summary: $EDITS edits in ${DURATION}s\" >> ~/.claude/session_log.txt"
          }
        ]
      }
    ]
  }
}
```

### Caching Strategies

Cache expensive operations:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.file_path'); HASH=$(md5 -q \"$FILE\" 2>/dev/null || echo 'new'); CACHE=\"/tmp/claude_lint_cache_$HASH\"; if [ -f \"$CACHE\" ]; then cat \"$CACHE\"; else eslint \"$FILE\" --format json 2>/dev/null | tee \"$CACHE\"; fi"
          }
        ]
      }
    ]
  }
}
```

## Security Best Practices

### Input Validation

Always validate hook inputs:

```bash
#!/bin/bash
set -euo pipefail

# Validate JSON input
if ! jq -e '.' >/dev/null 2>&1; then
  echo "Invalid JSON input" >&2
  exit 0  # Allow operation on validation failure
fi

# Safely extract values
FILE_PATH=$(jq -r '.file_path // empty')
if [[ -z "$FILE_PATH" ]]; then
  exit 0  # No file path, allow
fi

# Validate path is within project
REAL_PATH=$(realpath "$FILE_PATH" 2>/dev/null || echo "")
PROJECT_ROOT=$(pwd)
if [[ ! "$REAL_PATH" == "$PROJECT_ROOT"* ]]; then
  echo "BLOCKED: File outside project" >&2
  exit 2
fi
```

### Credential Safety

Never expose credentials in hooks:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "CMD=$(jq -r '.tool_input.command'); if echo \"$CMD\" | grep -qE '(API_KEY|SECRET|PASSWORD|TOKEN)='; then echo 'BLOCKED: Command may expose secrets' >&2; exit 2; fi"
          }
        ]
      }
    ]
  }
}
```

### Timeout Management

Set appropriate timeouts:

| Hook Type | Recommended Timeout |
|-----------|-------------------|
| Command (simple) | 5-10s |
| Command (complex) | 15-30s |
| Prompt (haiku) | 10-20s |
| Prompt (sonnet) | 20-40s |
| Agent | 60-120s |

### Error Handling

Handle errors gracefully:

```bash
#!/bin/bash
# Fail open on errors (don't block user on hook failure)
trap 'exit 0' ERR

# Your validation logic here
# ...

# Only exit 2 for explicit blocks
if [[ "$SHOULD_BLOCK" == "true" ]]; then
  echo "BLOCKED: $REASON" >&2
  exit 2
fi
```

## Performance Optimization

### Fast Path for Common Cases

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.file_path'); [[ $FILE == *.test.* ]] && exit 0; [[ $FILE == *.spec.* ]] && exit 0"
          },
          {
            "type": "prompt",
            "prompt": "Validate non-test file edit...",
            "timeout": 15
          }
        ]
      }
    ]
  }
}
```

### Conditional Expensive Checks

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "FILE=$(jq -r '.file_path'); if [[ $FILE == src/security/* ]] || [[ $FILE == src/auth/* ]]; then echo 'SECURITY_FILE=true' > /tmp/claude_hook_flags; fi"
          },
          {
            "type": "prompt",
            "prompt": "Security-critical file detected. Perform thorough review...",
            "timeout": 30,
            "condition": "[ -f /tmp/claude_hook_flags ] && grep -q 'SECURITY_FILE=true' /tmp/claude_hook_flags"
          }
        ]
      }
    ]
  }
}
```

## Troubleshooting

### Hook Not Firing?

1. Check event name spelling (case-sensitive)
2. Verify matcher pattern matches tool name
3. Check hook file location and permissions
4. Run `claude --debug` to see hook loading

### Prompt Hook Timing Out?

1. Reduce prompt complexity
2. Use faster model (haiku)
3. Increase timeout value
4. Add fast-path command hook first

### Agent Hook Failing?

1. Verify agent exists and is valid
2. Check agent has required tools
3. Increase timeout for complex analysis
4. Review agent output for errors

### State Not Persisting?

1. Use absolute paths for state files
2. Ensure directory exists and is writable
3. Clean up state files in SessionEnd
4. Check for race conditions with multiple hooks

## Quick Reference

### Minimal Prompt Hook
```json
{"type": "prompt", "prompt": "Check: $TOOL_INPUT. Reply APPROVE or BLOCK."}
```

### Minimal Agent Hook
```json
{"type": "agent", "agent": "validator", "prompt": "Validate $FILE_PATH"}
```

### Minimal Once Hook
```json
{"type": "command", "command": "echo 'Init'", "once": true}
```

### Permission Auto-Allow
```json
{"event": "PermissionRequest", "matcher": "Bash", "response": "ALLOW"}
```
