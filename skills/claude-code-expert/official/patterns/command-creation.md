# Command Creation Pattern

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/slash-commands.md
> **Last Updated**: 2025-01-15

## What Are Custom Slash Commands?

Custom slash commands are Markdown files that create reusable prompts with the `/command-name` syntax. They enable workflow shortcuts, parameterized prompts, and team-shared conventions.

## File Structure and Locations

### Storage Directories

**Project-level commands** (shared with team):
```
.claude/commands/
```

**Personal commands** (available across all projects):
```
~/.claude/commands/
```

### File Naming

Command names derive from the Markdown filename (without `.md` extension):

```
.claude/commands/optimize.md  →  /optimize
.claude/commands/review-pr.md  →  /review-pr
~/.claude/commands/commit.md  →  /commit
```

### Namespacing with Subdirectories

Organize commands hierarchically **without affecting the command name**:

```
.claude/commands/frontend/component.md  →  /component (project:frontend)
.claude/commands/backend/api.md         →  /api (project:backend)
```

The subdirectory appears in the description but doesn't change the command name.

## Basic Command Format

### Simplest Command

Create a Markdown file with your prompt:

```markdown
Analyze this code for performance issues and suggest optimizations.
```

Usage: `/optimize`

### Command with Description

```markdown
---
description: Review code for security issues
---

Perform a comprehensive security review focusing on:
- OWASP Top 10 vulnerabilities
- Authentication and authorization
- Input validation
- SQL injection risks
- XSS vulnerabilities
```

Usage: `/security-review`

## Frontmatter Configuration

### Available Fields

| Field | Purpose | Example |
|-------|---------|---------|
| `description` | Brief summary shown in `/help` | `"Review code for security issues"` |
| `allowed-tools` | Tools the command can access | `Bash(git add:*), Bash(git status:*)` |
| `argument-hint` | Expected parameters for auto-complete | `[pr-number] [priority] [assignee]` |
| `model` | Specific Claude model to use | `claude-3-5-haiku-20241022` |
| `disable-model-invocation` | Prevent SlashCommand tool from executing it | `true` |

### Full Example

```markdown
---
description: Create a git commit
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
argument-hint: [message]
model: sonnet
---

Create a git commit with the following message: $ARGUMENTS

Follow these conventions:
- Use conventional commit format (feat:, fix:, docs:, etc.)
- Keep first line under 72 characters
- Include detailed description if needed
- Reference issue numbers
```

## Model Selection for Commands

Choose the appropriate model based on the command's complexity and frequency of use:

### When to Use Haiku

**Best for**:
- Simple, frequently-used commands
- Format conversions and transformations
- Basic file operations
- Quick status checks
- Repetitive workflows

**Examples**:
```markdown
---
description: Format code with prettier
model: haiku
---
# Fast, simple formatting operation
```

```markdown
---
description: List recent commits
allowed-tools: Bash(git log:*)
model: haiku
---
# Simple git log command
```

### When to Use Sonnet (Default Recommendation)

**Best for**:
- Code review commands
- Analysis and recommendations
- Multi-step workflows
- Moderate complexity prompts
- Most general-purpose commands

**Examples**:
```markdown
---
description: Review code for issues
model: sonnet
---
# Balanced code review analysis
```

```markdown
---
description: Generate unit tests
model: sonnet
---
# Requires reasoning about test cases
```

### When to Use Opus

**Best for**:
- Critical decision-making commands
- Security audits
- Architectural reviews
- Complex analysis requiring deep reasoning
- High-stakes deployments

**Examples**:
```markdown
---
description: Pre-production security audit
model: opus
---
# Critical security review before production
```

```markdown
---
description: Review architectural changes
model: opus
---
# Complex architectural decision-making
```

### Decision Framework for Commands

1. **Usage Frequency**: How often will this command be invoked?
   - Very frequent (daily/hourly) → Haiku
   - Regular (few times per session) → Sonnet
   - Occasional (critical moments) → Opus

2. **Reasoning Complexity**: How much analysis is required?
   - Simple execution → Haiku
   - Moderate analysis → Sonnet
   - Deep reasoning → Opus

