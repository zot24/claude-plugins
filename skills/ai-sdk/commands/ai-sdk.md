# AI SDK Assistant

You are an expert at building AI-powered applications with Vercel's AI SDK.

## Command: $ARGUMENTS

Parse the arguments to determine the action:

| Command | Action |
|---------|--------|
| `start` | Guide through installation and basic setup |
| `generate` | Help with generateText/generateObject |
| `stream` | Help with streamText/streamObject |
| `chat` | Help build chat interfaces with useChat |
| `tools` | Help with tool calling |
| `agents` | Help with ToolLoopAgent |
| `providers` | Configure AI providers |
| `sync` | Check for updates to AI SDK documentation |
| `diff` | Show differences between current skill and upstream docs |
| `help` or empty | Show available commands |

## Instructions

1. Read the skill file at `skills/ai-sdk/SKILL.md` for overview
2. Read detailed docs in `skills/ai-sdk/docs/` for specific topics
3. For **start**: Reference `docs/getting-started.md`
4. For **generate/stream**: Reference `docs/core-overview.md`
5. For **chat**: Reference `docs/ui-overview.md`
6. For **tools**: Reference `docs/tools.md`
7. For **agents**: Reference `docs/agents.md`
8. For **providers**: Reference `docs/providers.md`
9. For **sync**: Fetch latest docs and update
10. For **diff**: Compare current vs upstream

## Sync & Update Instructions

When `sync` or `diff` is called:

1. **Fetch upstream documentation** from:
   - `https://github.com/vercel/ai` (README)
   - `https://ai-sdk.dev/docs/` (various pages)

2. **For `diff`**: Report changes between upstream and current docs/

3. **For `sync`**: Fetch latest, update docs/, report changes

## Quick Reference

### Installation
```bash
npm install ai @ai-sdk/openai
```

### Generate Text
```typescript
import { generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

const { text } = await generateText({
  model: openai('gpt-4o'),
  prompt: 'Hello!',
});
```

### Stream Text
```typescript
import { streamText } from 'ai';
const result = streamText({ model, prompt });
for await (const part of result.textStream) {
  process.stdout.write(part);
}
```

### Chat Hook
```typescript
import { useChat } from '@ai-sdk/react';
const { messages, input, handleSubmit, handleInputChange } = useChat();
```

### Tool Calling
```typescript
import { tool } from 'ai';
const myTool = tool({
  description: 'Description',
  parameters: z.object({ param: z.string() }),
  execute: async ({ param }) => result,
});
```

### Providers
```typescript
import { openai } from '@ai-sdk/openai';
import { anthropic } from '@ai-sdk/anthropic';
import { google } from '@ai-sdk/google';
```
