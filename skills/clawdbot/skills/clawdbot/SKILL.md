---
name: clawdbot
description: Clawdbot AI assistant framework - connects Claude/LLMs to messaging platforms (WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams). Use for setup, configuration, channels, troubleshooting.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Expert

You are an expert on Clawdbot, the AI assistant framework connecting LLMs to messaging platforms.

## Overview

- Connects Claude, OpenAI, and other LLMs to messaging channels
- Supports WhatsApp, Telegram, Discord, Slack, Signal, iMessage, MS Teams
- Gateway architecture with WebSocket protocol
- Workspace management with memory and session persistence
- Skills system via AgentSkills-compatible format
- MCP server support via MCPorter integration
- Runs on macOS, iOS, Android, Windows (WSL2), Linux

## Quick Start

```bash
# Install
curl -fsSL https://clawd.bot/install.sh | bash

# Setup
clawdbot onboard --install-daemon

# Configure API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Start gateway
clawdbot gateway

# Connect channel
clawdbot channels login  # Scan WhatsApp QR
```

## Core Concepts

**Gateway**: Central hub coordinating channels and agent execution (`ws://127.0.0.1:18789`)

**Channels**: Messaging platform integrations (WhatsApp, Telegram, Discord, etc.)

**Workspace**: Directory with memory, skills, config (default: `~/clawd`)

## Documentation

Reference detailed docs for specific topics:

- **[Installation](docs/install.md)** - Docker, npm, source, Ansible, Nix
- **[CLI Commands](docs/cli.md)** - Message sending, gateway control, updates
- **[Core Concepts](docs/concepts.md)** - Architecture, memory, sessions, streaming
- **[Gateway](docs/gateway.md)** - Protocol, config, auth, health, troubleshooting
- **[Channels](docs/channels.md)** - WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams
- **[Providers](docs/providers.md)** - Anthropic, OpenAI, Moonshot, MiniMax, OpenRouter
- **[Tools & Skills](docs/tools.md)** - Exec, browser, slash commands, MCP servers, ClawdHub
- **[Automation](docs/automation.md)** - Webhooks, Gmail, cron jobs, polling
- **[Web Interfaces](docs/web.md)** - Control panel, dashboard, webchat, TUI
- **[Nodes & Media](docs/nodes.md)** - Camera, images, audio, location, voice
- **[Platforms](docs/platforms.md)** - macOS, iOS, Android, Windows, Linux, VPS

## Common Commands

```bash
clawdbot gateway              # Start gateway
clawdbot status               # Check status
clawdbot doctor               # Health check
clawdbot message send --channel whatsapp --to +1234567890 --message "Hello"
clawdbot agent "What's the weather?"
```

## Configuration

Main config: `~/.clawdbot/clawdbot.json`

```json
{
  "gateway": { "port": 18789, "bind": "loopback" },
  "channels": { "whatsapp": { "enabled": true } },
  "agents": { "defaults": { "model": "claude-sonnet-4-20250514" } }
}
```

## Upstream Sources

- **Documentation**: https://docs.clawd.bot/
- **Repository**: https://github.com/clawdbot/clawdbot
- **Discord**: https://discord.gg/clawdbot

## Sync & Update

When user runs `sync`: fetch latest from https://docs.clawd.bot/ and update docs/ files.
When user runs `diff`: compare current docs/ vs upstream without modifying.
