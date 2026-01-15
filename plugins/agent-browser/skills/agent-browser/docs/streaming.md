# Agent-Browser Streaming

> Source: https://agent-browser.dev/streaming

## Overview

Agent-browser enables viewport streaming via WebSocket for real-time preview and "pair browsing" where humans can watch and interact alongside AI agents.

## Enable Streaming

Set the `AGENT_BROWSER_STREAM_PORT` environment variable:

```bash
AGENT_BROWSER_STREAM_PORT=9223 agent-browser open example.com
```

The server transmits viewport frames and receives input events (mouse, keyboard, touch).

## WebSocket Protocol

Connect to `ws://localhost:9223` to receive frames and send input.

### Frame Messages

The server sends frame messages containing base64-encoded image data:

```json
{
  "type": "frame",
  "data": "<base64-encoded-jpeg>",
  "metadata": {
    "deviceWidth": 1280,
    "deviceHeight": 720,
    "pageScaleFactor": 1,
    "offsetTop": 0,
    "scrollOffsetX": 0,
    "scrollOffsetY": 0
  }
}
```

### Status Messages

Connection and screencast status updates:

```json
{
  "type": "status",
  "connected": true,
  "screencasting": true,
  "viewportWidth": 1280,
  "viewportHeight": 720
}
```

## Input Injection

Control the browser remotely by sending input events.

### Mouse Events

```json
// Click
{
  "type": "input_mouse",
  "eventType": "mousePressed",
  "x": 100,
  "y": 200,
  "button": "left",
  "clickCount": 1
}

// Release
{
  "type": "input_mouse",
  "eventType": "mouseReleased",
  "x": 100,
  "y": 200,
  "button": "left"
}

// Move
{
  "type": "input_mouse",
  "eventType": "mouseMoved",
  "x": 150,
  "y": 250
}

// Scroll
{
  "type": "input_mouse",
  "eventType": "mouseWheel",
  "x": 100,
  "y": 200,
  "deltaX": 0,
  "deltaY": 100
}
```

### Keyboard Events

```json
// Key down
{
  "type": "input_keyboard",
  "eventType": "keyDown",
  "key": "Enter",
  "code": "Enter"
}

// Key up
{
  "type": "input_keyboard",
  "eventType": "keyUp",
  "key": "Enter",
  "code": "Enter"
}

// Type character
{
  "type": "input_keyboard",
  "eventType": "char",
  "text": "a"
}

// With modifiers (1=Alt, 2=Ctrl, 4=Meta, 8=Shift)
{
  "type": "input_keyboard",
  "eventType": "keyDown",
  "key": "c",
  "code": "KeyC",
  "modifiers": 2
}
```

### Touch Events

```json
// Touch start
{
  "type": "input_touch",
  "eventType": "touchStart",
  "touchPoints": [{ "x": 100, "y": 200 }]
}

// Touch move
{
  "type": "input_touch",
  "eventType": "touchMove",
  "touchPoints": [{ "x": 150, "y": 250 }]
}

// Touch end
{
  "type": "input_touch",
  "eventType": "touchEnd",
  "touchPoints": []
}

// Multi-touch (pinch zoom)
{
  "type": "input_touch",
  "eventType": "touchStart",
  "touchPoints": [
    { "x": 100, "y": 200, "id": 0 },
    { "x": 200, "y": 200, "id": 1 }
  ]
}
```

## Programmatic API

Control streaming via TypeScript:

```typescript
import { BrowserManager } from 'agent-browser';

const browser = new BrowserManager();
await browser.launch({ headless: true });
await browser.navigate('https://example.com');

// Start screencast with callback
await browser.startScreencast((frame) => {
  console.log('Frame:', frame.metadata.deviceWidth, 'x', frame.metadata.deviceHeight);
  // frame.data is base64-encoded image
}, {
  format: 'jpeg',  // or 'png'
  quality: 80,     // 0-100, jpeg only
  maxWidth: 1280,
  maxHeight: 720,
  everyNthFrame: 1
});

// Inject mouse event
await browser.injectMouseEvent({
  type: 'mousePressed',
  x: 100,
  y: 200,
  button: 'left',
  clickCount: 1
});

// Inject keyboard event
await browser.injectKeyboardEvent({
  type: 'keyDown',
  key: 'Enter',
  code: 'Enter'
});

// Inject touch event
await browser.injectTouchEvent({
  type: 'touchStart',
  touchPoints: [{ x: 100, y: 200 }]
});

// Check if screencasting
console.log('Active:', browser.isScreencasting());

// Stop screencast
await browser.stopScreencast();
```

## Use Cases

- **Pair browsing**: Human observes and assists AI agent in real-time
- **Remote preview**: View browser output in a separate interface
- **Recording**: Capture frames for video generation
- **Mobile testing**: Inject touch events for mobile emulation
- **Accessibility testing**: Manual interaction during automated tests
