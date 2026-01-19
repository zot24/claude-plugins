# Beeper Desktop API Skill

Expert assistance for building integrations with Beeper's unified messaging platform.

## Overview

The Beeper Desktop API provides a local REST API for accessing 12+ chat platforms through a single interface:

- **Platforms**: WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Instagram, Google Messages, and more
- **Local API**: Runs at `localhost:23373` (requires Beeper Desktop)
- **MCP Server**: Built-in support for AI assistants (Claude, Cursor, VS Code)
- **SDKs**: TypeScript, Python, Go

## Commands

| Command | Description |
|---------|-------------|
| `/beeper` | Quick start guide |
| `/beeper start` | Setup instructions |
| `/beeper auth` | Authentication options |
| `/beeper accounts` | Working with accounts |
| `/beeper chats` | Chat endpoints |
| `/beeper messages` | Message search and send |
| `/beeper send <text>` | Generate send message code |
| `/beeper search <query>` | Generate search code |
| `/beeper mcp` | MCP server setup |
| `/beeper sdk` | TypeScript SDK reference |
| `/beeper sync` | Update documentation |
| `/beeper help` | Show all commands |

## Quick Start

### 1. Enable the API

In Beeper Desktop: **Settings → Developers → Enable Beeper Desktop API**

### 2. Create an access token

In **Settings → Developers → Approved connections**, click "+" to create a token.

### 3. Make your first request

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:23373/v1/accounts
```

### 4. Or use the TypeScript SDK

```bash
npm install @beeper/desktop-api
```

```typescript
import BeeperDesktop from '@beeper/desktop-api';

const client = new BeeperDesktop({
  accessToken: process.env['BEEPER_ACCESS_TOKEN'],
});

const accounts = await client.accounts.list();
console.log(accounts.items);
```

## MCP Integration

Connect AI assistants to Beeper for messaging capabilities:

```bash
# Claude Code
claude mcp add beeper http://localhost:23373/v0/mcp -t http -s user
```

See [MCP documentation](skills/beeper/docs/mcp.md) for Cursor, VS Code, and other clients.

## Documentation

- [Getting Started](skills/beeper/docs/getting-started.md) - Prerequisites and setup
- [Authentication](skills/beeper/docs/authentication.md) - Token and OAuth 2.0
- [API Reference](skills/beeper/docs/api-reference.md) - All endpoints
- [MCP Integration](skills/beeper/docs/mcp.md) - AI assistant setup
- [TypeScript SDK](skills/beeper/docs/typescript-sdk.md) - Full SDK reference

## Upstream Sources

- **Developer Docs**: https://developers.beeper.com/desktop-api
- **API Reference**: https://developers.beeper.com/desktop-api-reference/
- **TypeScript SDK**: https://www.npmjs.com/package/@beeper/desktop-api

## Limitations

- **Local-only**: Requires Beeper Desktop to be running
- **Message history**: Limited to indexed messages (recent by default)
- **iMessage**: macOS only
- **Personal use**: High message volume may trigger network suspensions