3. **Error Impact**: What's the consequence of mistakes?
   - Low impact (formatting) → Haiku
   - Moderate impact (reviews) → Sonnet
   - High impact (security/deployment) → Opus

**Tip**: Leave the model field unset to inherit from the main conversation. Only specify when the command requires different capabilities than typical conversation flow.

## Dynamic Arguments

### Capture All Arguments

The `$ARGUMENTS` placeholder captures all passed arguments:

```markdown
---
description: Fix issue with specific priority
argument-hint: [issue-number] [priority]
---

Fix issue #$ARGUMENTS following our coding standards and best practices.
```

Usage:
```
/fix-issue 123 high-priority
```

Result: "Fix issue #123 high-priority following our coding standards..."

### Positional Arguments

Access specific arguments using `$1`, `$2`, etc., similar to shell scripts:

```markdown
---
description: Review PR with priority and assignee
argument-hint: [pr-number] [priority] [assignee]
---

Review PR #$1 with priority level $2 and assign to $3.

Focus on:
- Code quality
- Test coverage
- Security concerns
- Performance implications
```

Usage:
```
/review-pr 456 high alice
```

Result: "Review PR #456 with priority level high and assign to alice..."

## Advanced Features

### Bash Command Execution

Execute bash commands with the `!` prefix. Output is included in command context.

**Important**: Must include `allowed-tools` with `Bash` tool.

```markdown
---
description: Review git changes
allowed-tools: Bash(git status:*), Bash(git diff:*)
---

Current git status:
!`git status`

Current changes:
!`git diff HEAD`

Please review these changes and suggest improvements.
```

### File References

Include file contents using the `@` prefix:

```markdown
---
description: Review implementation
---

Review the implementation in @src/utils/helpers.js

Compare the following files:
- Old version: @src/old-version.js
- New version: @src/new-version.js

Suggest improvements and identify breaking changes.
```

### Combined: Arguments + Bash + Files

```markdown
---
description: Analyze specific component
argument-hint: [component-name]
allowed-tools: Bash(find:*), Bash(grep:*)
---

Analyze the $1 component:

Component file:
@src/components/$1.tsx

Test file:
@tests/components/$1.test.tsx

Recent changes:
!`git log --oneline -n 5 -- src/components/$1.tsx`

Provide analysis of:
1. Code quality
2. Test coverage
3. Recent changes
4. Potential improvements
```

Usage: `/analyze-component Button`

### Extended Thinking

Commands can trigger extended thinking by including "thinking keywords":

```markdown
---
description: Complex architectural decision
---

Think carefully about the following architectural decision:

$ARGUMENTS

Consider:
- Scalability implications
- Security concerns
- Performance impact
- Maintenance burden
- Team expertise required

Provide a detailed analysis with pros, cons, and recommendations.
```

Keywords that trigger thinking: "think carefully", "analyze deeply", "consider thoroughly"

## Common Command Patterns

### 1. Git Workflow Commands

```markdown
---
description: Create conventional commit
allowed-tools: Bash(git add:*), Bash(git commit:*)
argument-hint: [type] [message]
---

Create a conventional commit:
- Type: $1 (feat, fix, docs, style, refactor, test, chore)
- Message: $2

Current staged files:
!`git diff --cached --name-only`

Generate a commit message following conventional commit format.
```

### 2. Code Review Commands

```markdown
---
description: Comprehensive code review
argument-hint: [file-or-directory]
---

Perform a comprehensive code review of: $1

Files to review:
!`find $1 -type f -name "*.ts" -o -name "*.tsx"`

Review criteria:
- [ ] Code quality and maintainability
- [ ] Security vulnerabilities
- [ ] Performance issues
- [ ] Test coverage
- [ ] Documentation completeness
- [ ] Best practices adherence
```

### 3. Testing Commands

```markdown
---
description: Generate unit tests
allowed-tools: Bash(npm test:*)
argument-hint: [file-path]
---

Generate comprehensive unit tests for: @$1

Run existing tests first:
!`npm test -- $1`

Create tests covering:
1. Happy path scenarios
2. Edge cases
3. Error handling
4. Integration points
```

### 4. Documentation Commands

