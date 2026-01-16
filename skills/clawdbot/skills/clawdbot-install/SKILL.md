---
name: clawdbot-install
description: Clawdbot installation methods - Docker, npm, source, Ansible, Nix, updates and rollback
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Installation Expert

Complete guide to installing Clawdbot using various methods.

**Documentation**: https://docs.clawd.bot/install/

---

## Quick Install (Recommended)

The fastest way to get started:

```bash
curl -fsSL https://clawd.bot/install.sh | bash
```

This installer:
- Detects your platform (macOS, Linux)
- Installs Node.js if needed (via Homebrew on macOS)
- Sets up the CLI globally
- Configures shell completions

### Non-root Install

For systems without root access:

```bash
curl -fsSL https://clawd.bot/install-cli.sh | bash
```

Installs to `~/.clawdbot` with a dedicated Node runtime.

---

## Docker Installation

### Quick Start with Docker

```bash
docker run -d \
  --name clawdbot \
  -p 18789:18789 \
  -v ~/.clawdbot:/root/.clawdbot \
  -e ANTHROPIC_API_KEY="sk-ant-..." \
  ghcr.io/clawdbot/clawdbot:latest
```

### Docker Compose

Create `docker-compose.yml`:

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
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - GATEWAY_BIND=0.0.0.0
      - GATEWAY_PORT=18789
    healthcheck:
      test: ["CMD", "clawdbot", "gateway", "health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

Start with:
```bash
docker-compose up -d
```

### Environment Variables for Docker

| Variable | Description | Default |
|----------|-------------|---------|
| `ANTHROPIC_API_KEY` | Anthropic API key | - |
| `OPENAI_API_KEY` | OpenAI API key | - |
| `GATEWAY_BIND` | Gateway bind address | `127.0.0.1` |
| `GATEWAY_PORT` | Gateway port | `18789` |
| `WORKSPACE_PATH` | Agent workspace path | `/root/clawd` |
| `LOG_LEVEL` | Logging verbosity | `info` |

### Docker with Channels

For WhatsApp (requires QR scan):
```bash
docker run -it \
  --name clawdbot \
  -p 18789:18789 \
  -v ~/.clawdbot:/root/.clawdbot \
  ghcr.io/clawdbot/clawdbot:latest \
  clawdbot channels login
```

### Building from Source (Docker)

```dockerfile
FROM node:22-slim

WORKDIR /app
RUN npm install -g clawdbot
EXPOSE 18789

CMD ["clawdbot", "gateway"]
```

---

## Docker Port Reference

**CRITICAL**: Understanding Clawdbot ports is essential for Docker deployment.

| Port | Protocol | Service | Description |
|------|----------|---------|-------------|
| 18789 | HTTP + WebSocket | Gateway | Main gateway, WebChat UI at `/chat`, WebSocket API |
| 18790 | TCP (JSONL) | Bridge | Mobile node connections (iOS/Android) - **NOT HTTP!** |
| 18793 | HTTP | Canvas | File serving for node WebViews |

**Common mistake**: Port 18790 is NOT the webchat - it's a TCP bridge for mobile nodes. The webchat UI is served by the Gateway at `http://host:18789/chat`.

---

## Docker Network Configuration

### Binding to External Interfaces

By default, Clawdbot binds to `loopback` (127.0.0.1) which is NOT accessible from outside the container.

**For Docker deployment, you MUST use `bind: "lan"`**:

```json
{
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "lan",
    "auth": {
      "mode": "token",
      "token": "your-secure-token"
    }
  }
}
```

**Important**: Non-loopback binds (`lan`, `tailnet`, `auto`) **require authentication**. Set either:
- `gateway.auth.token` in config
- `CLAWDBOT_GATEWAY_TOKEN` environment variable

### Docker Compose for Umbrel/Self-Hosted

```yaml
version: '3.8'

services:
  clawdbot:
    image: ghcr.io/clawdbot/clawdbot:latest
    restart: unless-stopped
    ports:
      - "18789:18789"  # Gateway + WebChat (HTTP/WS)
    volumes:
      - ./data:/root/.clawdbot
      - ./workspace:/root/clawd
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - CLAWDBOT_GATEWAY_TOKEN=${CLAWDBOT_GATEWAY_TOKEN:-auto}
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:18789/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
```

### Accessing WebChat

After starting, access the WebChat UI at:
```
http://your-host:18789/chat
```

---

## NPM Installation

### Global Install

```bash
npm install -g clawdbot
```

### Project-local Install

```bash
npm install clawdbot
npx clawdbot --version
```

### With specific Node version

```bash
# Using nvm
nvm use 22
npm install -g clawdbot
```

---

## Source Installation

### Clone and Build

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot
npm install
npm run build
npm link
```

### Development Mode

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot
npm install
npm run dev
```

---

## Ansible Installation

### Playbook Example

```yaml
---
- name: Install Clawdbot
  hosts: servers
  become: yes
  tasks:
    - name: Install Node.js 22
      apt:
        name: nodejs
        state: present
      when: ansible_os_family == "Debian"

    - name: Install Clawdbot via npm
      npm:
        name: clawdbot
        global: yes

    - name: Create clawdbot config directory
      file:
        path: /home/{{ ansible_user }}/.clawdbot
        state: directory
        owner: "{{ ansible_user }}"

    - name: Copy clawdbot config
      template:
        src: clawdbot.json.j2
        dest: /home/{{ ansible_user }}/.clawdbot/clawdbot.json
        owner: "{{ ansible_user }}"

    - name: Start clawdbot gateway service
      systemd:
        name: clawdbot
        state: started
        enabled: yes
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
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

---

## Nix Installation

### Using Flakes

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    clawdbot.url = "github:clawdbot/clawdbot";
  };

  outputs = { self, nixpkgs, clawdbot }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        clawdbot.nixosModules.default
        {
          services.clawdbot = {
            enable = true;
            settings = {
              gateway.port = 18789;
            };
          };
        }
      ];
    };
  };
}
```

### Home Manager

```nix
{ pkgs, ... }:

{
  home.packages = [ pkgs.clawdbot ];

  xdg.configFile."clawdbot/clawdbot.json".text = builtins.toJSON {
    gateway = {
      mode = "local";
      port = 18789;
    };
  };
}
```

---

## Bun Installation

Clawdbot supports Bun as an alternative runtime:

```bash
bun install -g clawdbot
```

**Note**: Some features (especially WhatsApp) work better with Node.js. If you experience issues with Bun, switch to Node.js.

---

## Updates

### Check for Updates

```bash
clawdbot update check
```

### Apply Update

```bash
clawdbot update run
```

### Update via npm

```bash
npm update -g clawdbot
```

### Update Docker

```bash
docker pull ghcr.io/clawdbot/clawdbot:latest
docker-compose down && docker-compose up -d
```

---

## Rollback

### Via npm

```bash
npm install -g clawdbot@<previous-version>
```

### Via Docker

```bash
docker pull ghcr.io/clawdbot/clawdbot:<version-tag>
```

### Check Available Versions

```bash
npm view clawdbot versions
```

---

## Prerequisites

### Required

- **Node.js 22+** (auto-installed on macOS via Homebrew)
- **Git** (required for source builds)

### Platform-Specific

- **macOS**: Xcode CLI tools (`xcode-select --install`)
- **Windows**: WSL2 with Ubuntu recommended
- **Linux**: Build essentials (`apt install build-essential`)

---

## Post-Install Setup

After installation, run the onboarding wizard:

```bash
clawdbot onboard --install-daemon
```

This configures:
- Model authentication (API keys or OAuth)
- Gateway settings
- Channel credentials
- Pairing defaults
- Workspace bootstrap

### Authentication

For Anthropic models:
```bash
# Option 1: Set API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Option 2: Reuse Claude Code credentials
claude setup-token
```

OAuth credentials stored in `~/.clawdbot/credentials/oauth.json`

---

## Troubleshooting Installation

### Common Issues

**Node.js version too old:**
```bash
node --version  # Should be 22+
nvm install 22 && nvm use 22
```

**Permission denied (npm global):**
```bash
npm config set prefix ~/.npm-global
export PATH=~/.npm-global/bin:$PATH
```

**Missing build tools (Linux):**
```bash
sudo apt install build-essential python3
```

**Docker permission denied:**
```bash
sudo usermod -aG docker $USER
# Then logout and login again
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/install/installer
- https://docs.clawd.bot/install/npm
- https://docs.clawd.bot/install/source
- https://docs.clawd.bot/install/docker
- https://docs.clawd.bot/install/ansible
- https://docs.clawd.bot/install/nix
- https://docs.clawd.bot/install/bun
- https://docs.clawd.bot/updates/updating
- https://docs.clawd.bot/updates/rollback

Run `./sync.sh` to update from upstream.
