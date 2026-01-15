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
│   ├── clawdbot/             # Clawdbot AI assistant framework
│   └── agent-browser/        # Browser automation for AI agents
└── README.md
```

---

## Plugin Architecture (IMPORTANT)

All plugins MUST follow the **Progressive Disclosure Pattern** from official Claude Code documentation.

### Progressive Disclosure Pattern

This pattern optimizes token usage by loading content on-demand:

| Level | Location | When Loaded | Token Impact |
|-------|----------|-------------|--------------|
| **Level 1** | SKILL.md frontmatter | Skill discovery | Zero until activated |
| **Level 2** | SKILL.md content | Skill activation | ~500-1000 tokens |
| **Level 3** | docs/*.md files | On-demand reference | Only when needed |

### Standardized Plugin Structure

```
plugins/<plugin-name>/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── commands/
│   └── <plugin-name>.md      # Slash command entry point
├── skills/<skill-name>/
│   ├── SKILL.md              # MINIMAL: ~100 lines, summary + references
│   └── docs/                 # DETAILED: cached upstream documentation
│       ├── installation.md
│       ├── commands.md
│       ├── <topic>.md
│       └── readme-upstream.md  # Raw upstream README
├── sync.json                 # CI sync configuration
├── .gitignore                # Excludes .cache/ only
└── README.md                 # User-facing documentation
```

### SKILL.md Template (~100 lines max)

```markdown
---
name: <skill-name>
description: Specific description with trigger keywords. Use when user wants to <action>. Triggers on mentions of <keywords>.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# <Skill Name>

Brief expert statement.

## Overview

4-6 bullet points of key capabilities.

## Quick Start

Minimal code example (5-10 lines).

## Core Concepts

Brief explanation of 2-3 key concepts.

## Documentation

Reference links to docs/ files:

- **[Installation](docs/installation.md)** - Setup instructions
- **[Commands](docs/commands.md)** - Full reference
- **[Topic](docs/topic.md)** - Detailed guide

## Common Workflows

2-3 brief workflow examples.

## Upstream Sources

- **Repository**: <URL>
- **Documentation**: <URL>

## Sync & Update

When user runs `sync`: fetch latest, update docs/ files.
When user runs `diff`: compare current vs upstream.
```

### docs/ Folder Contents

The `docs/` folder contains **cached upstream documentation** that:
- Is fetched from upstream sources
- Is committed to git (NOT gitignored)
- Is updated by CI sync workflow
- Provides detailed reference material

Each file in `docs/` should:
- Have a source URL comment at the top
- Contain the full content from that source
- Be synced via the CI workflow

### commands/<plugin-name>.md Template

```markdown
# <Plugin Name> Assistant

You are an expert at <domain>.

## Command: $ARGUMENTS

Parse the arguments to determine the action:

| Command | Action |
|---------|--------|
| `<cmd1>` | Description |
| `<cmd2>` | Description |
| `sync` | Check for updates to documentation |
| `diff` | Show differences vs upstream |
| `help` | Show available commands |

## Instructions

1. Read the skill file at `skills/<skill>/SKILL.md` for overview
2. Read detailed docs in `skills/<skill>/docs/` for specific topics
3. For **sync**: Fetch latest and update docs/ files
4. For **diff**: Compare current vs upstream

## Quick Reference

Brief reference for most common operations.
```

### sync.json Configuration

```json
{
  "name": "<plugin-name>",
  "version": "1.0.0",
  "description": "Brief description",
  "sources": [
    {
      "url": "https://raw.githubusercontent.com/<org>/<repo>/main/README.md",
      "target": "skills/<skill>/docs/readme-upstream.md",
      "type": "raw",
      "freshness_days": 14
    },
    {
      "url": "https://<docs-site>/installation",
      "target": "skills/<skill>/docs/installation.md",
      "type": "extract-content",
      "freshness_days": 14
    }
  ],
  "cache_dir": ".cache"
}
```

### .gitignore (Standardized)

```
# Sync cache (temporary comparison files)
.cache/
```

Note: The `docs/` folder is NOT gitignored - it contains committed cached documentation.

---

## Documentation Sync

Each plugin syncs documentation from upstream sources.

### Sync Commands

```bash
# Sync a specific plugin
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
| agent-browser | https://github.com/vercel-labs/agent-browser + https://agent-browser.dev/ | URL-based |

