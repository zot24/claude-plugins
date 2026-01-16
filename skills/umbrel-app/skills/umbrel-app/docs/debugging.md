# Debugging

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

## Common Issues

### App won't install
- Invalid YAML syntax
- Image not available for architecture
- Missing dependencies
- Port conflict

### Bad Gateway
- Wrong `APP_HOST`
- Wrong `APP_PORT`
- App not fully started

### Data not persisting
- Volumes not mounted
- Wrong path (not `${APP_DATA_DIR}`)

## Debug Commands

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

## Common Error Patterns

| Symptom | Likely Cause | Debug Command | Fix |
|---------|--------------|---------------|-----|
| App "Not running" | Container crash | `docker logs <container>` | Restart or reinstall |
| "Bad Gateway" | Wrong APP_HOST/PORT | Check docker-compose.yml | Fix proxy config |
| "could not connect" | Dependency not running | `docker ps` | Start dependency first |
| Disk full | Storage exhausted | `df -h` | Clean up or expand |
| Slow performance | Memory pressure | `free -h` | Reduce running apps |

## Deployment Troubleshooting

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
