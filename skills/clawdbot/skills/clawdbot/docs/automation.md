<!-- Source: https://docs.clawd.bot/automation/ -->

# Clawdbot Automation

Complete guide to automation features in Clawdbot.

## Webhooks

```json
{
  "automation": {
    "webhooks": {
      "enabled": true,
      "port": 8081,
      "endpoints": {
        "notify": {
          "path": "/webhook/notify",
          "secret": "webhook-secret",
          "handler": "notify-handler"
        }
      }
    }
  }
}
```

### Webhook Handler

```javascript
// handlers/notify-handler.js
module.exports = async (payload, context) => {
  await context.send({
    channel: 'slack',
    to: '#deployments',
    message: `Deployment ${payload.event}: ${payload.status}`
  });
};
```

---

## Gmail Integration

```json
{
  "automation": {
    "gmail": {
      "enabled": true,
      "credentials": "~/.clawdbot/credentials/gmail.json",
      "watch": {
        "labels": ["INBOX"],
        "filters": ["from:important@example.com"]
      }
    }
  }
}
```

```bash
clawdbot gmail status
clawdbot gmail list --limit 10
clawdbot gmail watch
```

---

## Cron Jobs

```json
{
  "automation": {
    "cron": {
      "enabled": true,
      "jobs": {
        "daily-summary": {
          "schedule": "0 9 * * *",
          "task": "Generate daily summary",
          "channel": "slack",
          "to": "#daily-standup"
        },
        "health-check": {
          "schedule": "*/5 * * * *",
          "handler": "health-check-handler"
        }
      }
    }
  }
}
```

### Common Schedules

| Schedule | Description |
|----------|-------------|
| `0 9 * * *` | Daily at 9 AM |
| `0 9 * * 1-5` | Weekdays at 9 AM |
| `*/15 * * * *` | Every 15 minutes |
| `0 0 1 * *` | First of month |

```bash
clawdbot cron list
clawdbot cron run daily-summary
clawdbot cron pause daily-summary
```

---

## Polling

```json
{
  "automation": {
    "polling": {
      "enabled": true,
      "jobs": {
        "github-issues": {
          "url": "https://api.github.com/repos/owner/repo/issues",
          "interval": 300000,
          "headers": { "Authorization": "token ${GITHUB_TOKEN}" },
          "handler": "github-issues-handler"
        }
      }
    }
  }
}
```

---

## Auth Monitoring

```json
{
  "automation": {
    "authMonitoring": {
      "enabled": true,
      "checkInterval": 60000,
      "alertChannel": "slack",
      "alertTo": "#alerts",
      "providers": ["anthropic", "openai"]
    }
  }
}
```

Events: `auth.expired`, `auth.revoked`, `auth.refreshed`, `auth.failed`

---

## Event System

```json
{
  "automation": {
    "events": {
      "subscriptions": {
        "message.received": "message-handler",
        "agent.completed": "completion-handler",
        "channel.connected": "connection-handler"
      }
    }
  }
}
```

### Available Events

`message.received`, `message.sent`, `agent.started`, `agent.completed`, `agent.error`, `channel.connected`, `channel.disconnected`

---

## Automation CLI

```bash
clawdbot automation list
clawdbot automation status
clawdbot automation run <job-name>
clawdbot automation logs --job <job-name>
clawdbot automation pause --all
clawdbot automation resume --all
```

---

## Best Practices

### Rate Limiting

```json
{
  "automation": {
    "rateLimit": { "enabled": true, "maxPerMinute": 60, "maxPerHour": 1000 }
  }
}
```

### Idempotency

```javascript
const processed = new Set();
module.exports = async (data, context) => {
  if (processed.has(data.id)) return;
  processed.add(data.id);
  // Process data
};
```

---

## Upstream Sources

- https://docs.clawd.bot/automation/webhooks
- https://docs.clawd.bot/automation/gmail
- https://docs.clawd.bot/automation/cron
- https://docs.clawd.bot/automation/polling
