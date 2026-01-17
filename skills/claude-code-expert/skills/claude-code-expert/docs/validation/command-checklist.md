# Command Validation Checklist

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/slash-commands.md
> **Last Updated**: 2025-01-15

## Pre-Creation Validation

### Purpose Definition
- [ ] Command serves a clear, specific purpose
- [ ] Command is not duplicating built-in Claude Code commands
- [ ] Command provides value through reusability or automation
- [ ] Command name is descriptive and intuitive

### Scope Determination
- [ ] Project-level command (team-shared) vs personal command (user-only) determined
- [ ] Command location chosen: `.claude/commands/` (project) or `~/.claude/commands/` (personal)
- [ ] Subdirectory organization planned if part of command group

## File Structure Validation

### Naming Convention
- [ ] Filename uses lowercase letters, numbers, hyphens only
- [ ] Filename is descriptive (e.g., `review-pr.md`, not `rp.md`)
- [ ] `.md` extension used
- [ ] Name doesn't conflict with existing commands

### File Location
- [ ] Correct directory: `.claude/commands/` or `~/.claude/commands/`
- [ ] Subdirectory used for organization if applicable
- [ ] File path is accessible and has proper permissions

## Frontmatter Validation

### Required Fields
- [ ] Valid YAML frontmatter with opening `---`
- [ ] Valid YAML frontmatter with closing `---`
- [ ] No tabs in YAML (spaces only)

### Optional Fields (if used)
- [ ] `description`: Clear, concise summary (shows in `/help`)
- [ ] `allowed-tools`: Properly formatted tool list with specific permissions
- [ ] `argument-hint`: Descriptive parameter guidance (e.g., `[pr-number] [priority]`)
- [ ] `model`: Valid model identifier (`sonnet`, `opus`, `haiku`) if specific model needed
- [ ] `model` choice appropriate for command profile:
  - Haiku: frequently-used commands, simple operations, format conversions, quick checks
  - Sonnet: code reviews, analysis, multi-step workflows, most general commands (default)
  - Opus: critical decisions, security audits, architectural reviews, high-stakes operations
- [ ] Usage frequency considered (frequent commands benefit from Haiku for cost efficiency)
- [ ] Reasoning complexity assessed (simple execution vs deep analysis)
- [ ] Error impact evaluated (low vs high stakes)
- [ ] `disable-model-invocation`: Set to `true` if preventing SlashCommand tool use

### Frontmatter Example Validation
```yaml
---
description: Create a git commit with conventional format
allowed-tools: Bash(git add:*), Bash(git commit:*)
argument-hint: [type] [message]
---
```

## Content Validation

### Prompt Quality
- [ ] Prompt is clear and unambiguous
- [ ] Instructions are specific and actionable
- [ ] Prompt follows consistent style/tone
- [ ] Prompt includes context for Claude to understand task

### Dynamic Arguments
- [ ] `$ARGUMENTS` used correctly for capturing all arguments
- [ ] `$1`, `$2`, etc. used correctly for positional arguments
- [ ] Argument placeholders match `argument-hint` in frontmatter
- [ ] Arguments are properly referenced in prompt text

### File References
- [ ] `@file-path` syntax used correctly for including files
- [ ] File paths are valid and accessible
- [ ] File references make sense for command purpose

### Bash Execution
- [ ] `!`command`` syntax used correctly for bash execution
- [ ] `allowed-tools` includes `Bash` with appropriate permissions
- [ ] Commands are safe and appropriate
- [ ] Output will be useful in command context

## Functionality Validation

### Command Logic
- [ ] Command achieves stated purpose
- [ ] Logic flow is clear and sequential
- [ ] Edge cases are considered
- [ ] Error scenarios are addressed

### Tool Permissions
- [ ] `allowed-tools` includes all necessary tools
- [ ] Tool permissions are appropriately restricted (e.g., `Bash(git:*)` not `Bash(rm:*)`)
- [ ] No unnecessary tools included
- [ ] Security implications of tool access considered

### Argument Handling
- [ ] Command works with expected number of arguments
- [ ] Command fails gracefully with wrong argument count
- [ ] Arguments are validated or sanitized if needed
- [ ] Default values provided where appropriate

## Security Validation

### Input Safety
- [ ] User input is not directly executed without validation
- [ ] File paths are validated before use
- [ ] Bash commands don't use unvalidated user input
- [ ] No injection vulnerabilities present

### Tool Access
- [ ] Bash permissions limited to specific safe commands
- [ ] No access to dangerous operations (rm -rf, chmod 777, etc.)
- [ ] File access limited to appropriate directories
- [ ] No access to sensitive files (.env, credentials, etc.)

### Secret Protection
- [ ] Command doesn't expose API keys or credentials
- [ ] No hardcoded secrets in command file
- [ ] Sensitive data handled appropriately

