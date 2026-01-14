# Clawdbot Plugin

Expert assistant for Clawdbot - the AI assistant framework that connects Claude and other LLMs to messaging platforms.

## What is Clawdbot?

Clawdbot is an AI assistant framework that:
- Connects LLMs (Claude, OpenAI, etc.) to messaging platforms
- Supports WhatsApp, Telegram, Discord, Slack, Signal, iMessage, MS Teams
- Uses a gateway architecture with WebSocket protocol
- Provides workspace management with memory and session persistence
- Supports skills/plugins via AgentSkills-compatible system
- Runs on macOS, iOS, Android, Windows (WSL2), Linux

**Documentation**: https://docs.clawd.bot/

## Installation

```bash
# Add marketplace
/plugin marketplace add zot24/claude-plugins

# Install plugin
/plugin install clawdbot@claude-plugins
```

### Project-Level Installation

Add to your project's `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "clawdbot@claude-plugins": true
  }
}
```

## Commands

### `/clawdbot setup`
Guide through installation and initial configuration:
- Check prerequisites (Node.js 22+)
- Run installation script
- Configure `clawdbot onboard --install-daemon`
- Set up authentication (API keys or OAuth)

### `/clawdbot channel <name>`
Configure a specific messaging channel:

| Channel | Setup |
|---------|-------|
| `whatsapp` | QR code login, DM policies, self-chat mode |
| `telegram` | @BotFather token, group settings, streaming |
| `discord` | Bot creation, intents, permissions, invite |
| `slack` | App creation, Socket Mode, tokens and scopes |
| `signal` | signal-cli setup |
| `imessage` | macOS Full Disk Access permission |
| `msteams` | App registration, appId/appPassword |

### `/clawdbot diagnose`
Troubleshoot common issues:
1. Run `clawdbot doctor --verbose`
2. Check gateway status
3. Verify channel connections
4. Review log files at `/tmp/clawdbot/`
5. Provide specific fixes

### `/clawdbot gateway`
Help with gateway configuration:
- Starting: `clawdbot gateway --port 18789`
- Health check: `clawdbot gateway health`
- Remote access via SSH/Tailscale
- Hot reload configuration

### `/clawdbot skills`
Guide on creating and managing Clawdbot skills:
- SKILL.md structure and frontmatter
- Skill locations and precedence
- ClawdHub installation: `clawdhub install <skill>`
- Configuration in `clawdbot.json`

### `/clawdbot memory`
Configure the memory system:
- Daily files: `memory/YYYY-MM-DD.md`
- Long-term: `MEMORY.md`
- Memory search with embeddings
- Provider configuration (OpenAI/local)

### `/clawdbot sync`
Update documentation from upstream https://docs.clawd.bot/

### `/clawdbot diff`
Check for documentation changes without modifying.

### `/clawdbot help`
Show available commands.

## Natural Language

The plugin auto-activates when you mention Clawdbot topics:
- "How do I set up WhatsApp with Clawdbot?"
- "My Telegram bot isn't receiving messages"
- "Configure Discord for Clawdbot"
- "Clawdbot gateway won't start"
- "Create a Clawdbot skill"
- "Set up memory search"

## Quick Start

### Install Clawdbot

```bash
curl -fsSL https://clawd.bot/install.sh | bash
clawdbot onboard --install-daemon
```

### Configure Authentication

```bash
# Option 1: API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Option 2: Reuse Claude Code credentials
claude setup-token
```

### Start Gateway

```bash
clawdbot gateway
```

### Set Up WhatsApp

```bash
clawdbot channels login
# Scan QR code with your phone
```

### Configuration File

Location: `~/.clawdbot/clawdbot.json`

```json
{
  "gateway": {
    "mode": "local",
    "bind": "loopback",
    "port": 18789
  },
  "channels": {
    "whatsapp": { "enabled": true },
    "telegram": { "enabled": true, "botToken": "123:abc" },
    "discord": { "enabled": true, "botToken": "..." },
    "slack": { "enabled": true, "appToken": "xapp-...", "botToken": "xoxb-..." }
  },
  "agents": {
    "defaults": {
      "workspace": "~/clawd",
      "timeoutSeconds": 600
    }
  }
}
```

## Coverage

The skill covers all major Clawdbot documentation:

| Section | Topics |
|---------|--------|
| **Installation** | Quick install, prerequisites, post-install setup, authentication |
| **Architecture** | Gateway, control-plane clients, nodes, WebChat, wire protocol |
| **Gateway** | Starting, commands, configuration, hot reload |
| **WhatsApp** | Setup, DM policies, self-chat mode, troubleshooting |
| **Telegram** | Bot setup, group settings, forum topics, streaming |
| **Discord** | Bot creation, intents, permissions, features |
| **Slack** | App creation, Socket Mode, tokens, scopes, threading |
| **Signal** | signal-cli setup |
| **iMessage** | macOS only, Full Disk Access |
| **MS Teams** | App registration |
| **CLI** | Message sending, agent commands, pairing, diagnostics |
| **Agent Loop** | Execution flow, timeouts, event streams |
| **Memory** | Daily files, long-term, search, providers |
| **System Prompt** | Bootstrap files, time handling |
| **Skills** | Creation, locations, ClawdHub |
| **Providers** | Anthropic, OpenAI, others |
| **Troubleshooting** | Common issues, diagnostic commands, logs |
| **Platforms** | macOS, iOS/Android, Linux, Windows WSL2, VPS |
| **Remote Access** | SSH tunneling, Tailscale, Bonjour |
| **Automation** | Webhooks, cron jobs, Gmail integration |

## Common Issues

### Gateway Won't Start

```bash
# Check port availability
lsof -i :18789

