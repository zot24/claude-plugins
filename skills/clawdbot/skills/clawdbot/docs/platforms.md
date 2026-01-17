<!-- Source: https://docs.clawd.bot/platforms/ -->

# Clawdbot Platforms

Platform-specific installation and configuration.

## macOS

Full support including native app.

```bash
curl -fsSL https://clawd.bot/install.sh | bash
# or
brew install clawdbot
```

### Permissions Required

| Permission | Purpose |
|------------|---------|
| Full Disk Access | iMessage integration |
| Camera | Photo capture |
| Microphone | Voice input |
| Screen Recording | Screen capture |

Grant in System Preferences > Privacy & Security.

---

## iOS

Download from App Store: "Clawdbot"

Features: Chat interface, photo/video capture, location sharing, voice input, push notifications, Shortcuts integration.

Configure gateway URL in app settings: `ws://your-gateway:18789`

---

## Android

Download from Google Play or APK from https://clawd.bot/download/android

Features: Chat interface, camera, location, voice, push notifications, Tasker integration.

---

## Windows (WSL2)

```bash
# In WSL2 terminal
curl -fsSL https://clawd.bot/install.sh | bash
```

### WSL2 Setup

```powershell
wsl --install
wsl --install -d Ubuntu
```

Limitations: No native Windows GUI, no iMessage.

---

## Linux

```bash
curl -fsSL https://clawd.bot/install.sh | bash
# or
npm install -g clawdbot
```

### Systemd Service

```ini
[Unit]
Description=Clawdbot Gateway
After=network.target

[Service]
Type=simple
User=clawdbot
ExecStart=/usr/bin/clawdbot gateway
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable clawdbot
sudo systemctl start clawdbot
```

---

## Hetzner VPS

1. Create CX11/CX21 server with Ubuntu 22.04
2. SSH into server
3. Install and configure

| Plan | vCPU | RAM | Use Case |
|------|------|-----|----------|
| CX11 | 1 | 2GB | Personal |
| CX21 | 2 | 4GB | Small team |
| CX31 | 2 | 8GB | Multiple channels |

---

## exe.dev Hosting

```bash
npm install -g @exe/cli
exe deploy
exe secrets set ANTHROPIC_API_KEY sk-ant-...
```

Limitations: Stateless, no WebSocket, cold starts.

---

## Remote Access

### Tailscale (Recommended)

```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
clawdbot gateway --tailscale serve
```

### SSH Tunnel

```bash
ssh -L 18789:localhost:18789 user@server
```

### Cloudflare Tunnel

```bash
cloudflared tunnel create clawdbot
cloudflared tunnel route dns clawdbot clawdbot.yourdomain.com
cloudflared tunnel run clawdbot
```

---

## Upstream Sources

- https://docs.clawd.bot/platforms/macos
- https://docs.clawd.bot/platforms/ios
- https://docs.clawd.bot/platforms/android
- https://docs.clawd.bot/platforms/windows
- https://docs.clawd.bot/platforms/linux
- https://docs.clawd.bot/platforms/hetzner
