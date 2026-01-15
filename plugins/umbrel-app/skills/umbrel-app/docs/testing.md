# Testing

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

## Local Docker Testing (RECOMMENDED FIRST STEP)

**Always test Docker images locally before deploying to Umbrel!**

This catches issues like missing UI builds, wrong ports, or configuration errors before wasting time on Umbrel reinstalls.

```bash
# 1. Pull the image
docker pull <image>@sha256:<digest>

# 2. Run locally with minimal config
docker run -d --name test-app \
  -p <port>:<port> \
  -e REQUIRED_ENV_VAR=test \
  <image>@sha256:<digest>

# 3. Wait for startup, check logs
sleep 5
docker logs test-app

# 4. Test HTTP endpoints
curl -s -o /dev/null -w "%{http_code}" http://localhost:<port>/
curl -s http://localhost:<port>/ | head -20  # Check content

# 5. Clean up
docker stop test-app && docker rm test-app
```

## What to Verify

- Container starts without errors
- HTTP endpoints return 200
- UI assets load (check HTML for JS/CSS references)
- No "file not found" or build errors in logs

## Common Issues Caught by Local Testing

- Missing build steps (e.g., `pnpm ui:build`)
- Wrong port bindings
- Missing environment variables
- Container crash loops
- HTTP vs TCP/WebSocket confusion

## Dev Environment

```bash
# Clone and start
git clone https://github.com/getumbrel/umbrel.git
cd umbrel && npm run dev

# Copy app
rsync -av <app-id>/ umbrel@umbrel-dev.local:/home/umbrel/umbrel/app-stores/getumbrel-umbrel-apps-github-53f74447/<app-id>/

# Install
npm run dev client -- apps.install.mutate -- --appId <app-id>
```

## Physical Device

```bash
rsync -av <app-id>/ umbrel@umbrel.local:/home/umbrel/umbrel/app-stores/getumbrel-umbrel-apps-github-53f74447/<app-id>/
ssh umbrel@umbrel.local
umbreld client apps.install.mutate --appId <app-id>
```