### When to Sync

1. **Before making changes** - Ensure you have latest upstream documentation
2. **When user reports outdated info** - Run sync with `--force`
3. **Periodically** - CI runs bi-weekly, but manual sync is encouraged

---

## Creating a New Plugin

### Step-by-Step

1. **Create directory structure** following the standardized template above

2. **Write SKILL.md** (~100 lines max):
   - Good description with trigger keywords
   - Quick overview and examples
   - References to docs/ files

3. **Create docs/ folder** with cached upstream documentation:
   - Fetch all relevant upstream docs
   - Save as individual .md files
   - Add source URL comment at top of each

4. **Create command file** at `commands/<plugin-name>.md`

5. **Configure sync.json** with all upstream sources

6. **Register in marketplace**:
   - Add entry to `.claude-plugin/marketplace.json`
   - Add to `.github/workflows/sync-docs.yml` PLUGINS array
   - Update CLAUDE.md plugin sources table

7. **Update README.md** with plugin documentation

### Checklist

- [ ] SKILL.md is ~100 lines (not 500+)
- [ ] SKILL.md references docs/ files
- [ ] docs/ folder has all upstream documentation
- [ ] commands/<name>.md exists
- [ ] sync.json lists all upstream sources
- [ ] .gitignore only excludes .cache/
- [ ] Registered in marketplace.json
- [ ] Added to sync-docs.yml workflow
- [ ] README.md updated

---

## Working on Plugins

### Before Starting

1. Check current branch
2. Run sync to ensure latest docs
3. Review upstream for recent changes

### Making Changes

1. **SKILL.md changes** - Keep minimal, reference docs/
2. **docs/ changes** - Prefer sync over manual edits
3. **Command changes** - Test command flow locally
4. **New features** - Update README and sync.json

### After Changes

1. Update plugin README if user-facing behavior changed
2. Bump version in sync.json if significant
3. Commit with conventional format: `feat(<plugin>): description`

---

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

---

## CI Automation

### Sync Workflow

- Runs bi-weekly (1st and 15th of month)
- Syncs all plugins in PLUGINS array
- Creates PR if changes detected
- Auto-merges with squash

### Manual Trigger

GitHub Actions > Sync Plugin Documentation > Run workflow
- Enable `force` to ignore freshness check
- Enable `dry_run` to check without modifying

### Adding New Plugin to CI

1. Add plugin name to PLUGINS array in `.github/workflows/sync-docs.yml`:
   ```yaml
   PLUGINS=("umbrel-app" "claude-code-expert" "clawdbot" "agent-browser" "<new-plugin>")
   ```

2. Ensure sync.json is properly configured with all sources

---

## Anti-Patterns to Avoid

### DON'T: Put everything in SKILL.md

```markdown
# Bad: 500+ lines in SKILL.md
---
name: my-skill
---

## Section 1
[200 lines of content]

## Section 2
[200 lines of content]

## Section 3
[200 lines of content]
```

### DO: Use progressive disclosure

```markdown
# Good: ~100 lines in SKILL.md with references
---
name: my-skill
---

## Overview
Brief summary.

## Documentation
- **[Section 1](docs/section1.md)** - Detailed guide
- **[Section 2](docs/section2.md)** - Reference
- **[Section 3](docs/section3.md)** - Examples
```

### DON'T: Duplicate content

Having the same information in both SKILL.md AND docs/ files wastes tokens and creates sync issues.

### DO: Single source of truth

- SKILL.md = Summary + references
- docs/ = Detailed content
- SKILL.md references docs/, never duplicates
