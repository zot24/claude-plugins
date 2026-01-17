<!-- Source: https://docs.clawd.bot/web/ -->

# Clawdbot Web Interfaces

Guide to Clawdbot's web-based interfaces.

## Control Panel

```bash
clawdbot gateway --control
clawdbot gateway --control --control-port 3000
```

Features: Channel status monitoring, message history, agent configuration, real-time logs, user management.

```json
{
  "web": {
    "control": {
      "enabled": true,
      "port": 3000,
      "auth": { "type": "password", "password": "secure-password" }
    }
  }
}
```

---

## Dashboard

Analytics and monitoring at `http://localhost:3001`

```json
{
  "web": {
    "dashboard": {
      "enabled": true,
      "port": 3001,
      "metrics": { "enabled": true, "retention": "7d" }
    }
  }
}
```

Panels: Messages, Channels, Agents, Usage, Health

---

## Webchat

Browser-based chat interface served by the Gateway.

**Access**: `http://localhost:18789/chat`

**Note**: WebChat runs on the Gateway port, NOT a separate port. Port 18790 is the Bridge for mobile nodes.

```bash
clawdbot gateway              # webchat included by default
clawdbot gateway --port 8080  # access at http://localhost:8080/chat
```

### Configuration

```json
{
  "web": {
    "webchat": {
      "enabled": true,
      "title": "My Assistant",
      "theme": "dark",
      "welcomeMessage": "Hello! How can I help?"
    }
  }
}
```

### Docker Access

For Docker, use `bind: "lan"` with authentication:

```json
{
  "gateway": {
    "bind": "lan",
    "auth": { "mode": "token", "token": "your-token" }
  }
}
```

### Embedding

```html
<iframe src="http://localhost:18789/chat" width="400" height="600"></iframe>
```

Or widget:

```html
<script src="http://localhost:18789/widget.js"></script>
<script>ClawdbotChat.init({ position: 'bottom-right', theme: 'dark' });</script>
```

---

## Terminal UI (TUI)

```bash
clawdbot tui
```

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Exit |
| `Ctrl+L` | Clear screen |
| `Tab` | Switch channel |
| `↑/↓` | Navigate history |
| `?` | Show help |

---

## Remote Access

### SSH Tunnel

```bash
ssh -L 8080:localhost:8080 user@server
```

### Tailscale

```bash
clawdbot gateway --webchat --tailscale serve
clawdbot gateway --webchat --tailscale funnel  # Public (use with auth!)
```

---

## Security

### HTTPS/TLS

```json
{
  "web": {
    "tls": { "enabled": true, "cert": "/path/to/cert.pem", "key": "/path/to/key.pem" }
  }
}
```

### CORS

```json
{
  "web": {
    "cors": { "enabled": true, "origins": ["https://mysite.com"] }
  }
}
```

### Rate Limiting

```json
{
  "web": {
    "rateLimit": { "enabled": true, "windowMs": 60000, "max": 100 }
  }
}
```

---

## Upstream Sources

- https://docs.clawd.bot/web/control
- https://docs.clawd.bot/web/dashboard
- https://docs.clawd.bot/web/webchat
- https://docs.clawd.bot/web/tui
