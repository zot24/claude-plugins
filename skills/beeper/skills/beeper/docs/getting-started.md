<!-- Source: https://developers.beeper.com/desktop-api -->

# Beeper Desktop API - Getting Started Guide

## Overview

The Beeper Desktop API provides a local interface for accessing your unified messaging platform across multiple services including WhatsApp, Instagram, Telegram, Google Messages, Signal, Discord, Slack, and more. The system includes REST APIs and SDKs for JavaScript, Python, and Go.

## Key Capabilities

According to the documentation, you can:
- Search chat history across all connected accounts
- Send or draft messages programmatically
- Integrate third-party applications with Beeper Desktop
- Control the Beeper Desktop application

## Important Limitations

The documentation notes several constraints:

1. **Local-only operation**: The API runs within Beeper Desktop and requires the application to be actively running. Remote access from other devices is not available by default.

2. **Message history**: "Message history might be limited. Beeper indexes your messages...when you first add an account, only recent messages might be available."

3. **Platform constraints**: iMessage support is macOS-exclusive, and the API is described as "still new and evolving."

## Installation Requirements

- **Minimum version**: Beeper Desktop v4.1.169 or later
- **Download**: Available at beeper.com/download

## Setup Instructions

### Step 1: Install Beeper Desktop
Download and install the latest version of Beeper Desktop from the official website.

### Step 2: Enable the API
Navigate to **Settings → Developers** and toggle the **Beeper Desktop API** option to activate it.

### Step 3: Default Configuration
Once enabled, the server automatically launches on `http://localhost:23373` with the built-in MCP server ready for integration.

## SDK & Integration Options

- **TypeScript SDK**: Recommended as the easiest starting point
- **REST API**: Direct access available for custom implementations
- **MCP Server**: Built-in option for compatible applications
- Additional language support is planned for future releases

## Community & Support

Developers can engage through:
- Beeper community room (accessible via Settings → Developers)
- Matrix federation at #beeper-developers:beeper.com
- Email: help@beeper.com
- X (Twitter) for direct outreach

**Usage note**: "We recommend Beeper Desktop API for personal use only. Sending too many messages might result in account suspension by the networks."
