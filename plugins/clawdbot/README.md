# Clawdbot Plugin

Expert assistant for Clawdbot - the AI assistant framework that connects Claude and other LLMs to messaging platforms.

## What is Clawdbot?

Clawdbot is an AI assistant framework that:
- Connects LLMs (Claude, OpenAI, etc.) to messaging platforms
- Supports WhatsApp, Telegram, Discord, Slack, Signal, iMessage, MS Teams
- Uses a gateway architecture with WebSocket protocol
- Provides workspace management with memory and session persistence
- Supports skills/plugins via AgentSkills-compatible system

**Documentation**: https://docs.clawd.bot/

## Installation

```bash
# Add marketplace
/plugin marketplace add zot24/claude-plugins

# Install plugin
/plugin install clawdbot@claude-plugins
```

## Commands

### `/clawdbot setup`
Guide through installation and initial configuration.

### `/clawdbot channel <name>`
Configure a messaging channel:
- `whatsapp` - QR login, DM policies
- `telegram` - Bot token, group settings
- `discord` - Bot creation, intents
- `slack` - Socket Mode, tokens
- `signal` - signal-cli setup
- `imessage` - macOS setup
- `msteams` - App registration

### `/clawdbot diagnose`
Troubleshoot common issues with diagnostic commands.

### `/clawdbot gateway`
Help with gateway configuration and remote access.

### `/clawdbot skills`
Guide on creating and managing Clawdbot skills.

### `/clawdbot memory`
Explain and configure the memory system.

### `/clawdbot sync`
Update documentation from upstream.

### `/clawdbot help`
Show available commands.

## Natural Language

The plugin also activates when you mention Clawdbot topics:
- "How do I set up WhatsApp with Clawdbot?"
- "My Telegram bot isn't receiving messages"
- "Configure Discord for Clawdbot"
- "Clawdbot gateway won't start"

## Coverage

The skill covers all major Clawdbot documentation:

| Section | Topics |
|---------|--------|
| Installation | Quick install, prerequisites, post-install setup |
| Architecture | Gateway, control-plane, nodes, wire protocol |
| Gateway | Starting, commands, configuration, hot reload |
| Channels | WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams |
| CLI | Message sending, agent commands, pairing, diagnostics |
| Agent Loop | Execution flow, timeouts, event streams |
| Memory | Daily files, long-term memory, search |
| System Prompt | Bootstrap files, time handling |
| Skills | Creation, locations, ClawdHub |
| Providers | Anthropic, OpenAI, others |
| Troubleshooting | Common issues, diagnostic commands, logs |
| Platforms | macOS, iOS/Android, Linux, Windows WSL2, VPS |
| Remote Access | SSH tunneling, Tailscale, Bonjour |
| Automation | Webhooks, cron jobs, Gmail integration |

## Upstream Source

Documentation sourced from: https://docs.clawd.bot/

## License

MIT
