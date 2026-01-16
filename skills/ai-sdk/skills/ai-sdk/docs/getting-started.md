<!-- Source: https://ai-sdk.dev/docs/getting-started -->

# Getting Started

This guide covers setting up AI SDK in your project.

## Prerequisites

- Node.js 18+
- npm, pnpm, or yarn
- API key from your chosen provider (OpenAI, Anthropic, etc.)

## Installation

```bash
# Core package
npm install ai

# Provider packages (install as needed)
npm install @ai-sdk/openai
npm install @ai-sdk/anthropic
npm install @ai-sdk/google
```

## Environment Setup

Create a `.env.local` file:

```bash
# OpenAI
OPENAI_API_KEY=sk-...

# Anthropic
ANTHROPIC_API_KEY=sk-ant-...

# Google
GOOGLE_GENERATIVE_AI_API_KEY=...
```

## Framework Quick Start

### Next.js App Router

```typescript
// app/api/chat/route.ts
import { openai } from '@ai-sdk/openai';
import { streamText } from 'ai';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: openai('gpt-4o'),
    messages,
  });

  return result.toDataStreamResponse();
}
```

```typescript
// app/page.tsx
'use client';
import { useChat } from '@ai-sdk/react';

export default function Chat() {
  const { messages, input, handleInputChange, handleSubmit } = useChat();

  return (
    <div>
      {messages.map(m => (
        <div key={m.id}>{m.role}: {m.content}</div>
      ))}
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} />
        <button type="submit">Send</button>
      </form>
    </div>
  );
}
```

### Node.js

```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

async function main() {
  const { text } = await generateText({
    model: openai('gpt-4o'),
    prompt: 'Hello, AI!',
  });

  console.log(text);
}

main();
```

### Express

```typescript
import express from 'express';
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

const app = express();
app.use(express.json());

app.post('/api/chat', async (req, res) => {
  const { prompt } = req.body;

  const result = streamText({
    model: openai('gpt-4o'),
    prompt,
  });

  result.pipeDataStreamToResponse(res);
});

app.listen(3000);
```

## Supported Frameworks

### Frontend
- React (@ai-sdk/react)
- Vue.js (@ai-sdk/vue)
- Svelte (@ai-sdk/svelte)
- Angular (@ai-sdk/angular)
- SolidJS (community)

### Backend
- Next.js (App Router & Pages Router)
- Express
- Hono
- Fastify
- Nest.js
- Node.js HTTP Server
