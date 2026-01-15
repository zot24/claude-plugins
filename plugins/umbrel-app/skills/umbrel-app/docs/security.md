# App Security & Authentication

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

Protect apps that don't have built-in login with Umbrel's authentication layer.

## Built-in App Proxy (Recommended)

Umbrel's `app_proxy` automatically protects apps with Umbrel password + optional 2FA.

**Default behavior**: All apps require Umbrel login
**How it works**: Every HTTP/WebSocket request validates session tokens

### Verifying Protection is Enabled

Check the app's `docker-compose.yml`:

```yaml
services:
  app_proxy:
    environment:
      # Auth is ON by default - only these vars change it:
      # PROXY_AUTH_ADD: "false"  # DISABLES auth (remove to enable)
      # PROXY_AUTH_WHITELIST: "/api/*"  # Exempt specific paths
      # PROXY_AUTH_BLACKLIST: "/admin/*"  # Require auth for specific paths
```

### If App is Unprotected

1. Check `docker-compose.yml` for `PROXY_AUTH_ADD: "false"`
2. Remove or set to `"true"` to enable authentication
3. Reinstall the app:

```bash
umbreld client apps.uninstall.mutate --appId <app-id>
umbreld client apps.install.mutate --appId <app-id>
```

### Path-based Authentication

| Scenario | Configuration |
|----------|---------------|
| Protect entire app (default) | No config needed |
| Disable auth completely | `PROXY_AUTH_ADD: "false"` |
| Public root, protected admin | `PROXY_AUTH_BLACKLIST: "/admin/*"` |
| Protected root, public API | `PROXY_AUTH_WHITELIST: "/api/*"` |

## Additional Security with Nginx Proxy Manager

For apps needing extra protection layers:

1. Install **Nginx Proxy Manager** from Umbrel App Store
2. Features:
   - Access Lists (restrict by IP/subnet)
   - Basic HTTP Authentication (additional password layer)
   - Free SSL via Let's Encrypt

## Zoraxy for IP-based Restrictions

1. Install **Zoraxy** from Umbrel App Store
2. Features:
   - Geo-IP based blocking/allowing
   - IP blacklisting/whitelisting
   - Rate limiting

## External SSO Solutions

For advanced use cases requiring SSO/MFA across multiple apps:

| Solution | Use Case | Complexity | Resources |
|----------|----------|------------|-----------|
| Authelia | Lightweight MFA portal | Medium | < 30MB RAM |
| Authentik | Full identity provider | High | GUI, SAML/OIDC |

**Note**: These are NOT in the Umbrel app store and require manual Docker deployment.

## Diagnosing Unprotected Apps

```bash
# SSH into Umbrel
ssh umbrel@umbrel.local

# Check app's docker-compose for auth settings
cat ~/umbrel/app-stores/*/<app-id>/docker-compose.yml | grep -A5 "app_proxy"

# If PROXY_AUTH_ADD is "false", that's why it's unprotected
# Look for: PROXY_AUTH_ADD: "false"
```

## Security Checklist

- [ ] Verify `app_proxy` service is present in docker-compose.yml
- [ ] Check `PROXY_AUTH_ADD` is not set to "false"
- [ ] Enable 2FA in Umbrel settings for extra protection
- [ ] For internet-exposed apps, add NPM Access Lists
- [ ] Never expose sensitive apps without authentication
