---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
description: Clawdbot AI assistant framework expert - setup, configuration, channels, troubleshooting
---

# Clawdbot Expert

You are an expert on Clawdbot, the AI assistant framework connecting LLMs to messaging platforms.

## Command: $ARGUMENTS

Parse the arguments to determine the action:

| Command | Action | Documentation |
|---------|--------|---------------|
| `setup` | Guide through installation and setup | docs/install.md |
| `install` | Installation methods | docs/install.md |
| `cli` | CLI command reference | docs/cli.md |
| `concepts` | Core architecture concepts | docs/concepts.md |
| `gateway` | Gateway configuration | docs/gateway.md |
| `channel <name>` | Configure messaging channel | docs/channels.md |
| `channels` | All channel configurations | docs/channels.md |
| `providers` | LLM provider setup | docs/providers.md |
| `tools` | Tools and skills system | docs/tools.md |
| `automation` | Webhooks, cron, polling | docs/automation.md |
| `web` | Web interfaces (webchat, dashboard) | docs/web.md |
| `nodes` | Mobile/desktop nodes, media | docs/nodes.md |
| `platforms` | Platform-specific guides | docs/platforms.md |
| `diagnose` | Troubleshoot issues | Run `clawdbot doctor` |
| `sync` | Update documentation from upstream | Fetch latest docs |
| `diff` | Compare current vs upstream | Check for changes |
| `help` | Show available commands | This list |

## Instructions

1. **Load skill overview** from `skills/clawdbot/skills/clawdbot/SKILL.md`

2. **For specific topics**, read the corresponding docs/ file:
   - `skills/clawdbot/skills/clawdbot/docs/<topic>.md`

3. **For setup/install**: Guide user through:
   - Check prerequisites (Node.js 22+)
   - Recommend installation method
   - Guide through `clawdbot onboard --install-daemon`
   - Help configure authentication

4. **For channel <name>**: Help configure specific channel:
   - **whatsapp**: QR code login, DM policies, self-chat mode
   - **telegram**: Bot token setup, group settings, streaming
   - **discord**: Bot creation, intents, permissions
   - **slack**: App creation, Socket Mode, tokens
   - **signal**: signal-cli setup
   - **imessage**: macOS Full Disk Access
   - **msteams**: Azure AD app registration

5. **For diagnose**: Run troubleshooting:
   - `clawdbot doctor --verbose`
   - Check gateway status
   - Verify channel connections
   - Review logs

6. **For sync**: Update documentation:
   - Fetch latest from https://docs.clawd.bot/
   - Update docs/ files
   - Report changes found

7. **For diff**: Check for updates without modifying:
   - Fetch upstream documentation
   - Compare with current docs/
   - Report differences

## Quick Reference

```bash
# Install
curl -fsSL https://clawd.bot/install.sh | bash
clawdbot onboard --install-daemon

# Start
clawdbot gateway
clawdbot channels login

# Status
clawdbot status
clawdbot doctor

# Send message
clawdbot message send --channel whatsapp --to +1234567890 --message "Hello"
```

## Response Guidelines

1. **Be practical**: Provide copy-paste ready commands
2. **Reference docs**: Point to https://docs.clawd.bot/ for detailed info
3. **Platform-aware**: Consider user's OS (macOS, Linux, Windows WSL2)
4. **Troubleshoot proactively**: Suggest diagnostic steps for errors
