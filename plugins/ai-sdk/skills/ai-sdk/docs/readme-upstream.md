<!-- Source: https://github.com/vercel/ai -->

# AI SDK

The AI Toolkit for TypeScript.

The AI SDK is a free open-source library for building AI-powered applications and agents. From the creators of Next.js.

## Features

- **Unified API** - Interact with model providers like OpenAI, Anthropic, Google, and more using a single, consistent interface
- **AI SDK Core** - Unified API for generating text, structured objects, and tool calls with LLMs
- **AI SDK UI** - Hooks for building chat and generative UIs with React, Vue, Svelte, and more
- **AI SDK Agents** - Build intelligent agents with ToolLoopAgent and custom agent implementations
- **Streaming Support** - Real-time text and object streaming for responsive applications
- **Tool Calling** - Define and execute tools/functions with type-safe parameters
- **Structured Outputs** - Generate typed JSON objects with Zod schema validation

## Installation

```bash
npm install ai
```

Install provider packages as needed:

```bash
npm install @ai-sdk/openai
npm install @ai-sdk/anthropic
npm install @ai-sdk/google
```

## Quick Start

### Generate Text

```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

const { text } = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Write a haiku about programming.',
});

console.log(text);
```

### Stream Text

```typescript
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

const result = streamText({
  model: openai('gpt-4o'),
  prompt: 'Explain quantum computing in simple terms.',
});

for await (const textPart of result.textStream) {
  process.stdout.write(textPart);
}
```

### Generate Structured Object

```typescript
import { generateObject } from 'ai';
import { openai } from '@ai-sdk/openai';
import { z } from 'zod';

const { object } = await generateObject({
  model: openai('gpt-4o'),
  schema: z.object({
    recipe: z.object({
      name: z.string(),
      ingredients: z.array(z.string()),
      steps: z.array(z.string()),
    }),
  }),
  prompt: 'Generate a recipe for chocolate chip cookies.',
});

console.log(object.recipe);
```

## Supported Providers

- OpenAI
- Anthropic
- Google (Gemini)
- Cohere
- Amazon Bedrock
- Azure OpenAI
- Mistral
- Groq
- Perplexity
- Fireworks
- And many more...

## Documentation

Visit [ai-sdk.dev](https://ai-sdk.dev/) for full documentation.

## License

Apache-2.0
