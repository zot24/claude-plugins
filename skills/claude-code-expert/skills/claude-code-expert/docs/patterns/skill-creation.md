# Skill Creation Pattern

> **Source**: Official Claude Code Documentation + Anthropic Engineering Blog
> **Source URLs**:
> - https://code.claude.com/docs/en/skills
> - https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills
> **Last Updated**: 2025-01-17

## What Are Agent Skills?

Agent Skills are **modular packages** that extend Claude's capabilities through organized folders of instructions, scripts, and resources that agents can discover and load dynamically.

> "Building a skill for an agent is like putting together an onboarding guide for a new hire." - Anthropic Engineering

## File Structure & Organization

### Directory Locations (Priority Order)

1. **Enterprise/Managed Skills**: Organization-wide (highest priority)
   - Deployed by administrators through managed settings
   - Available organization-wide

2. **Personal Skills**: `~/.claude/skills/skill-name/`
   - Available across all projects
   - Individual workflows and experimental capabilities

3. **Project Skills**: `.claude/skills/skill-name/`
   - Shared with team via git
   - Team conventions and project-specific expertise

4. **Plugin Skills**: Bundled within Claude Code plugins
   - Automatically available upon plugin installation

If two Skills have the same name, the higher-priority location wins.

### Automatic Discovery from Nested Directories (Monorepo Support)

Claude Code automatically discovers Skills from nested `.claude/skills/` directories in subdirectories. This supports **monorepo setups**.

**Example**: When editing `packages/frontend/`, Claude also looks for Skills in:
- `packages/frontend/.claude/skills/`

This enables package-specific skills within a monorepo structure.

### Required Structure

Each skill **MUST** contain:
- `SKILL.md` (mandatory) - Contains YAML frontmatter and instructions
- Supporting files (optional) - Documentation, examples, scripts, templates

### Example Multi-File Structure
```
my-skill/
├── SKILL.md                    # Main skill definition (required)
├── state.json                  # Persistent state (optional)
├── reference.md                # Detailed documentation
├── examples.md                 # Usage examples
├── scripts/
│   └── helper.py               # Executable scripts
├── templates/
│   └── template.txt            # Template files
└── data/
    └── baseline.json           # Data files
```

## SKILL.md Frontmatter

### Required Fields

```yaml
---
name: skill-name
description: What the skill does and when Claude should use it
---
```

| Field | Required | Format | Max Length | Description |
|-------|----------|--------|------------|-------------|
| `name` | **Yes** | Lowercase, numbers, hyphens | 64 chars | Unique identifier |
| `description` | **Yes** | Natural language | 1024 chars | Discovery triggers |

**Critical**: The `description` field is the primary mechanism for Claude to discover when to use your skill. Poor descriptions = skill never activates.

### Optional Fields (Official)

```yaml
---
name: my-skill
description: Detailed description with trigger keywords
allowed-tools: Read, Grep, Glob
model: sonnet
context: fork
agent: general-purpose
user-invocable: true
disable-model-invocation: false
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

| Field | Default | Purpose |
|-------|---------|---------|
| `allowed-tools` | All tools | Restrict which tools Claude can access (comma-separated or YAML list) |
| `model` | Inherits | Specific model for this skill (e.g., `claude-sonnet-4-20250514`) |
| `context` | (none) | Set to `fork` to run skill in isolated sub-agent context |
| `agent` | general-purpose | Agent type when `context: fork` is set (`Explore`, `Plan`, `general-purpose`, or custom) |
| `user-invocable` | true | Controls whether skill appears in slash command menu |
| `disable-model-invocation` | false | Blocks programmatic invocation via `Skill` tool |
| `hooks` | (none) | Define lifecycle hooks scoped to this skill (`PreToolUse`, `PostToolUse`, `Stop`) |

### String Substitutions

Available variables for dynamic content in skill instructions:

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed when invoking the skill. If not present, arguments are appended as `ARGUMENTS: <value>` |
| `${CLAUDE_SESSION_ID}` | Current session ID for logging, session-specific files, or correlating output |

**Example**:
```yaml
---
name: session-logger
description: Log activity for this session
---

Log the following to logs/${CLAUDE_SESSION_ID}.log:

