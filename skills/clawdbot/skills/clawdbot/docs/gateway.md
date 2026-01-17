<!-- Source: https://docs.clawd.bot/gateway/ -->

# Clawdbot Gateway

Complete guide to the Clawdbot gateway daemon.

## Overview

The gateway is the central hub that coordinates all messaging channels, manages agent execution, handles WebSocket connections, and provides health monitoring.

## Starting the Gateway

```bash
clawdbot gateway                              # Basic start
clawdbot gateway --port 18789 --bind loopback # With options
clawdbot gateway --dev --allow-unconfigured   # Development mode
clawdbot gateway --force                      # Force restart
```

---

## Protocol

### Wire Format

```json
{"type": "req", "id": "uuid", "method": "agent.run", "params": {...}}
{"type": "res", "id": "uuid", "ok": true, "payload": {...}}
{"type": "event", "event": "agent.delta", "payload": {...}}
```

### Connection Handshake

1. Client connects to `ws://127.0.0.1:18789`
2. Client sends `connect` frame with `clientId` and `clientType`
3. Gateway responds with channels and health snapshot

---

## Bridge Protocol

For mobile nodes (iOS/Android) via TCP with JSONL format:

```json
{"type":"bridge.hello","nodeId":"iphone-xyz","capabilities":["camera","location"]}
```

Commands: `canvas.*`, `camera.*`, `screen.record`, `location.get`

---

## Configuration

```json
{
  "gateway": {
    "mode": "local",
    "bind": "loopback",
    "port": 18789,
    "maxConnections": 100
  }
}
```

### Bind Options

| Value | Address | Auth Required |
|-------|---------|---------------|
| `loopback` | `127.0.0.1` | No |
| `lan` | `0.0.0.0` | **Yes** |
| `tailnet` | Tailscale IP | **Yes** |

**Docker**: Use `bind: "lan"` with authentication.

---

## Port Reference

| Port | Protocol | Service |
|------|----------|---------|
| 18789 | HTTP + WebSocket | Gateway + WebChat at `/chat` |
| 18790 | TCP (JSONL) | Bridge (mobile nodes) |
| 18793 | HTTP | Canvas file serving |

---

## Authentication

```json
{
  "gateway": {
    "auth": {
      "type": "apiKey",
      "keys": ["key1", "key2"]
    }
  }
}
```

Or token auth via `CLAWDBOT_GATEWAY_TOKEN` env var.

---

## Pairing

```bash
clawdbot pairing list
clawdbot pairing approve whatsapp ABC123
clawdbot pairing deny whatsapp ABC123
```

```json
{
  "pairing": { "enabled": true, "codeExpiry": 300, "maxPending": 10 }
}
```

---

## Health & Doctor

```bash
clawdbot gateway health
clawdbot doctor --verbose
clawdbot doctor --fix
```

---

## Logging

```json
{
  "logging": {
    "level": "info",
    "format": "json",
    "file": "/tmp/clawdbot/clawdbot.log"
  }
}
```

```bash
clawdbot logs -f --level error --channel whatsapp
```

---

## Security

```json
{
  "gateway": {
    "sandbox": {
      "enabled": true,
      "allowNetwork": false,
      "allowFileSystem": "workspace"
    }
  }
}
```

---

## Remote Access

### SSH Tunnel

```bash
ssh -L 18789:localhost:18789 user@server
```

### Tailscale

```bash
clawdbot gateway --tailscale serve
clawdbot gateway --tailscale funnel  # Public (use with auth!)
```

### mDNS/Bonjour

```bash
clawdbot gateway --mdns
clawdbot gateway discover
```

---

## OpenAI-Compatible API

```json
{
  "gateway": {
    "openaiApi": { "enabled": true, "port": 8080 }
  }
}
```

---

## Troubleshooting

**Port in use:**
```bash
lsof -i :18789
clawdbot gateway --force
```

**Channel disconnections:**
```bash
clawdbot channels status
clawdbot channels login
```

---

## Upstream Sources

- https://docs.clawd.bot/gateway/protocol
- https://docs.clawd.bot/gateway/config
- https://docs.clawd.bot/gateway/auth
- https://docs.clawd.bot/gateway/health
- https://docs.clawd.bot/gateway/troubleshooting
