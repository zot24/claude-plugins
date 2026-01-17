<!-- Source: https://docs.clawd.bot/concepts/ -->

# Clawdbot Core Concepts

Core concepts and architecture of Clawdbot.

## Architecture

### Core Components

- **Gateway (Daemon)**: Central hub on `ws://127.0.0.1:18789`, coordinates channels, manages providers
- **Control-Plane Clients**: CLI, macOS app, web dashboards connect via WebSocket
- **Nodes**: iOS, Android, macOS use Bridge protocol (TCP JSONL)
- **WebChat**: Static UI using Gateway WebSocket API

### Wire Protocol

```json
{"type": "req", "id": "uuid", "method": "agent.run", "params": {...}}
{"type": "res", "id": "uuid", "ok": true, "payload": {...}}
{"type": "event", "event": "agent.delta", "payload": {...}}
```

---

## Agent Runtime

### Execution Flow

1. RPC Validation -> 2. Agent Setup -> 3. Runtime Execution -> 4. Event Streaming -> 5. Completion

### Agent Loop

```
User Message -> Model -> Tool Calls -> Tool Results -> Model -> ... -> Final Response
```

### Timeouts

- Agent runtime: 600s (`agents.defaults.timeoutSeconds`)
- `agent.wait`: 30s (configurable via `timeoutMs`)

---

## System Prompt

Bootstrap files auto-injected: `AGENTS.md`, `SOUL.md`, `TOOLS.md`, `IDENTITY.md`, `USER.md`, `HEARTBEAT.md`, `BOOTSTRAP.md`

Max chars: `agents.defaults.bootstrapMaxChars` (default 20,000)

---

## Memory System

### Memory Files

- **Daily**: `memory/YYYY-MM-DD.md` - Append-only logs
- **Long-term**: `MEMORY.md` - Curated durable facts

### Memory Search

```json
{
  "agents": {
    "defaults": {
      "memorySearch": { "enabled": true, "provider": "remote" }
    }
  }
}
```

---

## Sessions

### Session Keys

- `whatsapp:+1234567890`
- `discord:123456789:channel:987654321`
- `telegram:123456:topic:789`

### Session Lifecycle

Creation -> Active -> Idle -> Compaction -> Expiry

### Configuration

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

```json
{
  "agents": {
    "defaults": {
      "compaction": { "enabled": true, "threshold": 80000, "targetTokens": 40000 }
    }
  }
}
```

---

## Workspaces

```
~/clawd/
├── MEMORY.md
├── AGENTS.md
├── SOUL.md
├── memory/
└── skills/
```

---

## Multi-Agent

```json
{
  "agents": {
    "routing": {
      "rules": [
        { "match": "code|programming", "agent": "coder", "model": "claude-3-opus" },
        { "match": ".*", "agent": "default" }
      ]
    }
  }
}
```

---

## Streaming

| Mode | Description |
|------|-------------|
| `off` | Wait for complete response |
| `partial` | Stream token-by-token |
| `block` | Stream in blocks |

---

## Presence & Queue

```json
{
  "presence": { "enabled": true, "heartbeatInterval": 30000 },
  "queue": { "maxSize": 1000, "processingTimeout": 60000 },
  "retry": { "maxAttempts": 3, "backoff": "exponential" }
}
```

---

## Token Usage

```json
{
  "usage": {
    "tracking": true,
    "limits": { "daily": 1000000, "perSession": 100000 }
  }
}
```

---

## Upstream Sources

- https://docs.clawd.bot/concepts/architecture
- https://docs.clawd.bot/concepts/agent-runtime
- https://docs.clawd.bot/concepts/memory
- https://docs.clawd.bot/concepts/sessions
- https://docs.clawd.bot/concepts/streaming
