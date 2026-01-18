# Chat SDK Skill

Expert assistant for building AI chatbot applications with Vercel's Chat SDK.

## Overview

[Chat SDK](https://chat-sdk.dev/) is a free, open-source template for building production-ready AI chatbots. This skill provides comprehensive guidance on setup, customization, and deployment.

## Features

- **Quick Setup**: Get started with one-click Vercel deployment or local development
- **AI Provider Support**: Configure xAI, OpenAI, Anthropic, Google, Cohere, and more
- **Generative UI**: Build dynamic, interactive chat interfaces
- **Custom Artifacts**: Create specialized workspaces for code execution, documents, and more
- **Theming**: Customize colors, fonts, and layout
- **Production Ready**: Auth, persistence, file storage, and streaming built-in

## Commands

| Command | Description |
|---------|-------------|
| `/chat-sdk setup` | Installation and configuration guide |
| `/chat-sdk models` | Configure AI providers |
| `/chat-sdk artifact <name>` | Create or customize artifacts |
| `/chat-sdk deploy` | Deployment instructions |
| `/chat-sdk theme` | Customize appearance |
| `/chat-sdk sync` | Update documentation from upstream |
| `/chat-sdk diff` | Show changes vs upstream |
| `/chat-sdk help` | Show available commands |

## Quick Start

```bash
# Create new project
npx create-next-app --example https://github.com/vercel/ai-chatbot my-chatbot
cd my-chatbot

# Setup
pnpm install
cp .env.example .env.local
# Add your API keys

# Run
pnpm db:migrate
pnpm dev
```

## Documentation

- [Setup Guide](skills/chat-sdk/docs/setup.md)
- [Architecture](skills/chat-sdk/docs/architecture.md)
- [Models & Providers](skills/chat-sdk/docs/models.md)
- [Artifacts](skills/chat-sdk/docs/artifacts.md)
- [Theming](skills/chat-sdk/docs/theming.md)
- [Deployment](skills/chat-sdk/docs/deployment.md)

## Upstream Sources

- **Repository**: https://github.com/vercel/ai-chatbot
- **Documentation**: https://chat-sdk.dev/
- **Announcement**: https://vercel.com/blog/introducing-chat-sdk

## Documentation Sync

Documentation is synced from upstream sources. Run sync manually:

```bash
.github/workflows/scripts/sync-skill.sh skills/chat-sdk
```

Or wait for the bi-weekly CI sync.

## License

MIT
