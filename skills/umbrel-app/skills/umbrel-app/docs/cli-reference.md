# Umbrel CLI Reference

> Source: https://github.com/getumbrel/umbrel

Complete command reference for managing umbrelOS systems and apps.

## System Commands

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

## App Management Commands

```bash
# List & Discover
umbrel app list           # List all installed apps

# Install & Uninstall
umbrel app install <app-id>     # Install an app
umbrel app uninstall <app-id>   # Uninstall an app
```

## umbreld Client Commands

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

## SSH Access

```bash
# Default credentials
ssh umbrel@umbrel.local
# Password: your Umbrel dashboard password

# Alternative hostnames
ssh umbrel@umbrel.local      # mDNS
ssh umbrel@<ip-address>      # Direct IP
```

## File System Paths

```bash
~/umbrel/                    # Main Umbrel directory
~/umbrel/app-data/<app-id>/  # App persistent data
~/umbrel/app-stores/         # App store repositories
~/umbrel/scripts/            # System scripts
~/umbrel/scripts/debug       # Debug script
```
