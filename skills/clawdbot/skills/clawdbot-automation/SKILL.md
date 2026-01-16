---
name: clawdbot-automation
description: Clawdbot automation - webhooks, Gmail integration, cron jobs, polling
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Clawdbot Automation Expert

Complete guide to automation features in Clawdbot.

**Documentation**: https://docs.clawd.bot/automation/

---

## Webhooks

### Configuration

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

### Webhook Endpoints

```bash
# Receive webhook
POST http://localhost:8081/webhook/notify
Content-Type: application/json
X-Webhook-Secret: webhook-secret

{
  "event": "deployment",
  "status": "success"
}
```

### Webhook Handlers

Create handler in workspace:

```javascript
// handlers/notify-handler.js
module.exports = async (payload, context) => {
  const { event, status } = payload;

  // Send notification to channel
  await context.send({
    channel: 'slack',
    to: '#deployments',
    message: `Deployment ${event}: ${status}`
  });
};
```

### Security

- Always use secrets for authentication
- Validate payload signatures
- Use HTTPS in production

```json
{
  "automation": {
    "webhooks": {
      "validateSignature": true,
      "signatureHeader": "X-Hub-Signature-256"
    }
  }
}
```

---

## Gmail Integration

### Setup

1. Enable Gmail API in Google Cloud Console
2. Create OAuth credentials
3. Configure Clawdbot

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

### Gmail Pub/Sub

For real-time email notifications:

```json
{
  "automation": {
    "gmail": {
      "pubsub": {
        "enabled": true,
        "topicName": "projects/my-project/topics/gmail",
        "subscriptionName": "clawdbot-gmail"
      }
    }
  }
}
```

### Email Handlers

```javascript
// handlers/email-handler.js
module.exports = async (email, context) => {
  const { from, subject, body } = email;

  // Process email with agent
  await context.agent.run({
    message: `New email from ${from}: ${subject}\n\n${body}`,
    session: 'email-processor'
  });
};
```

### Gmail Commands

```bash
# Check gmail connection
clawdbot gmail status

# List recent emails
clawdbot gmail list --limit 10

# Watch for new emails
clawdbot gmail watch
```

---

## Cron Jobs

### Configuration

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

### Cron Schedule Format

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6)
│ │ │ │ │
* * * * *
```

### Common Schedules

| Schedule | Description |
|----------|-------------|
| `0 9 * * *` | Daily at 9 AM |
| `0 9 * * 1-5` | Weekdays at 9 AM |
| `*/15 * * * *` | Every 15 minutes |
| `0 0 1 * *` | First of month |
| `0 */2 * * *` | Every 2 hours |

### Cron Job Handlers

```javascript
// handlers/health-check-handler.js
module.exports = async (context) => {
  const health = await context.gateway.health();

  if (health.status !== 'healthy') {
    await context.send({
      channel: 'slack',
      to: '#alerts',
      message: `Health check failed: ${JSON.stringify(health)}`
    });
  }
};
```

### Managing Cron Jobs

```bash
# List jobs
clawdbot cron list

# Run job manually
clawdbot cron run daily-summary

# Pause job
clawdbot cron pause daily-summary

# Resume job
clawdbot cron resume daily-summary
```

---

## Polling

For services without webhooks, use polling.

### Configuration

```json
{
  "automation": {
    "polling": {
      "enabled": true,
      "jobs": {
        "github-issues": {
          "url": "https://api.github.com/repos/owner/repo/issues",
          "interval": 300000,
          "headers": {
            "Authorization": "token ${GITHUB_TOKEN}"
          },
          "handler": "github-issues-handler"
        }
      }
    }
  }
}
```

### Polling Handler

```javascript
// handlers/github-issues-handler.js
let lastSeen = new Set();

module.exports = async (data, context) => {
  const newIssues = data.filter(issue => !lastSeen.has(issue.id));

  for (const issue of newIssues) {
    await context.send({
      channel: 'discord',
      to: 'channel:123',
      message: `New issue: ${issue.title}\n${issue.html_url}`
    });
    lastSeen.add(issue.id);
  }
};
```

### Polling Options

| Option | Description |
|--------|-------------|
| `interval` | Polling interval in ms |
| `timeout` | Request timeout |
| `retries` | Number of retries on failure |
| `backoff` | Backoff strategy |

---

## Auth Monitoring

Monitor authentication status and alert on issues.

### Configuration

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

### Auth Events

- `auth.expired` - Token expired
- `auth.revoked` - Access revoked
- `auth.refreshed` - Token refreshed
- `auth.failed` - Auth attempt failed

### Custom Auth Handler

```javascript
// handlers/auth-handler.js
module.exports = async (event, context) => {
  if (event.type === 'auth.expired') {
    await context.send({
      channel: 'slack',
      to: '@admin',
      message: `Auth expired for ${event.provider}. Please re-authenticate.`
    });
  }
};
```

---

## Event System

### Subscribing to Events

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

| Event | Description |
|-------|-------------|
| `message.received` | New message received |
| `message.sent` | Message sent |
| `agent.started` | Agent execution started |
| `agent.completed` | Agent execution completed |
| `agent.error` | Agent error occurred |
| `channel.connected` | Channel connected |
| `channel.disconnected` | Channel disconnected |

---

## Automation CLI

```bash
# List all automation jobs
clawdbot automation list

# Status
clawdbot automation status

# Run specific job
clawdbot automation run <job-name>

# Logs
clawdbot automation logs --job <job-name>

# Pause all automation
clawdbot automation pause --all

# Resume
clawdbot automation resume --all
```

---

## Best Practices

### Rate Limiting

```json
{
  "automation": {
    "rateLimit": {
      "enabled": true,
      "maxPerMinute": 60,
      "maxPerHour": 1000
    }
  }
}
```

### Error Handling

```javascript
module.exports = async (data, context) => {
  try {
    // Handler logic
  } catch (error) {
    context.log.error('Handler failed:', error);
    await context.send({
      channel: 'slack',
      to: '#errors',
      message: `Automation error: ${error.message}`
    });
  }
};
```

### Idempotency

Track processed items to avoid duplicates:

```javascript
const processed = new Set();

module.exports = async (data, context) => {
  if (processed.has(data.id)) {
    return; // Already processed
  }
  processed.add(data.id);
  // Process data
};
```

---

## Sync Information

**Upstream Sources:**
- https://docs.clawd.bot/automation/auth-monitoring
- https://docs.clawd.bot/automation/webhooks
- https://docs.clawd.bot/automation/gmail
- https://docs.clawd.bot/automation/cron
- https://docs.clawd.bot/automation/polling

Run `./sync.sh` to update from upstream.
