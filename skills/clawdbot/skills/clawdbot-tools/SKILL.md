---
name: clawdbot-tools
description: Clawdbot tools & skills - exec, browser automation, slash commands, subagents, ClawdHub
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Tools Expert

Complete guide to tools and skills in Clawdbot.

**Documentation**: https://docs.clawd.bot/tools/

---

## Skills System

### What Are Skills?

AgentSkills-compatible folders with `SKILL.md` that teach Clawdbot tools and capabilities.

### Skill Locations (Precedence)

1. **Workspace skills**: `<workspace>/skills` (highest)
2. **Managed/local**: `~/.clawdbot/skills`
3. **Bundled**: Shipped with installation (lowest)

### Creating Skills

```markdown
---
name: my-skill
description: What this skill does
allowed-tools: Read, Write, Edit, Bash
---

# My Skill

Instructions for the agent...

## Available Commands

### /mycommand
Does something useful...
```

### Skill Configuration

```json
{
  "skills": {
    "entries": {
      "my-skill": {
        "enabled": true,
        "apiKey": "...",
        "env": { "MY_VAR": "value" }
      }
    }
  }
}
```

---

## ClawdHub

Public skills registry at https://clawdhub.com

### Install Skills

```bash
# Install from ClawdHub
clawdhub install <skill-slug>

# Install specific version
clawdhub install <skill-slug>@1.2.0
```

### Update Skills

```bash
# Update all
clawdhub update --all

# Update specific
clawdhub update <skill-slug>
```

### Publish Skills

```bash
# Login
clawdhub login

# Sync/publish
clawdhub sync --all

# Publish new version
clawdhub publish <skill-dir>
```

### List Skills

```bash
# List installed
clawdhub list

# Search registry
clawdhub search "web scraping"
```

---

## Exec Tool

Execute shell commands safely.

### Configuration

```json
{
  "tools": {
    "exec": {
      "enabled": true,
      "allowedCommands": ["ls", "cat", "grep", "find"],
      "blockedCommands": ["rm", "sudo", "chmod"],
      "timeout": 30000
    }
  }
}
```

### Sandbox Execution

```json
{
  "tools": {
    "exec": {
      "sandbox": {
        "enabled": true,
        "network": false,
        "filesystem": "readonly"
      }
    }
  }
}
```

---

## Patch Tool

Apply code patches safely.

### Usage

The patch tool allows agents to modify files with review:

```json
{
  "tools": {
    "patch": {
      "enabled": true,
      "requireApproval": true,
      "maxFileSize": "1MB"
    }
  }
}
```

### Patch Format

```diff
--- a/file.js
+++ b/file.js
@@ -1,3 +1,4 @@
 const x = 1;
+const y = 2;
 console.log(x);
```

---

## Elevated Mode

Run commands with elevated permissions.

### Configuration

```json
{
  "tools": {
    "elevated": {
      "enabled": false,
      "requireConfirmation": true,
      "allowedUsers": ["admin@example.com"]
    }
  }
}
```

### Usage

Only enable for trusted users/sessions.

---

## Browser Automation

Control web browsers programmatically.

### Setup

```json
{
  "tools": {
    "browser": {
      "enabled": true,
      "engine": "playwright",
      "headless": true
    }
  }
}
```

### Capabilities

- Navigate to URLs
- Click elements
- Fill forms
- Take screenshots
- Extract content
- Execute JavaScript

### Example

```javascript
// In skill context
await browser.goto('https://example.com');
await browser.click('#login-button');
await browser.fill('#username', 'user');
const screenshot = await browser.screenshot();
```

---

## Slash Commands

### Built-in Commands

| Command | Description |
|---------|-------------|
| `/help` | Show available commands |
| `/status` | Show agent status |
| `/clear` | Clear conversation |
| `/model` | Switch model |
| `/workspace` | Change workspace |

### Custom Commands

Define in skill files:

```markdown
## /mycommand

When user runs `/mycommand`:
1. Do something
2. Return result
```

### Command Configuration

```json
{
  "commands": {
    "custom": {
      "mycommand": {
        "description": "Does something useful",
        "skill": "my-skill"
      }
    }
  }
}
```

---

## Thinking Directives

Control how agents think and reason.

### Configuration

```json
{
  "agents": {
    "defaults": {
      "thinking": {
        "enabled": true,
        "showProcess": false,
        "maxTokens": 1000
      }
    }
  }
}
```

### In Skills

```markdown
## Thinking Guidelines

When solving problems:
1. Break down the problem
2. Consider alternatives
3. Explain your reasoning
```

---

## Agent Send

Send messages from agent to channels.

### Configuration

```json
{
  "tools": {
    "agentSend": {
      "enabled": true,
      "allowedChannels": ["slack", "discord"],
      "rateLimit": 10
    }
  }
}
```

### Usage

```javascript
// Agent can send proactively
await agentSend({
  channel: 'slack',
  to: '#notifications',
  message: 'Task completed!'
});
```

---

## Subagents

Spawn child agents for specific tasks.

### Configuration

```json
{
  "agents": {
    "subagents": {
      "enabled": true,
      "maxConcurrent": 3,
      "defaultModel": "claude-3-haiku"
    }
  }
}
```

### Usage

```javascript
// Spawn subagent
const result = await subagent.run({
  task: "Research this topic",
  model: "claude-3-haiku",
  timeout: 60000
});
```

### Subagent Types

- **Research**: Gather information
- **Code**: Write/review code
- **Analysis**: Analyze data
- **Custom**: Define your own

---

## Reactions

React to messages with emojis.

### Configuration

```json
{
  "tools": {
    "reactions": {
      "enabled": true,
      "allowedEmojis": ["thumbsup", "thumbsdown", "thinking", "check"]
    }
  }
}
```

### Usage

```javascript
// React to message
await react({
  messageId: '123',
  emoji: 'thumbsup'
});
```

---

## Tool Permissions

### Per-Session Permissions

```json
{
  "tools": {
    "permissions": {
      "session:whatsapp:+1234567890": {
        "exec": false,
        "browser": true,
        "patch": false
      }
    }
  }
}
```

### Per-Skill Permissions

```json
{
  "skills": {
    "entries": {
      "web-scraper": {
        "tools": ["browser", "fetch"]
      }
    }
  }
}
```

---

## Tool Development

### Creating Custom Tools

```javascript
// In skill directory: tools/mytool.js
module.exports = {
  name: 'mytool',
  description: 'Does something useful',
  parameters: {
    type: 'object',
    properties: {
      input: { type: 'string' }
    }
  },
  execute: async ({ input }) => {
    // Tool logic
    return { result: 'done' };
  }
};
```

### Tool Lifecycle

1. **Registration**: Tool loaded from skill
2. **Validation**: Parameters validated
3. **Execution**: Tool runs
4. **Result**: Output returned to agent

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/tools/skills
- https://docs.clawd.bot/tools/exec
- https://docs.clawd.bot/tools/patch
- https://docs.clawd.bot/tools/elevated
- https://docs.clawd.bot/tools/browser
- https://docs.clawd.bot/tools/slash-commands
- https://docs.clawd.bot/tools/thinking
- https://docs.clawd.bot/tools/agent-send
- https://docs.clawd.bot/tools/subagents
- https://docs.clawd.bot/tools/reactions
- https://docs.clawd.bot/tools/clawdhub

Run `./sync.sh` to update from upstream.
