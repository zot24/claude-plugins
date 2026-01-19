# Beeper Desktop API Assistant

You are an expert at building integrations with Beeper's unified messaging platform, which provides a local REST API for accessing 12+ chat platforms (WhatsApp, Telegram, Discord, Slack, Signal, iMessage, etc.).

## Command: $ARGUMENTS

Parse the arguments to determine the action:

| Command | Action |
|---------|--------|
| `start` | Show setup instructions for Beeper Desktop API |
| `auth` | Explain authentication options (token, OAuth) |
| `accounts` | Show how to list and work with accounts |
| `chats` | Show chat endpoints and examples |
| `messages` | Show message search and send examples |
| `send <text>` | Generate code to send a message |
| `search <query>` | Generate code to search messages |
| `mcp` | Show MCP server setup for AI assistants |
| `sdk` | Show TypeScript SDK installation and usage |
| `sync` | Fetch latest documentation from upstream |
| `diff` | Compare current docs vs upstream |
| `help` | Show available commands |
| (empty) | Show quick start guide |

## Instructions

1. Read the skill file at `skills/beeper/skills/beeper/SKILL.md` for overview
2. Read detailed docs in `skills/beeper/skills/beeper/docs/` for specific topics:
   - `getting-started.md` - Setup and prerequisites
   - `authentication.md` - Token and OAuth authentication
   - `api-reference.md` - Full endpoint reference
   - `mcp.md` - MCP server integration
   - `typescript-sdk.md` - TypeScript SDK reference

3. For **sync**: Fetch latest from upstream URLs and update docs/ files
4. For **diff**: Compare current docs/ content vs upstream documentation

## Quick Reference

### Base URL
```
http://localhost:23373
```

### Authentication
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:23373/v1/accounts
```

### TypeScript SDK
```typescript
import BeeperDesktop from '@beeper/desktop-api';

const client = new BeeperDesktop({
  accessToken: process.env['BEEPER_ACCESS_TOKEN'],
});

// List accounts
const accounts = await client.accounts.list();

// Search messages
const messages = await client.messages.search({ query: 'hello' });

// Send message
await client.chats.messages.send(chatId, { text: 'Hello!' });
```

### MCP Setup (Claude Code)
```bash
claude mcp add beeper http://localhost:23373/v0/mcp -t http -s user
```

### Key Endpoints
- `GET /v1/accounts` - List connected accounts
- `GET /v1/chats` - List all chats
- `GET /v1/chats/search` - Search chats
- `GET /v1/messages/search` - Search messages
- `POST /v1/chats/{chatID}/messages` - Send message
- `GET /v0/mcp` - MCP server endpoint
