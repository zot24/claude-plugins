# Community App Stores

> Source: https://github.com/getumbrel/umbrel-community-app-store

Community App Stores allow you to distribute apps without submitting to the official Umbrel App Store.

## Creating a Community App Store

1. Use the template: https://github.com/getumbrel/umbrel-community-app-store
2. Create `umbrel-app-store.yml`:
```yaml
id: "mystore"  # Unique prefix for all apps
name: "My Store"  # Displays as "My Store Community App Store"
```
3. App folders must be prefixed with store ID: `mystore-myapp/`

## CRITICAL: Icon & Gallery Handling

**Icons DO NOT work from the app folder in community stores!**

Umbrel tries to fetch icons from the official gallery repo, causing broken icons.
See: https://github.com/getumbrel/umbrel/issues/1998

**Workaround:** Use a separate gallery repository with full URLs.

### Step 1: Create Gallery Repository

Create a repo like `username/umbrel-apps-gallery`:
```
umbrel-apps-gallery/
└── mystore-myapp/
    ├── icon.png      # 256x256 PNG (or SVG)
    ├── 1.jpg         # 1440x900 gallery image
    ├── 2.jpg
    └── 3.jpg
```

### Step 2: Add `icon:` Field to umbrel-app.yml

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

## Adding Community Store to Umbrel

### Via UI
App Store → Community App Stores → Add URL

### Via CLI
```bash
ssh umbrel@umbrel.local
sudo ~/umbrel/scripts/repo add https://github.com/username/umbrel-apps.git
sudo ~/umbrel/scripts/repo update
```

## Official App Store

- **URL**: https://apps.umbrel.com/
- **Repository**: https://github.com/getumbrel/umbrel-apps
- Pre-vetted apps, maintained by Umbrel team

## Example Community Stores

| Store | Repository | Focus |
|-------|------------|-------|
| Alby | https://github.com/getAlby/umbrel-community-app-store | Lightning apps |
| Denny's | https://github.com/dennysubke/dennys-umbrel-app-store | Various utilities |

## Trust & Safety

- Community apps are NOT reviewed by Umbrel team
- Review the app's source code before installing
- Check the store maintainer's reputation
- Community apps have full access to your system
