<!-- Source: https://chat-sdk.dev/docs/customization/models -->

# Models & Providers

Chat SDK supports multiple AI model providers through the AI SDK's unified interface.

## Default Configuration

The template ships with xAI as the default provider:

```typescript
// lib/ai/models.ts
import { xai } from '@ai-sdk/xai';

export const chatModel = xai('grok-2-vision-1212');
export const titleModel = xai('grok-3-mini');
```

## Switching Providers

### OpenAI

```typescript
import { openai } from '@ai-sdk/openai';

export const chatModel = openai('gpt-4o');
export const titleModel = openai('gpt-4o-mini');
```

Environment variable: `OPENAI_API_KEY`

### Anthropic

```typescript
import { anthropic } from '@ai-sdk/anthropic';

export const chatModel = anthropic('claude-3-5-sonnet-20241022');
export const titleModel = anthropic('claude-3-haiku-20240307');
```

Environment variable: `ANTHROPIC_API_KEY`

### Google

```typescript
import { google } from '@ai-sdk/google';

export const chatModel = google('gemini-1.5-pro');
export const titleModel = google('gemini-1.5-flash');
```

Environment variable: `GOOGLE_GENERATIVE_AI_API_KEY`

### Cohere

```typescript
import { cohere } from '@ai-sdk/cohere';

export const chatModel = cohere('command-r-plus');
```

Environment variable: `COHERE_API_KEY`

## Using Multiple Providers

You can configure multiple providers and switch between them:

```typescript
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';

export const models = {
  'gpt-4o': openai('gpt-4o'),
  'claude-3-5-sonnet': anthropic('claude-3-5-sonnet-20241022'),
} as const;

export type ModelId = keyof typeof models;
```

## Model Selection UI

To let users choose models, update the chat interface to include a model selector dropdown and pass the selected model to the API.

## Provider-Specific Features

Each provider may have unique capabilities:
- **OpenAI**: Function calling, vision, DALL-E integration
- **Anthropic**: Long context, tool use, vision
- **xAI**: Vision, real-time knowledge
- **Google**: Multimodal, long context

Refer to [AI SDK Providers](https://sdk.vercel.ai/providers) for complete documentation.
