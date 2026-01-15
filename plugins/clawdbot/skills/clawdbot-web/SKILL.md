---
name: clawdbot-web
description: Clawdbot web interfaces - control panel, dashboard, webchat, TUI
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Web Interfaces Expert

Guide to Clawdbot's web-based interfaces.

**Documentation**: https://docs.clawd.bot/web/

---

## Control Panel

Web-based control panel for managing Clawdbot.

### Starting Control Panel

```bash
# Start with control panel
clawdbot gateway --control

# Custom port
clawdbot gateway --control --control-port 3000
```

### Features

- Channel status monitoring
- Message history
- Agent configuration
- Real-time logs
- User management

### Access

Default: `http://localhost:3000`

### Configuration

```json
{
  "web": {
    "control": {
      "enabled": true,
      "port": 3000,
      "auth": {
        "type": "password",
        "password": "secure-password"
      }
    }
  }
}
```

---

## Dashboard

Analytics and monitoring dashboard.

### Configuration

```json
{
  "web": {
    "dashboard": {
      "enabled": true,
      "port": 3001,
      "metrics": {
        "enabled": true,
        "retention": "7d"
      }
    }
  }
}
```

### Dashboard Panels

- **Messages**: Message volume over time
- **Channels**: Per-channel activity
- **Agents**: Agent execution stats
- **Usage**: Token usage and costs
- **Health**: System health metrics

### Access

Default: `http://localhost:3001`

---

## Webchat

Browser-based chat interface served by the Gateway.

### Default Access

WebChat is served directly by the Gateway on the same port (default 18789):

```
http://localhost:18789/chat
```

**Note**: WebChat runs on the Gateway port, NOT a separate port. Port 18790 is the Bridge (TCP) for mobile nodes, not webchat.

### Starting Webchat

```bash
# Start gateway (webchat included by default)
clawdbot gateway

# Or explicitly enable
clawdbot gateway --webchat

# Custom gateway port (webchat follows)
clawdbot gateway --port 8080
# Access at: http://localhost:8080/chat
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

For Docker deployment, ensure the Gateway binds to `lan`:

```json
{
  "gateway": {
    "bind": "lan",
    "auth": { "mode": "token", "token": "your-token" }
  }
}
```

Then access at `http://your-host:18789/chat`

### Webchat Features

- Real-time messaging
- File uploads
- Markdown rendering
- Code syntax highlighting
- Message history
- Mobile responsive

### Customization

```json
{
  "web": {
    "webchat": {
      "customCss": "~/.clawdbot/webchat.css",
      "branding": {
        "logo": "/path/to/logo.png",
        "primaryColor": "#007bff"
      }
    }
  }
}
```

### Embedding

Embed webchat in your website:

```html
<iframe
  src="http://localhost:8080"
  width="400"
  height="600"
  frameborder="0">
</iframe>
```

Or use the widget:

```html
<script src="http://localhost:8080/widget.js"></script>
<script>
  ClawdbotChat.init({
    position: 'bottom-right',
    theme: 'dark'
  });
</script>
```

---

## Terminal UI (TUI)

Terminal-based user interface.

### Starting TUI

```bash
clawdbot tui
```

### TUI Features

- Split-pane layout
- Channel switching
- Message history
- Real-time updates
- Keyboard shortcuts

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Exit |
| `Ctrl+L` | Clear screen |
| `Tab` | Switch channel |
| `↑/↓` | Navigate history |
| `Ctrl+N` | New conversation |
| `?` | Show help |

### Configuration

```json
{
  "tui": {
    "theme": "dark",
    "showTimestamps": true,
    "messageLimit": 100,
    "layout": "split"
  }
}
```

### TUI Themes

- `dark` - Dark background
- `light` - Light background
- `monokai` - Monokai colors
- `dracula` - Dracula colors

---

## Remote Access

### SSH Tunnel

```bash
# On server
clawdbot gateway --webchat

# On local machine
ssh -L 8080:localhost:8080 user@server

# Access in browser
open http://localhost:8080
```

### Tailscale Serve

```bash
# Serve on Tailscale network
clawdbot gateway --webchat --tailscale serve
```

### Tailscale Funnel

```bash
# Public access (use with auth!)
clawdbot gateway --webchat --tailscale funnel
```

### Authentication for Remote

```json
{
  "web": {
    "webchat": {
      "auth": {
        "enabled": true,
        "type": "basic",
        "users": {
          "admin": "password-hash"
        }
      }
    }
  }
}
```

---

## API Endpoints

All web interfaces expose REST APIs:

### Control API

```bash
# Get status
GET /api/status

# List channels
GET /api/channels

# Send message
POST /api/messages
```

### Dashboard API

```bash
# Get metrics
GET /api/metrics?period=24h

# Get logs
GET /api/logs?level=error&limit=100
```

### Webchat API

```bash
# Send message
POST /api/chat
{
  "message": "Hello",
  "session": "web-session-123"
}

# Get history
GET /api/chat/history?session=web-session-123
```

---

## Security

### HTTPS/TLS

```json
{
  "web": {
    "tls": {
      "enabled": true,
      "cert": "/path/to/cert.pem",
      "key": "/path/to/key.pem"
    }
  }
}
```

### CORS

```json
{
  "web": {
    "cors": {
      "enabled": true,
      "origins": ["https://mysite.com"],
      "methods": ["GET", "POST"]
    }
  }
}
```

### Rate Limiting

```json
{
  "web": {
    "rateLimit": {
      "enabled": true,
      "windowMs": 60000,
      "max": 100
    }
  }
}
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/web/control
- https://docs.clawd.bot/web/dashboard
- https://docs.clawd.bot/web/webchat
- https://docs.clawd.bot/web/tui

Run `./sync.sh` to update from upstream.
