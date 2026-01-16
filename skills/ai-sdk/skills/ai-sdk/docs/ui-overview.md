<!-- Source: https://ai-sdk.dev/docs/ai-sdk-ui/overview -->

# AI SDK UI Overview

AI SDK UI is a framework-agnostic toolkit for building interactive chat, completion, and assistant applications.

## Primary Hooks

### useChat

Real-time streaming chat with automatic state management:

```typescript
'use client';
import { useChat } from '@ai-sdk/react';

export default function Chat() {
  const {
    messages,
    input,
    handleInputChange,
    handleSubmit,
    isLoading,
    error,
    reload,
    stop,
  } = useChat();

  return (
    <div>
      {messages.map(m => (
        <div key={m.id}>
          <strong>{m.role}:</strong> {m.content}
        </div>
      ))}

      {isLoading && <div>AI is typing...</div>}

      <form onSubmit={handleSubmit}>
        <input
          value={input}
          onChange={handleInputChange}
          placeholder="Say something..."
        />
        <button type="submit">Send</button>
      </form>
    </div>
  );
}
```

### useCompletion

For text completion interfaces:

```typescript
'use client';
import { useCompletion } from '@ai-sdk/react';

export default function Completion() {
  const {
    completion,
    input,
    handleInputChange,
    handleSubmit,
    isLoading,
  } = useCompletion();

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input value={input} onChange={handleInputChange} />
        <button type="submit">Complete</button>
      </form>

      {isLoading && <div>Generating...</div>}
      <div>{completion}</div>
    </div>
  );
}
```

### useObject

For consuming streamed JSON objects:

```typescript
'use client';
import { useObject } from '@ai-sdk/react';
import { z } from 'zod';

const schema = z.object({
  notifications: z.array(z.object({
    title: z.string(),
    message: z.string(),
  })),
});

export default function Notifications() {
  const { object, submit, isLoading } = useObject({
    api: '/api/notifications',
    schema,
  });

  return (
    <div>
      <button onClick={() => submit({ prompt: 'Generate notifications' })}>
        Generate
      </button>

      {object?.notifications?.map((n, i) => (
        <div key={i}>
          <h3>{n.title}</h3>
          <p>{n.message}</p>
        </div>
      ))}
    </div>
  );
}
```

## Framework Support

| Framework | Package | Hooks |
|-----------|---------|-------|
| React | @ai-sdk/react | useChat, useCompletion, useObject |
| Vue.js | @ai-sdk/vue | useChat, useCompletion, useObject |
| Svelte | @ai-sdk/svelte | useChat, useCompletion, useObject |
| Angular | @ai-sdk/angular | useChat, useCompletion, useObject |
| SolidJS | Community | useChat, useCompletion, useObject |

## useChat Options

```typescript
const { messages, ... } = useChat({
  api: '/api/chat',           // Custom API endpoint
  id: 'my-chat',              // Unique chat ID
  initialMessages: [],        // Pre-populate messages
  initialInput: '',           // Pre-populate input
  onResponse: (response) => {}, // Called on response
  onFinish: (message) => {},    // Called when complete
  onError: (error) => {},       // Called on error
  headers: {},                  // Custom headers
  body: {},                     // Additional body data
});
```

## Server-Side API Routes

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
