# Claude Code Expert

---
name: claude-code-expert
description: Claude Code and Anthropic ecosystem knowledge. Provides official patterns for creating agents, skills, hooks, and commands. Auto-invokes when creating or validating Claude Code artifacts.
model: sonnet
allowed-tools: Read, Grep, Glob
auto_invoke: true
triggers:
  - "create new agent"
  - "create new skill"
  - "create new hook"
  - "create new command"
  - "validate agent"
  - "validate skill"
  - "validate hook"
  - "validate command"
  - "best practices"
  - "Claude Code features"
  - "MCP integration"
  - "tool usage patterns"
---

## Purpose

Provides authoritative knowledge for Claude Code development, ensuring all artifacts follow official best practices.

## Knowledge Base

### Patterns (Creation Guides)
- `official/patterns/agent-creation.md` - Agent creation guide
- `official/patterns/skill-creation.md` - Skill creation guide
- `official/patterns/hook-creation.md` - Hook creation guide
- `official/patterns/hook-advanced.md` - Advanced hook patterns (v2.1.0+)
- `official/patterns/command-creation.md` - Command creation guide

### Features (Capability Guides)
- `official/features/tool-usage.md` - Read, Write, Edit, Grep, Glob, Bash
- `official/features/mcp-integration.md` - MCP servers and integration
- `official/features/code-execution.md` - Code execution with MCP

### Validation (Quality Checklists)
- `official/validation/agent-checklist.md` - Agent quality checks
- `official/validation/skill-checklist.md` - Skill quality checks
- `official/validation/hook-checklist.md` - Hook quality checks
- `official/validation/command-checklist.md` - Command quality checks

### Ecosystem (Version Info)
- `official/ecosystem/claude-versions.md` - Model versions
- `official/ecosystem/model-capabilities.md` - Capability comparison

## Workflow

1. **Auto-invoke** on trigger keywords
2. **Load** relevant pattern/checklist based on task
3. **Guide** creation following official patterns
4. **Validate** against checklist when complete

## Examples

### Creating an Agent
```
User: "Create an agent for code security reviews"
→ Load official/patterns/agent-creation.md
→ Provide structure, frontmatter, system prompt guidance
→ After creation, validate against official/validation/agent-checklist.md
```

### Validating a Hook
```
User: "Validate my authentication hook"
→ Load official/validation/hook-checklist.md
→ Review against all checklist items
→ Report issues with recommendations
```

## Documentation Sync

External documentation is cached from official sources. To update:

```bash
# Check freshness
./scripts/check-updates.sh --verbose

# Sync stale sources
./scripts/sync-sources.sh

# Force refresh
./scripts/sync-sources.sh --force
```

Sources defined in `sources/registry.json`:
- code.claude.com/docs - Claude Code documentation
- docs.anthropic.com - API and SDK docs
- anthropic.com/engineering - Best practices blog
- github.com/anthropics/* - Official repos
- agentskills.io - Skills specification
