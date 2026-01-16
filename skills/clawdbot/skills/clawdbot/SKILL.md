---
name: clawdbot
description: Clawdbot overview - AI assistant framework connecting Claude/LLMs to messaging platforms. Use for general Clawdbot questions and getting started.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Expert

You are an expert on Clawdbot, the AI assistant framework that connects Claude and other LLMs to messaging platforms.

**Documentation**: https://docs.clawd.bot/

---

## What is Clawdbot?

Clawdbot is an AI assistant framework that:
- Connects LLMs (Claude, OpenAI, etc.) to messaging platforms
- Supports WhatsApp, Telegram, Discord, Slack, Signal, iMessage, MS Teams
- Uses a gateway architecture with WebSocket protocol
- Provides workspace management with memory and session persistence
- Supports skills/plugins via AgentSkills-compatible system
- Runs on macOS, iOS, Android, Windows (WSL2), Linux

---

## Quick Start

### Install

```bash
curl -fsSL https://clawd.bot/install.sh | bash
```

### Setup

```bash
clawdbot onboard --install-daemon
```

### Configure API Key

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### Start Gateway

```bash
clawdbot gateway
```

### Connect Channel

```bash
clawdbot channels login  # Scan WhatsApp QR
```

---

## Specialized Skills

For detailed documentation, see these specialized skills:

| Skill | Description |
|-------|-------------|
| **clawdbot-install** | Installation methods: Docker, npm, source, Ansible, Nix |
| **clawdbot-cli** | CLI commands: message, gateway, updates, sandbox |
| **clawdbot-concepts** | Core concepts: architecture, memory, sessions, streaming |
| **clawdbot-gateway** | Gateway: protocol, config, auth, health, troubleshooting |
| **clawdbot-channels** | Channels: WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams |
| **clawdbot-providers** | Providers: Anthropic, OpenAI, Moonshot, MiniMax, OpenRouter |
| **clawdbot-tools** | Tools & skills: exec, browser, slash-commands, ClawdHub |
| **clawdbot-automation** | Automation: webhooks, Gmail, cron jobs, polling |
| **clawdbot-web** | Web interfaces: control panel, dashboard, webchat, TUI |
| **clawdbot-nodes** | Nodes & media: camera, images, audio, location, voice |
| **clawdbot-platforms** | Platforms: macOS, iOS, Android, Windows, Linux, VPS |

---

## Key Concepts

### Gateway

Central hub that coordinates all channels and agent execution.

```bash
clawdbot gateway --port 18789
```

### Channels

Messaging platform integrations (WhatsApp, Telegram, etc.).

### Workspace

Directory containing memory, skills, and configuration.
Default: `~/clawd`

### Skills

AgentSkills-compatible plugins that teach Clawdbot new capabilities.

---

## Common Commands

```bash
# Start gateway
clawdbot gateway

# Check status
clawdbot status

# Health check
clawdbot doctor

# Send message
clawdbot message send --channel whatsapp --to +1234567890 --message "Hello"

# Run agent
clawdbot agent "What's the weather?"
```

---

## Configuration

Main config: `~/.clawdbot/clawdbot.json`

```json
{
  "gateway": {
    "port": 18789,
    "bind": "loopback"
  },
  "channels": {
    "whatsapp": { "enabled": true },
    "telegram": { "enabled": true, "botToken": "..." }
  },
  "agents": {
    "defaults": {
      "model": "claude-sonnet-4-20250514",
      "workspace": "~/clawd"
    }
  }
}
```

---

## Getting Help

- **Documentation**: https://docs.clawd.bot/
- **Discord**: https://discord.gg/clawdbot
- **GitHub**: https://github.com/clawdbot/clawdbot

---

## Sync Information

This is an overview skill. For complete documentation, see the specialized skills listed above.

**Upstream Sources:**
- https://docs.clawd.bot/start/getting-started
- https://docs.clawd.bot/start/wizard
- https://docs.clawd.bot/start/faq

Run `./sync.sh` to update all skills from upstream.