$ARGUMENTS
```

### Deprecated/Unofficial Fields

> ⚠️ **Warning**: The following fields appear in some documentation but are **not in the official Claude Code docs**. Use with caution as they may not be officially supported.

| Field | Status | Notes |
|-------|--------|-------|
| `context_persistence` | Unofficial | May work but not documented officially |
| `auto_invoke` | Unofficial | Skills are model-invoked by default based on description |
| `triggers` | Unofficial | Use description keywords instead for discovery |

## Model Selection for Skills

Choose the appropriate model based on the skill's operational frequency, complexity, and accuracy needs:

### When to Use Haiku

**Best for**:
- High-frequency skills (trigger many times per session)
- Simple, repetitive operations
- Format conversions and data transformations
- Linting and validation
- File organization tasks
- Cost-sensitive monitoring

**Examples**:
```yaml
# Formatter - runs frequently
name: code-formatter
model: haiku

# File organizer - simple operations
name: file-organizer
model: haiku

# Linter - well-defined rules
name: syntax-checker
model: haiku
```

### When to Use Sonnet (Default Recommendation)

**Best for**:
- Moderate-frequency skills
- Analysis and reporting
- Documentation generation
- Code review assistance
- Most monitoring and tracking skills
- Balanced complexity workflows

**Examples**:
```yaml
# Performance monitor - balanced analysis
name: performance-monitor
model: sonnet

# Doc sync - moderate complexity
name: doc-sync
model: sonnet

# API analyzer - requires reasoning
name: api-analyzer
model: sonnet
```

### When to Use Opus

**Best for**:
- Low-frequency, high-stakes skills
- Security auditing
- Compliance validation
- Complex architectural analysis
- Critical decision support
- Infrequent but critical operations

**Examples**:
```yaml
# Security auditor - critical accuracy
name: security-auditor
model: opus

# Compliance checker - high stakes
name: compliance-checker
model: opus

# Production gatekeeper - critical decisions
name: production-validator
model: opus
```

### Decision Framework for Skills

Consider these factors:

1. **Invocation Frequency**: How often will this skill activate?
   - Many times per session → Haiku (cost-efficient)
   - Several times per session → Sonnet (balanced)
   - Rarely, on-demand → Opus (when accuracy critical)

2. **Operation Complexity**: How sophisticated is the analysis?
   - Simple pattern matching → Haiku
   - Moderate analysis → Sonnet
   - Complex reasoning → Opus

3. **Error Impact**: What happens if the skill makes a mistake?
   - Low impact (formatting) → Haiku
   - Moderate impact (docs) → Sonnet
   - High impact (security/compliance) → Opus

4. **State Management**: Does state complexity matter?
   - Simple state tracking → Haiku
   - Moderate state analysis → Sonnet
   - Complex state reasoning → Opus

**Tip**: For auto-invoking skills with high frequency, strongly consider Haiku to minimize token costs. Reserve Sonnet/Opus for skills that run less frequently or require deeper analysis.

## Auto-Invocation Mechanism

Skills operate through **model-invocation**—Claude autonomously determines usage based on your request and the skill's description.

### Discovery Effectiveness

**Generic descriptions FAIL**:
```yaml
description: Helps with documents
```
Result: Never triggers

**Specific descriptions SUCCEED**:
```yaml
description: Extract text and tables from PDF files. Supports multi-page analysis and table detection. Use when working with PDF files or extracting structured data from documents.
```
Result: Triggers on PDF-related tasks

### Best Description Patterns

Include these elements:
1. **What it does**: Core functionality
2. **Specific capabilities**: Detailed features
3. **When to use**: Trigger scenarios
4. **Keywords**: Domain terms Claude recognizes

Example:
```yaml
description: Analyze PostgreSQL database schemas and query performance. Identifies missing indexes, N+1 queries, and optimization opportunities. Use PROACTIVELY when working with database performance, slow queries, or schema design.
```

## Visibility Control

Control how skills can be invoked using `user-invocable` and `disable-model-invocation`:

| Setting | Slash Menu | `Skill` Tool | Auto-Discovery | Use Case |
|---------|-----------|--------------|-----------------|----------|
| `user-invocable: true` (default) | Visible | Allowed | Yes | Skills users can invoke directly |
| `user-invocable: false` | Hidden | Allowed | Yes | Skills Claude uses programmatically but users don't invoke manually |
| `disable-model-invocation: true` | Visible | Blocked | Yes | Skills users invoke but Claude doesn't invoke programmatically |

### Example: Model-Only Skill (Hidden from Users)

```yaml
---
name: internal-review-standards
description: Apply internal code review standards when reviewing pull requests
user-invocable: false
---

