---
name: clawdbot
description: Expert on Clawdbot - AI assistant framework connecting Claude/LLMs to messaging platforms. Use when user asks about Clawdbot setup, configuration, channels (WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams), gateway, CLI, skills, memory, troubleshooting, or any Clawdbot-related topic.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Expert Skill

You are an expert on Clawdbot, the AI assistant framework that connects Claude and other LLMs to messaging platforms.

## What is Clawdbot?

Clawdbot is an AI assistant framework that:
- Connects LLMs (Claude, OpenAI, etc.) to messaging platforms
- Supports WhatsApp, Telegram, Discord, Slack, Signal, iMessage, MS Teams
- Uses a gateway architecture with WebSocket protocol
- Provides workspace management with memory and session persistence
- Supports skills/plugins via AgentSkills-compatible system
- Runs on macOS, iOS, Android, Windows (WSL2), Linux

**Documentation**: https://docs.clawd.bot/

---

## 1. INSTALLATION

### Quick Install (Recommended)

```bash
curl -fsSL https://clawd.bot/install.sh | bash
```

### Alternative: Non-root Install

```bash
curl -fsSL https://clawd.bot/install-cli.sh | bash
```

Installs to `~/.clawdbot` with dedicated Node runtime.

### Prerequisites

- **Node.js 22+** (auto-installed on macOS via Homebrew)
- **Git** (required for source builds)
- **macOS**: Xcode CLI tools for app development
- **Windows**: WSL2 (Ubuntu recommended)

### Post-Install Setup

```bash
clawdbot onboard --install-daemon
```

This wizard configures:
- Model authentication (API keys or OAuth)
- Gateway settings
- Channel credentials
- Pairing defaults
- Workspace bootstrap

### Authentication

For Anthropic models:
```bash
# Option 1: Set API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Option 2: Reuse Claude Code credentials
claude setup-token
```

OAuth credentials stored in `~/.clawdbot/credentials/oauth.json`

---

## 2. ARCHITECTURE

### Core Components

**Gateway (Daemon)**
- Central hub coordinating all channels
- WebSocket API on `127.0.0.1:18789` (default)
- Maintains provider connections
- Emits events (agent execution, chat, presence, health, cron)

**Control-Plane Clients**
- CLI, macOS app, web dashboards
- Connect via WebSocket
- Send typed requests, receive events

**Nodes (Mobile/Desktop)**
- iOS, Android, macOS nodes
- Use Bridge protocol (TCP JSONL) not WebSocket
- Expose commands: `canvas.*`, `camera.*`, `screen.record`, `location.get`

**WebChat**
- Static UI using Gateway WebSocket API
- Accessible via SSH/Tailscale tunnels

### Wire Protocol

```json
// Request
{"type": "req", "id": "...", "method": "...", "params": {...}}

// Response
{"type": "res", "id": "...", "ok": true, "payload": {...}}

// Event
{"type": "event", "event": "...", "payload": {...}}
```

**Connection Flow:**
1. Client sends `connect` frame (mandatory first message)
2. Gateway responds with presence/health snapshot
3. Server pushes async events
4. Client sends requests, receives responses

---

## 3. GATEWAY

### Starting the Gateway

```bash
# Basic start
clawdbot gateway

# With options
clawdbot gateway --port 18789 --bind loopback --verbose

# Development mode
clawdbot gateway --dev --allow-unconfigured

# Force restart (kill existing)
clawdbot gateway --force
```

### Gateway Commands

```bash
# Health check
clawdbot gateway health

# Comprehensive status
clawdbot gateway status

# Discover gateways on network
clawdbot gateway discover

# Low-level RPC call
clawdbot gateway call <method>
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
    "telegram": { "enabled": true, "botToken": "..." },
    "discord": { "enabled": true },
    "slack": { "enabled": true }
  },
  "agents": {
    "defaults": {
      "workspace": "~/clawd",
      "timeoutSeconds": 600
    }
  }
}
```

### Hot Reload

Config changes auto-reload. Send `SIGUSR1` for in-process restart.

---

## 4. CHANNELS

### WhatsApp

**Setup:**
1. Configure in `~/.clawdbot/clawdbot.json`
2. Scan QR: `clawdbot channels login`
3. Start gateway

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "dmPolicy": "pairing",
      "allowFrom": ["+1234567890"]
    }
  }
}
```

**DM Policies:**
- `pairing` (default): Unknown senders get approval code
- `allowlist`: Only specified numbers
- `open`: Anyone (requires `allowFrom: ["*"]`)

**Self-chat mode** (personal number):
```json
"selfChatMode": true
```

**Troubleshooting:**
- Not linked: `clawdbot channels login`
- Disconnected: `clawdbot doctor`
- Use Node.js, not Bun (Bun unreliable for WhatsApp)

---

### Telegram

**Setup:**
1. Create bot via @BotFather
2. Copy token
3. Configure

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "123:abc",
      "dmPolicy": "pairing"
    }
  }
}
```

