<!-- Source: https://ai-sdk.dev/docs/ai-sdk-core/tools-and-tool-calling -->

# Tools and Tool Calling

Tools extend LLM capabilities beyond text generation, enabling actions like API calls, database queries, and computations.

## Defining Tools

```typescript
import { generateText, tool } from 'ai';
import { openai } from '@ai-sdk/openai';
import { z } from 'zod';

const result = await generateText({
  model: openai('gpt-4o'),
  tools: {
    weather: tool({
      description: 'Get the weather in a location',
      parameters: z.object({
        city: z.string().describe('The city to get weather for'),
        unit: z.enum(['celsius', 'fahrenheit']).optional(),
      }),
      execute: async ({ city, unit = 'celsius' }) => {
        // Call weather API
        return { temperature: 22, unit, city };
      },
    }),
    calculator: tool({
      description: 'Perform mathematical calculations',
      parameters: z.object({
        expression: z.string().describe('Math expression to evaluate'),
      }),
      execute: async ({ expression }) => {
        return { result: eval(expression) };
      },
    }),
  },
  prompt: 'What is the weather in Tokyo and what is 15 * 24?',
});
```

## Tool Call Results

```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  tools: { weather, calculator },
  prompt: 'What is the weather in Paris?',
});

// Check if tools were called
console.log(result.toolCalls);
// [{ toolName: 'weather', args: { city: 'Paris' } }]

console.log(result.toolResults);
// [{ toolName: 'weather', result: { temperature: 18, city: 'Paris' } }]

console.log(result.text);
// "The weather in Paris is 18°C."
```

## Multi-Step Tool Calls

Enable the model to call multiple tools in sequence:

```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  tools: { weather, flights, hotels },
  maxSteps: 5, // Allow up to 5 tool call rounds
  prompt: 'Plan a trip to Tokyo. Check weather, find flights, and book a hotel.',
});
```

## Streaming with Tools

```typescript
const result = streamText({
  model: openai('gpt-4o'),
  tools: { weather },
  prompt: 'What is the weather in London?',
});

for await (const part of result.fullStream) {
  if (part.type === 'tool-call') {
    console.log('Calling tool:', part.toolName, part.args);
  }
  if (part.type === 'tool-result') {
    console.log('Tool result:', part.result);
  }
  if (part.type === 'text-delta') {
    process.stdout.write(part.textDelta);
  }
}
```

## Tool Choice

Control how the model uses tools:

```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  tools: { weather, calculator },

  // Options:
  toolChoice: 'auto',        // Model decides (default)
  toolChoice: 'none',        // Don't use tools
  toolChoice: 'required',    // Must use a tool
  toolChoice: { type: 'tool', toolName: 'weather' }, // Use specific tool

  prompt: 'Hello',
});
```

## Human-in-the-Loop Approval

Require user approval before executing tools:

```typescript
const result = await generateText({
  model: openai('gpt-4o'),
  tools: {
    sendEmail: tool({
      description: 'Send an email',
      parameters: z.object({
        to: z.string(),
        subject: z.string(),
        body: z.string(),
      }),
      // Don't auto-execute, return for approval
    }),
  },
  prompt: 'Send an email to john@example.com',
});

// Check toolCalls and ask user for approval
// Then execute manually if approved
```