## Documentation Validation

### Description Quality
- [ ] `description` field present and clear
- [ ] Description explains what command does
- [ ] Description mentions any prerequisites
- [ ] Description shown correctly in `/help`

### Usage Clarity
- [ ] `argument-hint` provides clear parameter guidance
- [ ] Examples provided in command if complex
- [ ] Expected behavior documented
- [ ] Error messages or outputs explained if relevant

### Comments and Annotations
- [ ] Complex logic explained with comments
- [ ] Non-obvious choices documented
- [ ] Prerequisites or dependencies noted
- [ ] Usage examples provided if helpful

## Testing Validation

### Manual Testing
- [ ] Command runs successfully with valid arguments
- [ ] Command fails gracefully with invalid arguments
- [ ] Command produces expected output
- [ ] Command doesn't cause errors or side effects

### Argument Testing
- [ ] Tested with minimum arguments
- [ ] Tested with maximum arguments
- [ ] Tested with special characters in arguments
- [ ] Tested with missing optional arguments

### Integration Testing
- [ ] Command works with allowed tools
- [ ] File references resolve correctly
- [ ] Bash commands execute as expected
- [ ] Output format is useful

## Team Collaboration Validation (Project Commands)

### Shareability
- [ ] Command is useful to entire team
- [ ] Command doesn't include personal preferences
- [ ] Command location is in project directory (`.claude/commands/`)
- [ ] Command is committed to version control

### Documentation for Team
- [ ] Clear description for team members
- [ ] Usage documented in project README or docs
- [ ] Prerequisites communicated
- [ ] Command discoverable via `/help`

### Naming Conflicts
- [ ] Command name doesn't conflict with personal commands
- [ ] Command name follows team conventions
- [ ] Command subdirectory follows team structure

## Best Practices Validation

### Command Design
- [ ] Command does one thing well (Single Responsibility)
- [ ] Command is reusable, not one-off
- [ ] Command name is intuitive and memorable
- [ ] Command provides clear value over manual execution

### Maintainability
- [ ] Command logic is simple and clear
- [ ] Command can be updated easily
- [ ] Command doesn't have hardcoded values that change frequently
- [ ] Command dependencies are minimal

### Performance
- [ ] Command executes in reasonable time
- [ ] Command doesn't make unnecessary API calls
- [ ] Command doesn't read large files unnecessarily
- [ ] Command output is appropriately sized

## Post-Creation Validation

### Verification
- [ ] Command appears in `/help` output
- [ ] Command can be invoked with `/command-name`
- [ ] Command executes without errors
- [ ] Command produces expected results

### Documentation Update
- [ ] Command added to project documentation if project-level
- [ ] Team notified of new command if applicable
- [ ] Usage examples added to project wiki/docs
- [ ] Command appears in command catalog if maintained

### Monitoring
- [ ] Command usage monitored initially
- [ ] Feedback collected from users
- [ ] Issues or improvements identified
- [ ] Command refined based on usage

## Common Issues Checklist

### Troubleshooting
- [ ] Command not appearing? Check file location and `.md` extension
- [ ] Command failing? Verify `allowed-tools` includes needed tools
- [ ] Arguments not working? Check `$ARGUMENTS` or `$N` syntax
- [ ] Bash not executing? Verify `!`command`` syntax and permissions
- [ ] Files not loading? Verify `@path` syntax and file existence

### Performance Issues
- [ ] Command too slow? Optimize bash commands or file reads
- [ ] Output too large? Filter or summarize output
- [ ] Token usage high? Simplify prompt or reduce file inclusions

### Security Issues
- [ ] Unauthorized access? Review `allowed-tools` restrictions
- [ ] Data leakage? Check what command outputs
- [ ] Injection risks? Validate and sanitize inputs

## Quick Reference

**Minimal Command**:
```markdown
Simple prompt text here.
```

**Command with Description**:
```markdown
---
description: Brief description
---

Prompt text here.
```

**Command with Arguments**:
```markdown
---
description: Process file
argument-hint: [file-path]
---

Process: $1
Or all args: $ARGUMENTS
```

**Command with Bash**:
```markdown
---
description: Run with bash
allowed-tools: Bash(git:*)
---

Status: !`git status`
```

**Complete Command**:
```markdown
---
description: Comprehensive review
allowed-tools: Bash(git:*), Bash(npm test:*)
argument-hint: [file-path]
---

Review: $1

Status: !`git status`
File: @$1
Tests: !`npm test -- $1`

Provide analysis.
```

## Validation Completion

- [ ] All sections reviewed
- [ ] All critical checks passed
- [ ] Command tested successfully
- [ ] Documentation complete
- [ ] Ready for team use (if project-level)
