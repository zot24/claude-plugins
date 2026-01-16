---
name: ai-sdk
description: Expert on Vercel's AI SDK for building AI-powered applications. Use when user wants to integrate LLMs, stream text, generate structured data, use tools, or build agents. Triggers on mentions of ai-sdk, vercel ai, generateText, streamText, useChat, tool calling.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# AI SDK Skill

Expert at building AI-powered applications with Vercel's AI SDK.

## Overview

**AI SDK** is the TypeScript toolkit for building AI applications:
- Unified API for OpenAI, Anthropic, Google, Cohere, and more
- Core functions: generateText, streamText, generateObject, streamObject
- UI hooks: useChat, useCompletion, useObject
- Tool calling and function execution
- Agent framework with ToolLoopAgent
- Works with React, Next.js, Vue, Svelte, Node.js

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

## Core Concepts

### Core Functions
- `generateText` - Non-interactive text generation
- `streamText` - Real-time streaming for chat
- `generateObject` - Typed structured data with Zod schemas
- `streamObject` - Stream structured objects

### UI Hooks
```typescript
import { useChat } from '@ai-sdk/react';

function Chat() {
  const { messages, input, handleInputChange, handleSubmit } = useChat();
  // Real-time streaming chat UI
}
```

### Tool Calling
```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  tools: {
    weather: tool({
      parameters: z.object({ city: z.string() }),
      execute: async ({ city }) => getWeather(city),
    }),
  },
  prompt: 'What is the weather in Tokyo?',
});
```

## Documentation

For detailed information, see the reference documentation:

- **[Getting Started](docs/getting-started.md)** - Installation and setup
- **[Core Overview](docs/core-overview.md)** - generateText, streamText, etc.
- **[UI Overview](docs/ui-overview.md)** - React hooks and components
- **[Tools](docs/tools.md)** - Tool calling and function execution
- **[Agents](docs/agents.md)** - ToolLoopAgent and agent patterns
- **[Providers](docs/providers.md)** - OpenAI, Anthropic, Google, etc.
- **[Upstream README](docs/readme-upstream.md)** - Full documentation

## Common Workflows

### Streaming Chat with React
```typescript
'use client';
import { useChat } from '@ai-sdk/react';

export default function Chat() {
  const { messages, input, handleSubmit, handleInputChange } = useChat();
  return (
    <div>
      {messages.map(m => <div key={m.id}>{m.content}</div>)}
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} />
      </form>
    </div>
  );
}
```

### Switch Providers
```typescript
import { anthropic } from '@ai-sdk/anthropic';
const { text } = await generateText({
  model: anthropic('claude-3-5-sonnet-20241022'),
  prompt: 'Hello!',
});
```

## Upstream Sources

- **Repository**: https://github.com/vercel/ai
- **Documentation**: https://ai-sdk.dev/

## Sync & Update

When user runs `sync`: fetch latest from upstream sources, update docs/ files.
When user runs `diff`: compare current vs upstream, report changes.
