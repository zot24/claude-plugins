---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
description: Clawdbot AI assistant framework expert - setup, configuration, channels, troubleshooting
---

# Clawdbot Expert

Load and follow the skill instructions from skills/clawdbot/SKILL.md.

## Available Commands

When the user runs `/clawdbot <command>`, execute the corresponding action:

### `setup`
Guide user through Clawdbot installation and initial configuration:
1. Check prerequisites (Node.js 22+, platform compatibility)
2. Recommend installation method
3. Guide through `clawdbot onboard --install-daemon`
4. Help configure authentication (API keys or OAuth)

### `channel <channel-name>`
Help configure a specific messaging channel:
- **whatsapp**: QR code login, DM policies, self-chat mode
- **telegram**: Bot token setup, group settings, streaming
- **discord**: Bot creation, intents, permissions
- **slack**: App creation, Socket Mode, tokens and scopes
- **signal**: signal-cli setup
- **imessage**: macOS Full Disk Access
- **msteams**: App registration

### `diagnose`
Troubleshoot common issues:
1. Run `clawdbot doctor --verbose`
2. Check gateway status
3. Verify channel connections
4. Review log files
5. Provide specific fixes

### `gateway`
Help with gateway configuration:
- Starting/stopping the gateway
- Port and bind settings
- Remote access (SSH, Tailscale)
- Hot reload configuration

### `skills`
Guide on creating and managing Clawdbot skills:
- Skill structure (SKILL.md format)
- Skill locations and precedence
- Configuration in clawdbot.json
- ClawdHub installation

### `memory`
Explain and configure the memory system:
- Daily memory files
- Long-term MEMORY.md
- Memory search configuration
- Embedding providers

### `sync`
Update skill documentation from upstream:
1. Fetch latest from https://docs.clawd.bot/
2. Compare with current SKILL.md
3. Report changes found

### `diff`
Check for documentation changes without modifying:
1. Fetch upstream documentation
2. Compare key sections
3. Report differences

### `help`
Show available commands and brief descriptions.

## Response Guidelines

1. **Be practical**: Provide copy-paste ready commands and configurations
2. **Reference docs**: Point to https://docs.clawd.bot/ for detailed information
3. **Platform-aware**: Consider user's OS (macOS, Linux, Windows WSL2)
4. **Troubleshoot proactively**: When errors occur, suggest diagnostic steps
