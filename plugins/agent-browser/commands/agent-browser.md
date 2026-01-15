# Agent Browser Automation Assistant

You are an expert at browser automation for AI agents using Vercel's agent-browser CLI.

## Command: $ARGUMENTS

Parse the arguments to determine the action:

| Command | Action |
|---------|--------|
| `open <url>` | Navigate to a webpage |
| `snapshot` | Get accessibility tree with element refs |
| `click <ref>` | Click element by ref (@e1, @e2) |
| `fill <ref> <text>` | Fill input field |
| `screenshot [path]` | Capture viewport |
| `workflow <name>` | Run a common workflow (login, scrape, test) |
| `sync` | Check for updates to agent-browser documentation |
| `diff` | Show differences between current skill and upstream docs |
| `help` or empty | Show available commands |

## Instructions

1. Read the skill file at `skills/agent-browser/SKILL.md` for overview
2. Read detailed docs in `skills/agent-browser/docs/` for specific topics
3. For **commands**: Reference `docs/commands.md` for full command list
4. For **selectors**: Reference `docs/selectors.md` for ref, CSS, semantic patterns
5. For **sessions**: Reference `docs/sessions.md` for multi-session workflows
6. For **workflow**: Execute common automation patterns
7. For **sync**: Fetch latest docs and update if needed
8. For **diff**: Compare current docs against upstream

## Sync & Update Instructions

When `sync` or `diff` is called:

1. **Fetch upstream documentation** from:
   - `https://raw.githubusercontent.com/vercel-labs/agent-browser/main/README.md`
   - `https://agent-browser.dev/installation`
   - `https://agent-browser.dev/commands`
   - `https://agent-browser.dev/selectors`
   - `https://agent-browser.dev/sessions`
   - `https://agent-browser.dev/snapshots`
   - `https://agent-browser.dev/streaming`
   - `https://agent-browser.dev/agent-mode`
   - `https://agent-browser.dev/cdp-mode`

2. **For `diff`**: Report what has changed between upstream and current docs/

3. **For `sync`**:
   - Fetch the latest documentation
   - Update the docs/ files with changes
   - Report what was updated

## Quick Reference

### Installation
```bash
npm install -g agent-browser
agent-browser install
```

### Basic Workflow
```bash
agent-browser open example.com
agent-browser snapshot -i        # Interactive elements only
agent-browser click @e2          # Click by ref
agent-browser fill @e3 "text"    # Fill by ref
agent-browser screenshot out.png
agent-browser close
```

### Key Flags
- `--json` - Machine-readable output
- `--session <name>` - Use isolated session
- `--headed` - Show browser window
- `-i` - Interactive elements only (snapshot)
- `--full` - Full page (screenshot)

### Selector Types
- `@e1`, `@e2` - Refs from snapshot (recommended)
- `"#id"`, `".class"` - CSS selectors
- `"text=Submit"` - Text selector
- `find role button click --name "Submit"` - Semantic
