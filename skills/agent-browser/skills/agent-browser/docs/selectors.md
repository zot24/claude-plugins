# Agent-Browser Selectors

> Source: https://agent-browser.dev/selectors

## 1. Refs (Recommended)

Refs provide deterministic element selection from snapshots. Best for AI agents.

### How it works

1. Get a snapshot: `agent-browser snapshot`
2. Output displays elements with ref identifiers (e.g., `[ref=e1]`)
3. Use refs in commands with `@` prefix

### Example workflow

```bash
agent-browser click @e2
agent-browser fill @e3 "test@example.com"
agent-browser get text @e1
agent-browser hover @e4
```

### Key advantages

- **Deterministic** - Ref points to exact element from snapshot
- **Fast** - No DOM re-query needed
- **AI-friendly** - LLMs can reliably parse and use refs

## 2. CSS Selectors

Standard CSS selector syntax:

```bash
agent-browser click "#id"
agent-browser click ".class"
agent-browser click "div > button"
agent-browser click "[data-testid='submit']"
```

## 3. Text & XPath

Alternative targeting methods:

```bash
agent-browser click "text=Submit"
agent-browser click "xpath=//button[@type='submit']"
```

## 4. Semantic Locators

Find elements by role, label, or other semantic properties:

```bash
agent-browser find role button click --name "Submit"
agent-browser find label "Email" fill "test@test.com"
agent-browser find placeholder "Search..." fill "query"
agent-browser find testid "submit-btn" click
```
