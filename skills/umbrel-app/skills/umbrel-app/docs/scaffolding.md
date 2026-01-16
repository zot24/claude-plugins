# App Scaffolding

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

## Required Information

When creating a new app, gather:
- **App name**: Human-readable (e.g., "BTC RPC Explorer")
- **App ID**: Lowercase with dashes (e.g., "btc-rpc-explorer")
- **Category**: `files`, `finance`, `media`, `networking`, `social`, `automation`, `developer`, `gaming`
- **Docker image**: Repository and tag
- **Port**: Web UI port
- **Dependencies**: Required apps (bitcoin, lightning, electrs)

## Directory Structure

```
<app-id>/
├── docker-compose.yml
├── umbrel-app.yml
└── exports.sh
```

## docker-compose.yml Template

```yaml
version: "3.7"

services:
  app_proxy:
    environment:
      APP_HOST: <app-id>_web_1
      APP_PORT: <port>
      # PROXY_AUTH_ADD: "false"  # Disable auth
      # PROXY_AUTH_WHITELIST: "/api/*"  # Protect only these
      # PROXY_AUTH_BLACKLIST: "/admin/*"  # Unprotect these

  web:
    image: <image>:<tag>@sha256:<digest>
    restart: on-failure
    stop_grace_period: 1m
    volumes:
      - ${APP_DATA_DIR}/data:/data
    environment:
      PORT: <port>
```

## umbrel-app.yml Template

```yaml
manifestVersion: 1
id: <app-id>
category: <category>
name: <App Name>
version: "1.0.0"
tagline: <Short description>
description: >-
  <Detailed description>
releaseNotes: >-
  Initial release.
developer: <Developer Name>
website: <https://example.com>
dependencies: []
repo: <https://github.com/user/repo>
support: <https://github.com/user/repo/issues>
port: <port>
gallery:
  - 1.jpg
  - 2.jpg
  - 3.jpg
path: ""
defaultUsername: ""
defaultPassword: ""
submitter: <Your Name>
submission: https://github.com/getumbrel/umbrel-apps/pull/XXX
```

## exports.sh Template

```bash
# Export environment variables for other apps
# export APP_<APP_ID_UPPERCASE>_VARIABLE="value"
```

## Valid Categories

`files`, `finance`, `media`, `networking`, `social`, `automation`, `developer`, `gaming`
