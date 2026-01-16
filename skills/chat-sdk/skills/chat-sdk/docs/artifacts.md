<!-- Source: https://chat-sdk.dev/docs/customization/artifacts -->

# Artifacts

Artifacts are custom workspaces that extend chat functionality with interactive tools.

## What Are Artifacts?

Artifacts provide specialized interfaces for complex interactions:
- Document editing and creation
- Code execution and preview
- Data visualization
- Interactive tools

## Built-in Artifacts

Chat SDK includes several pre-built artifacts:

### Code Artifact
Execute code snippets directly in the browser using WASM and pyodide:
- Python execution
- JavaScript/TypeScript
- HTML/CSS preview

### Document Artifact
Create and edit rich text documents within the chat interface.

### Image Artifact
Display and interact with generated or uploaded images.

## Creating Custom Artifacts

### 1. Define the Artifact Component

```typescript
// components/artifacts/my-artifact.tsx
'use client';

interface MyArtifactProps {
  data: MyArtifactData;
  onUpdate: (data: MyArtifactData) => void;
}

export function MyArtifact({ data, onUpdate }: MyArtifactProps) {
  return (
    <div className="artifact-container">
      {/* Your artifact UI */}
    </div>
  );
}
```

### 2. Register the Artifact

Add your artifact to the artifact registry:

```typescript
// lib/artifacts/registry.ts
import { MyArtifact } from '@/components/artifacts/my-artifact';

export const artifactRegistry = {
  // ... existing artifacts
  'my-artifact': {
    component: MyArtifact,
    name: 'My Artifact',
    description: 'Description of what it does',
  },
};
```

### 3. Configure AI Tool Calling

Set up the AI to create your artifact:

```typescript
// lib/ai/tools.ts
export const tools = {
  createMyArtifact: {
    description: 'Create my custom artifact',
    parameters: z.object({
      data: z.string(),
    }),
    execute: async ({ data }) => {
      return { type: 'my-artifact', data };
    },
  },
};
```

## Artifact Best Practices

1. **Keep artifacts focused** - Each artifact should do one thing well
2. **Handle state carefully** - Use proper React state management
3. **Consider persistence** - Save artifact state when needed
4. **Make them responsive** - Artifacts should work on all screen sizes
5. **Add keyboard shortcuts** - Improve usability with keyboard navigation

## In-Browser Code Execution

The code artifact uses WebAssembly for secure execution:
- No server-side code execution required
- Sandboxed environment
- Support for Python via pyodide
- Real-time output streaming
