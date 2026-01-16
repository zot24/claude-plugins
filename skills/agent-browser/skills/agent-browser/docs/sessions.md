# Agent-Browser Sessions

> Source: https://agent-browser.dev/sessions

## Overview

The Sessions feature enables operation of multiple isolated browser instances simultaneously, each maintaining separate state and authentication contexts.

## Basic Usage

### Running different sessions

```bash
agent-browser --session agent1 open site-a.com
agent-browser --session agent2 open site-b.com
```

### Via environment variable

```bash
AGENT_BROWSER_SESSION=agent1 agent-browser click "#btn"
```

### List active sessions

```bash
agent-browser session list
# Output:
# Active sessions:
# -> default
#    agent1
```

### Show current session

```bash
agent-browser session
```

## Session Isolation

Each session maintains independent state:

- Browser instance
- Cookies and storage
- Navigation history
- Authentication state

## Authenticated Sessions

Set HTTP headers scoped to specific origins using the `--headers` flag:

```bash
agent-browser open api.example.com --headers '{"Authorization": "Bearer <token>"}'
agent-browser snapshot -i --json
agent-browser click @e2
agent-browser open other-site.com
```

**Key behavior:** Headers apply only to the specified origin and are not transmitted to other domains.

### Use cases

- Skip login flows through header-based authentication
- Manage multiple users with different tokens per session
- Test protected API endpoints
- Maintain security by limiting header scope to specific origins

## Multiple Origins

Handle different authentication tokens across various domains:

```bash
agent-browser open api.example.com --headers '{"Authorization": "Bearer token1"}'
agent-browser open api.acme.com --headers '{"Authorization": "Bearer token2"}'
```

## Global Headers

Apply headers across all domains:

```bash
agent-browser set headers '{"X-Custom-Header": "value"}'
```
