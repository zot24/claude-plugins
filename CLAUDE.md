# Claude Plugins Development Guide

This repository contains Claude Code plugins for various development workflows.

## Project Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest
├── .github/
│   ├── scripts/
│   │   └── sync-plugin.sh    # Generic sync script
│   └── workflows/
│       ├── sync-docs.yml     # Scheduled sync workflow
│       └── release-on-merge.yml
├── plugins/
│   ├── umbrel-app/           # Umbrel app development
│   ├── claude-code-expert/   # Claude Code knowledge base
│   └── clawdbot/             # Clawdbot AI assistant framework
└── README.md
```

## Documentation Sync

Each plugin syncs documentation from upstream sources. **Always check and sync documentation when working on a plugin.**

### Sync Commands

```bash
# Sync all plugins
.github/scripts/sync-plugin.sh plugins/<plugin-name>

# Force refresh (ignore cache)
.github/scripts/sync-plugin.sh plugins/<plugin-name> --force

# Dry run (check without modifying)
.github/scripts/sync-plugin.sh plugins/<plugin-name> --dry-run
```

### Plugin Sources

| Plugin | Upstream Source | Sync Type |
|--------|-----------------|-----------|
| umbrel-app | https://github.com/getumbrel/umbrel-apps/blob/master/README.md | URL-based |
| claude-code-expert | Multiple sources via registry.json | Registry-based |
| clawdbot | https://docs.clawd.bot/ | URL-based |

### When to Sync

1. **Before making changes** - Ensure you have latest upstream documentation
2. **When user reports outdated info** - Run sync with `--force`
3. **Periodically** - CI runs bi-weekly, but manual sync is encouraged

## Plugin Development

### Creating a New Plugin

1. Create directory structure:
   ```
   plugins/<plugin-name>/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── commands/
   │   └── <command>.md
   ├── skills/
   │   └── <skill-name>/
   │       └── SKILL.md
   ├── sync.json
   ├── .gitignore
   └── README.md
   ```

2. Configure `sync.json`:
   ```json
   {
     "name": "<plugin-name>",
     "version": "1.0.0",
     "sources": [
       {
         "url": "https://...",
         "target": "skills/<skill-name>/SKILL.md",
         "freshness_days": 14
       }
     ],
     "cache_dir": ".cache"
   }
   ```

3. Register in `.claude-plugin/marketplace.json`

4. Update main `README.md` and workflow files

### Plugin File Responsibilities

- **SKILL.md** - Comprehensive knowledge base (auto-activated by context)
- **commands/<cmd>.md** - Slash command entry points with specific actions
- **sync.json** - Defines upstream sources for documentation sync
- **README.md** - User-facing documentation with examples

### SKILL.md Structure

```markdown
---
name: <skill-name>
description: Brief description for auto-activation
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# <Skill Name>

## Section 1
...

## Sync & Update

### Upstream Source
<URL>

### Sync Command
When user runs `sync`: fetch, compare, update, report changes
When user runs `diff`: fetch, compare, report without modifying
```

## Working on Plugins

### Before Starting

1. Check current branch
2. Run sync to ensure latest docs
3. Review upstream for recent changes

### Making Changes

1. **SKILL.md changes** - Ensure they align with upstream documentation
2. **Command changes** - Test command flow locally
3. **New features** - Update README and sync.json if needed

### After Changes

1. Update plugin README if user-facing behavior changed
2. Bump version in sync.json if significant
3. Commit with conventional format: `feat(<plugin>): description`

## Conventions

### Commit Messages

```
feat(<plugin>): add new feature
fix(<plugin>): fix bug
docs(<plugin>): update documentation
chore(<plugin>): maintenance task
```

### Version Bumps

- **Patch** (1.0.X): Documentation sync, bug fixes
- **Minor** (1.X.0): New commands/features
- **Major** (X.0.0): Breaking changes

### Labels

PRs should have labels:
- `documentation` - Doc updates
- `automated` - CI-generated PRs
- `<plugin-name>` - Plugin-specific label

## CI Automation

### Sync Workflow

- Runs bi-weekly (1st and 15th of month)
- Creates separate PR per plugin
- Auto-merges with squash
- Tags release after merge

### Manual Trigger

GitHub Actions > Sync Plugin Documentation > Run workflow
- Select plugin (all, umbrel-app, claude-code-expert, clawdbot)
- Enable force or dry_run as needed