```markdown
---
description: Update API documentation
argument-hint: [api-file]
---

Update API documentation for: @$1

Current documentation:
@docs/api/$(basename $1 .ts).md

Ensure documentation includes:
- Function signatures
- Parameter descriptions
- Return values
- Usage examples
- Error conditions
```

### 5. Refactoring Commands

```markdown
---
description: Refactor for performance
argument-hint: [component-name]
---

Refactor $1 component for better performance:

Current implementation:
@src/components/$1.tsx

Performance profiling:
!`npm run profile -- $1`

Focus on:
- Memo usage
- Callback optimization
- Re-render prevention
- Bundle size reduction
```

### 6. Deployment Commands

```markdown
---
description: Pre-deployment checklist
allowed-tools: Bash(git status:*), Bash(npm:*)
---

Run pre-deployment checklist:

Git status:
!`git status`

Run tests:
!`npm test`

Check build:
!`npm run build`

Verify:
- [ ] All tests passing
- [ ] No uncommitted changes
- [ ] Build successful
- [ ] Environment variables set
- [ ] Database migrations ready
```

## Best Practices

### 1. Use Descriptive Names
**Poor**: `/do`, `/run`, `/check`
**Good**: `/security-review`, `/generate-tests`, `/deploy-staging`

### 2. Include Frontmatter Descriptions
Helps with discovery and `/help` menu:
```markdown
---
description: Clear, concise description of what this command does
---
```

### 3. Organize with Subdirectories
Group related commands:
```
.claude/commands/
├── git/
│   ├── commit.md
│   ├── review.md
│   └── cleanup.md
├── testing/
│   ├── unit.md
│   ├── e2e.md
│   └── coverage.md
└── deployment/
    ├── staging.md
    └── production.md
```

### 4. Specify Allowed Tools
Limit command capabilities for security:
```markdown
---
allowed-tools: Bash(git status:*), Bash(git diff:*)
---
```

### 5. Provide Clear Argument Hints
Guide users on expected parameters:
```markdown
---
argument-hint: [component-name] [test-type]
---
```

### 6. Start Simple, Build Complexity Gradually
Begin with basic prompts, add features as needed:
```markdown
# Version 1: Basic
Analyze code for issues.

# Version 2: With file reference
Analyze code in @$1 for issues.

# Version 3: With bash execution
Current files: !`ls $1`
Analyze code in @$1 for issues.

# Version 4: With full context
Run tests: !`npm test -- $1`
Current implementation: @$1
Current tests: @tests/$1
Analyze code and tests for issues.
```

### 7. Document with Comments
Explain non-obvious prompt logic:
```markdown
---
description: Complex deployment command
---

<!-- This command runs pre-deployment checks -->
<!-- Requires: npm, git, environment variables set -->

Check deployment readiness for: $1
...
```

## Conflict Resolution

**Naming conflicts**: Commands at project-level and personal-level with the same name cannot coexist. Choose unique names or use subdirectories for organization.

## SlashCommand Tool Integration

To enable Claude to **automatically invoke** custom commands during conversations:

1. Add `description` field to frontmatter
2. Reference command in CLAUDE.md or project instructions:

```markdown
Run /write-unit-test when you are about to start writing tests.
Run /security-review before committing authentication code.
```

**Important**: Custom commands require a `description` field to be available to the SlashCommand tool.

## Quick Reference

### Minimal Command
```markdown
Simple prompt text here.
```

### Command with Description
```markdown
---
description: Brief description
---

Prompt text here.
```

### Command with Arguments
```markdown
---
description: Process specific file
argument-hint: [file-path]
---

Process file: $1
Or all arguments: $ARGUMENTS
```

### Command with Bash Execution
```markdown
---
description: Run with bash output
allowed-tools: Bash(ls:*), Bash(cat:*)
---

Files: !`ls $1`
Content: !`cat $1`
```

### Command with File References
```markdown
---
description: Compare files
---

Old version: @src/old.js
New version: @src/new.js
```

### Complete Example
```markdown
---
description: Comprehensive code review
allowed-tools: Bash(git status:*), Bash(npm test:*)
argument-hint: [file-path]
model: sonnet
---

Review code changes in: $1

Current status:
!`git status`

File content:
@$1

Test results:
!`npm test -- $1`

Provide detailed review covering quality, security, and performance.
```
