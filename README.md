# Claude Plugins

A collection of Claude Code plugins for various development workflows.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [umbrel-app](./plugins/umbrel-app) | Expert assistant for developing, packaging, testing, and submitting apps for umbrelOS |
| [claude-code-expert](./plugins/claude-code-expert) | Comprehensive Claude Code & Anthropic ecosystem knowledge. Official patterns for agents, skills, hooks, commands, MCP. |
| [clawdbot](./plugins/clawdbot) | Expert on Clawdbot - AI assistant framework connecting Claude/LLMs to messaging platforms (WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams) |
| [agent-browser](./plugins/agent-browser) | Expert on agent-browser - Vercel's headless browser automation CLI for AI agents with 50+ commands, snapshots, and multi-session support |

## Installation

### Add the Marketplace

```bash
/plugin marketplace add zot24/claude-plugins
```

### Install a Plugin

```bash
/plugin install umbrel-app@zot24-claude-code-plugins
```

### Or Add to Project Settings

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "zot24-claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "zot24/claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "umbrel-app@zot24-claude-code-plugins": true
  }
}
```

## Usage

Once installed, you can use plugins via **slash commands** or **natural language**.

### Slash Commands

Format: `/plugin-name:command-name [arguments]`

```bash
# Umbrel app development
/umbrel-app:umbrel scaffold my-app        # Create new app structure
/umbrel-app:umbrel validate ./my-app      # Validate app configuration
/umbrel-app:umbrel convert ./docker-app   # Convert Docker Compose to Umbrel
/umbrel-app:umbrel pr ./my-app            # Generate PR submission
/umbrel-app:umbrel debug ./my-app         # Troubleshoot issues

# Claude Code expertise
/claude-code-expert:claude create agent   # Guide for creating agents
/claude-code-expert:claude create skill   # Guide for creating skills
/claude-code-expert:claude validate ./x   # Validate against best practices
/claude-code-expert:claude features       # Show Claude Code capabilities

# Clawdbot AI assistant framework
/clawdbot:clawdbot setup                  # Installation guide
/clawdbot:clawdbot channel whatsapp       # Configure WhatsApp
/clawdbot:clawdbot channel telegram       # Configure Telegram
/clawdbot:clawdbot diagnose               # Troubleshoot issues
/clawdbot:clawdbot gateway                # Gateway configuration

