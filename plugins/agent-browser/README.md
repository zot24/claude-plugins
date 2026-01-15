# Agent Browser Plugin

Expert assistant for browser automation with AI agents using [Vercel's agent-browser](https://github.com/vercel-labs/agent-browser) CLI.

## Features

- Complete command reference for 50+ browser automation commands
- Selector patterns (refs, CSS, semantic locators)
- Session management for isolated browser instances
- Snapshot-based element targeting for AI agents
- Integration patterns for Claude Code, Cursor, and other AI tools

## Installation

Add to your Claude Code project:

```bash
# Clone the plugins repository
git clone https://github.com/zot24/claude-plugins.git

# Or add as a submodule
git submodule add https://github.com/zot24/claude-plugins.git .claude-plugins
```

## Usage

The skill auto-activates when you mention:
- Browser automation
- agent-browser commands
- Web scraping with AI
- Headless browser testing

### Example Prompts

```
"Help me automate logging into a website"
"How do I capture screenshots with agent-browser?"
"Show me how to use snapshots for element selection"
"Set up multi-session browser automation"
```

## Quick Reference

### Installation

```bash
npm install -g agent-browser
agent-browser install  # Downloads Chromium
```

### Basic Workflow

```bash
agent-browser open example.com
agent-browser snapshot -i              # Get interactive elements
agent-browser click @e2                # Click using ref
agent-browser fill @e3 "text"          # Fill input
agent-browser screenshot page.png
agent-browser close
```

### Key Concepts

- **Refs**: Element references (`@e1`, `@e2`) from snapshots for deterministic selection
- **Sessions**: Isolated browser instances with independent state
- **Snapshots**: Accessibility tree views optimized for AI parsing

## Upstream Source

- **Documentation**: https://agent-browser.dev/
- **Repository**: https://github.com/vercel-labs/agent-browser

## Sync

Documentation syncs from upstream automatically. Manual sync:

```bash
.github/scripts/sync-plugin.sh plugins/agent-browser
```
