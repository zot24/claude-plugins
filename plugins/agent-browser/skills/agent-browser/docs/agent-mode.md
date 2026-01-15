# Agent-Browser Agent Mode

> Source: https://agent-browser.dev/agent-mode

## Overview

agent-browser works with any AI coding agent. Use `--json` for machine-readable output.

## Compatible Agents

- Claude Code
- Cursor
- GitHub Copilot
- OpenAI Codex
- Google Gemini
- opencode
- Any agent that can run shell commands

## JSON Output Format

The tool provides machine-readable output for integration with AI agents:

```bash
agent-browser snapshot --json
# {"success":true,"data":{"snapshot":"...","refs":{...}}}

agent-browser get text @e1 --json
agent-browser is visible @e2 --json
```

## Optimal Workflow

The recommended sequence for browser automation:

```bash
# 1. Navigate and get snapshot
agent-browser open example.com
agent-browser snapshot -i --json   # AI parses tree and refs

# 2. AI identifies target refs from snapshot
# 3. Execute actions using refs
agent-browser click @e2
agent-browser fill @e3 "input text"

# 4. Get new snapshot if page changed
agent-browser snapshot -i --json
```

## Integration Methods

### Direct Approach

Simply request the agent to "Use agent-browser to test the login flow. Run `agent-browser --help` to see available commands."

### Configuration Files

Add to AGENTS.md or CLAUDE.md:

```markdown
## Browser Automation

Use `agent-browser` for web automation. Run `agent-browser --help` for commands.

Core workflow:
1. `agent-browser open <url>` - Navigate to page
2. `agent-browser snapshot -i` - Get interactive elements (@e1, @e2)
3. `agent-browser click @e1` / `fill @e2 "text"` - Interact using refs
4. Re-snapshot after page changes
```

### Claude Code Skill Installation

Copy from node_modules:

```bash
cp -r node_modules/agent-browser/skills/agent-browser .claude/skills/
```

Or download directly:

```bash
mkdir -p .claude/skills/agent-browser
curl -o .claude/skills/agent-browser/SKILL.md \
  https://raw.githubusercontent.com/vercel-labs/agent-browser/main/skills/agent-browser/SKILL.md
```