Apply these internal review standards...
```

### Example: User-Only Skill (Not Auto-Invoked)

```yaml
---
name: dangerous-cleanup
description: Aggressive cleanup of temp files and caches
disable-model-invocation: true
---

⚠️ This skill performs destructive operations...
```

## Run Skills in Forked Context

Use `context: fork` to run a skill in an isolated sub-agent context with its own conversation history:

```yaml
---
name: code-analysis
description: Analyze code quality and generate detailed reports
context: fork
agent: general-purpose
---

Perform comprehensive code analysis...
```

**Key Points**:
- The `agent` field specifies which agent type to use (defaults to `general-purpose`)
- Built-in agents: `Explore`, `Plan`, `general-purpose`
- Can also reference custom agents from `.claude/agents/`
- Forked context preserves main conversation context

## Skills and Subagents

### Give Subagents Access to Skills

Custom subagents **don't automatically inherit skills**. You must explicitly list them in the subagent's `skills` field:

```yaml
# .claude/agents/code-reviewer.md
---
name: code-reviewer
description: Expert code reviewer
skills: code-analysis, security-check
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer using the code-analysis and security-check skills.
```

**Important Notes**:
- The full skill content is **injected into the subagent's context** at startup
- Subagents do NOT inherit skills from the parent conversation
- **Built-in agents** (`Explore`, `Plan`, `general-purpose`) **don't have access to your Skills** — only custom subagents with explicit `skills` field

### Run a Skill in a Subagent Context

Use `context: fork` and `agent` to run a skill in a forked subagent:

```yaml
---
name: code-analysis
description: Analyze code quality
context: fork
agent: code-reviewer
---
```

## Define Hooks for Skills

Skills can define hooks scoped to their lifecycle:

```yaml
---
name: secure-operations
description: Perform operations with additional security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh $TOOL_INPUT"
          once: true
---
```

**Supported Events**:
- `PreToolUse` - Before tool execution
- `PostToolUse` - After tool completes
- `Stop` - When skill finishes

**Options**:
- `once: true` - Run the hook only once per session; automatically removed after first successful execution
- Hooks defined in skills are scoped to that skill's execution and automatically cleaned up when the skill finishes

## Progressive Disclosure Pattern

Claude loads content efficiently by reading supplementary files **only when needed**.

### Basic Progressive Disclosure
```markdown
# Main instructions in SKILL.md

For advanced patterns, see [advanced.md](advanced.md).
For troubleshooting, see [troubleshooting.md](troubleshooting.md).
For examples, see [examples/](examples/).
```

### Three-Tier Disclosure Pattern

**Level 1: Always Loaded** (SKILL.md frontmatter)
- Name and description only
- Zero tokens until skill activates

**Level 2: Loaded When Relevant** (SKILL.md content)
- Full instructions
- Core patterns
- ~2-5k tokens

**Level 3+: On-Demand** (Referenced files)
- Detailed documentation
- Examples and templates
- Scripts and tools
- Load only when explicitly needed

### Token Efficiency

> "The amount of context that can be bundled into a skill is effectively unbounded" since agents access information through filesystem tools rather than loading everything into context.

## State Management

### When to Use State

Use `state.json` for skills that need to:
- Track progress across sessions
- Remember baselines or metrics
- Store configuration preferences
- Maintain version information
- Track feature adoption

### State File Pattern
```json
{
  "version": "1.0.0",
  "lastRun": "2025-11-10T10:30:00Z",
  "metrics": {
    "totalRuns": 42,
    "lastResult": "success"
  },
  "config": {
    "checkInterval": "14 days",
    "autoUpdate": false
  },
  "history": [
    {
      "timestamp": "2025-11-10T10:30:00Z",
      "event": "baseline_captured",
      "data": {}
    }
  ]
}
```

### State Access Pattern in SKILL.md
```markdown
When invoked:
1. Read state.json to check last run date
2. If > 14 days, suggest update
3. Load relevant historical data
4. Execute skill logic
5. Update state.json with results
```

## Skill vs Agent Decision Matrix

| Use Case | Choose |
|----------|--------|
| Persistent state across sessions | **Skill** |
| Multi-phase workflow | **Skill** |
| Auto-invocation on keywords | **Skill** |
| Complex directory structure | **Skill** |
| Simple, focused task | Agent |
| One-time specialized analysis | Agent |
| Tool restriction only | Agent |

**Rule of thumb**: Skills = complex + stateful + auto-invoke. Agents = simple + stateless + explicit invoke.

## Common Skill Patterns

### Monitoring Skill Pattern
```yaml
---
name: performance-monitor
description: Track application performance metrics over time. Detects regressions and monitors optimization history. Use PROACTIVELY when deploying changes, checking performance, or investigating performance regressions.
allowed-tools: Read, Bash, Grep, Glob
---