**Group Settings:**
- Default: Only responds to mentions
- Disable Privacy Mode in BotFather for non-mention responses
- Configure per-group: `channels.telegram.groups.<id>`

**Forum Topics:**
- Each topic gets isolated session
- Session key: `...:topic:<threadId>`

**Streaming:**
```json
"streamMode": "partial"  // off, partial, block
```

---

### Discord

**Setup:**
1. Create app at discord.com/developers
2. Enable bot, get token
3. Configure intents and permissions
4. Invite to server

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "botToken": "...",
      "dmPolicy": "pairing"
    }
  }
}
```

**Required Intents:**
- `GUILDS`, `GUILD_MESSAGES`, `MESSAGE_CONTENT`, `DIRECT_MESSAGES`

**Features:**
- Slash commands
- Thread management
- Reactions
- File attachments
- Voice (with additional setup)

---

### Slack

**Setup:**
1. Create app at api.slack.com/apps
2. Enable Socket Mode
3. Generate App Token (`xapp-...`) with `connections:write`
4. Add bot token scopes, install to workspace
5. Enable Event Subscriptions

```json
{
  "channels": {
    "slack": {
      "enabled": true,
      "appToken": "xapp-...",
      "botToken": "xoxb-..."
    }
  }
}
```

**Required Scopes:**
`chat:write`, `im:write`, `channels:history`, `groups:history`, `users:read`, `reactions:read/write`, `files:write`

**Threading:**
```json
"replyToMode": "all"  // off, first, all
```

---

### Signal

```json
{
  "channels": {
    "signal": {
      "enabled": true,
      "number": "+1234567890"
    }
  }
}
```

Requires signal-cli setup.

---

### iMessage

macOS only. Requires Full Disk Access permission.

```json
{
  "channels": {
    "imessage": {
      "enabled": true
    }
  }
}
```

---

### Microsoft Teams

```json
{
  "channels": {
    "msteams": {
      "enabled": true,
      "appId": "...",
      "appPassword": "..."
    }
  }
}
```

---

## 5. CLI COMMANDS

### Message Sending

```bash
# Send message
clawdbot message send --channel whatsapp --to +1234567890 --message "Hello"

# Send with media
clawdbot message send --channel telegram --to @user --message "Photo" --media ./photo.jpg

# Create poll
clawdbot message poll --channel discord --to channel:123 \
  --poll-question "Lunch?" --poll-option Pizza --poll-option Sushi

# React to message
clawdbot message react --channel slack --message-id 123 --emoji thumbsup
```

### Channel Selection

```bash
--channel whatsapp|telegram|discord|slack|signal|imessage|msteams
```

### Agent Commands

```bash
# Run agent
clawdbot agent "What's the weather?"

# With specific model
clawdbot agent --model claude-3-opus "Complex task"
```

### Pairing

```bash
# List pending
clawdbot pairing list

# Approve
clawdbot pairing approve whatsapp <code>

# Deny
clawdbot pairing deny telegram <code>
```

### Diagnostics

```bash
# Health check
clawdbot doctor

# Verbose diagnostics
clawdbot doctor --verbose

# Status
clawdbot status
```

### Updates

```bash
# Check for updates
clawdbot update check

# Apply update
clawdbot update run
```

---

## 6. AGENT LOOP

### Execution Flow

1. **RPC Validation** - Validate params, resolve session
2. **Agent Setup** - Resolve model, load skills snapshot
3. **Runtime Execution** - Run pi-agent-core
4. **Event Streaming** - Tool events, assistant deltas, lifecycle
5. **Completion** - Return results and token usage

### Timeouts

- Agent runtime: `agents.defaults.timeoutSeconds` (default 600s)
- `agent.wait` default: 30s (configurable via `timeoutMs`)

### Event Streams

- `lifecycle` - Start, end, error signals
- `assistant` - Model-generated text deltas
- `tool` - Tool invocation and results

---

## 7. MEMORY SYSTEM

### Memory Files

Location: Agent workspace (default `~/clawd`)

**Daily Memory:**
```
memory/YYYY-MM-DD.md
```
- Append-only daily logs
- Read at session start (today + yesterday)

**Long-term Memory:**
```
MEMORY.md
```
- Curated durable facts
- Only loaded in main/private sessions

### Writing Memory

- Permanent preferences → `MEMORY.md`
- Temporary notes → `memory/YYYY-MM-DD.md`
- User requests to remember → Write immediately to disk

### Memory Search

Requires embedding provider (OpenAI default or local):

```json
{
  "agents": {
    "defaults": {
      "memorySearch": {
        "enabled": true,
        "provider": "remote"  // or "local"
      }
    }
  }
}
```

**Memory Tools:**
- `memory_search` - Semantic search
- `memory_get` - Read specific files

---

## 8. SYSTEM PROMPT

### Bootstrap Files

Automatically injected into system prompt:
- `AGENTS.md`
- `SOUL.md`
- `TOOLS.md`
- `IDENTITY.md`
- `USER.md`
- `HEARTBEAT.md`
- `BOOTSTRAP.md`

Located in workspace directory. Max chars: `agents.defaults.bootstrapMaxChars` (default 20,000)

### Time Handling

UTC by default. User timezone via `agents.defaults.userTimezone`

---

## 9. SKILLS

### What Are Skills?

AgentSkills-compatible folders with `SKILL.md` that teach Clawdbot tools.

### Skill Locations (Precedence)

1. **Workspace skills**: `<workspace>/skills` (highest)
2. **Managed/local**: `~/.clawdbot/skills`
3. **Bundled**: Shipped with installation (lowest)

### Creating Skills

```markdown
---
name: my-skill
description: What this skill does
---

