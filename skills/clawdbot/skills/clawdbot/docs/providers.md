<!-- Source: https://docs.clawd.bot/providers/ -->

# Clawdbot Providers

Complete guide to configuring LLM providers.

## Overview

| Provider | Models | Auth Method |
|----------|--------|-------------|
| Anthropic | Claude 3/3.5/4 | API Key or OAuth |
| OpenAI | GPT-4, GPT-4o | API Key |
| Moonshot | Moonshot models | API Key |
| MiniMax | MiniMax models | API Key |
| OpenRouter | Multiple | API Key |
| OpenCode | Local models | API Key |
| GLM | ChatGLM | API Key |

---

## Anthropic (Default)

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

Or OAuth via Claude Code credentials:
```bash
claude setup-token
```

### Available Models

- `claude-3-opus-20240229`
- `claude-3-5-sonnet-20241022`
- `claude-sonnet-4-20250514`
- `claude-opus-4-20250514`

```json
{
  "agents": {
    "defaults": { "model": "claude-sonnet-4-20250514" }
  }
}
```

---

## OpenAI

```bash
export OPENAI_API_KEY="sk-..."
```

### Available Models

`gpt-4`, `gpt-4-turbo`, `gpt-4o`, `gpt-4o-mini`, `o1-preview`, `o1-mini`

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

## OpenRouter

Access multiple models through one API:

```json
{
  "providers": { "openrouter": { "apiKey": "sk-or-..." } },
  "agents": {
    "defaults": { "model": "openrouter/anthropic/claude-3-opus" }
  }
}
```

---

## OpenCode (Local Models)

For Ollama, vLLM, LocalAI, LM Studio:

```json
{
  "providers": {
    "opencode": { "baseUrl": "http://localhost:11434/v1" }
  },
  "agents": {
    "defaults": { "model": "opencode/llama3" }
  }
}
```

---

## Moonshot / MiniMax / GLM

```json
{
  "providers": {
    "moonshot": { "apiKey": "...", "baseUrl": "https://api.moonshot.cn/v1" },
    "minimax": { "apiKey": "...", "groupId": "..." },
    "glm": { "apiKey": "..." }
  }
}
```

---

## Provider Failover

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

---

## Rate Limiting & Usage

```json
{
  "providers": {
    "anthropic": {
      "rateLimit": { "requestsPerMinute": 60, "tokensPerMinute": 100000 }
    },
    "usage": { "enabled": true, "logFile": "~/.clawdbot/usage.log" }
  }
}
```

```bash
clawdbot usage show --provider anthropic --period month
```

---

## Environment Variables

| Variable | Provider |
|----------|----------|
| `ANTHROPIC_API_KEY` | Anthropic |
| `OPENAI_API_KEY` | OpenAI |
| `OPENROUTER_API_KEY` | OpenRouter |
| `MOONSHOT_API_KEY` | Moonshot |

---

## Upstream Sources

- https://docs.clawd.bot/providers/overview
- https://docs.clawd.bot/providers/anthropic
- https://docs.clawd.bot/providers/openai
- https://docs.clawd.bot/providers/openrouter
- https://docs.clawd.bot/providers/opencode