# Performance Monitoring Skill

## Context
Maintains baseline performance metrics and detects regressions.

## State Management
- Tracks historical metrics in state.json
- Compares current vs baseline
- Alerts on regressions > 10%

## Workflow
1. Check state.json for baseline
2. Measure current performance
3. Compare and analyze
4. Update state with results
5. Alert if regression detected

For detailed metrics, see [metrics.md](metrics.md).
For baseline capture process, see [baseline-process.md](baseline-process.md).
```

### Documentation Management Skill
```yaml
---
name: doc-sync
description: Keep documentation synchronized with code changes. Automatically updates API docs, README files, and changelog. Use when committing code changes, before releases, or when updating docs.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
---

# Documentation Sync Skill

## Purpose
Ensures documentation stays current with code.

## Checks
- [ ] API docs match implementation
- [ ] README reflects new features
- [ ] Changelog updated
- [ ] Examples still work

## Process
1. Detect code changes via git
2. Identify affected docs
3. Update docs with changes
4. Validate examples
5. Commit doc updates

See [api-doc-patterns.md](patterns/api-docs.md) for API documentation standards.
```

### Code Execution Skill Pattern
```yaml
---
name: data-processor
description: Process large datasets using Python scripts. Handles CSV analysis, data transformation, and report generation. Use for data analysis tasks requiring computation.
allowed-tools: Read, Write, Bash
---

# Data Processing Skill

## Capabilities
- CSV/Excel file analysis
- Data transformation pipelines
- Statistical calculations
- Report generation

## Scripts Included
- `scripts/analyze.py` - Data analysis
- `scripts/transform.py` - Data transformation
- `scripts/visualize.py` - Chart generation

## Usage
```bash
python scripts/analyze.py input.csv --output report.json
```

See [script-reference.md](scripts/README.md) for full documentation.
```

## Best Practices

### 1. Keep Skills Focused
**Poor**: "Document processing"
**Better**: Separate skills for "PDF form filling," "Excel data analysis," "Git commit messages"

### 2. Write Discoverable Descriptions

**Vague**: "Helps with data"
**Clear**: "Analyze Excel spreadsheets, generate pivot tables, create charts. Use when working with .xlsx files or financial data analysis."

### 3. Start with Evaluation
- Test agents on representative tasks
- Identify capability gaps
- Build skills incrementally
- Don't anticipate needs upfront

### 4. Structure for Scale
- Split large SKILL.md into referenced files
- Keep mutually exclusive contexts separate
- Use code as tools AND documentation

### 5. Think From Claude's Perspective
- Monitor real-world skill usage
- Iterate based on observations
- Focus on `name` and `description` quality
- Request Claude's self-reflection when skills underperform

### 6. Iterate Collaboratively
- Work with Claude to capture successful approaches
- Document mistakes to avoid
- Refine based on usage patterns

### 7. Bundle Scripts for Determinism
> "Sorting a list via token generation is far more expensive than simply running a sorting algorithm."

Bundle pre-written scripts for:
- Sorting and filtering
- Form field extraction
- Data validation
- Complex calculations

## Security Considerations

⚠️ **Skills provide powerful capabilities but introduce risks:**

- Install only from **trusted sources**
- Thoroughly **audit** unfamiliar skills before use
- Examine bundled **files, dependencies, and code**
- Scrutinize instructions directing Claude to **external networks**

Use `allowed-tools` to restrict skill capabilities:
```yaml
# Read-only skill
allowed-tools: Read, Grep, Glob

# Limited write access
allowed-tools: Read, Write, Grep

