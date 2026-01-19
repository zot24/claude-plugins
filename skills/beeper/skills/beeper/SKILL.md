---
name: beeper
description: Expert on Beeper Desktop API for unified messaging across 12+ platforms (WhatsApp, Telegram, Discord, Slack, Signal, iMessage). Use when building messaging integrations, automating chat workflows, or working with Beeper's local REST API. Triggers on mentions of Beeper, desktop-api, unified messaging, chat API, MCP messaging.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Beeper Desktop API

Expert at building integrations with Beeper's unified messaging platform.

## Overview

- Local REST API at `localhost:23373` (requires Beeper Desktop running)
- 13 endpoints for accounts, contacts, chats, messages, reminders, assets
- Built-in MCP server at `/v0/mcp` for AI assistant integration
- SDKs: TypeScript (`@beeper/desktop-api`), Python, Go
- Auth: Bearer token (in-app) or OAuth 2.0 with PKCE

## Quick Start

```typescript
import BeeperDesktop from '@beeper/desktop-api';

const client = new BeeperDesktop({
  accessToken: process.env['BEEPER_ACCESS_TOKEN'],
});

// Search messages across all accounts
const results = await client.messages.search({ query: 'meeting' });

// Send a message
await client.chats.messages.send(chatId, { text: 'Hello!' });
```

## Core Concepts

**Local-only API**: Runs within Beeper Desktop; requires the app to be running. No remote access by default.

**Unified Accounts**: Single API to access WhatsApp, Telegram, Discord, Slack, Signal, iMessage, and more.

**MCP Integration**: Built-in Model Context Protocol server for AI assistants (Claude, Cursor, VS Code).

## API Endpoints

| Resource | Endpoints |
|----------|-----------|
| Accounts | `GET /v1/accounts` |
| Contacts | `GET /v1/accounts/{id}/contacts` |
| Chats | `GET/POST /v1/chats`, `GET /v1/chats/search` |
| Messages | `GET /v1/messages/search`, `POST /v1/chats/{id}/messages` |
| Assets | `POST /v1/assets/download` |
| Reminders | `POST/DELETE /v1/chats/{id}/reminders` |

## Documentation

- **[Getting Started](docs/getting-started.md)** - Prerequisites, setup, limitations
- **[Authentication](docs/authentication.md)** - Token auth and OAuth 2.0
- **[API Reference](docs/api-reference.md)** - All endpoints with examples
- **[MCP Integration](docs/mcp.md)** - Claude, Cursor, VS Code setup
- **[TypeScript SDK](docs/typescript-sdk.md)** - Full SDK reference

## Common Workflows

### Search messages across all accounts
```bash
curl "http://localhost:23373/v1/messages/search?query=hello" \
  -H "Authorization: Bearer $TOKEN"
```

### Set up MCP for Claude Code
```bash
claude mcp add beeper http://localhost:23373/v0/mcp -t http -s user
```

### List connected accounts (TypeScript)
```typescript
const accounts = await client.accounts.list();
accounts.items.forEach(a => console.log(a.service, a.id));
```

## Upstream Sources

- **Developer Docs**: https://developers.beeper.com/desktop-api
- **API Reference**: https://developers.beeper.com/desktop-api-reference/
- **TypeScript SDK**: https://www.npmjs.com/package/@beeper/desktop-api

## Sync & Update

When user runs `sync`: fetch latest from upstream and update docs/ files.
When user runs `diff`: compare current docs/ vs upstream documentation.
