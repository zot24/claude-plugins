# PR Submission

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

## Required Assets

- 256x256 SVG icon (no rounded corners)
- 3-5 gallery images at 1440x900px PNG

## PR Template

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

## Submission Process

1. Fork https://github.com/getumbrel/umbrel-apps
2. Create your app directory
3. Add all required files
4. Open PR using the template above
5. Wait for review from Umbrel team
