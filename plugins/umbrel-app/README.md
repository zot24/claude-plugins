# Umbrel App Plugin for Claude Code

A comprehensive Claude Code plugin for developing, packaging, testing, and submitting apps for umbrelOS.

## Features

- **Scaffold** - Generate complete app structure with all required files
- **Validate** - Check apps against 20+ requirements and best practices
- **Convert** - Transform existing Docker Compose apps to Umbrel format
- **PR Generation** - Create submission-ready pull request content
- **Debug** - Troubleshoot installation and runtime issues
- **Sync** - Keep skill updated with upstream Umbrel documentation
- **Diff** - Check for documentation changes without modifying skill

## Installation

### Option 1: Local Testing

```bash
claude --plugin-dir /path/to/umbrel-app-plugin
```

### Option 2: Install from GitHub

```bash
# Add the marketplace (if hosting on GitHub)
/plugin marketplace add your-username/umbrel-app-plugin

# Install the plugin
/plugin install umbrel-app
```

### Option 3: Project-Level Installation

Add to your project's `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "umbrel-app@your-marketplace": true
  }
}
```

## Usage

### Slash Command

```
/umbrel-app:umbrel-app scaffold my-cool-app
/umbrel-app:umbrel-app validate ./my-app
/umbrel-app:umbrel-app convert ./existing-docker-app
/umbrel-app:umbrel-app pr ./my-app
/umbrel-app:umbrel-app debug ./my-app
/umbrel-app:umbrel-app sync
/umbrel-app:umbrel-app diff
/umbrel-app:umbrel-app help
```

### Natural Language

The skill also triggers automatically when you mention:
- "Create an Umbrel app"
- "Package this for umbrelOS"
- "Validate my Umbrel app"
- "Submit to Umbrel app store"

## What is an Umbrel App?

Umbrel apps are Docker-based applications packaged for [umbrelOS](https://umbrel.com), a personal server OS. Each app requires:

```
my-app/
├── docker-compose.yml    # Container orchestration
├── umbrel-app.yml        # App manifest/metadata
├── exports.sh            # Environment exports
├── icon.svg              # 256x256 app icon
└── gallery/              # 3-5 screenshots (1440x900)
```

## Key Requirements

### Docker Images Must Use SHA256 Digests

```yaml
# Correct
image: getumbrel/btc-rpc-explorer:v3.4.0@sha256:abc123...

# Wrong
image: getumbrel/btc-rpc-explorer:latest
```

### App Proxy is Required

Every app needs the `app_proxy` service for routing and authentication:

```yaml
services:
  app_proxy:
    environment:
      APP_HOST: myapp_web_1
      APP_PORT: 8080
```

### Persistent Data Uses APP_DATA_DIR

```yaml
volumes:
  - ${APP_DATA_DIR}/data:/app/data
```

## Environment Variables

Apps have access to Umbrel environment variables:

| Variable | Description |
|----------|-------------|
| `$APP_DATA_DIR` | Persistent storage path |
| `$APP_PASSWORD` | Auto-generated password |
| `$APP_SEED` | Deterministic seed |
| `$APP_HIDDEN_SERVICE` | Tor .onion address |
| `$APP_BITCOIN_NODE_IP` | Bitcoin Core IP |
| `$APP_BITCOIN_RPC_*` | Bitcoin RPC credentials |
| `$APP_LIGHTNING_NODE_IP` | LND IP address |
| `$TOR_PROXY_IP/PORT` | Tor SOCKS proxy |

## Testing Your App

### Development Environment

```bash
# Start umbrel-dev
git clone https://github.com/getumbrel/umbrel.git
cd umbrel && npm run dev

# Deploy your app
rsync -av ./my-app/ umbrel@umbrel-dev.local:/home/umbrel/umbrel/app-stores/getumbrel-umbrel-apps-github-53f74447/my-app/

# Install
npm run dev client -- apps.install.mutate -- --appId my-app
```

### Physical Device

```bash
rsync -av ./my-app/ umbrel@umbrel.local:/home/umbrel/umbrel/app-stores/getumbrel-umbrel-apps-github-53f74447/my-app/
ssh umbrel@umbrel.local umbreld client apps.install.mutate --appId my-app
```

## Submitting Your App

1. Fork [getumbrel/umbrel-apps](https://github.com/getumbrel/umbrel-apps)
2. Add your app directory
3. Include 256x256 SVG icon (no rounded corners)
4. Include 3-5 gallery images (1440x900 PNG)
5. Open a pull request

Use `/umbrel-app:umbrel-app pr ./my-app` to generate the PR template.

## Keeping the Plugin Updated

The plugin includes commands to stay synchronized with the official Umbrel documentation.

### Check for Changes

```bash
/umbrel-app:umbrel-app diff
```

Compares the current skill against the upstream documentation and reports any differences without making changes.

### Sync with Upstream

```bash
/umbrel-app:umbrel-app sync
```

Fetches the latest documentation from GitHub and updates the skill with any new requirements, fields, or procedures.

### Upstream Source

The authoritative documentation is at:
- **GitHub**: https://github.com/getumbrel/umbrel-apps/blob/master/README.md
- **Raw**: https://raw.githubusercontent.com/getumbrel/umbrel-apps/master/README.md

### What Gets Monitored

| Section | Changes Tracked |
|---------|-----------------|
| Dockerfile | Best practices, multi-arch requirements |
| docker-compose.yml | app_proxy config, version, services |
| umbrel-app.yml | Manifest fields, manifestVersion |
| Environment Variables | New/deprecated variables |
| Testing | Commands, dev environment setup |
| Submission | PR requirements, asset specs |

## Plugin Structure

```
umbrel-app-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin manifest
├── commands/
│   └── umbrel-app.md     # Slash command definition
├── skills/
│   └── umbrel-app/
│       └── SKILL.md      # Skill instructions
└── README.md
```

## License

MIT

## Resources

- [Umbrel App Documentation](https://github.com/getumbrel/umbrel-apps)
- [umbrelOS](https://umbrel.com)
- [Claude Code](https://claude.ai/claude-code)
