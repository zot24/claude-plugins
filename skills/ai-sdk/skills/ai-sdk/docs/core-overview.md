<!-- Source: https://ai-sdk.dev/docs/ai-sdk-core/overview -->

# AI SDK Core Overview

AI SDK Core simplifies working with LLMs by offering a standardized way of integrating them into your app.

## Primary Functions

### generateText

For non-interactive scenarios like automation, email drafting, or summarization:

```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

const { text, usage, finishReason } = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Summarize this article: ...',
});
```

### streamText

For real-time streaming in interactive applications:

```typescript
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

const result = streamText({
  model: openai('gpt-4o'),
  messages: [{ role: 'user', content: 'Tell me a story' }],
});

for await (const textPart of result.textStream) {
  process.stdout.write(textPart);
}
```

### generateObject

For typed, structured data matching Zod schemas:

```typescript
import { generateObject } from 'ai';
import { openai } from '@ai-sdk/openai';
import { z } from 'zod';

const { object } = await generateObject({
  model: openai('gpt-4o'),
  schema: z.object({
    name: z.string(),
    age: z.number(),
    email: z.string().email(),
  }),
  prompt: 'Generate a user profile for John Doe, 30 years old',
});
```

### streamObject

For streaming structured objects in real-time:

```typescript
import { streamObject } from 'ai';
import { openai } from '@ai-sdk/openai';
import { z } from 'zod';

const result = streamObject({
  model: openai('gpt-4o'),
  schema: z.object({
    items: z.array(z.object({
      title: z.string(),
      description: z.string(),
    })),
  }),
  prompt: 'Generate 5 product ideas',
});

for await (const partialObject of result.partialObjectStream) {
  console.log(partialObject);
}
```

## Common Options

All functions accept these common options:

```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Hello',

  // Optional settings
  system: 'You are a helpful assistant.',
  temperature: 0.7,
  maxTokens: 1000,
  topP: 1,
  frequencyPenalty: 0,
  presencePenalty: 0,
  seed: 12345,

  // Abort signal for cancellation
  abortSignal: controller.signal,
});
```

## Messages Format

For multi-turn conversations:

```typescript
const { text } = await generateText({
  model: openai('gpt-4o'),
  messages: [
    { role: 'system', content: 'You are a helpful assistant.' },
    { role: 'user', content: 'What is TypeScript?' },
    { role: 'assistant', content: 'TypeScript is...' },
    { role: 'user', content: 'How do I use it?' },
  ],
});
```

## Response Properties

```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Hello',
});

console.log(result.text);        // Generated text
console.log(result.usage);       // { promptTokens, completionTokens, totalTokens }
console.log(result.finishReason); // 'stop', 'length', 'tool-calls', etc.
console.log(result.response);    // Full response metadata
```
