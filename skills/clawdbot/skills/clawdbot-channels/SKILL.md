---
name: clawdbot-channels
description: Clawdbot messaging channels - WhatsApp, Telegram, Discord, Slack, Signal, iMessage, MS Teams
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Channels Expert

Complete guide to configuring messaging channels in Clawdbot.

**Documentation**: https://docs.clawd.bot/channels/

---

## WhatsApp

### Setup

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

### DM Policies

| Policy | Description |
|--------|-------------|
| `pairing` | Unknown senders get approval code (default) |
| `allowlist` | Only specified numbers |
| `open` | Anyone (requires `allowFrom: ["*"]`) |

### Self-Chat Mode

For using your personal WhatsApp number:

```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "selfChatMode": true
    }
  }
}
```

### Group Configuration

```json
{
  "channels": {
    "whatsapp": {
      "groups": {
        "group-jid@g.us": {
          "enabled": true,
          "mentionOnly": true
        }
      }
    }
  }
}
```

### Troubleshooting WhatsApp

- **Not linked**: `clawdbot channels login`
- **Disconnected**: `clawdbot doctor`
- **Use Node.js, not Bun** (Bun unreliable for WhatsApp)
- **Session expired**: Delete `~/.clawdbot/whatsapp-session` and re-scan

---

## Telegram

### Setup

1. Create bot via @BotFather
2. Copy token
3. Configure

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "123456:ABC-DEF...",
      "dmPolicy": "pairing"
    }
  }
}
```

### Group Settings

- Default: Only responds to mentions
- Disable Privacy Mode in BotFather for non-mention responses
- Configure per-group: `channels.telegram.groups.<id>`

```json
{
  "channels": {
    "telegram": {
      "groups": {
        "-1001234567890": {
          "enabled": true,
          "mentionOnly": false
        }
      }
    }
  }
}
```

### Forum Topics

Each topic gets isolated session:
- Session key: `...:topic:<threadId>`

### Streaming

```json
{
  "channels": {
    "telegram": {
      "streamMode": "partial"
    }
  }
}
```

Stream modes: `off`, `partial`, `block`

### grammY Integration

Clawdbot uses grammY for Telegram. Custom middleware:

```javascript
// In workspace skills
module.exports = {
  telegram: {
    middleware: (ctx, next) => {
      // Custom logic
      return next();
    }
  }
};
```

---

## Discord

### Setup

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

### Required Intents

- `GUILDS`
- `GUILD_MESSAGES`
- `MESSAGE_CONTENT`
- `DIRECT_MESSAGES`

### Bot Permissions

Required permissions integer: `274877910016`
- Send Messages
- Read Message History
- Add Reactions
- Attach Files
- Use Slash Commands

### Features

- Slash commands
- Thread management
- Reactions
- File attachments
- Voice (with additional setup)

### Server Configuration

```json
{
  "channels": {
    "discord": {
      "servers": {
        "server-id": {
          "enabled": true,
          "channels": ["channel-id-1", "channel-id-2"]
        }
      }
    }
  }
}
```

---

## Slack

### Setup

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

### Required Scopes

Bot Token Scopes:
- `chat:write`
- `im:write`
- `channels:history`
- `groups:history`
- `users:read`
- `reactions:read`
- `reactions:write`
- `files:write`

### Threading

```json
{
  "channels": {
    "slack": {
      "replyToMode": "all"
    }
  }
}
```

Reply modes: `off`, `first`, `all`

### Event Subscriptions

Required events:
- `message.channels`
- `message.groups`
- `message.im`
- `app_mention`

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

### Requirements

- signal-cli installed and configured
- Phone number registered with Signal

### Setup signal-cli

```bash
# Install
brew install signal-cli  # macOS

# Register
signal-cli -u +1234567890 register

# Verify
signal-cli -u +1234567890 verify <code>
```

---

## iMessage

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

### Requirements

- macOS only
- Full Disk Access in System Preferences > Privacy
- Messages app configured with Apple ID

### Granting Access

1. System Preferences > Privacy & Security > Full Disk Access
2. Add Terminal or your terminal app
3. Restart terminal

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

### Azure Setup

1. Register app in Azure AD
2. Create bot channel registration
3. Configure messaging endpoint
4. Get App ID and Password

### Permissions

- `Team.ReadBasic.All`
- `Channel.ReadBasic.All`
- `ChannelMessage.Send`

---

## Broadcast Groups

Send to multiple channels simultaneously:

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

Usage:
```bash
clawdbot message send --broadcast all-social --message "Announcement!"
```

---

## Channel Troubleshooting

### General Issues

**Channel not connecting:**
- Verify credentials/tokens
- Check `clawdbot doctor`
- Review logs: `clawdbot logs --channel <name>`

**Messages not received:**
- Check DM policy settings
- Verify pairing approvals
- Check allowlist configuration

### Per-Channel Issues

**WhatsApp:**
- Re-scan QR if disconnected
- Use Node.js (not Bun)
- Check `~/.clawdbot/whatsapp-session`

**Telegram:**
- Verify bot token with @BotFather
- Check Privacy Mode settings
- Ensure bot added to group as admin

**Discord:**
- Verify intents enabled in Developer Portal
- Check bot permissions in server
- Ensure MESSAGE_CONTENT intent enabled

**Slack:**
- Verify both app and bot tokens
- Check Socket Mode enabled
- Review event subscriptions

---

## Location Features

Some channels support location sharing:

```json
{
  "channels": {
    "whatsapp": {
      "location": {
        "enabled": true,
        "shareOnRequest": true
      }
    }
  }
}
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/channels/whatsapp
- https://docs.clawd.bot/channels/telegram
- https://docs.clawd.bot/channels/grammy
- https://docs.clawd.bot/channels/discord
- https://docs.clawd.bot/channels/slack
- https://docs.clawd.bot/channels/signal
- https://docs.clawd.bot/channels/imessage
- https://docs.clawd.bot/channels/msteams
- https://docs.clawd.bot/channels/broadcast
- https://docs.clawd.bot/channels/troubleshooting
- https://docs.clawd.bot/channels/location

Run `./sync.sh` to update from upstream.
