# AI Agent Operations

Workflows for AI agents to manage and debug Umbrel systems.

## Debug Error on System

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

## App Lifecycle Management

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

## Batch Operations

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

## Health Check Workflow

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
