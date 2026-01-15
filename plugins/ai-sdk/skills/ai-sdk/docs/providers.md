<!-- Source: https://ai-sdk.dev/providers -->

# AI Providers

AI SDK supports multiple LLM providers through a unified interface.

## Official Providers

### OpenAI

```bash
npm install @ai-sdk/openai
```

```typescript
import { openai } from '@ai-sdk/openai';

const model = openai('gpt-4o');
const model = openai('gpt-4o-mini');
const model = openai('o1');
const model = openai('o1-mini');
```

Environment: `OPENAI_API_KEY`

### Anthropic

```bash
npm install @ai-sdk/anthropic
```

```typescript
import { anthropic } from '@ai-sdk/anthropic';

const model = anthropic('claude-3-5-sonnet-20241022');
const model = anthropic('claude-3-5-haiku-20241022');
const model = anthropic('claude-3-opus-20240229');
```

Environment: `ANTHROPIC_API_KEY`

### Google (Gemini)

```bash
npm install @ai-sdk/google
```

```typescript
import { google } from '@ai-sdk/google';

const model = google('gemini-1.5-pro');
const model = google('gemini-1.5-flash');
const model = google('gemini-2.0-flash-exp');
```

Environment: `GOOGLE_GENERATIVE_AI_API_KEY`

### Cohere

```bash
npm install @ai-sdk/cohere
```

```typescript
import { cohere } from '@ai-sdk/cohere';

const model = cohere('command-r-plus');
const model = cohere('command-r');
```

Environment: `COHERE_API_KEY`

### Mistral

```bash
npm install @ai-sdk/mistral
```

```typescript
import { mistral } from '@ai-sdk/mistral';

const model = mistral('mistral-large-latest');
const model = mistral('mistral-small-latest');
```

Environment: `MISTRAL_API_KEY`

### Amazon Bedrock

```bash
npm install @ai-sdk/amazon-bedrock
```

```typescript
import { bedrock } from '@ai-sdk/amazon-bedrock';

const model = bedrock('anthropic.claude-3-5-sonnet-20241022-v2:0');
const model = bedrock('amazon.titan-text-premier-v1:0');
```

Environment: AWS credentials

### Azure OpenAI

```bash
npm install @ai-sdk/azure
```

```typescript
import { azure } from '@ai-sdk/azure';

const model = azure('your-deployment-name');
```

Environment: `AZURE_OPENAI_API_KEY`, `AZURE_OPENAI_ENDPOINT`

## Additional Providers

- **Groq** - @ai-sdk/groq
- **Perplexity** - @ai-sdk/perplexity
- **Fireworks** - @ai-sdk/fireworks
- **Together AI** - @ai-sdk/togetherai
- **xAI** - @ai-sdk/xai

## Custom Providers

Create custom provider for any OpenAI-compatible API:

```typescript
import { createOpenAI } from '@ai-sdk/openai';

const customProvider = createOpenAI({
  baseURL: 'https://your-api.com/v1',
  apiKey: process.env.CUSTOM_API_KEY,
});

const model = customProvider('model-name');
```

## Switching Providers

```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';

// Easy to switch providers
const provider = process.env.USE_ANTHROPIC
  ? anthropic('claude-3-5-sonnet-20241022')
  : openai('gpt-4o');

const { text } = await generateText({
  model: provider,
  prompt: 'Hello!',
});
```
