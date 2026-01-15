# Agent-Browser CDP Mode

> Source: https://agent-browser.dev/cdp-mode

## Overview

CDP (Chrome DevTools Protocol) Mode enables connection to existing browsers rather than launching new instances.

## Connection Examples

### Electron Application Connection

```bash
agent-browser --cdp 9222 snapshot
```

### Chrome with Remote Debugging

Start Chrome with remote debugging enabled:

```bash
google-chrome --remote-debugging-port=9222
```

Then connect:

```bash
agent-browser --cdp 9222 open about:blank
```

## Supported Environments

CDP Mode enables control of:

- Electron applications
- Chrome/Chromium instances with remote debugging enabled
- WebView2 applications
- Any browser exposing a CDP endpoint

## Global Options

| Option | Purpose |
|--------|---------|
| `--session <name>` | Use isolated session |
| `--headers <json>` | HTTP headers scoped to origin |
| `--executable-path` | Custom browser executable |
| `--json` | JSON output for agents |
| `--full, -f` | Full page screenshot |
| `--name, -n` | Locator name filter |
| `--exact` | Exact text match |
| `--headed` | Show browser window |
| `--cdp <port>` | CDP connection port |
| `--debug` | Debug output |
