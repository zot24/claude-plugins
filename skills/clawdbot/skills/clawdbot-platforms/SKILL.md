---
name: clawdbot-platforms
description: Clawdbot platforms - macOS, iOS, Android, Windows WSL2, Linux, VPS hosting
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Platforms Expert

Platform-specific installation and configuration.

**Documentation**: https://docs.clawd.bot/platforms/

---

## macOS

Full support including native app.

### Installation

```bash
# Via installer script
curl -fsSL https://clawd.bot/install.sh | bash

# Via Homebrew
brew install clawdbot

# Via npm
npm install -g clawdbot
```

### Features

- Native macOS app
- CLI tools
- iMessage integration
- Camera/screen capture
- System notifications
- Menu bar integration

### macOS App

Download from https://clawd.bot/download/macos

Features:
- Menu bar quick access
- Native notifications
- Share extension
- Keyboard shortcuts

### Permissions Required

| Permission | Purpose |
|------------|---------|
| Full Disk Access | iMessage integration |
| Camera | Photo capture |
| Microphone | Voice input |
| Screen Recording | Screen capture |
| Accessibility | Keyboard shortcuts |

Grant in: System Preferences > Privacy & Security

### Launch at Login

```bash
# Enable
clawdbot config set daemon.launchAtLogin true

# Or via app preferences
```

---

## iOS

iPhone and iPad app.

### Installation

Download from App Store: "Clawdbot"

### Features

- Chat interface
- Photo/video capture
- Location sharing
- Voice input
- Push notifications
- Shortcuts integration

### iOS Configuration

The app connects to your gateway. Configure in app settings:

1. Gateway URL: `ws://your-gateway:18789` or Tailscale hostname
2. Authentication: API key or pairing

### Shortcuts Integration

Clawdbot exposes Shortcuts actions:
- Send Message
- Ask Question
- Get Status

### Background Refresh

Enable in iOS Settings > Clawdbot > Background App Refresh

---

## Android

Android phone and tablet app.

### Installation

Download from Google Play: "Clawdbot"

Or install APK from: https://clawd.bot/download/android

### Features

- Chat interface
- Camera integration
- Location services
- Voice commands
- Push notifications
- Tasker integration

### Android Configuration

Similar to iOS - configure gateway connection in app settings.

### Tasker Integration

Clawdbot exposes Tasker events and actions:

**Events:**
- Message Received
- Agent Completed

**Actions:**
- Send Message
- Run Agent

### Permissions

| Permission | Purpose |
|------------|---------|
| Camera | Photo capture |
| Microphone | Voice input |
| Location | Location sharing |
| Notifications | Push notifications |
| Storage | File attachments |

---

## Windows (WSL2)

Clawdbot runs on Windows via WSL2.

### Prerequisites

1. Windows 10/11 with WSL2 enabled
2. Ubuntu or Debian distribution

### Installation

```bash
# In WSL2 terminal
curl -fsSL https://clawd.bot/install.sh | bash
```

### WSL2 Setup

```powershell
# Enable WSL2 (PowerShell as admin)
wsl --install

# Install Ubuntu
wsl --install -d Ubuntu

# Launch and setup
wsl
```

### Network Configuration

WSL2 has its own network. To access gateway from Windows:

```bash
# Get WSL2 IP
ip addr show eth0 | grep inet

# Or use localhost forwarding (WSL2 default)
```

### Starting on Windows Boot

Create scheduled task or use Windows Service wrapper.

### Limitations

- No native Windows GUI
- iMessage not available
- Some Node.js native modules may need compilation

---

## Linux

Full CLI and gateway support.

### Installation

```bash
# Via installer script
curl -fsSL https://clawd.bot/install.sh | bash

# Via npm
npm install -g clawdbot

# Via package manager (if available)
# apt install clawdbot
```

### Systemd Service

```ini
# /etc/systemd/system/clawdbot.service
[Unit]
Description=Clawdbot Gateway
After=network.target

[Service]
Type=simple
User=clawdbot
WorkingDirectory=/home/clawdbot
ExecStart=/usr/bin/clawdbot gateway
Restart=always
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl enable clawdbot
sudo systemctl start clawdbot
```

### Docker on Linux

```bash
docker run -d \
  --name clawdbot \
  --restart unless-stopped \
  -p 18789:18789 \
  -v ~/.clawdbot:/root/.clawdbot \
  ghcr.io/clawdbot/clawdbot:latest
```

### Distribution-Specific Notes

**Ubuntu/Debian:**
```bash
# Install Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install nodejs
```

**Fedora/RHEL:**
```bash
# Install Node.js
sudo dnf install nodejs
```

**Arch Linux:**
```bash
# Install from AUR
yay -S clawdbot
```

---

## Hetzner VPS

Deploy Clawdbot to Hetzner cloud servers.

### Quick Deploy

1. Create CX11 or CX21 server with Ubuntu 22.04
2. SSH into server
3. Install Clawdbot:

```bash
curl -fsSL https://clawd.bot/install.sh | bash
clawdbot onboard
```

### Recommended Specs

| Plan | vCPU | RAM | Use Case |
|------|------|-----|----------|
| CX11 | 1 | 2GB | Personal |
| CX21 | 2 | 4GB | Small team |
| CX31 | 2 | 8GB | Multiple channels |

### Firewall Configuration

```bash
# Allow gateway port (if remote access needed)
ufw allow 18789/tcp

# Or use Tailscale instead
```

### With Docker

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Run Clawdbot
docker run -d \
  --name clawdbot \
  --restart unless-stopped \
  -p 18789:18789 \
  -v /root/.clawdbot:/root/.clawdbot \
  ghcr.io/clawdbot/clawdbot:latest
```

### Backup

```bash
# Backup config and data
tar -czf clawdbot-backup.tar.gz ~/.clawdbot

# Restore
tar -xzf clawdbot-backup.tar.gz -C ~
```

---

## exe.dev Hosting

Deploy to exe.dev serverless platform.

### Quick Deploy

```bash
# Install exe CLI
npm install -g @exe/cli

# Deploy
exe deploy
```

### Configuration

Create `exe.json`:

```json
{
  "name": "my-clawdbot",
  "runtime": "node22",
  "env": {
    "ANTHROPIC_API_KEY": "@anthropic-key"
  },
  "regions": ["us-east-1"],
  "memory": 512
}
```

### Secrets

```bash
# Add secrets
exe secrets set ANTHROPIC_API_KEY sk-ant-...
exe secrets set OPENAI_API_KEY sk-...
```

### Logs

```bash
exe logs -f
```

### Limitations

- Stateless (use external storage for persistence)
- No WebSocket (use HTTP API mode)
- Cold starts

---

## Remote Access

### Tailscale (Recommended)

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Login
tailscale up

# Serve Clawdbot
clawdbot gateway --tailscale serve
```

### SSH Tunnel

```bash
# From local machine
ssh -L 18789:localhost:18789 user@server
```

### Cloudflare Tunnel

```bash
# Install cloudflared
# Create tunnel
cloudflared tunnel create clawdbot
cloudflared tunnel route dns clawdbot clawdbot.yourdomain.com

# Run
cloudflared tunnel run clawdbot
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/platforms/macos
- https://docs.clawd.bot/platforms/ios
- https://docs.clawd.bot/platforms/android
- https://docs.clawd.bot/platforms/windows
- https://docs.clawd.bot/platforms/linux
- https://docs.clawd.bot/platforms/hetzner
- https://docs.clawd.bot/platforms/exe-dev

Run `./sync.sh` to update from upstream.
