---
name: agent-browser
description: Expert on browser automation with AI agents using Vercel's agent-browser CLI. Use when the user wants to automate browsers, scrape websites, capture screenshots, or build AI-powered web workflows. Triggers on mentions of agent-browser, browser automation, headless browsing, web scraping with AI.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Agent Browser Skill

Expert at browser automation for AI agents using Vercel's agent-browser CLI.

## Overview

**agent-browser** is a headless browser automation CLI optimized for AI agents with:
- 50+ commands for navigation, forms, screenshots, network, and storage
- AI-optimized snapshots with element refs for deterministic selection
- Multi-session support for isolated browser instances
- Cross-platform native Rust CLI with Node.js fallback

## Quick Start

```bash
npm install -g agent-browser
agent-browser install

agent-browser open example.com
agent-browser snapshot -i          # Get interactive elements with refs
agent-browser click @e2            # Click using ref
agent-browser fill @e3 "text"      # Fill input using ref
agent-browser screenshot page.png
agent-browser close
```

## Core Concepts

### Refs (Recommended for AI)
Element references from snapshots provide deterministic selection:
```bash
agent-browser snapshot        # Shows: button "Submit" [ref=e2]
agent-browser click @e2       # Click using ref
```

### Sessions
Isolated browser instances with independent state:
```bash
agent-browser --session agent1 open site.com
agent-browser --session agent2 open other.com
```

## Documentation

For detailed information, see the reference documentation:

- **[Installation](docs/installation.md)** - npm, source builds, custom browsers
- **[Quick Start](docs/quick-start.md)** - Basic workflow and examples
- **[Commands](docs/commands.md)** - Full 50+ command reference
- **[Selectors](docs/selectors.md)** - Refs, CSS, semantic locators
- **[Sessions](docs/sessions.md)** - Multi-session and authentication
- **[Snapshots](docs/snapshots.md)** - Accessibility tree and options
- **[Streaming](docs/streaming.md)** - WebSocket viewport streaming
- **[Agent Mode](docs/agent-mode.md)** - AI agent integration patterns
- **[CDP Mode](docs/cdp-mode.md)** - Chrome DevTools Protocol

## Common Workflows

### Login Flow
```bash
agent-browser open https://example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password"
agent-browser click @e3
agent-browser wait navigation
```

### Data Extraction
```bash
agent-browser open https://example.com/data
agent-browser snapshot --json > data.json
agent-browser get text ".product-title"
```

### Screenshot Capture
```bash
agent-browser screenshot viewport.png
agent-browser screenshot full.png --full
```

## Upstream Sources

- **Repository**: https://github.com/vercel-labs/agent-browser
- **Documentation**: https://agent-browser.dev/

## Sync & Update

When user runs `sync`: fetch latest from upstream sources, update docs/ files.
When user runs `diff`: compare current vs upstream, report changes.
