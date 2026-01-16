# Agent Skills Plugin

Expert assistance for the **Agent Skills open format** - a standard for extending AI agent capabilities.

## What is Agent Skills?

Agent Skills is an open format for giving AI agents new capabilities via SKILL.md files:

- **Portable**: Skills are just files - easy to version, share, and edit
- **Efficient**: Progressive disclosure keeps context usage low
- **Universal**: Supported by Claude Code, Gemini CLI, Cursor, VS Code, GitHub, and 10+ other tools

## Installation

Add this plugin to Claude Code via the marketplace or local installation.

## Usage

### Create a new skill
```
/agent-skills create my-skill
```

### Validate a skill
```
/agent-skills validate ./path/to/skill
```

### View specification
```
/agent-skills spec
```

### See examples
```
/agent-skills example
```

### Integration guide
```
/agent-skills integrate
```

## Features

- **Create**: Scaffold new skills with proper structure
- **Validate**: Check skills for format compliance
- **Specification**: Full SKILL.md format reference
- **Integration**: Guide for adding skills to your agent
- **Best Practices**: Authoring guidelines

## Quick Reference

### SKILL.md Structure

```yaml
---
name: my-skill
description: What it does and when to use it.
---

# My Skill

Instructions for the agent...
```

### Required Fields

| Field | Constraints |
|-------|-------------|
| `name` | 1-64 chars, lowercase + hyphens, matches directory |
| `description` | 1-1024 chars, what + when to use |

### Directory Structure

```
skill-name/
├── SKILL.md          # Required
├── scripts/          # Optional executables
├── references/       # Optional documentation
└── assets/           # Optional resources
```

## Upstream Sources

- **Repository**: https://github.com/agentskills/agentskills
- **Documentation**: https://agentskills.io
- **Reference Library**: https://github.com/agentskills/agentskills/tree/main/skills-ref
- **Example Skills**: https://github.com/anthropics/skills

## Sync

Update documentation from upstream:
```
/agent-skills sync
```

Compare with upstream:
```
/agent-skills diff
```
