# Agent-Browser Installation

> Source: https://agent-browser.dev/installation

## Installation Methods

### NPM (Recommended)

The quickest setup involves installing globally via npm:

```bash
npm install -g agent-browser
agent-browser install  # Download Chromium
```

### From Source

For development or custom builds, clone and build locally:

```bash
git clone https://github.com/vercel-labs/agent-browser
cd agent-browser
pnpm install
pnpm build
pnpm build:native
./bin/agent-browser install
pnpm link --global
```

### Linux Dependencies

On Linux systems, install required system dependencies using:

```bash
agent-browser install --with-deps
# or manually: npx playwright install-deps chromium
```

## Custom Browser Configuration

Users can specify alternative browser executables instead of the bundled Chromium through two methods:

### Via Command Flag

```bash
agent-browser --executable-path /path/to/chromium open example.com
```

### Via Environment Variable

```bash
AGENT_BROWSER_EXECUTABLE_PATH=/path/to/chromium agent-browser open example.com
```

## Custom Browser Options

Three primary alternatives exist:

1. **Serverless** - Use `@sparticuz/chromium` (~50MB vs ~684MB)
2. **System browser** - Leverage existing Chrome installations
3. **Custom builds** - Deploy modified browser binaries

### Serverless Implementation Example

```javascript
import chromium from '@sparticuz/chromium';
import { BrowserManager } from 'agent-browser';

export async function handler() {
  const browser = new BrowserManager();
  await browser.launch({
    executablePath: await chromium.executablePath(),
    headless: true,
  });
  // ... use browser
}
```
