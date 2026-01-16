---
name: clawdbot-concepts
description: Clawdbot core concepts - architecture, agent runtime, memory, sessions, streaming, and more
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Concepts Expert

Core concepts and architecture of Clawdbot.

**Documentation**: https://docs.clawd.bot/concepts/

---

## Architecture

### Core Components

**Gateway (Daemon)**
- Central hub coordinating all channels
- WebSocket API on `127.0.0.1:18789` (default)
- Maintains provider connections
- Emits events (agent execution, chat, presence, health, cron)

**Control-Plane Clients**
- CLI, macOS app, web dashboards
- Connect via WebSocket
- Send typed requests, receive events

**Nodes (Mobile/Desktop)**
- iOS, Android, macOS nodes
- Use Bridge protocol (TCP JSONL) not WebSocket
- Expose commands: `canvas.*`, `camera.*`, `screen.record`, `location.get`

**WebChat**
- Static UI using Gateway WebSocket API
- Accessible via SSH/Tailscale tunnels

### Wire Protocol

```json
// Request
{"type": "req", "id": "uuid", "method": "agent.run", "params": {...}}

// Response
{"type": "res", "id": "uuid", "ok": true, "payload": {...}}

// Event
{"type": "event", "event": "agent.delta", "payload": {...}}
```

### Connection Flow

1. Client sends `connect` frame (mandatory first message)
2. Gateway responds with presence/health snapshot
3. Server pushes async events
4. Client sends requests, receives responses

---

## Agent Runtime

### Execution Flow

1. **RPC Validation** - Validate params, resolve session
2. **Agent Setup** - Resolve model, load skills snapshot
3. **Runtime Execution** - Run pi-agent-core
4. **Event Streaming** - Tool events, assistant deltas, lifecycle
5. **Completion** - Return results and token usage

### Agent Loop

The agent operates in a loop:

```
User Message → Model → Tool Calls → Tool Results → Model → ... → Final Response
```

### Timeouts

| Setting | Default | Description |
|---------|---------|-------------|
| Agent runtime | 600s | `agents.defaults.timeoutSeconds` |
| `agent.wait` | 30s | Configurable via `timeoutMs` |

---

## System Prompt

### Bootstrap Files

Automatically injected into system prompt:
- `AGENTS.md` - Agent configuration
- `SOUL.md` - Personality/behavior
- `TOOLS.md` - Tool documentation
- `IDENTITY.md` - Identity info
- `USER.md` - User preferences
- `HEARTBEAT.md` - Time-based context
- `BOOTSTRAP.md` - Startup instructions

Located in workspace directory. Max chars: `agents.defaults.bootstrapMaxChars` (default 20,000)

### Time Handling

UTC by default. User timezone via `agents.defaults.userTimezone`

---

## Memory System

### Memory Files

Location: Agent workspace (default `~/clawd`)

**Daily Memory:**
```
memory/YYYY-MM-DD.md
```
- Append-only daily logs
- Read at session start (today + yesterday)

**Long-term Memory:**
```
MEMORY.md
```
- Curated durable facts
- Only loaded in main/private sessions

### Writing Memory

- Permanent preferences → `MEMORY.md`
- Temporary notes → `memory/YYYY-MM-DD.md`
- User requests to remember → Write immediately to disk

### Memory Search

Requires embedding provider (OpenAI default or local):

```json
{
  "agents": {
    "defaults": {
      "memorySearch": {
        "enabled": true,
        "provider": "remote"
      }
    }
  }
}
```

**Memory Tools:**
- `memory_search` - Semantic search
- `memory_get` - Read specific files

---

## Sessions

### Session Keys

Sessions are identified by composite keys:
- Channel + User ID
- `whatsapp:+1234567890`
- `discord:123456789:channel:987654321`
- `telegram:123456:topic:789`

### Session Lifecycle

1. **Creation** - On first message from user
2. **Active** - Ongoing conversation
3. **Idle** - No recent activity
4. **Compaction** - Context compressed
5. **Expiry** - Session data archived

### Session Configuration

```json
{
  "sessions": {
    "idleTimeout": 3600,
    "maxContextTokens": 100000,
    "compactionThreshold": 80000
  }
}
```

---

## Compaction

When context grows too large, compaction summarizes history:

```json
{
  "agents": {
    "defaults": {
      "compaction": {
        "enabled": true,
        "threshold": 80000,
        "targetTokens": 40000
      }
    }
  }
}
```

### Compaction Process

1. Detect context exceeds threshold
2. Generate summary of conversation
3. Replace old messages with summary
4. Continue with reduced context

