---
name: clawdbot-gateway
description: Clawdbot gateway - protocol, configuration, authentication, health, security, troubleshooting
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Gateway Expert

Complete guide to the Clawdbot gateway daemon.

**Documentation**: https://docs.clawd.bot/gateway/

---

## Gateway Overview

The gateway is the central hub that:
- Coordinates all messaging channels
- Manages agent execution
- Handles WebSocket connections
- Provides health monitoring

---

## Starting the Gateway

```bash
# Basic start
clawdbot gateway

# With options
clawdbot gateway --port 18789 --bind loopback --verbose

# Development mode
clawdbot gateway --dev --allow-unconfigured

# Force restart (kill existing)
clawdbot gateway --force
```

---

## Protocol

### Wire Format

All communication uses JSON over WebSocket.

**Request:**
```json
{
  "type": "req",
  "id": "uuid-string",
  "method": "agent.run",
  "params": {
    "message": "Hello",
    "session": "whatsapp:+1234567890"
  }
}
```

**Response:**
```json
{
  "type": "res",
  "id": "uuid-string",
  "ok": true,
  "payload": {
    "result": "..."
  }
}
```

**Event:**
```json
{
  "type": "event",
  "event": "agent.delta",
  "payload": {
    "text": "Hello! How can I help?"
  }
}
```

### Connection Handshake

1. Client connects to `ws://127.0.0.1:18789`
2. Client sends `connect` frame:
```json
{
  "type": "req",
  "id": "1",
  "method": "connect",
  "params": {
    "clientId": "cli-abc123",
    "clientType": "cli"
  }
}
```
3. Gateway responds with snapshot:
```json
{
  "type": "res",
  "id": "1",
  "ok": true,
  "payload": {
    "channels": {...},
    "health": {...}
  }
}
```

---

## Bridge Protocol

For mobile nodes (iOS/Android), use Bridge protocol over TCP:

**Format:** Newline-delimited JSON (JSONL)

```json
{"type":"bridge.hello","nodeId":"iphone-xyz"}
{"type":"bridge.capability","commands":["camera.capture","location.get"]}
```

### Bridge Commands

- `canvas.*` - Drawing/annotation
- `camera.*` - Photo/video capture
- `screen.record` - Screen recording
- `location.get` - GPS location

---

## Configuration

### Main Config File

Location: `~/.clawdbot/clawdbot.json`

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

### Gateway Modes

| Mode | Description |
|------|-------------|
| `local` | Only local connections (default) |
| `lan` | Allow LAN connections |
| `public` | Allow all connections (use with auth) |

### Bind Options

| Value | Address | Auth Required |
|-------|---------|---------------|
| `loopback` | `127.0.0.1` | No |
| `lan` | `0.0.0.0` (all interfaces) | **Yes** |
| `tailnet` | Tailscale IP | **Yes** |
| `auto` | Auto-detect | **Yes** |
| IP address | Specific IP | Depends |

**Important for Docker**: Use `bind: "lan"` to expose the gateway outside the container. This requires authentication via `gateway.auth.token` or `CLAWDBOT_GATEWAY_TOKEN` env var.

---

## Port Reference

| Port | Protocol | Service | Description |
|------|----------|---------|-------------|
| 18789 | HTTP + WebSocket | Gateway | Main gateway, serves WebChat at `/chat` |
| 18790 | TCP (JSONL) | Bridge | Mobile node connections - **NOT HTTP** |
| 18793 | HTTP | Canvas | File serving for WebViews |

**Common mistake**: Port 18790 is NOT webchat. WebChat UI is at `http://host:18789/chat`.

---

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `GATEWAY_PORT` | Gateway port | `18789` |
| `GATEWAY_BIND` | Bind address | `loopback` |
| `GATEWAY_MODE` | Operation mode | `local` |
| `LOG_LEVEL` | Log verbosity | `info` |
| `DEBUG` | Enable debug mode | `false` |

---

## Authentication

### API Key Authentication

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

Client includes key in connect:
```json
{
  "method": "connect",
  "params": {
    "apiKey": "key1"
  }
}
```

### Token Authentication

```json
{
  "gateway": {
    "auth": {
      "type": "token",
      "secret": "jwt-secret"
    }
  }
}
```

---

## Pairing

### Pairing Flow

1. Unknown user sends message
2. Gateway generates 6-digit code
3. User receives code in chat
4. Admin approves: `clawdbot pairing approve <channel> <code>`
5. User is added to allowlist

### Pairing Configuration

```json
{
  "pairing": {
    "enabled": true,
    "codeExpiry": 300,
    "maxPending": 10
  }
}
```

### Pairing Commands

```bash
# List pending
clawdbot pairing list

# Approve
clawdbot pairing approve whatsapp ABC123

# Deny
clawdbot pairing deny whatsapp ABC123

# Clear expired
clawdbot pairing clear --expired
```

---

## Gateway Locking

Prevent multiple gateway instances:

```json
{
  "gateway": {
    "locking": {
      "enabled": true,
      "lockFile": "/tmp/clawdbot.lock"
    }
  }
}
```

---

## Health Monitoring

### Health Check

```bash
clawdbot gateway health
```

