# Agent Creation Pattern

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/sub-agents.md
> **Last Updated**: 2025-01-15

## What Are Subagents?

Subagents are specialized AI assistants stored as Markdown files with YAML frontmatter. They enable focused expertise, tool restriction, and reusable workflows across projects.

## File Structure

### Storage Locations (Priority Order)
1. **Project-level**: `.claude/agents/` (highest priority, current project only)
2. **User-level**: `~/.claude/agents/` (available across all projects)
3. **Plugin-provided**: Within plugin `agents/` directories

### Basic Structure
```markdown
---
name: agent-identifier
description: When and why to use this agent
tools: tool1, tool2, tool3
model: sonnet
---

System prompt content describing the agent's role,
capabilities, and approach to problem-solving.
```

## Required Fields

| Field | Required | Format | Description |
|-------|----------|--------|-------------|
| `name` | **Yes** | Lowercase with hyphens | Unique identifier (e.g., `code-reviewer`) |
| `description` | **Yes** | Natural language | When/why to use this agent, triggers |

## Optional Fields

| Field | Default | Purpose |
|-------|---------|---------|
| `tools` | All tools | Comma-separated list to restrict access |
| `model` | Inherits | `sonnet`, `opus`, `haiku`, or `'inherit'` |

**Important**: When `tools` field is omitted, agent inherits ALL available tools, including MCP server integrations.

## Model Selection for Agents

Choose the appropriate model based on the agent's complexity, frequency of use, and accuracy requirements:

### When to Use Haiku

**Best for**:
- Simple, repetitive tasks
- High-frequency operations (executed many times per session)
- Straightforward transformations
- Well-defined, narrow scope
- Cost-sensitive applications

**Examples**:
```yaml
# Format converter - simple, repetitive
name: json-formatter
model: haiku

# File renamer - straightforward operations
name: file-renamer
model: haiku

# Simple linter - well-defined rules
name: code-linter
model: haiku
```

### When to Use Sonnet (Default Recommendation)

**Best for**:
- General-purpose agents
- Balanced complexity and performance needs
- Standard development workflows
- Code reviews and refactoring
- Most production use cases

**Examples**:
```yaml
# Code reviewer - balanced analysis
name: code-reviewer
model: sonnet

# API integration - moderate complexity
name: api-integrator
model: sonnet

# Debugger - requires reasoning
name: debugger
model: sonnet
```

### When to Use Opus

**Best for**:
- Critical decision-making
- Complex architectural analysis
- Security audits
- Novel problem-solving
- High-stakes situations where accuracy is paramount

**Examples**:
```yaml
# Security auditor - critical accuracy needed
name: security-auditor
model: opus

# System architect - complex decisions
name: system-architect
model: opus

# Compliance reviewer - high stakes
name: compliance-reviewer
model: opus
```

### Decision Framework

Ask yourself these questions:

1. **Task Complexity**: How intricate is the reasoning required?
   - Simple → Haiku
   - Moderate → Sonnet
   - Complex → Opus

2. **Frequency of Use**: How often will this agent run?
   - Very frequent → Haiku (cost-efficient)
   - Regular → Sonnet (balanced)
   - Occasional → Opus (when needed)

3. **Error Cost**: What's the impact of mistakes?
   - Low impact → Haiku
   - Moderate impact → Sonnet
   - High impact/critical → Opus

4. **Speed vs Accuracy Trade-off**: What matters more?
   - Speed priority → Haiku
   - Balanced → Sonnet
   - Accuracy priority → Opus

**Tip**: Start with Sonnet for most agents. Switch to Haiku if the task proves simple and repetitive. Upgrade to Opus if critical accuracy is needed.

## System Prompt Best Practices

Effective system prompts should include:

### 1. Role Definition
Clear statement of expertise and responsibilities:
```markdown
You are a security-focused code reviewer specializing in identifying
vulnerabilities in web applications. You have deep expertise in OWASP
Top 10 vulnerabilities and secure coding practices.
```

### 2. Specific Instructions
Step-by-step processes when invoked:
```markdown
When invoked:
1. Read all changed files
2. Analyze for security vulnerabilities
3. Check for OWASP Top 10 issues
4. Review authentication/authorization logic
5. Examine input validation
```

### 3. Checklists
Review criteria and validation steps:
```markdown
## Security Checklist
- [ ] No SQL injection vulnerabilities
- [ ] Proper input validation
- [ ] Secure password handling
- [ ] No hardcoded secrets
- [ ] CSRF protection in place
```

### 4. Output Format
How results should be presented:
```markdown
## Output Format

Provide findings as:
- **Critical**: Immediate security risks
- **High**: Important vulnerabilities
- **Medium**: Should be addressed
- **Low**: Minor improvements
```

### 5. Constraints
Limitations or focus areas:
```markdown
## Constraints
- Focus ONLY on security issues
- Do NOT refactor for style
- Prioritize authentication/authorization bugs
- Flag any secrets in code
```

### 6. Examples
Concrete scenarios demonstrating expected behavior:
```markdown
## Example Analysis

**Bad**:
```javascript
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

**Issue**: SQL injection vulnerability
**Fix**: Use parameterized queries
```

## Tool Selection Strategy

**Limit to necessary tools** for the agent's specific purpose:

```yaml
# Security reviewer - read-only
tools: Read, Grep, Glob

# Code generator - full access
tools: Read, Write, Edit, Grep, Glob, Bash

