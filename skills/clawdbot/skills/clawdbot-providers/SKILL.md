---
name: clawdbot-providers
description: Clawdbot model providers - OpenAI, Anthropic, Moonshot, MiniMax, OpenRouter, and more
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Providers Expert

Complete guide to configuring LLM providers in Clawdbot.

**Documentation**: https://docs.clawd.bot/providers/

---

## Overview

Clawdbot supports multiple LLM providers:

| Provider | Models | Auth Method |
|----------|--------|-------------|
| Anthropic | Claude 3/3.5/4 | API Key or OAuth |
| OpenAI | GPT-4, GPT-4o | API Key |
| Moonshot | Moonshot models | API Key |
| MiniMax | MiniMax models | API Key |
| OpenRouter | Multiple | API Key |
| OpenCode | Local models | API Key |
| GLM | ChatGLM | API Key |
| Z.AI | Z.AI models | API Key |

---

## Anthropic (Default)

### API Key Authentication

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

Or in config:

```json
{
  "providers": {
    "anthropic": {
      "apiKey": "sk-ant-..."
    }
  }
}
```

### OAuth Authentication

Reuse Claude Code credentials:

```bash
claude setup-token
```

OAuth credentials stored in `~/.clawdbot/credentials/oauth.json`

### Available Models

- `claude-3-opus-20240229`
- `claude-3-5-sonnet-20241022`
- `claude-3-5-haiku-20241022`
- `claude-sonnet-4-20250514`
- `claude-opus-4-20250514`

### Model Selection

```json
{
  "agents": {
    "defaults": {
      "model": "claude-sonnet-4-20250514"
    }
  }
}
```

Or per-request:

```bash
clawdbot agent --model claude-3-opus "Complex task"
```

---

## OpenAI

### Setup

```bash
export OPENAI_API_KEY="sk-..."
```

Or in config:

```json
{
  "providers": {
    "openai": {
      "apiKey": "sk-..."
    }
  }
}
```

### Available Models

- `gpt-4`
- `gpt-4-turbo`
- `gpt-4o`
- `gpt-4o-mini`
- `o1-preview`
- `o1-mini`

### Organization ID

```json
{
  "providers": {
    "openai": {
      "apiKey": "sk-...",
      "organization": "org-..."
    }
  }
}
```

---

## Moonshot

Chinese LLM provider.

### Setup

```json
{
  "providers": {
    "moonshot": {
      "apiKey": "...",
      "baseUrl": "https://api.moonshot.cn/v1"
    }
  }
}
```

### Models

- `moonshot-v1-8k`
- `moonshot-v1-32k`
- `moonshot-v1-128k`

---

## MiniMax

### Setup

```json
{
  "providers": {
    "minimax": {
      "apiKey": "...",
      "groupId": "..."
    }
  }
}
```

### Models

- `abab5.5-chat`
- `abab6-chat`

---

## OpenRouter

Access multiple models through one API.

### Setup

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-..."
    }
  }
}
```

### Model Selection

Use full model paths:

```json
{
  "agents": {
    "defaults": {
      "model": "openrouter/anthropic/claude-3-opus"
    }
  }
}
```

### Available Models (via OpenRouter)

- `anthropic/claude-3-opus`
- `anthropic/claude-3-sonnet`
- `openai/gpt-4-turbo`
- `meta-llama/llama-3-70b`
- `google/gemini-pro`
- And many more...

---

## OpenCode

For local/self-hosted models.

### Setup

```json
{
  "providers": {
    "opencode": {
      "baseUrl": "http://localhost:8080/v1",
      "apiKey": "optional-key"
    }
  }
}
```

### Compatible Servers

- Ollama
- vLLM
- LocalAI
- LM Studio
- Text Generation WebUI (with OpenAI extension)

### Ollama Example

```bash
# Start Ollama
ollama serve

# Pull model
ollama pull llama3

# Configure Clawdbot
```

```json
{
  "providers": {
    "opencode": {
      "baseUrl": "http://localhost:11434/v1"
    }
  },
  "agents": {
    "defaults": {
      "model": "opencode/llama3"
    }
  }
}
```

---

## GLM (ChatGLM)

### Setup

```json
{
  "providers": {
    "glm": {
      "apiKey": "..."
    }
  }
}
```

### Models

- `glm-4`
- `glm-3-turbo`

---

## Z.AI

### Setup

```json
{
  "providers": {
    "zai": {
      "apiKey": "..."
    }
  }
}
```

---

## Provider Failover

Configure automatic failover between providers:

```json
{
  "providers": {
    "failover": {
      "enabled": true,
      "providers": ["anthropic", "openai", "openrouter"],
      "retryCount": 3,
      "retryDelay": 1000
    }
  }
}
```

### Failover Behavior

1. Try primary provider (first in list)
2. On failure, try next provider
3. Retry each provider up to `retryCount` times
4. Wait `retryDelay` ms between retries

---

## Rate Limiting

```json
{
  "providers": {
    "anthropic": {
      "rateLimit": {
        "requestsPerMinute": 60,
        "tokensPerMinute": 100000
      }
    }
  }
}
```

---

## Usage Tracking

Enable usage tracking:

```json
{
  "providers": {
    "usage": {
      "enabled": true,
      "logFile": "~/.clawdbot/usage.log"
    }
  }
}
```

View usage:

```bash
clawdbot usage show
clawdbot usage show --provider anthropic --period month
```

---

## Custom Base URLs

For proxies or enterprise deployments:

```json
{
  "providers": {
    "anthropic": {
      "baseUrl": "https://your-proxy.com/anthropic"
    },
    "openai": {
      "baseUrl": "https://your-proxy.com/openai"
    }
  }
}
```

---

## Environment Variables

| Variable | Provider |
|----------|----------|
| `ANTHROPIC_API_KEY` | Anthropic |
| `OPENAI_API_KEY` | OpenAI |
| `OPENROUTER_API_KEY` | OpenRouter |
| `MOONSHOT_API_KEY` | Moonshot |
| `MINIMAX_API_KEY` | MiniMax |
| `GLM_API_KEY` | GLM |

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/providers/overview
- https://docs.clawd.bot/providers/openai
- https://docs.clawd.bot/providers/anthropic
- https://docs.clawd.bot/providers/moonshot
- https://docs.clawd.bot/providers/minimax
- https://docs.clawd.bot/providers/openrouter
- https://docs.clawd.bot/providers/opencode
- https://docs.clawd.bot/providers/glm
- https://docs.clawd.bot/providers/zai

Run `./sync.sh` to update from upstream.
