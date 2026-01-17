<!-- Source: https://docs.clawd.bot/cli/ -->

# Clawdbot CLI

Complete reference for Clawdbot command-line interface.

## Message Commands

```bash
# Send message
clawdbot message send --channel whatsapp --to +1234567890 --message "Hello"
clawdbot message send --channel telegram --to @user --message "Photo" --media ./photo.jpg
clawdbot message send --channel discord --to channel:123456789 --message "Hello"
clawdbot message send --channel slack --to #general --message "Hello"

# Send poll
clawdbot message poll --channel discord --to channel:123 \
  --poll-question "Lunch?" --poll-option Pizza --poll-option Sushi

# React
clawdbot message react --channel slack --message-id 123 --emoji thumbsup
```

---

## Gateway Commands

```bash
clawdbot gateway                    # Start gateway
clawdbot gateway --port 18789       # Custom port
clawdbot gateway --bind loopback    # Bind address
clawdbot gateway --dev              # Development mode
clawdbot gateway --force            # Kill existing first
clawdbot gateway health             # Health check
clawdbot gateway status             # Full status
clawdbot gateway stop               # Stop gateway
clawdbot gateway discover           # Find gateways on network
clawdbot gateway --tailscale serve  # Serve via Tailscale
```

---

## Agent Commands

```bash
clawdbot agent "What's the weather?"              # Simple query
clawdbot agent --model claude-3-opus "Complex"    # Specific model
clawdbot agent --workspace ~/myproject "Review"   # With workspace
clawdbot agent --stream "Generate a story"        # Stream output
```

---

## Channel Commands

```bash
clawdbot channels login                  # WhatsApp QR scan
clawdbot channels login --channel telegram
clawdbot channels status
clawdbot pairing list                    # Pending requests
clawdbot pairing approve whatsapp <code>
clawdbot pairing deny telegram <code>
```

---

## Update Commands

```bash
clawdbot update check
clawdbot update run
clawdbot update rollback
```

---

## Sandbox Commands

```bash
clawdbot sandbox exec "npm install"
clawdbot sandbox exec --network "curl https://api.example.com"
clawdbot sandbox shell
```

---

## Diagnostic Commands

```bash
clawdbot doctor              # Health check
clawdbot doctor --verbose    # Detailed diagnostics
clawdbot doctor --fix        # Auto-fix issues
clawdbot status              # Overall status
clawdbot status --json       # JSON output
clawdbot logs                # View logs
clawdbot logs -f             # Follow logs
clawdbot logs --level error  # Filter by level
```

---

## Configuration Commands

```bash
clawdbot config show
clawdbot config get gateway.port
clawdbot config set gateway.port 18790
clawdbot config reset
clawdbot onboard --install-daemon
```

---

## Skills Commands

```bash
clawdbot skills list
clawdbot skills install <skill-slug>
clawdbot skills update --all
clawdbot skills remove <skill-name>
```

---

## Global Options

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

## Upstream Sources

- https://docs.clawd.bot/cli/message
- https://docs.clawd.bot/cli/gateway
- https://docs.clawd.bot/cli/updates
- https://docs.clawd.bot/cli/sandbox
