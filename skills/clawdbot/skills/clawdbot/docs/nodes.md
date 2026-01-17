<!-- Source: https://docs.clawd.bot/nodes/ -->

# Clawdbot Nodes & Media

Guide to mobile/desktop nodes and media capabilities.

## Overview

Nodes extend Clawdbot's capabilities:
- **iOS Node**: iPhone/iPad app
- **Android Node**: Android app
- **macOS Node**: Native Mac app

Nodes connect via Bridge protocol and expose device-specific commands.

---

## Camera

```json
{
  "tools": {
    "camera": { "enabled": true, "quality": "high", "format": "jpeg" }
  }
}
```

| Command | Description |
|---------|-------------|
| `camera.capture` | Take a photo |
| `camera.video` | Record video |
| `camera.stream` | Start live stream |

---

## Images

```json
{
  "tools": {
    "images": { "enabled": true, "maxSize": "10MB", "formats": ["jpeg", "png", "webp"] }
  }
}
```

| Command | Description |
|---------|-------------|
| `image.analyze` | Analyze image content |
| `image.resize` | Resize image |
| `image.ocr` | Extract text |

---

## Audio

```json
{
  "tools": {
    "audio": { "enabled": true, "format": "mp3", "sampleRate": 44100, "maxDuration": 300 }
  }
}
```

| Command | Description |
|---------|-------------|
| `audio.record` | Record audio |
| `audio.play` | Play audio |
| `audio.transcribe` | Speech-to-text |
| `audio.synthesize` | Text-to-speech |

---

## Location

```json
{
  "tools": {
    "location": { "enabled": true, "accuracy": "high", "timeout": 10000 }
  }
}
```

| Command | Description |
|---------|-------------|
| `location.get` | Get current location |
| `location.watch` | Track location changes |
| `location.geocode` | Address to coordinates |
| `location.reverse` | Coordinates to address |

---

## Voice Wake

Wake word detection for hands-free activation.

```json
{
  "nodes": {
    "voiceWake": {
      "enabled": true,
      "wakeWord": "hey clawd",
      "sensitivity": 0.5,
      "wakeWords": ["hey clawd", "ok clawd", "clawd"]
    }
  }
}
```

---

## Talk Mode

Continuous voice conversation mode.

```json
{
  "nodes": {
    "talkMode": {
      "enabled": true,
      "voiceInput": true,
      "voiceOutput": true,
      "voice": "nova",
      "autoListen": true
    }
  }
}
```

```bash
clawdbot talk
```

### Voice Options

`alloy` (neutral), `echo` (male), `fable` (female British), `onyx` (deep male), `nova` (female), `shimmer` (female expressive)

---

## Canvas Tools

```json
{
  "nodes": {
    "canvas": { "enabled": true, "defaultColor": "#000000", "defaultStroke": 2 }
  }
}
```

Commands: `canvas.draw`, `canvas.annotate`, `canvas.clear`, `canvas.export`

---

## Screen Recording

macOS only. Requires Screen Recording permission.

```json
{
  "nodes": {
    "screen": { "enabled": true, "format": "mp4", "quality": "high" }
  }
}
```

Commands: `screen.record`, `screen.screenshot`

---

## Node Connection

### Bridge Protocol

```json
{"type":"bridge.hello","nodeId":"iphone-xyz","capabilities":["camera","location","audio"]}
```

```bash
clawdbot nodes list
clawdbot nodes info <node-id>
```

```json
{
  "nodes": {
    "allowedNodes": ["iphone-xyz", "macbook-abc"],
    "requirePairing": true
  }
}
```

---

## Upstream Sources

- https://docs.clawd.bot/nodes/camera
- https://docs.clawd.bot/nodes/images
- https://docs.clawd.bot/nodes/audio
- https://docs.clawd.bot/nodes/location
- https://docs.clawd.bot/nodes/voice-wake
- https://docs.clawd.bot/nodes/talk
