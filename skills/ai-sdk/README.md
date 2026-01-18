# AI SDK Skill

Expert assistant for building AI-powered applications with Vercel's AI SDK.

## Overview

[AI SDK](https://ai-sdk.dev/) is the TypeScript toolkit for building AI applications and agents. This skill provides comprehensive guidance on text generation, streaming, tool calling, agents, and multi-provider support.

## Features

- **Unified API**: Single interface for OpenAI, Anthropic, Google, Cohere, and more
- **Core Functions**: generateText, streamText, generateObject, streamObject
- **UI Hooks**: useChat, useCompletion, useObject for React, Vue, Svelte
- **Tool Calling**: Define and execute tools with type-safe parameters
- **Agent Framework**: ToolLoopAgent for complex task orchestration
- **Streaming**: Real-time text and structured object streaming

## Commands

| Command | Description |
|---------|-------------|
| `/ai-sdk start` | Installation and basic setup |
| `/ai-sdk generate` | Help with text/object generation |
| `/ai-sdk stream` | Help with streaming |
| `/ai-sdk chat` | Build chat interfaces |
| `/ai-sdk tools` | Tool calling guide |
| `/ai-sdk agents` | ToolLoopAgent and agent patterns |
| `/ai-sdk providers` | Configure AI providers |
| `/ai-sdk sync` | Update from upstream |
| `/ai-sdk diff` | Show changes vs upstream |

## Quick Start

```bash
npm install ai @ai-sdk/openai
```

```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

const { text } = await generateText({
  model: openai('gpt-4o'),
  prompt: 'What is the weather in San Francisco?',
});
```

## Documentation

- [Getting Started](skills/ai-sdk/docs/getting-started.md)
- [Core Overview](skills/ai-sdk/docs/core-overview.md)
- [UI Overview](skills/ai-sdk/docs/ui-overview.md)
- [Tools](skills/ai-sdk/docs/tools.md)
- [Agents](skills/ai-sdk/docs/agents.md)
- [Providers](skills/ai-sdk/docs/providers.md)

## Upstream Sources

- **Repository**: https://github.com/vercel/ai
- **Documentation**: https://ai-sdk.dev/

## Documentation Sync

Documentation is synced from upstream sources. Run sync manually:

```bash
.github/workflows/scripts/sync-skill.sh skills/ai-sdk
```

Or wait for the bi-weekly CI sync.

## License

MIT
