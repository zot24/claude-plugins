<!-- Source: https://docs.clawd.bot/channels/ -->

# Clawdbot Channels

Complete guide to configuring messaging channels.

## WhatsApp

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

### Setup

1. Configure in `~/.clawdbot/clawdbot.json`
2. Scan QR: `clawdbot channels login`
3. Start gateway

### DM Policies

| Policy | Description |
|--------|-------------|
| `pairing` | Unknown senders get approval code (default) |
| `allowlist` | Only specified numbers |
| `open` | Anyone (requires `allowFrom: ["*"]`) |

### Self-Chat Mode

```json
{ "channels": { "whatsapp": { "selfChatMode": true } } }
```

### Troubleshooting

- Use Node.js (not Bun)
- Re-scan QR if disconnected
- Delete `~/.clawdbot/whatsapp-session` and re-scan

---

## Telegram

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "123456:ABC-DEF...",
      "dmPolicy": "pairing",
      "streamMode": "partial"
    }
  }
}
```

### Setup

1. Create bot via @BotFather
2. Copy token
3. Configure and start gateway

Stream modes: `off`, `partial`, `block`

---

## Discord

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

### Required Intents

`GUILDS`, `GUILD_MESSAGES`, `MESSAGE_CONTENT`, `DIRECT_MESSAGES`

### Bot Permissions

Permissions integer: `274877910016` (Send Messages, Read History, Add Reactions, Attach Files, Slash Commands)

---

## Slack

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

### Setup

1. Create app at api.slack.com/apps
2. Enable Socket Mode
3. Generate App Token with `connections:write`
4. Add bot token scopes, install to workspace

### Required Scopes

`chat:write`, `im:write`, `channels:history`, `groups:history`, `users:read`, `reactions:read`, `reactions:write`, `files:write`

---

## Signal

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

Requires signal-cli installed and configured.

---

## iMessage

macOS only. Requires Full Disk Access permission.

```json
{
  "channels": { "imessage": { "enabled": true } }
}
```

Grant in System Preferences > Privacy & Security > Full Disk Access.

---

## Microsoft Teams

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

Requires Azure AD app registration and bot channel.

---

## Broadcast Groups

```json
{
  "channels": {
    "broadcast": {
      "groups": {
        "all-social": {
          "channels": ["discord", "slack", "telegram"],
          "targets": {
            "discord": "channel:123",
            "slack": "#announcements",
            "telegram": "@channel"
          }
        }
      }
    }
  }
}
```

```bash
clawdbot message send --broadcast all-social --message "Announcement!"
```

---

## Troubleshooting

**Channel not connecting:**
- Verify credentials/tokens
- `clawdbot doctor`
- `clawdbot logs --channel <name>`

**Messages not received:**
- Check DM policy settings
- Verify pairing approvals

---

## Upstream Sources

- https://docs.clawd.bot/channels/whatsapp
- https://docs.clawd.bot/channels/telegram
- https://docs.clawd.bot/channels/discord
- https://docs.clawd.bot/channels/slack
- https://docs.clawd.bot/channels/signal
- https://docs.clawd.bot/channels/imessage
- https://docs.clawd.bot/channels/msteams