# Database specialist - includes MCP
# (omit tools field to inherit all, including MCP servers)
```

Benefits of tool restriction:
- Improves security
- Maintains focus
- Prevents unintended actions

## When to Use Subagents

Use subagents when:
- ✅ Tasks require specialized expertise or dedicated focus
- ✅ Separate context windows prevent pollution of main conversation
- ✅ Consistent workflows benefit from reusable configurations
- ✅ Tool permissions need restriction for security
- ✅ Complex projects require multiple specialized assistants
- ✅ Team sharing and collaboration needed

## Invocation Patterns

### Automatic Delegation
Claude automatically invokes appropriate agents based on task description matching agent description.

**Encourage automatic selection** with these phrases in descriptions:
- "use PROACTIVELY"
- "MUST BE USED when..."
- "Auto-invokes when..."

Example:
```yaml
description: Use PROACTIVELY for security code reviews. MUST BE USED when analyzing authentication, authorization, or handling sensitive data.
```

### Explicit Invocation
Users can directly request specific agents:
```
> Use the code-reviewer agent to examine my changes
> Have the debugger agent investigate this error
> Ask the data-scientist agent to analyze these metrics
```

## Common Agent Patterns

### Code Reviewer Pattern
```yaml
---
name: code-reviewer
description: Reviews code for quality, security, and maintainability. Use for pull requests, security audits, and code quality checks.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are an experienced code reviewer focusing on:
- Code quality and maintainability
- Security vulnerabilities (OWASP Top 10)
- Best practices and patterns
- Error handling and edge cases
- Test coverage

## Review Checklist
- [ ] Clear, descriptive naming
- [ ] No code duplication
- [ ] Proper error handling
- [ ] No secrets in code
- [ ] Input validation present
- [ ] Test coverage adequate
```

### Debugger Pattern
```yaml
---
name: debugger
description: Specializes in root cause analysis and bug fixing. Use when investigating errors, exceptions, or unexpected behavior.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a debugging specialist who:
1. Captures error messages and stack traces
2. Identifies reproduction steps
3. Isolates failures through systematic testing
4. Implements minimal, targeted fixes
5. Reviews recent changes and logs
```

### Data Analyst Pattern
```yaml
---
name: data-analyst
description: Handles SQL queries and data analysis. Use for database operations, metrics analysis, and reporting.
tools: Read, Write, Bash
# Omit tools to inherit MCP servers like PostgreSQL
model: sonnet
---

You are a data analyst specializing in:
- Writing optimized SQL queries
- Data extraction and transformation
- Metrics calculation and analysis
- Clear data visualization
- Actionable recommendations
```

## Coordination Between Agents

### Agent Chaining
Combine multiple agents for complex workflows:
```
> First use code-analyzer for performance issues,
  then use optimizer to fix them
```

### Agent Resumption
Continue previous agent work with unique agent IDs:
```
> Resume work from agent-abc123
```

Agent transcripts are stored in `agent-{agentId}.jsonl` for continuity across sessions.

## Creation Approaches

### Recommended: AI-Assisted Creation
1. Describe the agent's purpose to Claude
2. Let Claude generate initial configuration
3. Review and customize the output
4. Save to appropriate directory
5. Test and iterate

### Manual Creation
1. Create Markdown file in `.claude/agents/` or `~/.claude/agents/`
2. Add required YAML frontmatter
3. Write comprehensive system prompt
4. Test with sample tasks
5. Refine based on results

### CLI Configuration (Temporary)
Use `--agents` flag with JSON for session-specific agents:
```bash
claude --agents '{"name":"temp-agent","description":"...","tools":"Read,Grep"}'
```

## Organizational Principles

### Core Agents (Generic Patterns)
Location: `.claude/agents/core/`

Categories:
- `backend-api/` - API patterns, database, security
- `infrastructure-deployment/` - Vercel, CI/CD, monitoring
- `frontend-development/` - Next.js, React, TypeScript
- `content-marketing/` - SEO, analytics, documentation
- `quality-assurance/` - Testing patterns
- `meta-orchestration/` - Agent coordination
- `business-strategy/` - Planning, metrics, research

### Domain Agents (Business Knowledge)
Location: `.claude/agents/domain/`

Contains business-specific knowledge without credentials.

### Three-Tier Architecture
```
Core (Generic Patterns)
  ↓ extends
Domain (Business Knowledge)
  ↓ extends
Project (Credentials & Configs)
```

## Best Practices Summary

1. **Focused responsibility**: Each agent handles single, clear objectives
2. **Detailed guidance**: Comprehensive instructions improve performance
3. **Version control**: Store project agents in repositories for collaboration
4. **Scope clarity**: Explicit descriptions help automatic agent selection
5. **Tool minimalism**: Limit tools to necessary operations
6. **Test thoroughly**: Validate agent behavior before team deployment
7. **Iterate based on usage**: Monitor performance and refine prompts

## Quick Reference

**Minimum viable agent**:
```yaml
---
name: my-agent
description: What this agent does and when to use it
---

Role definition and instructions here.
```

**Full-featured agent**:
```yaml
---
name: comprehensive-agent
description: Detailed description with PROACTIVE trigger keywords
tools: Read, Write, Edit, Grep, Glob
model: sonnet
---

# Role
Detailed role definition

# Capabilities
What you can do

# Instructions
Step-by-step process

# Checklist
Validation criteria

# Output Format
How to present results

# Examples
Concrete demonstrations
```
