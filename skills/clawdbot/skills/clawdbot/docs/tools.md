<!-- Source: https://docs.clawd.bot/tools/ -->

# Clawdbot Tools & Skills

Complete guide to tools and skills in Clawdbot.

## Skills System

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
```

### Skill Configuration

```json
{
  "skills": {
    "entries": {
      "my-skill": { "enabled": true, "env": { "MY_VAR": "value" } }
    }
  }
}
```

---

## ClawdHub

Public skills registry at https://clawdhub.com

```bash
clawdhub install <skill-slug>
clawdhub update --all
clawdhub search "web scraping"
clawdhub publish <skill-dir>
```

---

## Exec Tool

```json
{
  "tools": {
    "exec": {
      "enabled": true,
      "allowedCommands": ["ls", "cat", "grep"],
      "blockedCommands": ["rm", "sudo"],
      "timeout": 30000,
      "sandbox": { "enabled": true, "network": false }
    }
  }
}
```

---

## Patch Tool

```json
{
  "tools": {
    "patch": { "enabled": true, "requireApproval": true, "maxFileSize": "1MB" }
  }
}
```

---

## Browser Automation

```json
{
  "tools": {
    "browser": { "enabled": true, "engine": "playwright", "headless": true }
  }
}
```

Capabilities: Navigate, click, fill forms, screenshots, extract content, execute JS.

---

## Slash Commands

### Built-in

| Command | Description |
|---------|-------------|
| `/help` | Show commands |
| `/status` | Agent status |
| `/clear` | Clear conversation |
| `/model` | Switch model |

### Custom Commands

Define in skill files:

```markdown
## /mycommand
When user runs `/mycommand`: Do something...
```

---

## Thinking Directives

```json
{
  "agents": {
    "defaults": {
      "thinking": { "enabled": true, "showProcess": false, "maxTokens": 1000 }
    }
  }
}
```

---

## Subagents

```json
{
  "agents": {
    "subagents": { "enabled": true, "maxConcurrent": 3, "defaultModel": "claude-3-haiku" }
  }
}
```

```javascript
const result = await subagent.run({
  task: "Research this topic",
  model: "claude-3-haiku"
});
```

---

## Tool Permissions

```json
{
  "tools": {
    "permissions": {
      "session:whatsapp:+1234567890": { "exec": false, "browser": true }
    }
  }
}
```

---

## Custom Tool Development

```javascript
// tools/mytool.js
module.exports = {
  name: 'mytool',
  description: 'Does something useful',
  parameters: {
    type: 'object',
    properties: { input: { type: 'string' } }
  },
  execute: async ({ input }) => ({ result: 'done' })
};
```

---

## Upstream Sources

- https://docs.clawd.bot/tools/skills
- https://docs.clawd.bot/tools/exec
- https://docs.clawd.bot/tools/browser
- https://docs.clawd.bot/tools/slash-commands
- https://docs.clawd.bot/tools/subagents
- https://docs.clawd.bot/tools/clawdhub
