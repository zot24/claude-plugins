# Agent Skills Integration Guide

> Source: https://agentskills.io/integrate-skills

## Overview

A skills-compatible agent needs to:
1. **Discover** skills in configured directories
2. **Load metadata** (name and description) at startup
3. **Match** user tasks to relevant skills
4. **Activate** skills by loading full instructions
5. **Execute** scripts and access resources as needed

## Two Integration Approaches

### 1. Filesystem-based Agents
- Operate within a computer environment (bash/unix)
- Most capable option
- Skills activated when models issue shell commands like `cat /path/to/my-skill/SKILL.md`
- Bundled resources accessed through shell commands

### 2. Tool-based Agents
- Function without a dedicated computer environment
- Implement tools allowing models to trigger skills and access bundled assets
- Specific tool implementation is up to the developer

## Skill Discovery

Skills are folders containing a `SKILL.md` file. Your agent should scan configured directories for valid skills.

## Loading Metadata

Parse only the frontmatter of each `SKILL.md` file at startup to keep initial context usage low.

### Parsing Frontmatter Example

```
function parseMetadata(skillPath):
    content = readFile(skillPath + "/SKILL.md")
    frontmatter = extractYAMLFrontmatter(content)

    return {
        name: frontmatter.name,
        description: frontmatter.description,
        path: skillPath
    }
```

## Injecting Skills into Context

Include skill metadata in the system prompt so the model knows what skills are available.

### Recommended Format (Claude Models - XML)

```xml
<available_skills>
  <skill>
    <name>pdf-processing</name>
    <description>Extracts text and tables from PDF files, fills forms, merges documents.</description>
    <location>/path/to/skills/pdf-processing/SKILL.md</location>
  </skill>
  <skill>
    <name>data-analysis</name>
    <description>Analyzes datasets, generates charts, and creates summary reports.</description>
    <location>/path/to/skills/data-analysis/SKILL.md</location>
  </skill>
</available_skills>
```

**Key Details:**
- For **filesystem-based agents**: Include the `location` field with the absolute path to SKILL.md
- For **tool-based agents**: The location can be omitted
- Keep metadata concise; each skill should add roughly 50-100 tokens to context

## Security Considerations

When implementing script execution, consider:
- **Sandboxing**: Run scripts in isolated environments
- **Allowlisting**: Only execute scripts from trusted skills
- **Confirmation**: Ask users before running potentially dangerous operations
- **Logging**: Record all script executions for auditing

## Reference Implementation

The [**skills-ref** library](https://github.com/agentskills/agentskills/tree/main/skills-ref) provides Python utilities and a CLI for working with skills.

### Useful Commands

**Validate a skill directory:**
```bash
skills-ref validate <path>
```

**Generate `<available_skills>` XML for agent prompts:**
```bash
skills-ref to-prompt <path>...
```

Use the library source code as a reference implementation for your own integration.

## Progressive Disclosure Flow

1. **Startup**: Load only `name` and `description` from all skills (~100 tokens each)
2. **Task Matching**: When user request matches a skill's description, load full SKILL.md
3. **Execution**: Load scripts/references/assets only when specifically needed
4. **Cleanup**: Release loaded content when task completes

## Implementation Checklist

- [ ] Scan configured directories for SKILL.md files
- [ ] Parse YAML frontmatter to extract metadata
- [ ] Inject available skills into system prompt
- [ ] Implement mechanism to load full SKILL.md on activation
- [ ] Provide file access for bundled resources
- [ ] (Optional) Implement script execution with sandboxing
- [ ] (Optional) Add logging for skill usage analytics
