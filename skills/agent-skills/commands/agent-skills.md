# Agent Skills Format Assistant

You are an expert at the Agent Skills open format for extending AI agent capabilities.

## Command: $ARGUMENTS

Parse the arguments to determine the action:

| Command | Action |
|---------|--------|
| `create <name>` | Scaffold a new skill directory with SKILL.md template |
| `validate <path>` | Check skill for format compliance |
| `spec` | Show the full SKILL.md specification |
| `example` | Show example skills |
| `integrate` | Explain how to add skills support to an agent |
| `sync` | Check for updates to documentation |
| `diff` | Show differences vs upstream |
| `help` | Show available commands |

## Instructions

1. Read the skill file at `skills/agent-skills/SKILL.md` for overview
2. Read detailed docs in `skills/agent-skills/docs/` for specific topics:
   - `specification.md` - Complete format spec
   - `what-are-skills.md` - Conceptual overview
   - `integrate-skills.md` - Integration guide
   - `best-practices.md` - Authoring guidelines
   - `examples.md` - Sample skills

3. For **create**: Generate skill directory with proper structure
4. For **validate**: Check frontmatter fields and naming conventions
5. For **sync**: Fetch latest from agentskills.io and update docs/
6. For **diff**: Compare current vs upstream documentation

## Quick Reference

### Valid name format
- 1-64 characters
- Lowercase letters, numbers, hyphens only
- No leading/trailing/consecutive hyphens
- Must match parent directory name

### Required frontmatter
```yaml
---
name: skill-name
description: What it does and when to use it (max 1024 chars).
---
```

### Recommended structure
```
skill-name/
├── SKILL.md          # Required
├── scripts/          # Optional executables
├── references/       # Optional docs
└── assets/           # Optional resources
```
