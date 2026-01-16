# Docker-to-Umbrel Conversion

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

## Environment Variable Mapping

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

## Get Image Digest

```bash
docker pull <image>:<tag>
docker inspect --format='{{index .RepoDigests 0}}' <image>:<tag>
```

## Available Environment Variables

### System
- `$DEVICE_HOSTNAME`
- `$DEVICE_DOMAIN_NAME`

### Tor
- `$TOR_PROXY_IP`
- `$TOR_PROXY_PORT`

### App
- `$APP_HIDDEN_SERVICE`
- `$APP_PASSWORD`
- `$APP_SEED`
- `$APP_DATA_DIR`

### Bitcoin
- `$APP_BITCOIN_NODE_IP`
- `$APP_BITCOIN_RPC_PORT`
- `$APP_BITCOIN_RPC_USER`
- `$APP_BITCOIN_RPC_PASS`
- `$APP_BITCOIN_DATA_DIR`

### Lightning
- `$APP_LIGHTNING_NODE_IP`
- `$APP_LIGHTNING_NODE_GRPC_PORT`
- `$APP_LIGHTNING_NODE_REST_PORT`
- `$APP_LIGHTNING_NODE_DATA_DIR`

### Electrs
- `$APP_ELECTRS_NODE_IP`
- `$APP_ELECTRS_NODE_PORT`