---

## Workspaces

### Default Workspace

```
~/clawd/
├── MEMORY.md           # Long-term memory
├── AGENTS.md           # Agent config
├── SOUL.md             # Personality
├── memory/             # Daily memory files
│   └── 2024-01-15.md
└── skills/             # Local skills
```

### Workspace Configuration

```json
{
  "agents": {
    "defaults": {
      "workspace": "~/clawd"
    }
  }
}
```

### Per-Session Workspaces

```json
{
  "workspaces": {
    "project-a": {
      "path": "~/projects/a",
      "sessions": ["whatsapp:+1234567890"]
    }
  }
}
```

---

## Multi-Agent

### Agent Routing

Route different queries to different agents:

```json
{
  "agents": {
    "routing": {
      "rules": [
        {
          "match": "code|programming|debug",
          "agent": "coder",
          "model": "claude-3-opus"
        },
        {
          "match": ".*",
          "agent": "default"
        }
      ]
    }
  }
}
```

### Subagents

Spawn subagents for specific tasks:

```javascript
// In skill code
const result = await subagent.run({
  task: "Research this topic",
  model: "claude-3-haiku"
});
```

---

## Streaming

### Stream Modes

| Mode | Description |
|------|-------------|
| `off` | Wait for complete response |
| `partial` | Stream token-by-token |
| `block` | Stream in blocks |

### Configuration

```json
{
  "channels": {
    "telegram": {
      "streamMode": "partial"
    },
    "discord": {
      "streamMode": "block"
    }
  }
}
```

---

## Channel Routing

### Routing Rules

```json
{
  "routing": {
    "rules": [
      {
        "channel": "whatsapp",
        "user": "+1234567890",
        "workspace": "personal"
      },
      {
        "channel": "slack",
        "workspace": "work"
      }
    ]
  }
}
```

---

## Presence

Track user and agent presence:

```json
{
  "presence": {
    "enabled": true,
    "heartbeatInterval": 30000
  }
}
```

### Presence Events

- `presence.online` - User/agent came online
- `presence.offline` - User/agent went offline
- `presence.typing` - User/agent is typing

---

## Queue & Retry

### Message Queue

```json
{
  "queue": {
    "maxSize": 1000,
    "processingTimeout": 60000
  }
}
```

### Retry Logic

```json
{
  "retry": {
    "maxAttempts": 3,
    "backoff": "exponential",
    "initialDelay": 1000,
    "maxDelay": 30000
  }
}
```

---

## Token Usage

Track and limit token usage:

```json
{
  "usage": {
    "tracking": true,
    "limits": {
      "daily": 1000000,
      "perSession": 100000
    }
  }
}
```

---

## OAuth

### OAuth Flow

1. User initiates auth via CLI or app
2. Browser opens to provider's OAuth page
3. User grants access
4. Callback returns with token
5. Token stored in `~/.clawdbot/credentials/oauth.json`

### Refresh Tokens

Tokens auto-refresh before expiry.

---

## TypeBox Schemas

Clawdbot uses TypeBox for runtime type validation:

```typescript
import { Type } from '@sinclair/typebox';

const MessageSchema = Type.Object({
  channel: Type.String(),
  to: Type.String(),
  message: Type.String(),
  media: Type.Optional(Type.String())
});
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/concepts/architecture
- https://docs.clawd.bot/concepts/agent-runtime
- https://docs.clawd.bot/concepts/loops
- https://docs.clawd.bot/concepts/system-prompt
- https://docs.clawd.bot/concepts/tokens
- https://docs.clawd.bot/concepts/oauth
- https://docs.clawd.bot/concepts/workspaces
- https://docs.clawd.bot/concepts/memory
- https://docs.clawd.bot/concepts/multi-agent
- https://docs.clawd.bot/concepts/sessions
- https://docs.clawd.bot/concepts/compaction
- https://docs.clawd.bot/concepts/presence
- https://docs.clawd.bot/concepts/channel-routing
- https://docs.clawd.bot/concepts/messaging
- https://docs.clawd.bot/concepts/streaming
- https://docs.clawd.bot/concepts/groups
- https://docs.clawd.bot/concepts/typing
- https://docs.clawd.bot/concepts/queue
- https://docs.clawd.bot/concepts/retry
- https://docs.clawd.bot/concepts/providers
- https://docs.clawd.bot/concepts/failover
- https://docs.clawd.bot/concepts/usage
- https://docs.clawd.bot/concepts/timezone
- https://docs.clawd.bot/concepts/typebox

Run `./sync.sh` to update from upstream.
