---
name: umbrel-app
description: Expert Umbrel app developer. Use when the user wants to create, package, validate, test, debug, or submit apps for umbrelOS. Triggers on mentions of Umbrel apps, umbrelOS, app packaging, or Docker-to-Umbrel conversion.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Umbrel App Development Skill

You are an expert at developing, packaging, testing, and submitting apps for umbrelOS. This skill covers the complete lifecycle of Umbrel app development.

## Core Capabilities

1. **Scaffold** - Create new apps from scratch with proper structure
2. **Validate** - Check apps for 20+ common issues
3. **Convert** - Transform Docker Compose apps to Umbrel format
4. **PR Generation** - Create submission-ready PR content
5. **Debug** - Troubleshoot installation and runtime issues

---

## 1. APP SCAFFOLDING

When creating a new app, gather:
- **App name**: Human-readable (e.g., "BTC RPC Explorer")
- **App ID**: Lowercase with dashes (e.g., "btc-rpc-explorer")
- **Category**: `files`, `finance`, `media`, `networking`, `social`, `automation`, `developer`, `gaming`
- **Docker image**: Repository and tag
- **Port**: Web UI port
- **Dependencies**: Required apps (bitcoin, lightning, electrs)

### Directory Structure

```
<app-id>/
├── docker-compose.yml
├── umbrel-app.yml
└── exports.sh
```

### docker-compose.yml Template

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

### umbrel-app.yml Template

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

### exports.sh Template

```bash
# Export environment variables for other apps
# export APP_<APP_ID_UPPERCASE>_VARIABLE="value"
```

---

## 2. VALIDATION CHECKLIST

### File Structure
- [ ] `docker-compose.yml` exists
- [ ] `umbrel-app.yml` exists
- [ ] `exports.sh` exists

### docker-compose.yml
- [ ] Version is "3.7"
- [ ] `app_proxy` service with `APP_HOST` and `APP_PORT`
- [ ] Image uses SHA256 digest (`@sha256:`)
- [ ] `restart: on-failure` set
- [ ] `stop_grace_period` set
- [ ] Volumes use `${APP_DATA_DIR}`
- [ ] No hardcoded IPs

### umbrel-app.yml
- [ ] `manifestVersion` is 1 or 1.1
- [ ] `id` is lowercase alphanumeric with dashes
- [ ] `id` matches directory name
- [ ] Valid `category`
- [ ] `version` follows semver
- [ ] `port` matches docker-compose
- [ ] `gallery` has 3-5 images
- [ ] `submitter` present

### Critical Issues
- Image without SHA256 digest
- Missing `app_proxy` service
- Wrong `APP_HOST` format
- Port mismatch
- Hardcoded secrets

---

## 3. DOCKER-TO-UMBREL CONVERSION

### Environment Variable Mapping

| Original | Umbrel Variable |
|----------|-----------------|
| Bitcoin RPC host | `$APP_BITCOIN_NODE_IP` |
| Bitcoin RPC port | `$APP_BITCOIN_RPC_PORT` |
| Bitcoin RPC user | `$APP_BITCOIN_RPC_USER` |
| Bitcoin RPC pass | `$APP_BITCOIN_RPC_PASS` |
| LND host | `$APP_LIGHTNING_NODE_IP` |
| LND gRPC port | `$APP_LIGHTNING_NODE_GRPC_PORT` |
| LND REST port | `$APP_LIGHTNING_NODE_REST_PORT` |
| Electrum host | `$APP_ELECTRS_NODE_IP` |
| Electrum port | `$APP_ELECTRS_NODE_PORT` |
| Tor proxy | `$TOR_PROXY_IP:$TOR_PROXY_PORT` |

### Get Image Digest

```bash
docker pull <image>:<tag>
docker inspect --format='{{index .RepoDigests 0}}' <image>:<tag>
```

---

## 4. PR SUBMISSION

### Required Assets
- 256x256 SVG icon (no rounded corners)
- 3-5 gallery images at 1440x900px PNG

### PR Template

```markdown
# App Submission

### App name
<Name>

### 256x256 SVG icon
<!-- Upload here -->

### Gallery images (1440x900 PNG)
<!-- Upload 3-5 screenshots -->

### Tested on:
- [ ] Raspberry Pi 4/5
- [ ] x86 hardware
- [ ] Linux VM
- [ ] Umbrel Home
- [ ] umbrel-dev

### Checklist
- [ ] docker-compose.yml includes app_proxy
- [ ] Docker images use SHA256 digests
- [ ] umbrel-app.yml complete
- [ ] Icon is 256x256 SVG
- [ ] 3-5 gallery images
- [ ] Persistent data uses ${APP_DATA_DIR}
```

---

## 5. COMMUNITY APP STORES

Community App Stores allow you to distribute apps without submitting to the official Umbrel App Store.