# Full access (careful!)
# (omit allowed-tools field)
```

## Sharing & Distribution

### Recommended: Plugin Distribution
1. Package skills within plugins
2. Distribute via team marketplaces
3. Team members install plugins
4. Skills automatically available

### Alternative: Git-Based Sharing
1. Create project skill in `.claude/skills/`
2. Commit to version control
3. Team members pull changes
4. Skills automatically activate

## Troubleshooting

### Skill Not Triggering?

The `description` field is critical. Claude reads descriptions to find relevant skills. Include:
1. **What does this skill do?** - List specific capabilities
2. **When should Claude use it?** - Include trigger terms users would mention

**Bad description** (too vague):
```yaml
description: Helps with documents
```

**Good description** (specific):
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

### Skill Doesn't Load?

- ✓ **Check file path**: Must be exact: `SKILL.md` (case-sensitive)
- ✓ **Check YAML syntax**: Frontmatter must start with `---` on line 1 (no blank lines before), end with `---`, use spaces (not tabs)
- ✓ **Run debug mode**: `claude --debug`
- ✓ **Check file location**: `~/.claude/skills/name/SKILL.md` or `.claude/skills/name/SKILL.md`

### Skill Has Errors?

- ✓ Confirm required dependencies/packages are installed
- ✓ Verify script permissions: `chmod +x scripts/*.py`
- ✓ Use forward slashes in paths: `scripts/helper.py` not `scripts\helper.py`

### Multiple Skills Conflicting?

Make descriptions distinct with specific trigger terms:
- ✓ "sales data in Excel files and CRM exports" (vs generic "data analysis")
- ✓ "log files and system metrics" (vs generic "data analysis")

### Plugin Skills Not Loading?

1. **Clear plugin cache**:
   ```bash
   rm -rf ~/.claude/plugins/cache
   ```

2. **Verify plugin structure**:
   ```
   my-plugin/
   ├── .claude-plugin/
   │   └── plugin.json        # Only plugin.json goes here
   └── skills/                 # Skills at plugin root, NOT inside .claude-plugin
       └── my-skill/
           └── SKILL.md
   ```

3. **Restart Claude Code** after installing plugins (skills require restart to load)

4. **Test with debug flag**:
   ```bash
   claude --plugin-dir ./my-plugin --debug
   ```

## When to Use Skills vs Other Options

| Use This | When You Want To… | When It Runs |
|----------|-------------------|--------------|
| **Skills** | Give Claude specialized knowledge | Claude chooses when relevant |
| **Slash commands** | Create reusable prompts | You type `/command` |
| **CLAUDE.md** | Set project-wide instructions | Loaded into every conversation |
| **Subagents** | Delegate tasks in separate context | Claude delegates or you invoke |
| **Hooks** | Run scripts on events | Fires on specific tool events |
| **MCP servers** | Connect to external tools/data | Claude calls as needed |

## Platform Support

Agent Skills are supported across:
- ✅ Claude.ai
- ✅ Claude Code
- ✅ Claude Agent SDK
- ✅ Claude Developer Platform

## Quick Reference

**Minimum viable skill**:
```
.claude/skills/my-skill/
└── SKILL.md
```

```yaml
---
name: my-skill
description: Specific description with clear trigger keywords
---

Instructions for what this skill does.
```

**Full-featured skill** (with official fields):
```
.claude/skills/advanced-skill/
├── SKILL.md
├── state.json
├── reference.md
├── examples.md
├── scripts/
│   └── process.py
└── templates/
    └── output.md
```

```yaml
---
name: advanced-skill
description: Comprehensive description with PROACTIVE keywords and specific use cases
allowed-tools: Read, Write, Bash
model: sonnet
context: fork
agent: general-purpose
user-invocable: true
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---

# Main instructions

Session ID: ${CLAUDE_SESSION_ID}
Arguments: $ARGUMENTS

See [reference.md](reference.md) for details.
See [examples.md](examples.md) for usage.
```

**All official YAML fields**:
| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase, numbers, hyphens; max 64 chars) |
| `description` | Yes | When to use skill (max 1024 chars) |
| `allowed-tools` | No | Tools Claude can use (comma-separated or YAML list) |
| `model` | No | Model to use (e.g., `claude-sonnet-4-20250514`) |
| `context` | No | Set to `fork` for isolated sub-agent context |
| `agent` | No | Agent type when `context: fork` is set |
| `hooks` | No | Lifecycle hooks (`PreToolUse`, `PostToolUse`, `Stop`) |
| `user-invocable` | No | Show in slash command menu (default: true) |
| `disable-model-invocation` | No | Block `Skill` tool invocation |
