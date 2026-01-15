# Agent-Browser Quick Start

> Source: https://agent-browser.dev/quick-start

## Basic Workflow

The fundamental command sequence includes:

```bash
agent-browser open example.com              # Launch a website
agent-browser snapshot                       # Retrieve accessibility tree with refs
agent-browser click @e2                      # Click element by reference
agent-browser fill @e3 "test@example.com"   # Populate form fields
agent-browser get text @e1                   # Extract text content
agent-browser screenshot page.png            # Capture page image
agent-browser close                          # Terminate session
```

## Traditional Selectors

The tool supports standard web selectors alongside reference-based targeting:

```bash
agent-browser click "#submit"                            # CSS selector usage
agent-browser fill "#email" "test@example.com"          # Form field completion
agent-browser find role button click --name "Submit"    # Semantic locator pattern
```

## AI-Optimized Workflow

For AI agent integration:

1. Open site and capture snapshot with `-i --json` flags for machine-readable parsing
2. AI analyzes returned tree structure and identifies target references
3. Execute actions using element references (`@e2`, `@e3`, etc.)
4. Obtain refreshed snapshot after page modifications

```bash
# 1. Navigate and get snapshot
agent-browser open example.com
agent-browser snapshot -i --json

# 2. AI parses response, identifies refs
# 3. Execute actions
agent-browser click @e2
agent-browser fill @e3 "input text"

# 4. Re-snapshot after changes
agent-browser snapshot -i --json
```

## Display Modes

### Headed Mode

Display a visible browser window for debugging:

```bash
agent-browser open example.com --headed
```

### JSON Output

Append `--json` flag to commands for structured data responses:

```bash
agent-browser snapshot --json
agent-browser get text @e1 --json
agent-browser is visible @e2 --json
```
