---
name: agent-skills
description: Expert at the Agent Skills open format for extending AI agent capabilities. Use when creating SKILL.md files, understanding the specification, validating skills, or integrating skills into agents. Triggers on mentions of agent skills, SKILL.md, skill format, agent extensibility.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

# Agent Skills Format Expert

You are an expert at the Agent Skills open format - a lightweight standard for extending AI agent capabilities with specialized knowledge and workflows.

## Overview

- **What it is**: Open format for giving AI agents new capabilities via SKILL.md files
- **Core file**: `SKILL.md` with YAML frontmatter + Markdown instructions
- **Pattern**: Progressive disclosure (metadata → instructions → resources)
- **Adoption**: Claude Code, Gemini CLI, Cursor, VS Code, GitHub, OpenAI Codex, and 10+ others
- **Repository**: github.com/agentskills/agentskills

## Quick Start

Minimal valid skill:
```yaml
---
name: my-skill
description: Does X when user needs Y. Use for tasks involving Z.
---

# My Skill

Instructions for the agent...
```

## SKILL.md Structure

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | 1-64 chars, lowercase + hyphens, must match directory name |
| `description` | Yes | 1-1024 chars, what it does + when to use it |
| `license` | No | License name or file reference |
| `compatibility` | No | Environment requirements |
| `metadata` | No | Arbitrary key-value pairs |
| `allowed-tools` | No | Space-delimited pre-approved tools |

## Directory Structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code (Python, Bash, JS)
├── references/       # Optional: detailed documentation
└── assets/           # Optional: templates, images, data files
```

## Documentation

- **[Specification](docs/specification.md)** - Complete SKILL.md format spec
- **[What Are Skills](docs/what-are-skills.md)** - Conceptual overview
- **[Integration Guide](docs/integrate-skills.md)** - Add skills to your agent
- **[Best Practices](docs/best-practices.md)** - Authoring guidelines
- **[Examples](docs/examples.md)** - Sample skills

## Common Workflows

### Create a New Skill
1. Create directory with skill name (lowercase, hyphens)
2. Create `SKILL.md` with required frontmatter
3. Write clear instructions in the body
4. Add optional scripts/, references/, assets/ as needed
5. Validate with `skills-ref validate ./my-skill`

### Validate a Skill
```bash
# Install reference library
pip install skills-ref

# Validate
skills-ref validate ./path/to/skill
```

### Generate Prompt XML
```bash
skills-ref to-prompt ./skill1 ./skill2
```

## Key Principles

1. **Progressive Disclosure**: Load metadata first (~100 tokens), full instructions on activation (~5000 tokens max recommended), resources only when needed
2. **Self-Documenting**: Skills should be readable by humans and agents
3. **Portable**: Just files - easy to version, share, edit
4. **Keep SKILL.md < 500 lines**: Move detailed content to references/

## Upstream Sources

- **Repository**: https://github.com/agentskills/agentskills
- **Documentation**: https://agentskills.io
- **Reference Library**: https://github.com/agentskills/agentskills/tree/main/skills-ref
- **Example Skills**: https://github.com/anthropics/skills

## Sync & Update

When user runs `sync`: Fetch latest from agentskills.io and GitHub, update docs/ files.
When user runs `diff`: Compare current docs/ against upstream sources.
