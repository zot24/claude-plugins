---
name: clawdbot-nodes
description: Clawdbot nodes & media - camera, images, audio, location, voice wake, talk mode
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Nodes Expert

Guide to mobile/desktop nodes and media capabilities.

**Documentation**: https://docs.clawd.bot/nodes/

---

## Overview

Nodes are mobile and desktop clients that extend Clawdbot's capabilities:

- **iOS Node**: iPhone/iPad app
- **Android Node**: Android app
- **macOS Node**: Native Mac app
- **Desktop Node**: Cross-platform desktop

Nodes connect to the gateway via Bridge protocol and expose device-specific commands.

---

## Camera

### Capture Photo

```json
{
  "tools": {
    "camera": {
      "enabled": true,
      "quality": "high",
      "format": "jpeg"
    }
  }
}
```

### Camera Commands

| Command | Description |
|---------|-------------|
| `camera.capture` | Take a photo |
| `camera.video` | Record video |
| `camera.stream` | Start live stream |

### Usage in Skills

```javascript
// Capture photo
const photo = await node.camera.capture({
  quality: 'high',
  camera: 'back' // or 'front'
});

// Photo is returned as base64 or file path
```

### Camera Configuration

```json
{
  "nodes": {
    "camera": {
      "defaultCamera": "back",
      "defaultQuality": "high",
      "maxDuration": 60,
      "saveToGallery": false
    }
  }
}
```

---

## Images

### Image Processing

```json
{
  "tools": {
    "images": {
      "enabled": true,
      "maxSize": "10MB",
      "formats": ["jpeg", "png", "webp"]
    }
  }
}
```

### Image Commands

| Command | Description |
|---------|-------------|
| `image.analyze` | Analyze image content |
| `image.resize` | Resize image |
| `image.convert` | Convert format |
| `image.ocr` | Extract text |

### Image Analysis

```javascript
// Analyze image with vision model
const analysis = await node.images.analyze({
  image: photoData,
  prompt: "What's in this image?"
});
```

### OCR

```javascript
// Extract text from image
const text = await node.images.ocr({
  image: photoData,
  language: 'en'
});
```

---

## Audio

### Audio Recording

```json
{
  "tools": {
    "audio": {
      "enabled": true,
      "format": "mp3",
      "sampleRate": 44100,
      "maxDuration": 300
    }
  }
}
```

### Audio Commands

| Command | Description |
|---------|-------------|
| `audio.record` | Record audio |
| `audio.play` | Play audio |
| `audio.transcribe` | Speech-to-text |
| `audio.synthesize` | Text-to-speech |

### Speech-to-Text

```javascript
// Transcribe audio
const transcript = await node.audio.transcribe({
  audio: audioData,
  language: 'en'
});
```

### Text-to-Speech

```javascript
// Generate speech
const audio = await node.audio.synthesize({
  text: "Hello, world!",
  voice: "alloy",
  speed: 1.0
});
```

---

## Location

### Location Services

```json
{
  "tools": {
    "location": {
      "enabled": true,
      "accuracy": "high",
      "timeout": 10000
    }
  }
}
```

### Location Commands

| Command | Description |
|---------|-------------|
| `location.get` | Get current location |
| `location.watch` | Track location changes |
| `location.geocode` | Address to coordinates |
| `location.reverse` | Coordinates to address |

### Get Location

```javascript
// Get current location
const location = await node.location.get({
  accuracy: 'high'
});

// Returns: { lat: 37.7749, lng: -122.4194, accuracy: 10 }
```

### Geocoding

```javascript
// Address to coordinates
const coords = await node.location.geocode({
  address: "1 Infinite Loop, Cupertino, CA"
});

// Reverse geocode
const address = await node.location.reverse({
  lat: 37.7749,
  lng: -122.4194
});
```

### Location Sharing

```json
{
  "channels": {
    "whatsapp": {
      "location": {
        "shareOnRequest": true,
        "liveTracking": false
      }
    }
  }
}
```

---

## Voice Wake

Wake word detection for hands-free activation.

### Configuration

```json
{
  "nodes": {
    "voiceWake": {
      "enabled": true,
      "wakeWord": "hey clawd",
      "sensitivity": 0.5,
      "timeout": 30000
    }
  }
}
```

### Custom Wake Words

```json
{
  "nodes": {
    "voiceWake": {
      "wakeWords": ["hey clawd", "ok clawd", "clawd"]
    }
  }
}
```

### Voice Wake Events

| Event | Description |
|-------|-------------|
| `wake.detected` | Wake word heard |
| `wake.timeout` | No speech after wake |
| `wake.cancelled` | User cancelled |

---

## Talk Mode

Continuous voice conversation mode.

### Configuration

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

### Starting Talk Mode

```bash
# Via CLI
clawdbot talk

# Via node app
# Tap and hold microphone button
```

### Talk Mode Features

- **Voice Input**: Speak instead of type
- **Voice Output**: Hear responses
- **Auto-Listen**: Automatically listen after response
- **Interrupt**: Say wake word to interrupt

### Voice Options

| Voice | Description |
|-------|-------------|
| `alloy` | Neutral |
| `echo` | Male |
| `fable` | Female (British) |
| `onyx` | Deep male |
| `nova` | Female |
| `shimmer` | Female (expressive) |

---

## Canvas Tools

Drawing and annotation tools.

### Canvas Commands

| Command | Description |
|---------|-------------|
| `canvas.draw` | Draw on canvas |
| `canvas.annotate` | Annotate image |
| `canvas.clear` | Clear canvas |
| `canvas.export` | Export drawing |

### Configuration

```json
{
  "nodes": {
    "canvas": {
      "enabled": true,
      "defaultColor": "#000000",
      "defaultStroke": 2
    }
  }
}
```

---

## Screen Recording

macOS only.

### Configuration

```json
{
  "nodes": {
    "screen": {
      "enabled": true,
      "format": "mp4",
      "quality": "high"
    }
  }
}
```

### Screen Commands

| Command | Description |
|---------|-------------|
| `screen.record` | Record screen |
| `screen.screenshot` | Take screenshot |

### Permissions

Requires Screen Recording permission in System Preferences.

---

## Node Connection

### Bridge Protocol

Nodes connect via TCP with JSONL format:

```json
{"type":"bridge.hello","nodeId":"iphone-xyz","capabilities":["camera","location","audio"]}
```

### Node Status

```bash
# Check connected nodes
clawdbot nodes list

# Node details
clawdbot nodes info <node-id>
```

### Node Configuration

```json
{
  "nodes": {
    "allowedNodes": ["iphone-xyz", "macbook-abc"],
    "requirePairing": true
  }
}
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/nodes/camera
- https://docs.clawd.bot/nodes/images
- https://docs.clawd.bot/nodes/audio
- https://docs.clawd.bot/nodes/location
- https://docs.clawd.bot/nodes/voice-wake
- https://docs.clawd.bot/nodes/talk

Run `./sync.sh` to update from upstream.