# My Skill

Instructions for the agent...
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

### ClawdHub

Public skills registry: https://clawdhub.com

```bash
# Install skill
clawdhub install <skill-slug>

# Update all
clawdhub update --all

# Sync/publish
clawdhub sync --all
```

---

## 10. PROVIDERS

### Anthropic (Default)

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

Or OAuth via Claude Code credentials.

### OpenAI

```bash
export OPENAI_API_KEY="sk-..."
```

### Other Providers

Configure in `~/.clawdbot/clawdbot.json`:
- Moonshot
- MiniMax
- OpenRouter
- OpenCode
- GLM
- Z.AI

---

## 11. TROUBLESHOOTING

### Common Issues

**Gateway won't start:**
- Check port availability: `lsof -i :18789`
- Verify config: `clawdbot doctor`
- Check logs: `/tmp/clawdbot/clawdbot-YYYY-MM-DD.log`

**Channel not connecting:**
- WhatsApp: `clawdbot channels login` to re-scan QR
- Telegram: Verify bot token
- Discord: Check intents and permissions
- Slack: Verify app/bot tokens and scopes

**Messages not received:**
- Check DM policy settings
- Verify pairing approvals
- Check allowlist configuration

**Agent errors:**
- Verify API key/OAuth credentials
- Check model availability
- Review timeout settings

### Diagnostic Commands

```bash
# Full health check
clawdbot doctor --verbose

# Gateway status
clawdbot gateway status

# Channel status
clawdbot channels status

# View logs
tail -f /tmp/clawdbot/clawdbot-$(date +%Y-%m-%d).log
```

### Log Locations

- Main log: `/tmp/clawdbot/clawdbot-YYYY-MM-DD.log`
- Subsystems: `whatsapp/inbound`, `telegram/handler`, `web-reconnect`

---

## 12. PLATFORMS

### macOS

Full support including:
- Native app
- CLI
- iMessage integration
- Camera/screen capture

### iOS/Android

Via Bridge protocol:
- Canvas tools
- Camera capture
- Location services
- Requires pairing to gateway

### Linux

Full CLI and gateway support:
```bash
curl -fsSL https://clawd.bot/install.sh | bash
```

### Windows (WSL2)

Use WSL2 with Ubuntu:
```bash
# In WSL2
curl -fsSL https://clawd.bot/install.sh | bash
```

### VPS/Servers

Headless deployment:
1. Install via installer script
2. Configure credentials
3. Run gateway as daemon
4. Optional: Tailscale for remote access

---

## 13. REMOTE ACCESS

### SSH Tunneling

```bash
clawdbot gateway status --ssh user@gateway-host
```

### Tailscale

```bash
clawdbot gateway --tailscale serve  # or funnel
```

### Bonjour/mDNS Discovery

```bash
clawdbot gateway discover
```

---

## 14. AUTOMATION

### Webhooks

Configure webhook endpoints for external integrations.

### Cron Jobs

Schedule recurring agent tasks.

### Gmail Pub/Sub

Integrate with Gmail for email-triggered actions.

---

## 15. SYNC & UPDATE

### Upstream Source

```
https://docs.clawd.bot/
```

### Key Documentation Pages

| Section | URL |
|---------|-----|
| Getting Started | /start/getting-started |
| Architecture | /concepts/architecture |
| Gateway | /cli/gateway |
| WhatsApp | /channels/whatsapp |
| Telegram | /channels/telegram |
| Discord | /channels/discord |
| Slack | /channels/slack |
| Memory | /concepts/memory |
| Skills | /tools/skills |
| CLI Reference | /cli/message |

### Sync Command

When user runs `sync`:
1. Fetch latest docs from https://docs.clawd.bot/
2. Compare key sections for changes
3. Update SKILL.md with new information
4. Report changes

### Diff Command

When user runs `diff`:
1. Fetch upstream documentation
2. Compare without modifying
3. Report differences
