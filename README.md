# Claude Plugins

A collection of Claude Code plugins for various development workflows.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [umbrel-app](./plugins/umbrel-app) | Expert assistant for developing, packaging, testing, and submitting apps for umbrelOS |

## Installation

### Add the Marketplace

```bash
/plugin marketplace add YOUR_USERNAME/claude-plugins
```

### Install a Plugin

```bash
/plugin install umbrel-app@claude-plugins
```

### Or Add to Project Settings

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-plugins": {
      "source": {
        "source": "github",
        "repo": "YOUR_USERNAME/claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "umbrel-app@claude-plugins": true
  }
}
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
/umbrel-app:umbrel-app scaffold my-app
/umbrel-app:umbrel-app validate ./my-app
```

[Full documentation](./plugins/umbrel-app/README.md)

## Adding New Plugins

1. Create a new directory under `plugins/`:
   ```
   plugins/
   └── my-new-plugin/
       ├── .claude-plugin/
       │   └── plugin.json
       ├── commands/
       ├── skills/
       └── README.md
   ```

2. Add entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "my-new-plugin",
     "source": "./plugins/my-new-plugin",
     "description": "What it does",
     "version": "1.0.0"
   }
   ```

3. Commit and push

## Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest
├── plugins/
│   ├── umbrel-app/           # Umbrel app development plugin
│   └── [future-plugins]/     # Add more plugins here
└── README.md
```

## License

MIT
