# Agent-Browser Snapshots

> Source: https://agent-browser.dev/snapshots

## Overview

The `snapshot` command retrieves the accessibility tree with refs designed for AI-friendly interaction with web pages.

## Command Options

| Flag | Description |
|------|-------------|
| `-i, --interactive` | Only interactive elements (buttons, links, inputs) |
| `-c, --compact` | Remove empty structural elements |
| `-d, --depth` | Limit tree depth |
| `-s, --selector` | Scope to CSS selector |

## Usage Examples

```bash
agent-browser snapshot                    # Full accessibility tree
agent-browser snapshot -i                 # Interactive elements only
agent-browser snapshot -c                 # Compact (remove empty elements)
agent-browser snapshot -d 3               # Limit depth to 3 levels
agent-browser snapshot -s "#main"         # Scope to CSS selector
agent-browser snapshot -i -c -d 5         # Combine options
```

## Output Format

Standard text output example:

```
agent-browser snapshot
# Output:
# - heading "Example Domain" [ref=e1] [level=1]
# - button "Submit" [ref=e2]
# - textbox "Email" [ref=e3]
# - link "Learn more" [ref=e4]
```

## JSON Output

Using the `--json` flag produces machine-readable output:

```bash
agent-browser snapshot --json
# {"success":true,"data":{"snapshot":"...","refs":{"e1":{"role":"heading","name":"Title"},...}}}
```

## Best Practices

1. Use `-i` to reduce output to actionable elements
2. Use `--json` for structured parsing
3. Re-snapshot after page changes to get updated refs
4. Scope with `-s` for specific page sections