# Agent browser automation
/agent-browser:agent-browser open <url>   # Open a webpage
/agent-browser:agent-browser snapshot     # Get element refs
/agent-browser:agent-browser click @e2    # Click by ref
/agent-browser:agent-browser screenshot   # Capture viewport
```

### Natural Language

You can also just describe what you want:

```
"Create an Umbrel app for my Docker project"
"Help me package this for umbrelOS"
"How do I create a Claude Code agent?"
"What are the best practices for hooks?"
"How do I set up WhatsApp with Clawdbot?"
"My Telegram bot isn't receiving messages"
"Automate browser login with agent-browser"
"How do I use snapshots for element selection?"
```

The plugins auto-activate based on context.

### Quick Start Examples

**Create a new Umbrel app:**
```
> /umbrel-app:umbrel scaffold my-bitcoin-dashboard
```

**Validate before submitting:**
```
> /umbrel-app:umbrel validate ./my-bitcoin-dashboard
```

**Learn Claude Code patterns:**
```
> /claude-code-expert:claude create hook
```

## Plugin Details

### umbrel-app

Full lifecycle support for Umbrel app development:

- **scaffold** - Generate complete app structure
- **validate** - Check against 20+ requirements
- **convert** - Transform Docker Compose to Umbrel format
- **pr** - Generate submission-ready PR content
- **debug** - Troubleshoot issues
- **sync/diff** - Stay updated with upstream docs

```bash
/umbrel-app:umbrel scaffold my-app
/umbrel-app:umbrel validate ./my-app
```

[Full documentation](./plugins/umbrel-app/README.md)

### claude-code-expert

Comprehensive Claude Code and Anthropic ecosystem knowledge:

- **create agent/skill/hook/command** - Official patterns and guidance
- **validate** - Check artifacts against official checklists
- **patterns** - Browse available creation patterns
- **features** - Learn about Claude Code capabilities
- **sync/check** - Keep documentation up to date

```bash
/claude-code-expert:claude create agent
/claude-code-expert:claude create skill
/claude-code-expert:claude validate ./my-agent
/claude-code-expert:claude features
```

[Full documentation](./plugins/claude-code-expert/README.md)

### clawdbot

Expert on Clawdbot AI assistant framework:

- **setup** - Installation and configuration guide
- **channel** - Configure messaging platforms (WhatsApp, Telegram, Discord, Slack, Signal, iMessage, Teams)
- **diagnose** - Troubleshoot common issues
- **gateway** - Gateway configuration and remote access
- **skills** - Create and manage Clawdbot skills
- **memory** - Memory system configuration
- **sync/diff** - Stay updated with upstream docs

```bash
/clawdbot:clawdbot setup
/clawdbot:clawdbot channel whatsapp
/clawdbot:clawdbot diagnose
```

[Full documentation](./plugins/clawdbot/README.md)

### agent-browser

Expert on Vercel's browser automation CLI for AI agents:

- **open** - Navigate to webpages
- **snapshot** - Get accessibility tree with element refs
- **click/fill/type** - Interact with elements by ref
- **screenshot** - Capture viewport or full page
- **session** - Manage isolated browser instances
- **network** - Intercept and mock requests
- **sync/diff** - Stay updated with upstream docs

```bash
/agent-browser:agent-browser open https://example.com
/agent-browser:agent-browser snapshot -i
/agent-browser:agent-browser click @e2
/agent-browser:agent-browser screenshot page.png
```

[Full documentation](./plugins/agent-browser/README.md)

## Adding New Plugins

1. Create a new directory under `plugins/`:
   ```
   plugins/
   └── my-new-plugin/
       ├── .claude-plugin/
       │   └── plugin.json
       ├── commands/
       ├── skills/
       ├── sync.json           # Required for CI automation
       └── README.md
   ```

2. Create `sync.json` for automated updates:
   ```json
   {
     "name": "my-new-plugin",
     "version": "1.0.0",
     "description": "What it does",
     "sources": [
       {
         "url": "https://example.com/docs.md",
         "target": "skills/my-skill/SKILL.md",
         "freshness_days": 14
       }
     ],
     "cache_dir": ".cache"
   }
   ```

3. Add entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "my-new-plugin",
     "source": "./plugins/my-new-plugin",
     "description": "What it does",
     "version": "1.0.0"
   }
   ```

4. Commit and push

## CI Automation

The repository includes automated workflows for keeping plugin documentation up to date.

### Scheduled Sync

Runs bi-weekly (1st and 15th of each month) to check for upstream documentation changes.

**Manual trigger**: Actions > Sync Plugin Documentation > Run workflow

Options:
- `plugin`: all, umbrel-app, claude-code-expert, or clawdbot
- `force`: Force sync even without detected changes
- `dry_run`: Check for changes without creating PR

### Release Tagging

When sync PRs are merged:
- Bumps patch version in `sync.json`
- Creates git tag (e.g., `umbrel-app-v1.0.1`)
- Creates GitHub release with changelog

### Configuration

Set custom schedule via repository variable:
```
SYNC_SCHEDULE: "0 6 1,15 * *"  # Cron format
```

## Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace manifest
├── .github/
│   ├── scripts/
│   │   └── sync-plugin.sh        # Generic sync script
│   └── workflows/
│       ├── sync-docs.yml         # Scheduled sync workflow
│       └── release-on-merge.yml  # Auto-release on PR merge
├── plugins/
│   ├── umbrel-app/               # Umbrel app development
│   │   ├── sync.json
│   │   └── ...
│   ├── claude-code-expert/       # Claude Code knowledge base
│   │   ├── sync.json
│   │   └── ...
│   ├── clawdbot/                 # Clawdbot AI assistant framework
│   │   ├── sync.json
│   │   └── ...
│   └── agent-browser/            # Browser automation for AI agents
│       ├── sync.json
│       └── ...
└── README.md
```

## License

MIT