### Creating a Community App Store

1. Use the template: https://github.com/getumbrel/umbrel-community-app-store
2. Create `umbrel-app-store.yml`:
```yaml
id: "mystore"  # Unique prefix for all apps
name: "My Store"  # Displays as "My Store Community App Store"
```
3. App folders must be prefixed with store ID: `mystore-myapp/`

### CRITICAL: Icon & Gallery Handling

**Icons DO NOT work from the app folder in community stores!**

Umbrel tries to fetch icons from the official gallery repo, causing broken icons.
See: https://github.com/getumbrel/umbrel/issues/1998

**Workaround:** Use a separate gallery repository with full URLs.

#### Step 1: Create Gallery Repository

Create a repo like `username/umbrel-apps-gallery`:
```
umbrel-apps-gallery/
└── mystore-myapp/
    ├── icon.png      # 256x256 PNG (or SVG)
    ├── 1.jpg         # 1440x900 gallery image
    ├── 2.jpg
    └── 3.jpg
```

#### Step 2: Add `icon:` Field to umbrel-app.yml

```yaml
manifestVersion: 1
id: mystore-myapp
name: My App
icon: https://raw.githubusercontent.com/username/umbrel-apps-gallery/main/mystore-myapp/icon.png
category: automation
# ... rest of manifest
gallery:
  - https://raw.githubusercontent.com/username/umbrel-apps-gallery/main/mystore-myapp/1.jpg
  - https://raw.githubusercontent.com/username/umbrel-apps-gallery/main/mystore-myapp/2.jpg
  - https://raw.githubusercontent.com/username/umbrel-apps-gallery/main/mystore-myapp/3.jpg
```

