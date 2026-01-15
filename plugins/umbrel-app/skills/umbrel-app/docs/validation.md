# Validation Checklist

> Source: https://github.com/getumbrel/umbrel-apps/blob/master/README.md

## File Structure

- [ ] `docker-compose.yml` exists
- [ ] `umbrel-app.yml` exists
- [ ] `exports.sh` exists

## docker-compose.yml

- [ ] Version is "3.7"
- [ ] `app_proxy` service with `APP_HOST` and `APP_PORT`
- [ ] Image uses SHA256 digest (`@sha256:`)
- [ ] `restart: on-failure` set
- [ ] `stop_grace_period` set
- [ ] Volumes use `${APP_DATA_DIR}`
- [ ] No hardcoded IPs

## umbrel-app.yml

- [ ] `manifestVersion` is 1 or 1.1
- [ ] `id` is lowercase alphanumeric with dashes
- [ ] `id` matches directory name
- [ ] Valid `category`
- [ ] `version` follows semver
- [ ] `port` matches docker-compose
- [ ] `gallery` has 3-5 images
- [ ] `submitter` present

## Critical Issues

- Image without SHA256 digest
- Missing `app_proxy` service
- Wrong `APP_HOST` format
- Port mismatch
- Hardcoded secrets
