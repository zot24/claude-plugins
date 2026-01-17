<!-- Source: https://docs.clawd.bot/install/ -->

# Clawdbot Installation

Complete guide to installing Clawdbot using various methods.

## Quick Install (Recommended)

```bash
curl -fsSL https://clawd.bot/install.sh | bash
```

This installer detects your platform, installs Node.js if needed, sets up the CLI globally, and configures shell completions.

### Non-root Install

```bash
curl -fsSL https://clawd.bot/install-cli.sh | bash
```

Installs to `~/.clawdbot` with a dedicated Node runtime.

---

## Docker Installation

### Quick Start

```bash
docker run -d \
  --name clawdbot \
  -p 18789:18789 \
  -v ~/.clawdbot:/root/.clawdbot \
  -e ANTHROPIC_API_KEY="sk-ant-..." \
  ghcr.io/clawdbot/clawdbot:latest
```

### Docker Compose

```yaml
version: '3.8'
services:
  clawdbot:
    image: ghcr.io/clawdbot/clawdbot:latest
    container_name: clawdbot
    restart: unless-stopped
    ports:
      - "18789:18789"
    volumes:
      - ./data:/root/.clawdbot
      - ./workspace:/root/clawd
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - GATEWAY_BIND=0.0.0.0
    healthcheck:
      test: ["CMD", "clawdbot", "gateway", "health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Docker Port Reference

| Port | Protocol | Service | Description |
|------|----------|---------|-------------|
| 18789 | HTTP + WebSocket | Gateway | Main gateway, WebChat UI at `/chat` |
| 18790 | TCP (JSONL) | Bridge | Mobile node connections - **NOT HTTP!** |
| 18793 | HTTP | Canvas | File serving for node WebViews |

**Important**: Port 18790 is NOT webchat. WebChat is at `http://host:18789/chat`.

### Docker Network Configuration

For Docker, use `bind: "lan"` (requires authentication):

```json
{
  "gateway": {
    "bind": "lan",
    "auth": { "mode": "token", "token": "your-secure-token" }
  }
}
```

---

## NPM Installation

```bash
npm install -g clawdbot
```

---

## Source Installation

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot
npm install
npm run build
npm link
```

---

## Ansible Installation

```yaml
- name: Install Clawdbot
  hosts: servers
  become: yes
  tasks:
    - name: Install Clawdbot via npm
      npm:
        name: clawdbot
        global: yes
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
RestartSec=10

[Install]
WantedBy=multi-user.target
```

---

## Nix Installation

```nix
{
  inputs.clawdbot.url = "github:clawdbot/clawdbot";
  outputs = { self, nixpkgs, clawdbot }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        clawdbot.nixosModules.default
        { services.clawdbot.enable = true; }
      ];
    };
  };
}
```

---

## Bun Installation

```bash
bun install -g clawdbot
```

**Note**: Some features work better with Node.js.

---

## Updates & Rollback

```bash
clawdbot update check    # Check for updates
clawdbot update run      # Apply update
npm install -g clawdbot@<version>  # Rollback
```

---

## Prerequisites

- **Node.js 22+**
- **macOS**: Xcode CLI tools
- **Windows**: WSL2 with Ubuntu
- **Linux**: Build essentials

---

## Post-Install Setup

```bash
clawdbot onboard --install-daemon
export ANTHROPIC_API_KEY="sk-ant-..."
```

---

## Upstream Sources

- https://docs.clawd.bot/install/installer
- https://docs.clawd.bot/install/docker
- https://docs.clawd.bot/install/npm
- https://docs.clawd.bot/install/source
- https://docs.clawd.bot/updates/updating