**Key points:**
- Use full raw GitHub URLs for `icon:` and `gallery:` fields
- PNG works fine (doesn't have to be SVG)
- The `icon:` field is NOT in the official template but IS required for community stores

### Adding Community Store to Umbrel

```bash
# Via UI: App Store → Community App Stores → Add URL
# Via CLI:
ssh umbrel@umbrel.local
sudo ~/umbrel/scripts/repo add https://github.com/username/umbrel-apps.git
sudo ~/umbrel/scripts/repo update
```

---

## 6. DEBUGGING

### Common Issues

**App won't install:**
- Invalid YAML syntax
- Image not available for architecture
- Missing dependencies
- Port conflict

**Bad Gateway:**
- Wrong `APP_HOST`
- Wrong `APP_PORT`
- App not fully started

**Data not persisting:**
- Volumes not mounted
- Wrong path (not `${APP_DATA_DIR}`)

### Debug Commands

```bash
# SSH into Umbrel
ssh umbrel@umbrel.local

# View logs
docker logs <container-name>
umbreld client apps.logs --appId <app-id>

# Enter container
docker exec -it <container-name> /bin/sh

# Check app data
ls -la ~/umbrel/app-data/<app-id>/

# Restart/Reinstall
umbreld client apps.restart.mutate --appId <app-id>
umbreld client apps.uninstall.mutate --appId <app-id>
umbreld client apps.install.mutate --appId <app-id>
```

---

## 7. TESTING

### Local Docker Testing (RECOMMENDED FIRST STEP)

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

**What to verify:**
- Container starts without errors
- HTTP endpoints return 200
- UI assets load (check HTML for JS/CSS references)
- No "file not found" or build errors in logs

**Common issues caught by local testing:**
- Missing build steps (e.g., `pnpm ui:build`)
- Wrong port bindings
- Missing environment variables
- Container crash loops
- HTTP vs TCP/WebSocket confusion

### Dev Environment

```bash
# Clone and start
git clone https://github.com/getumbrel/umbrel.git
cd umbrel && npm run dev

# Copy app
rsync -av <app-id>/ umbrel@umbrel-dev.local:/home/umbrel/umbrel/app-stores/getumbrel-umbrel-apps-github-53f74447/<app-id>/

# Install
npm run dev client -- apps.install.mutate -- --appId <app-id>
```

### Physical Device

```bash
rsync -av <app-id>/ umbrel@umbrel.local:/home/umbrel/umbrel/app-stores/getumbrel-umbrel-apps-github-53f74447/<app-id>/
ssh umbrel@umbrel.local
umbreld client apps.install.mutate --appId <app-id>
```

---

## Available Environment Variables

**System:** `$DEVICE_HOSTNAME`, `$DEVICE_DOMAIN_NAME`

**Tor:** `$TOR_PROXY_IP`, `$TOR_PROXY_PORT`

**App:** `$APP_HIDDEN_SERVICE`, `$APP_PASSWORD`, `$APP_SEED`, `$APP_DATA_DIR`

**Bitcoin:** `$APP_BITCOIN_NODE_IP`, `$APP_BITCOIN_RPC_PORT`, `$APP_BITCOIN_RPC_USER`, `$APP_BITCOIN_RPC_PASS`, `$APP_BITCOIN_DATA_DIR`

**Lightning:** `$APP_LIGHTNING_NODE_IP`, `$APP_LIGHTNING_NODE_GRPC_PORT`, `$APP_LIGHTNING_NODE_REST_PORT`, `$APP_LIGHTNING_NODE_DATA_DIR`

**Electrs:** `$APP_ELECTRS_NODE_IP`, `$APP_ELECTRS_NODE_PORT`

---

## Valid Categories

`files`, `finance`, `media`, `networking`, `social`, `automation`, `developer`, `gaming`

---

## 7. UMBREL CLI REFERENCE

Complete command reference for managing umbrelOS systems and apps.

### System Commands

```bash
# Start/Stop/Restart Umbrel
umbrel start              # Start Umbrel
umbrel stop               # Stop Umbrel
umbrel restart            # Restart Umbrel
umbrel start --debug      # Start in debug mode

# Status & Updates
umbrel status             # Check current status
umbrel update             # Update Umbrel
umbrel update check       # Check for available updates

# Backup & Recovery
umbrel backup             # Create manual backup
umbrel restore <file>     # Restore from backup file
umbrel reset              # Factory reset (DESTRUCTIVE - erases all data)
```

### App Management Commands

```bash
# List & Discover
umbrel app list           # List all installed apps

# Install & Uninstall
umbrel app install <app-id>     # Install an app
umbrel app uninstall <app-id>   # Uninstall an app
```

### umbreld Client Commands

Direct API commands via the umbreld client for fine-grained control:

```bash
# App Lifecycle
umbreld client apps.install.mutate --appId <app-id>
umbreld client apps.uninstall.mutate --appId <app-id>
umbreld client apps.start.mutate --appId <app-id>
umbreld client apps.stop.mutate --appId <app-id>
umbreld client apps.restart.mutate --appId <app-id>

# Monitoring
umbreld client apps.logs --appId <app-id>
umbreld client apps.state --appId <app-id>

# Container-Level Operations
docker ps                               # List running containers
docker ps --filter name=<app-id>        # Filter by app
docker logs <container-name>            # View container logs
docker logs -f <container-name>         # Follow logs in real-time
docker inspect <container-name>         # Full container details
docker exec -it <container-name> /bin/sh  # Shell into container
```

### SSH Access

```bash
# Default credentials
ssh umbrel@umbrel.local
# Password: your Umbrel dashboard password

# Alternative hostnames
ssh umbrel@umbrel.local      # mDNS
ssh umbrel@<ip-address>      # Direct IP
```

### File System Paths

```bash
~/umbrel/                    # Main Umbrel directory
~/umbrel/app-data/<app-id>/  # App persistent data
~/umbrel/app-stores/         # App store repositories
~/umbrel/scripts/            # System scripts
~/umbrel/scripts/debug       # Debug script
```

---

## 8. COMMUNITY APP STORES

Umbrel supports community-maintained app stores alongside the official store.

### Official App Store

- **URL**: https://apps.umbrel.com/
- **Repository**: https://github.com/getumbrel/umbrel-apps
- Pre-vetted apps, maintained by Umbrel team

### Adding Community Stores

1. Open umbrelOS web interface
2. Go to **App Store** → **Community App Stores**
3. Click **Add Community App Store**
4. Paste the GitHub repository URL (e.g., `https://github.com/username/umbrel-app-store`)
5. Apps from the community store will appear in your app store

### Creating Your Own Community Store

Template repository: https://github.com/getumbrel/umbrel-community-app-store

```bash
# Fork the template
# Each app follows the same structure as official apps:
my-community-store/
├── app-1/
│   ├── docker-compose.yml
│   ├── umbrel-app.yml
│   └── exports.sh
├── app-2/
│   └── ...
└── umbrel-app-store.yml  # Store manifest
```

### Store Manifest (umbrel-app-store.yml)

```yaml
id: my-store-id
name: My Community Store
```

### Example Community Stores

| Store | Repository | Focus |
|-------|------------|-------|
| Alby | https://github.com/getAlby/umbrel-community-app-store | Lightning apps |
| Denny's | https://github.com/dennysubke/dennys-umbrel-app-store | Various utilities |

### Listing Apps from Community Stores

```bash
# Via UI: Browse App Store, filter by store
# Community apps show their source store

# Installed apps from all stores
umbrel app list
```

### Installing from Community

```bash
# Same commands as official apps
umbrel app install <community-app-id>

# Or via umbreld client
umbreld client apps.install.mutate --appId <community-app-id>
```

### Trust & Safety

- Community apps are NOT reviewed by Umbrel team
- Review the app's source code before installing
- Check the store maintainer's reputation
- Community apps have full access to your system

---

## 9. AI AGENT OPERATIONS

Workflows for AI agents to manage and debug Umbrel systems.

### Debug Error on System

Step-by-step workflow for diagnosing issues:

```bash
# 1. Connect to the device
ssh umbrel@umbrel.local

# 2. Check overall system status
umbrel status

# 3. Check disk space (common issue)
df -h

# 4. List running containers
docker ps

# 5. Check specific app logs
umbreld client apps.logs --appId <app-id>

# 6. View detailed container logs
docker logs <container-name>
docker logs -f <container-name> --tail 100  # Last 100 lines, follow

# 7. Check container health
docker inspect <container-name> | grep -A 10 "Health"

# 8. Run system debug script
sudo ~/umbrel/scripts/debug

# 9. Remediation options
umbreld client apps.restart.mutate --appId <app-id>  # Restart app
umbreld client apps.uninstall.mutate --appId <app-id>  # Uninstall
umbreld client apps.install.mutate --appId <app-id>    # Reinstall
```

### Common Error Patterns

| Symptom | Likely Cause | Debug Command | Fix |
|---------|--------------|---------------|-----|
| App "Not running" | Container crash | `docker logs <container>` | Restart or reinstall |
| "Bad Gateway" | Wrong APP_HOST/PORT | Check docker-compose.yml | Fix proxy config |
| "could not connect" | Dependency not running | `docker ps` | Start dependency first |
| Disk full | Storage exhausted | `df -h` | Clean up or expand |
| Slow performance | Memory pressure | `free -h` | Reduce running apps |

### App Lifecycle Management

```bash
# Check what's installed
umbrel app list

# Full reinstall cycle
umbreld client apps.stop.mutate --appId <app-id>
umbreld client apps.uninstall.mutate --appId <app-id>
# Wait a few seconds
umbreld client apps.install.mutate --appId <app-id>

# Verify app is running
docker ps --filter name=<app-id>
umbreld client apps.state --appId <app-id>
```

### Deployment Troubleshooting

```bash
# 1. Verify app files exist
ls -la ~/umbrel/app-stores/*/

# 2. Validate YAML syntax
cat ~/umbrel/app-stores/*/my-app/docker-compose.yml | python3 -c "import sys,yaml; yaml.safe_load(sys.stdin)"

# 3. Check image availability
docker pull <image>@sha256:<digest>

# 4. Verify port not in use
docker ps --format "{{.Ports}}" | grep <port>
netstat -tlnp | grep <port>

# 5. Check dependencies are installed
umbrel app list | grep <dependency-app-id>
```

### Batch Operations

```bash
# Restart all apps (use sparingly)
for app in $(umbrel app list | awk '{print $1}'); do
  umbreld client apps.restart.mutate --appId $app
done

# Check all container statuses
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Get logs from all containers for specific app
docker ps --filter name=<app-id> -q | xargs -I {} docker logs {}
```

### Health Check Workflow

```bash
# Quick health assessment
ssh umbrel@umbrel.local << 'EOF'
echo "=== System Status ==="
umbrel status

echo "=== Disk Usage ==="
df -h | grep -E "^/dev|Filesystem"

echo "=== Memory ==="
free -h

echo "=== Running Containers ==="
docker ps --format "table {{.Names}}\t{{.Status}}"

echo "=== Recent Errors ==="
docker ps -q | xargs -I {} sh -c 'docker logs {} 2>&1 | tail -5' 2>/dev/null
EOF
```

---

## 10. SYNC & UPDATE

This skill should stay synchronized with the official Umbrel documentation.

### Upstream Source

```
https://raw.githubusercontent.com/getumbrel/umbrel-apps/master/README.md
```

### Sync Command

When user runs `sync`:

1. Use WebFetch to get the latest README from the URL above
2. Extract and compare key sections:
   - Dockerfile requirements
   - Directory structure
   - docker-compose.yml format
   - umbrel-app.yml manifest fields
   - Environment variables
   - Testing procedures
   - Submission requirements
3. Identify any differences from current skill
4. Update this SKILL.md file with new/changed information
5. Report changes to user

### Diff Command

When user runs `diff`:

1. Fetch the upstream documentation
2. Compare against current skill content
3. Report differences WITHOUT making changes
4. Highlight:
   - New requirements added upstream
   - Changed configurations or fields
   - Deprecated features
   - New environment variables
   - Updated commands

### Key Sections to Monitor

| Section | What to Check |
|---------|---------------|
| Dockerfile | Best practices, multi-arch support |
| docker-compose.yml | app_proxy config, version, services |
| umbrel-app.yml | Manifest fields, manifestVersion |
| Environment Variables | New vars, deprecated vars |
| Testing | Commands, dev environment setup |
| Submission | PR requirements, assets |

### Last Sync Info

Store sync metadata in the skill when updating:
- Last sync date
- Upstream commit/version if available
- Changes made
