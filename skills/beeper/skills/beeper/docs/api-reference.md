<!-- Source: https://developers.beeper.com/desktop-api-reference/ -->

# Beeper Desktop API Reference

## Libraries

**TypeScript** (4.2.4)
```bash
npm install @beeper/desktop-api
```

**Python** (4.1.296)
```bash
pip install beeper_desktop_api
```

**Go** (0.1.0)
```bash
go get -u 'github.com/beeper/desktop-api-go@v0.0.1'
```

## API Endpoints

### Accounts

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v1/accounts` | List all connected chat accounts |

### Contacts

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v1/accounts/{accountID}/contacts` | Search contacts on a specific account |

### Chats

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v1/chats/{chatID}` | Retrieve specific chat details |
| POST | `/v1/chats` | Create new conversation |
| GET | `/v1/chats` | List all chats |
| GET | `/v1/chats/search` | Search for specific chats |
| POST | `/v1/chats/{chatID}/archive` | Archive or unarchive a chat |

### Chat Reminders

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/v1/chats/{chatID}/reminders` | Create chat reminder |
| DELETE | `/v1/chats/{chatID}/reminders` | Delete chat reminder |

### Messages

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v1/messages/search` | Search message content |
| GET | `/v1/chats/{chatID}/messages` | List messages in a chat |
| POST | `/v1/chats/{chatID}/messages` | Send a new message |

### Assets

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/v1/assets/download` | Download message attachments |

## Example Requests

### List Accounts (curl)

```bash
curl -X GET "http://localhost:23373/v1/accounts" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Search Messages (curl)

```bash
curl -X GET "http://localhost:23373/v1/messages/search?query=hello&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Send Message (curl)

```bash
curl -X POST "http://localhost:23373/v1/chats/{chatID}/messages" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello from the API!"}'
```

### List Chats (TypeScript)

```typescript
import BeeperDesktop from '@beeper/desktop-api';

const client = new BeeperDesktop({
  accessToken: process.env['BEEPER_ACCESS_TOKEN'],
});

const chats = await client.chats.list();
console.log(chats.items);
```

### Send Message (TypeScript)

```typescript
await client.chats.messages.send(chatId, {
  text: "Hello from the API!"
});
```

## Notes

- The v0 API version also exists with comparable operations
- All endpoints require Bearer token authentication
- Base URL: `http://localhost:23373`
- Beeper Desktop must be running for API access
