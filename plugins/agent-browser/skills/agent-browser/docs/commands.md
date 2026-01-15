# Agent-Browser Command Reference

> Source: https://agent-browser.dev/commands

## Core Commands

Navigate and interact with pages:

| Command | Description |
|---------|-------------|
| `open <url>` | Navigate (aliases: goto, navigate) |
| `click <sel>` | Click element |
| `dblclick <sel>` | Double-click |
| `fill <sel> <text>` | Clear and fill input |
| `type <sel> <text>` | Type into element |
| `press <key>` | Press key (Enter, Tab, Control+a) |
| `hover <sel>` | Hover element |
| `select <sel> <val>` | Select dropdown option |
| `check <sel>` | Check checkbox |
| `uncheck <sel>` | Uncheck checkbox |
| `scroll <dir> [px]` | Scroll (up/down/left/right) |
| `screenshot [path]` | Screenshot (--full for full page) |
| `snapshot` | Accessibility tree with refs |
| `eval <js>` | Run JavaScript |
| `close` | Close browser |

## Get Info Commands

Retrieve page and element data:

| Command | Description |
|---------|-------------|
| `get text <sel>` | Get text content |
| `get html <sel>` | Get innerHTML |
| `get value <sel>` | Get input value |
| `get attr <sel> <attr>` | Get attribute |
| `get title` | Get page title |
| `get url` | Get current URL |
| `get count <sel>` | Count matching elements |
| `get box <sel>` | Get bounding box |

## Check State Commands

Verify element conditions:

| Command | Description |
|---------|-------------|
| `is visible <sel>` | Check if visible |
| `is enabled <sel>` | Check if enabled |
| `is checked <sel>` | Check if checked |

## Find Elements (Semantic Locators)

Query by role, text, label, placeholder, testid, or position:

```bash
agent-browser find role <role> <action> [value]
agent-browser find text <text> <action>
agent-browser find label <label> <action> [value]
agent-browser find placeholder <ph> <action> [value]
agent-browser find testid <id> <action> [value]
agent-browser find first <sel> <action> [value]
agent-browser find nth <n> <sel> <action> [value]
```

Actions: click, fill, check, hover, text

### Examples

```bash
agent-browser find role button click --name "Submit"
agent-browser find label "Email" fill "test@test.com"
agent-browser find first ".item" click
```

## Wait Commands

Control timing and conditions:

| Command | Description |
|---------|-------------|
| `wait <selector>` | Wait for element |
| `wait <ms>` | Wait for time |
| `wait --text "Welcome"` | Wait for text |
| `wait --url "**/dash"` | Wait for URL pattern |
| `wait --load networkidle` | Wait for load state |
| `wait --fn "condition"` | Wait for JS condition |

## Mouse Commands

Control mouse interactions:

| Command | Description |
|---------|-------------|
| `mouse move <x> <y>` | Move mouse |
| `mouse down [button]` | Press button |
| `mouse up [button]` | Release button |
| `mouse wheel <dy> [dx]` | Scroll wheel |

## Settings Commands

Configure browser behavior:

| Command | Description |
|---------|-------------|
| `set viewport <w> <h>` | Set viewport size |
| `set device <name>` | Emulate device (e.g., "iPhone 14") |
| `set geo <lat> <lng>` | Set geolocation |
| `set offline [on|off]` | Toggle offline mode |
| `set headers <json>` | Extra HTTP headers |
| `set credentials <u> <p>` | HTTP basic auth |
| `set media [dark|light]` | Emulate color scheme |

## Cookies & Storage Commands

Manage cookies and browser storage:

```bash
# Cookies
agent-browser cookies              # Get all cookies
agent-browser cookies set <name> <val>  # Set cookie
agent-browser cookies clear        # Clear cookies

# localStorage
agent-browser storage local        # Get all localStorage
agent-browser storage local <key>  # Get specific key
agent-browser storage local set <k> <v>  # Set value
agent-browser storage local clear  # Clear all

# sessionStorage (same commands)
agent-browser storage session
agent-browser storage session <key>
agent-browser storage session set <k> <v>
agent-browser storage session clear
```

## Network Commands

Intercept and mock requests:

| Command | Description |
|---------|-------------|
| `network route <url>` | Intercept requests |
| `network route <url> --abort` | Block requests |
| `network route <url> --body <json>` | Mock response |
| `network unroute [url]` | Remove routes |
| `network requests` | View tracked requests |

## Tabs & Frames Commands

Manage multiple tabs and iframes:

| Command | Description |
|---------|-------------|
| `tab` | List tabs |
| `tab new [url]` | New tab |
| `tab <n>` | Switch to tab |
| `tab close [n]` | Close tab |
| `frame <sel>` | Switch to iframe |
| `frame main` | Back to main frame |

## Debug Commands

Troubleshoot and inspect:

| Command | Description |
|---------|-------------|
| `trace start [path]` | Start trace |
| `trace stop [path]` | Stop and save trace |
| `console` | View console messages |
| `errors` | View page errors |
| `highlight <sel>` | Highlight element |
| `state save <path>` | Save auth state |
| `state load <path>` | Load auth state |

## Navigation Commands

Control browser history:

| Command | Description |
|---------|-------------|
| `back` | Go back |
| `forward` | Go forward |
| `reload` | Reload page |

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
