# What Are Agent Skills?

> Source: https://agentskills.io/what-are-skills

## Overview

Agent Skills are a **lightweight, open format for extending AI agent capabilities** with specialized knowledge and workflows. At their core, skills are folders containing a `SKILL.md` file with metadata and instructions that tell agents how to perform specific tasks.

### Basic Structure

```
my-skill/
├── SKILL.md          # Required: instructions + metadata
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
└── assets/           # Optional: templates, resources
```

## How Skills Work

Skills use **progressive disclosure** to manage context efficiently:

1. **Discovery**: At startup, agents load only the name and description of each available skill—just enough to know when it might be relevant.

2. **Activation**: When a task matches a skill's description, the agent reads the full `SKILL.md` instructions into context.

3. **Execution**: The agent follows the instructions, optionally loading referenced files or executing bundled code as needed.

This approach keeps agents fast while giving them access to more context on demand.

## The SKILL.md File Format

Every skill starts with a `SKILL.md` file containing YAML frontmatter and Markdown instructions:

```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents.
---

# PDF Processing

## When to use this skill
Use this skill when the user needs to work with PDF files...

## How to extract text
1. Use pdfplumber for text extraction...

## How to fill forms
...
```

### Required Frontmatter

- **`name`**: A short identifier for the skill
- **`description`**: When to use this skill (helps agents decide if it's relevant)

The Markdown body contains the actual instructions with no specific restrictions on structure or content.

## Key Advantages

- **Self-documenting**: Skill authors and users can read `SKILL.md` to understand what it does, making skills easy to audit and improve.
- **Extensible**: Skills can range from text instructions alone to executable code, assets, and templates.
- **Portable**: Skills are just files, making them easy to edit, version, and share.

## Example Use Case: PDF Processing

A `pdf-processing` skill would include:
- Instructions for text extraction using tools like pdfplumber
- Methods for filling PDF forms
- Guidance on merging multiple documents
- Optional scripts in the `scripts/` directory for common operations
- Reference documentation in `references/`

## The Problem Skills Solve

**The Challenge:**
- Agents are increasingly capable but lack context needed for reliable real-world work
- Agents don't have access to procedural knowledge, company-specific information, or user-specific context

**The Solution:**
Skills solve this by giving agents access to:
- Procedural knowledge
- Company-, team-, and user-specific context
- On-demand loadable capabilities
- Task-specific extensions

## What Skills Enable

1. **Domain Expertise**: Package specialized knowledge into reusable instructions
2. **New Capabilities**: Give agents abilities like creating presentations, building MCP servers, analyzing datasets
3. **Repeatable Workflows**: Turn multi-step tasks into consistent, auditable workflows
4. **Interoperability**: Reuse the same skill across different skills-compatible agent products

## Adoption

Agent Skills are supported by leading AI development tools including:
- Claude Code
- Gemini CLI
- Cursor
- VS Code
- GitHub
- OpenAI Codex
- Amp
- Letta
- Goose
- Factory
- And more

## Resources

- **GitHub Repository**: https://github.com/agentskills/agentskills
- **Documentation**: https://agentskills.io
- **Example Skills**: https://github.com/anthropics/skills
- **Reference Library**: https://github.com/agentskills/agentskills/tree/main/skills-ref
