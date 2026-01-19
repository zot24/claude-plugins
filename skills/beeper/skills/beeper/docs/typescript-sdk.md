<!-- Source: https://developers.beeper.com/desktop-api-reference/typescript/ -->

# TypeScript SDK for Beeper Desktop API

## Overview

The Beeper Desktop API TypeScript SDK enables server-side access to Beeper's messaging platform. It provides type-safe bindings for interacting with accounts, chats, messages, and other resources.

**Package:** `@beeper/desktop-api`

## Installation

```bash
npm install @beeper/desktop-api
```

## Basic Usage

```typescript
import BeeperDesktop from '@beeper/desktop-api';

const client = new BeeperDesktop({
  accessToken: process.env['BEEPER_ACCESS_TOKEN'],
});

const page = await client.chats.search({
  includeMuted: true,
  limit: 3,
  type: 'single'
});
const chat = page.items[0];
console.log(chat.id);
```

## Type Definitions

The library includes comprehensive TypeScript definitions for all request parameters and response fields:

```typescript
import BeeperDesktop from '@beeper/desktop-api';

const client = new BeeperDesktop({
  accessToken: process.env['BEEPER_ACCESS_TOKEN'],
});

const accounts: BeeperDesktop.AccountListResponse =
  await client.accounts.list();
```

## Core Resources

### Accounts
- `list()` - Retrieve connected accounts

### Chats
- `retrieve(id)` - Get specific chat details
- `create(params)` - Create new chat
- `list(params)` - List chats
- `search(params)` - Search chats
- `archive(id)` - Archive/unarchive chat
- `reminders.create()` - Set chat reminder
- `reminders.delete()` - Remove chat reminder

### Messages
- `search(params)` - Search messages
- `list(params)` - List messages
- `send(params)` - Send message

### Client
- `focus()` - Focus application window
- `search(query)` - Global search

### Assets
- `download(id)` - Download asset file

### Contacts
- `contacts.search(params)` - Search account contacts

## Error Handling

The library throws `APIError` subclasses for failed requests:

```typescript
const accounts = await client.accounts.list().catch(async (err) => {
  if (err instanceof BeeperDesktop.APIError) {
    console.log(err.status);
    console.log(err.name);
    console.log(err.headers);
  } else {
    throw err;
  }
});
```

**Error mappings:**
- 400 → `BadRequestError`
- 401 → `AuthenticationError`
- 403 → `PermissionDeniedError`
- 404 → `NotFoundError`
- 422 → `UnprocessableEntityError`
- 429 → `RateLimitError`
- ≥500 → `InternalServerError`
- Connection issues → `APIConnectionError`

## Retries & Timeouts

### Automatic Retries

Connection errors, 408, 409, 429, and 5xx errors retry twice by default:

```typescript
const client = new BeeperDesktop({
  maxRetries: 0, // disable retries
});

// Override per-request
await client.accounts.list({ maxRetries: 5 });
```

### Request Timeouts

Default timeout is 30 seconds:

```typescript
const client = new BeeperDesktop({
  timeout: 20 * 1000, // 20 seconds
});

// Override per-request
await client.accounts.list({ timeout: 5 * 1000 });
```

Timeout errors throw `APIConnectionTimeoutError`.

## Auto-Pagination

Iterate through paginated results using async iteration:

```typescript
async function fetchAllMessages(params) {
  const allMessages = [];
  for await (const message of client.messages.search({
    accountIDs: ['local-telegram_ba_...'],
    limit: 10,
    query: 'deployment',
  })) {
    allMessages.push(message);
  }
  return allMessages;
}
```

Manual pagination:

```typescript
let page = await client.messages.search({ limit: 10 });
for (const message of page.items) {
  console.log(message);
}

while (page.hasNextPage()) {
  page = await page.getNextPage();
}
```

## Advanced Configuration

### Accessing Raw Response Data

```typescript
const response = await client.accounts.list().asResponse();
console.log(response.headers.get('X-My-Header'));

const { data: accounts, response: raw } =
  await client.accounts.list().withResponse();
```

### Logging

Configure log levels via environment or client option:

```typescript
const client = new BeeperDesktop({
  logLevel: 'debug', // debug | info | warn | error | off
});
```

Set environment variable: `BEEPER_DESKTOP_LOG=debug`

**Supported loggers:** pino, winston, bunyan, consola, signale, @std/log

```typescript
import pino from 'pino';

const logger = pino();
const client = new BeeperDesktop({
  logger: logger.child({ name: 'BeeperDesktop' }),
  logLevel: 'debug',
});
```

### Custom Fetch Implementation

```typescript
import BeeperDesktop from '@beeper/desktop-api';
import fetch from 'my-fetch';

const client = new BeeperDesktop({ fetch });
```

### Fetch Options & Proxies

**Node.js with undici:**
```typescript
import * as undici from 'undici';

const proxyAgent = new undici.ProxyAgent('http://localhost:8888');
const client = new BeeperDesktop({
  fetchOptions: { dispatcher: proxyAgent },
});
```

**Bun:**
```typescript
const client = new BeeperDesktop({
  fetchOptions: { proxy: 'http://localhost:8888' },
});
```

**Deno:**
```typescript
const httpClient = Deno.createHttpClient({
  proxy: { url: 'http://localhost:8888' }
});
const client = new BeeperDesktop({
  fetchOptions: { client: httpClient },
});
```

## Undocumented Endpoints & Parameters

### Custom Requests

```typescript
await client.post('/some/path', {
  body: { some_prop: 'foo' },
  query: { some_query_arg: 'bar' },
});
```

### Undocumented Parameters

```typescript
client.chats.search({
  // @ts-expect-error
  baz: 'undocumented option',
});
```

### Undocumented Response Properties

```typescript
const response = await client.accounts.list();
const extra = (response as any).undocumentedField;
```

## Requirements

- **TypeScript:** ≥4.9
- **Runtimes:** Node.js 20+ (non-EOL), Deno 1.28.0+, Bun 1.0+, Cloudflare Workers, Vercel Edge, Jest 28+, Nitro 2.6+
- **Browsers:** Requires `dangerouslyAllowBrowser: true` (exposes credentials)

## Semantic Versioning

The package follows SemVer with exceptions for:
- Type-only changes
- Internal implementation changes
- Changes unlikely to affect most users

## Contributing

Contributions welcome. See the [CONTRIBUTING.md](https://github.com/beeper/desktop-api-js/tree/main/./CONTRIBUTING.md) file in the repository.
