<!-- Source: https://ai-sdk.dev/docs/agents/overview -->

# AI Agents

Agents are LLMs that use tools in a loop to accomplish tasks. They combine LLMs, tools, and orchestration loops.

## What Are Agents?

Agents have three key components:

1. **LLMs** - Process input and determine next actions
2. **Tools** - Extend capabilities (file reading, API calls, database writes)
3. **Loop** - Orchestrates execution through context management and stopping conditions

## ToolLoopAgent

The `ToolLoopAgent` class handles agent orchestration automatically:

```typescript
import { ToolLoopAgent, tool } from 'ai';
import { openai } from '@ai-sdk/openai';
import { z } from 'zod';

const agent = new ToolLoopAgent({
  model: openai('gpt-4o'),
  system: 'You are a helpful research assistant.',
  tools: {
    search: tool({
      description: 'Search the web',
      parameters: z.object({ query: z.string() }),
      execute: async ({ query }) => {
        // Perform search
        return { results: ['Result 1', 'Result 2'] };
      },
    }),
    readUrl: tool({
      description: 'Read content from a URL',
      parameters: z.object({ url: z.string() }),
      execute: async ({ url }) => {
        // Fetch and return content
        return { content: 'Page content...' };
      },
    }),
  },
  maxSteps: 10,
});

const result = await agent.run({
  prompt: 'Research the latest AI developments and summarize.',
});

console.log(result.text);
```

## Why Use ToolLoopAgent?

- **Reduces boilerplate** - Manages loops and message arrays
- **Improves reusability** - Define tools once, reuse everywhere
- **Simplifies maintenance** - Centralized configuration

## Custom Agent Implementation

For complex workflows, implement the Agent interface:

```typescript
import { Agent, generateText } from 'ai';
import { openai } from '@ai-sdk/openai';

class MyCustomAgent implements Agent {
  async run(input: string) {
    let context = [];
    let iterations = 0;

    while (iterations < 10) {
      const result = await generateText({
        model: openai('gpt-4o'),
        messages: [...context, { role: 'user', content: input }],
        tools: this.tools,
      });

      // Custom logic for handling results
      if (this.shouldStop(result)) {
        return result;
      }

      context.push(...result.messages);
      iterations++;
    }
  }
}
```

## Agent Patterns

### Research Agent

```typescript
const researchAgent = new ToolLoopAgent({
  model: openai('gpt-4o'),
  system: 'You research topics thoroughly before answering.',
  tools: { search, readUrl, summarize },
  maxSteps: 15,
});
```

### Coding Agent

```typescript
const codingAgent = new ToolLoopAgent({
  model: openai('gpt-4o'),
  system: 'You write and execute code to solve problems.',
  tools: { writeFile, runCode, readFile },
  maxSteps: 20,
});
```

### Data Analysis Agent

```typescript
const analysisAgent = new ToolLoopAgent({
  model: openai('gpt-4o'),
  system: 'You analyze data and create visualizations.',
  tools: { queryDatabase, createChart, exportData },
  maxSteps: 10,
});
```

## Structured Workflows

For deterministic outcomes, use explicit control flow:

```typescript
import { generateText } from 'ai';

async function structuredWorkflow(input: string) {
  // Step 1: Analyze
  const analysis = await generateText({
    model: openai('gpt-4o'),
    prompt: `Analyze: ${input}`,
  });

  // Step 2: Process based on analysis
  if (analysis.text.includes('needs research')) {
    const research = await generateText({
      model: openai('gpt-4o'),
      tools: { search },
      prompt: `Research: ${input}`,
    });
    return research;
  }

  return analysis;
}
```
