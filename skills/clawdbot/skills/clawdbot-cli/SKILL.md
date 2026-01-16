---
name: clawdbot-cli
description: Clawdbot CLI commands - message sending, gateway control, updates, sandbox
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot CLI Expert

Complete reference for Clawdbot command-line interface.

**Documentation**: https://docs.clawd.bot/cli/

---

## Message Commands

### Send Message

```bash
# Basic message
clawdbot message send --channel whatsapp --to +1234567890 --message "Hello"

# With media attachment
clawdbot message send --channel telegram --to @user --message "Photo" --media ./photo.jpg

# To Discord channel
clawdbot message send --channel discord --to channel:123456789 --message "Hello Discord"

# To Slack channel
clawdbot message send --channel slack --to #general --message "Hello Slack"
```

### Send Poll

```bash
clawdbot message poll --channel discord --to channel:123 \
  --poll-question "Lunch?" \
  --poll-option Pizza \
  --poll-option Sushi \
  --poll-option Tacos
```

### React to Message

```bash
clawdbot message react --channel slack --message-id 123 --emoji thumbsup
```

### Channel Selection

```bash
--channel whatsapp|telegram|discord|slack|signal|imessage|msteams
```

---

## Gateway Commands

### Start Gateway

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

### Gateway Options

| Option | Description | Default |
|--------|-------------|---------|
| `--port` | Gateway port | `18789` |
| `--bind` | Bind address (`loopback`, `lan`, `0.0.0.0`) | `loopback` |
| `--verbose` | Enable verbose logging | `false` |
| `--dev` | Development mode | `false` |
| `--force` | Kill existing gateway first | `false` |

### Gateway Management

```bash
# Health check
clawdbot gateway health

# Comprehensive status
clawdbot gateway status

# Discover gateways on network
clawdbot gateway discover

# Low-level RPC call
clawdbot gateway call <method> [params]

# Stop gateway
clawdbot gateway stop
```

### Remote Gateway

```bash
# Connect to remote gateway via SSH
clawdbot gateway status --ssh user@gateway-host

# With Tailscale
clawdbot gateway --tailscale serve
```

---

## Agent Commands

### Run Agent

```bash
# Simple query
clawdbot agent "What's the weather?"

# With specific model
clawdbot agent --model claude-3-opus "Complex task"

# With workspace
clawdbot agent --workspace ~/myproject "Review this code"

# Stream output
clawdbot agent --stream "Generate a story"
```

### Agent Options

| Option | Description |
|--------|-------------|
| `--model` | Model to use (claude-3-opus, gpt-4, etc.) |
| `--workspace` | Working directory for agent |
| `--stream` | Stream output in real-time |
| `--timeout` | Timeout in seconds |

---

## Channel Commands

### Login to Channels

```bash
# WhatsApp QR scan
clawdbot channels login

# Specific channel
clawdbot channels login --channel telegram

# Check channel status
clawdbot channels status
```

### Pairing

```bash
# List pending pairing requests
clawdbot pairing list

# Approve pairing
clawdbot pairing approve whatsapp <code>

# Deny pairing
clawdbot pairing deny telegram <code>

# Clear all pairings
clawdbot pairing clear --channel whatsapp
```

---

## Update Commands

### Check Updates

```bash
clawdbot update check
```

### Apply Update

```bash
clawdbot update run
```

### Rollback

```bash
clawdbot update rollback
```

---

## Sandbox Commands

### Run in Sandbox

```bash
# Execute command in sandbox
clawdbot sandbox exec "npm install"

# With network access
clawdbot sandbox exec --network "curl https://api.example.com"

# Interactive shell
clawdbot sandbox shell
```

### Sandbox Options

| Option | Description |
|--------|-------------|
| `--network` | Allow network access |
| `--read-only` | Mount filesystem read-only |
| `--timeout` | Execution timeout |

---

## Diagnostic Commands

### Doctor

```bash
# Basic health check
clawdbot doctor

# Verbose diagnostics
clawdbot doctor --verbose

# Fix common issues
clawdbot doctor --fix
```

### Status

```bash
# Overall status
clawdbot status

# JSON output
clawdbot status --json
```

### Logs

```bash
# View recent logs
clawdbot logs

# Follow logs
clawdbot logs -f

# Filter by level
clawdbot logs --level error
```

---

## Configuration Commands

### Config Management

```bash
# Show current config
clawdbot config show

# Get specific value
clawdbot config get gateway.port

# Set value
clawdbot config set gateway.port 18790

# Reset to defaults
clawdbot config reset
```

### Onboarding

```bash
# Full onboarding wizard
clawdbot onboard

# With daemon installation
clawdbot onboard --install-daemon

# Skip interactive prompts
clawdbot onboard --non-interactive
```

---

## Skills Commands

### Manage Skills

```bash
# List installed skills
clawdbot skills list

# Install from ClawdHub
clawdbot skills install <skill-slug>

# Update skills
clawdbot skills update --all

# Remove skill
clawdbot skills remove <skill-name>
```

---

## Global Options

These options work with all commands:

| Option | Description |
|--------|-------------|
| `--help` | Show help |
| `--version` | Show version |
| `--verbose` | Verbose output |
| `--json` | JSON output format |
| `--config <path>` | Custom config file |

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `CLAWDBOT_CONFIG` | Path to config file |
| `CLAWDBOT_WORKSPACE` | Default workspace |
| `ANTHROPIC_API_KEY` | Anthropic API key |
| `OPENAI_API_KEY` | OpenAI API key |
| `DEBUG` | Enable debug logging |

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/cli/message
- https://docs.clawd.bot/cli/gateway
- https://docs.clawd.bot/cli/updates
- https://docs.clawd.bot/cli/sandbox

Run `./sync.sh` to update from upstream.