Response:
```json
{
  "status": "healthy",
  "uptime": 3600,
  "channels": {
    "whatsapp": "connected",
    "telegram": "connected"
  },
  "memory": {
    "used": "128MB",
    "total": "512MB"
  }
}
```

### Heartbeat

```json
{
  "gateway": {
    "heartbeat": {
      "interval": 30000,
      "timeout": 5000
    }
  }
}
```

---

## Doctor

Diagnose gateway issues:

```bash
# Basic check
clawdbot doctor

# Verbose
clawdbot doctor --verbose

# Auto-fix
clawdbot doctor --fix
```

### Doctor Checks

- Port availability
- Config validity
- Channel connectivity
- API key validity
- Disk space
- Memory usage

---

## Logging

### Log Levels

| Level | Description |
|-------|-------------|
| `error` | Errors only |
| `warn` | Warnings and errors |
| `info` | General info (default) |
| `debug` | Detailed debug |
| `trace` | Everything |

### Log Configuration

```json
{
  "logging": {
    "level": "info",
    "format": "json",
    "file": "/tmp/clawdbot/clawdbot.log",
    "maxSize": "100MB",
    "maxFiles": 5
  }
}
```

### Log Locations

- Main: `/tmp/clawdbot/clawdbot-YYYY-MM-DD.log`
- Subsystems: `whatsapp/inbound`, `telegram/handler`, etc.

### View Logs

```bash
# Recent logs
clawdbot logs

# Follow
clawdbot logs -f

# Filter
clawdbot logs --level error --channel whatsapp

# System logs
tail -f /tmp/clawdbot/clawdbot-$(date +%Y-%m-%d).log
```

---

## Security

### Sandbox Mode

Run agents in sandboxed environment:

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

### Security Best Practices

1. Use `loopback` bind for local-only access
2. Enable authentication for remote access
3. Use TLS/HTTPS for production
4. Rotate API keys regularly
5. Monitor logs for suspicious activity

---

## Background Processes

### Daemon Mode

```bash
# Start as daemon
clawdbot gateway --daemon

# With systemd
sudo systemctl start clawdbot
```

### Process Management

```bash
# Check if running
clawdbot gateway status

# Stop
clawdbot gateway stop

# Restart
clawdbot gateway restart
```

---

## Troubleshooting

### Common Issues

**Port in use:**
```bash
lsof -i :18789
kill <pid>
# Or use --force
clawdbot gateway --force
```

**Config errors:**
```bash
clawdbot doctor --verbose
```

**Channel disconnections:**
```bash
clawdbot channels status
clawdbot channels login  # Re-authenticate
```

### Debugging

```bash
# Enable debug mode
DEBUG=* clawdbot gateway

# Or in config
{
  "logging": { "level": "debug" }
}
```

---

## Remote Access

### SSH Tunneling

```bash
# On remote server
clawdbot gateway --bind lan

# On local machine
ssh -L 18789:localhost:18789 user@server

# Connect CLI to remote
clawdbot gateway status
```

### Tailscale

```bash
# Serve on Tailscale network
clawdbot gateway --tailscale serve

# Expose publicly (use with auth!)
clawdbot gateway --tailscale funnel
```

---

## Discovery

### mDNS/Bonjour

```bash
# Enable discovery
clawdbot gateway --mdns

# Find gateways
clawdbot gateway discover
```

### Discovery Configuration

```json
{
  "gateway": {
    "discovery": {
      "enabled": true,
      "serviceName": "clawdbot-gateway"
    }
  }
}
```

---

## OpenAI-Compatible API

Expose OpenAI-compatible HTTP API:

```json
{
  "gateway": {
    "openaiApi": {
      "enabled": true,
      "port": 8080
    }
  }
}
```

Use with any OpenAI-compatible client:
```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "claude-3-opus", "messages": [{"role": "user", "content": "Hello"}]}'
```

---

## Hot Reload

Config changes auto-reload. Force reload:
```bash
# Send SIGUSR1
kill -USR1 $(pgrep -f "clawdbot gateway")
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/gateway/protocol
- https://docs.clawd.bot/gateway/bridge
- https://docs.clawd.bot/gateway/pairing
- https://docs.clawd.bot/gateway/locking
- https://docs.clawd.bot/gateway/env
- https://docs.clawd.bot/gateway/config
- https://docs.clawd.bot/gateway/auth
- https://docs.clawd.bot/gateway/openai-api
- https://docs.clawd.bot/gateway/background
- https://docs.clawd.bot/gateway/health
- https://docs.clawd.bot/gateway/heartbeat
- https://docs.clawd.bot/gateway/doctor
- https://docs.clawd.bot/gateway/logging
- https://docs.clawd.bot/gateway/security
- https://docs.clawd.bot/gateway/sandbox
- https://docs.clawd.bot/gateway/troubleshooting
- https://docs.clawd.bot/gateway/debugging
- https://docs.clawd.bot/gateway/remote
- https://docs.clawd.bot/gateway/discovery
- https://docs.clawd.bot/gateway/bonjour
- https://docs.clawd.bot/gateway/tailscale

Run `./sync.sh` to update from upstream.
