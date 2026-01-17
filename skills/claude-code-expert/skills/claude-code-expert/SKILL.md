---
name: claude-code-expert
description: Claude Code and Anthropic ecosystem expert. Provides official patterns for creating agents, skills, hooks, and commands. Use when creating or validating Claude Code artifacts, asking about Claude Code features, MCP integration, or tool usage patterns.
allowed-tools: Read, Grep, Glob, WebFetch
---

# Claude Code Expert

## Purpose

Provides authoritative knowledge for Claude Code development, ensuring all artifacts follow official best practices.

## Knowledge Base

### Patterns (Creation Guides)
- `docs/patterns/agent-creation.md` - Agent creation guide
- `docs/patterns/skill-creation.md` - Skill creation guide
- `docs/patterns/hook-creation.md` - Hook creation guide
- `docs/patterns/hook-advanced.md` - Advanced hook patterns (v2.1.0+)
- `docs/patterns/command-creation.md` - Command creation guide

### Features (Capability Guides)
- `docs/features/tool-usage.md` - Read, Write, Edit, Grep, Glob, Bash
- `docs/features/mcp-integration.md` - MCP servers and integration
- `docs/features/code-execution.md` - Code execution with MCP

### Validation (Quality Checklists)
- `docs/validation/agent-checklist.md` - Agent quality checks
- `docs/validation/skill-checklist.md` - Skill quality checks
- `docs/validation/hook-checklist.md` - Hook quality checks
- `docs/validation/command-checklist.md` - Command quality checks

### Ecosystem (Version Info)
- `docs/ecosystem/claude-versions.md` - Model versions
- `docs/ecosystem/model-capabilities.md` - Capability comparison

## Workflow

1. **Auto-invoke** on trigger keywords
2. **Load** relevant pattern/checklist based on task
3. **Guide** creation following official patterns
4. **Validate** against checklist when complete

## Examples

### Creating an Agent
```
User: "Create an agent for code security reviews"
→ Load docs/patterns/agent-creation.md
→ Provide structure, frontmatter, system prompt guidance
→ After creation, validate against docs/validation/agent-checklist.md
```

### Validating a Hook
```
User: "Validate my authentication hook"
→ Load docs/validation/hook-checklist.md
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