# Verify config
clawdbot doctor

# Check logs
tail -f /tmp/clawdbot/clawdbot-$(date +%Y-%m-%d).log

# Force restart
clawdbot gateway --force
```

### WhatsApp Not Connecting

```bash
# Re-scan QR code
clawdbot channels login

# Check status
clawdbot gateway status

# Note: Use Node.js, not Bun (Bun unreliable for WhatsApp)
```

### Messages Not Received

1. Check DM policy settings in `clawdbot.json`
2. Verify pairing approvals: `clawdbot pairing list`
3. Check allowlist configuration

### Agent Errors

1. Verify API key: `echo $ANTHROPIC_API_KEY`
2. Check OAuth: `~/.clawdbot/credentials/oauth.json`
3. Review timeout settings

## Keeping Updated

### Check for Changes

```bash
/clawdbot diff
```

### Sync with Upstream

```bash
/clawdbot sync
```

### Upstream Sources

| Section | URL |
|---------|-----|
| Getting Started | https://docs.clawd.bot/start/getting-started |
| Architecture | https://docs.clawd.bot/concepts/architecture |
| Gateway | https://docs.clawd.bot/cli/gateway |
| WhatsApp | https://docs.clawd.bot/channels/whatsapp |
| Telegram | https://docs.clawd.bot/channels/telegram |
| Discord | https://docs.clawd.bot/channels/discord |
| Slack | https://docs.clawd.bot/channels/slack |
| Memory | https://docs.clawd.bot/concepts/memory |
| Skills | https://docs.clawd.bot/tools/skills |
| CLI Reference | https://docs.clawd.bot/cli/message |

## Plugin Structure

```
clawdbot/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── commands/
│   └── clawdbot.md       # Slash command definition
├── skills/
│   └── clawdbot/
│       └── SKILL.md      # Comprehensive knowledge base
├── sync.json             # Sync configuration for CI
├── .gitignore
└── README.md
```

## Resources

- [Clawdbot Documentation](https://docs.clawd.bot/)
- [ClawdHub Skills Registry](https://clawdhub.com)
- [AgentSkills Specification](https://agentskills.io)

## License

MIT
