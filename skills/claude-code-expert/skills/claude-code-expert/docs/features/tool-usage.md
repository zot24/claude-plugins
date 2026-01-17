# Claude Code Tool Usage Guide

> **Source**: Official Claude Code Documentation
> **Source URL**: https://code.claude.com/docs/en/common-workflows.md
> **Last Updated**: 2025-01-15

## Overview

Claude Code provides a comprehensive set of tools for file operations, code search, execution, and system interaction. This guide covers best practices and common patterns for each core tool.

## Core File Operation Tools

### Read Tool

**Purpose**: Read file contents with line numbers and optional range control.

**Capabilities**:
- Reads any file type (text, code, images, PDFs, Jupyter notebooks)
- Returns content with line numbers (cat -n format)
- Supports offset and limit for large files
- Multimodal: can read and display images visually
- PDF processing: extracts text and visual content page by page
- Jupyter notebook support: shows all cells with outputs

**Best Practices**:
```markdown
✅ DO:
- Read files in parallel when multiple files are needed
- Use offset/limit for very large files (>2000 lines)
- Always read before editing to understand context
- Read multiple potentially relevant files speculatively

❌ DON'T:
- Use cat, head, or tail commands via Bash
- Read directories (use Bash ls instead)
- Assume file contents without reading first
```

**Examples**:
```markdown
# Basic read
Read: /path/to/file.ts

# Read with range for large files
Read: /path/to/large-file.log
  offset: 1000
  limit: 500

# Parallel reads for analysis
Read: /path/to/component.tsx
Read: /path/to/component.test.tsx
Read: /path/to/types.ts
```

**Line Number Format**:
```
     1→first line of content
     2→second line of content
     3→third line of content
```

**Important**: Line numbers are prefixed with spaces, line number, then a tab. Everything after the tab is actual file content.

### Write Tool

**Purpose**: Create new files or completely overwrite existing files.

**Requirements**:
- Must read existing files before overwriting
- Use absolute paths only (no relative paths)
- Strongly prefer Edit over Write for existing files

**Best Practices**:
```markdown
✅ DO:
- Use for new files that don't exist
- Read existing files first before overwriting
- Provide complete, correct content
- Use absolute paths

❌ DON'T:
- Use for small changes to existing files (use Edit)
- Create files without being asked
- Proactively create documentation/README files
- Use relative paths
- Use emojis unless explicitly requested
```

**Examples**:
```markdown
# Creating a new configuration file
Write: /path/to/new-config.json
Content: {"setting": "value"}

# Creating a new component (only when needed)
Write: /path/to/components/NewComponent.tsx
Content: [full component code]
```

**When to Use Write vs Edit**:
- **Write**: New files, complete rewrites, generated code
- **Edit**: Modifications to existing files, bug fixes, refactoring

### Edit Tool

**Purpose**: Make precise string replacements in existing files.

**Requirements**:
- Must read the file first in the conversation
- `old_string` must be EXACT match (preserve indentation)
- `old_string` must be unique unless using `replace_all`
- Never include line number prefixes in strings

**Best Practices**:
```markdown
✅ DO:
- Preserve exact indentation from Read output (after line number tab)
- Include enough context to make old_string unique
- Use replace_all for renaming variables/functions
- Read file first in the same conversation
- Verify indentation matches exactly

❌ DON'T:
- Include line number prefixes in old_string or new_string
- Guess at indentation (tabs vs spaces)
- Use for multiple unrelated changes (make separate edits)
- Add emojis unless explicitly requested
```

**Examples**:
```typescript
// Good: Exact match with context
old_string: |
  function calculateTotal(items) {
    return items.reduce((sum, item) => sum + item.price, 0);
  }

new_string: |
  function calculateTotal(items: Item[]): number {
    return items.reduce((sum, item) => sum + item.price, 0);
  }

// Good: Using replace_all for renaming
old_string: "getUserData"
new_string: "fetchUserData"
replace_all: true
```

**Common Pitfalls**:
```markdown
# WRONG: Including line number prefix
old_string: "    42→  const value = 123;"

# CORRECT: Only the actual content
old_string: "  const value = 123;"

# WRONG: Non-unique string
old_string: "return true;"

# CORRECT: Include surrounding context
old_string: |
  if (isValid) {
    return true;
  }
```

## Search and Discovery Tools

### Grep Tool

**Purpose**: Search file contents using regex patterns with ripgrep.

**Capabilities**:
- Full regex support
- Case-insensitive search (-i flag)
- Context lines (-A, -B, -C flags)
- File type filtering (--type)
- Glob pattern filtering (--glob)
- Multiple output modes
- Multiline matching support

**Output Modes**:
1. **files_with_matches** (default): List files containing matches
2. **content**: Show matching lines with context
3. **count**: Show match counts per file

**Best Practices**:
```markdown
✅ DO:
- Use for content search across codebase
- Combine with glob or type filters
- Use output_mode: "content" to see actual matches
- Use -i for case-insensitive searches
- Use multiline: true for cross-line patterns

❌ DON'T:
- Use grep/rg commands via Bash
- Forget to escape special regex characters
- Use without appropriate filters on large codebases
```

**Examples**:
```markdown
# Find all TODO comments
Grep:
  pattern: "TODO:"
  output_mode: "content"
  -n: true

# Find function definitions in TypeScript
Grep:
  pattern: "function\\s+\\w+\\("
  type: "ts"
  output_mode: "content"

# Case-insensitive search with context
Grep:
  pattern: "error|exception"
  -i: true
  -C: 3
  output_mode: "content"

# Search in specific files
Grep:
  pattern: "useState"
  glob: "**/*.tsx"
  output_mode: "files_with_matches"

# Multiline pattern matching
Grep:
  pattern: "interface\\s+User\\s*\\{[\\s\\S]*?\\}"
  multiline: true
  output_mode: "content"
```

**Pattern Syntax**:
- Uses ripgrep (not grep)
- Literal braces need escaping: `interface\\{\\}`
- Dot matches any character except newline (unless multiline mode)
- Common patterns: `\s` (whitespace), `\w` (word char), `.*` (any)

**Performance Tips**:
```markdown
# Fast: Limit to specific file types
type: "js"

# Fast: Use specific glob patterns
glob: "src/**/*.ts"

# Slow: Search entire codebase without filters
pattern: "something"
```

### Glob Tool

**Purpose**: Find files by name/path patterns, sorted by modification time.

**Capabilities**:
- Fast pattern matching
- Works with any codebase size
- Supports standard glob syntax
- Returns files sorted by modification time

**Best Practices**:
```markdown
✅ DO:
- Use for finding files by name
- Use for discovering file structure
- Make multiple speculative searches in parallel
- Use specific patterns when possible

❌ DON'T:
- Use find or ls commands via Bash
- Use for content search (use Grep instead)
```

**Examples**:
```markdown
# Find all TypeScript files
Glob: "**/*.ts"

# Find configuration files
Glob: "**/*config.{js,ts,json}"

# Find test files
Glob: "**/*.test.{ts,tsx}"

# Find files in specific directory
Glob: "src/components/**/*.tsx"

# Parallel discovery
Glob: "**/*.md"
Glob: "**/*.json"
Glob: "**/README*"
```

**Glob Pattern Syntax**:
- `*` - Matches any characters except `/`
- `**` - Matches any characters including `/`
- `?` - Matches single character
- `{a,b}` - Matches a or b
- `[abc]` - Matches any character in brackets

## Execution Tools

### Bash Tool

**Purpose**: Execute terminal commands in persistent shell session.

**Use Cases**:
- Git operations
- Package management (npm, pip, etc.)
- Build commands
- Test execution
- Docker operations

**NOT for**:
- File reading (use Read)
- File writing (use Write/Edit)
- File searching (use Grep/Glob)
- Content manipulation (use Edit)

**Best Practices**:
```markdown
✅ DO:
- Quote paths with spaces: cd "path with spaces"
- Chain dependent commands with &&
- Run independent commands in parallel
- Use absolute paths over cd when possible
- Set appropriate timeouts for long operations
- Use description parameter for clarity

❌ DON'T:
- Use for file operations (read/write/edit/search)
- Use interactive commands (git rebase -i, git add -i)
- Skip directory verification before mkdir/touch
- Use newlines to separate commands (use && or ;)
- Run destructive git commands without user request
```

**Examples**:
```bash
# Good: Run tests
Bash: "npm test"
description: "Run test suite"

# Good: Chain dependent commands
Bash: "npm install && npm run build && npm test"
description: "Install dependencies, build, and test"

# Good: Parallel independent commands
Bash: "git status"
Bash: "git diff"
Bash: "git log --oneline -5"

# Good: Quote paths with spaces
Bash: 'cd "/Users/name/My Documents" && ls'

# Good: Use absolute paths instead of cd
Bash: "pytest /absolute/path/to/tests"

# Bad: Using cd unnecessarily
Bash: "cd /path && pytest tests"
```

**Command Chaining**:
```bash
# && - Run next command only if previous succeeds
git add . && git commit -m "message" && git push

# ; - Run next command regardless of previous result
npm run lint ; npm test

# Good for background processes
run_in_background: true
Bash: "npm run dev"
```

**Git Operations**:
```markdown
Safety Rules:
- NEVER update git config
- NEVER force push to main/master
- NEVER skip hooks (--no-verify)
- NEVER use interactive flags (-i)
- Only commit when explicitly requested
- Only push when explicitly requested

Good Git Patterns:
# Check status before operations
Bash: "git status"

# Safe commit flow
Bash: "git add . && git commit -m 'message'"

# Check before push
Bash: "git log origin/main..HEAD"
Bash: "git push"
```

**Background Execution**:
```bash
# Start long-running process
Bash: "npm run dev"
run_in_background: true

# Monitor output later
BashOutput: {bash_id: "shell-123"}

# Kill if needed
KillShell: {shell_id: "shell-123"}
```

**Timeout Management**:
```bash
# Default timeout: 120000ms (2 minutes)
Bash: "npm install"

# Custom timeout for long operations (max 600000ms)
Bash: "npm run build"
timeout: 300000  # 5 minutes
```

## Advanced Tool Patterns

### Parallel Operations

**When to parallelize**:
- Multiple independent file reads
- Multiple independent searches
- Git status checks and diffs
- Multiple test runs on different modules

**Example**:
```markdown
# Reading related files
Read: /path/to/component.tsx
Read: /path/to/component.test.tsx
Read: /path/to/types.ts
Read: /path/to/utils.ts

# Multiple searches
Grep: pattern "useState", glob "**/*.tsx"
Grep: pattern "useEffect", glob "**/*.tsx"
Grep: pattern "useCallback", glob "**/*.tsx"

# Git status overview
Bash: "git status"
Bash: "git diff"
Bash: "git log --oneline -10"
```

### Sequential Operations

**When to sequence**:
- Dependent operations (install before build)
- File write before git operations
- Directory creation before file creation

**Example**:
```bash
# Chain with &&
Bash: "mkdir -p dist && cp -r src/* dist/"

# Write then commit
Write: /path/to/file.ts
Bash: "git add /path/to/file.ts && git commit -m 'Add file'"
```

### Error Handling

**Verification patterns**:
```bash
# Verify before destructive operations
Bash: "ls /path/to/parent"  # Verify parent exists
Bash: "mkdir /path/to/parent/child"  # Then create

# Check results after operations
Bash: "npm run build"
Bash: "ls -la dist/"  # Verify build output
```

**Recovery patterns**:
```bash
# Try operation, check status
Bash: "npm install"
# If fails, check logs
Bash: "cat npm-debug.log"
```

## Tool Selection Decision Tree

```
Need to access file contents?
├─ Yes → Read tool
└─ No → Continue

Need to search file contents?
├─ Yes → Grep tool
└─ No → Continue

Need to find files by name?
├─ Yes → Glob tool
└─ No → Continue

Need to modify existing file?
├─ Small change → Edit tool
└─ Complete rewrite → Write tool (after Read)

Need to create new file?
└─ Write tool

Need to run command?
├─ File operation → Use specialized tool
└─ Git/npm/build/test → Bash tool
```

## Common Workflows

### Code Review Workflow
```markdown
1. Glob: Find changed files (or use git diff --name-only)
2. Read: Read each changed file in parallel
3. Grep: Search for specific patterns (e.g., TODO, FIXME)
4. Analysis: Review code
5. Output: Provide feedback
```

### Bug Fix Workflow
```markdown
1. Grep: Search for error patterns
2. Read: Read relevant files
3. Edit: Apply fixes
4. Bash: Run tests to verify
5. Bash: Git operations if requested
```

### Feature Implementation Workflow
```markdown
1. Glob: Discover related files
2. Read: Understand existing code
3. Write/Edit: Implement changes
4. Bash: Run linter/formatter
5. Bash: Run tests
6. Bash: Git operations if requested
```

### Refactoring Workflow
```markdown
1. Grep: Find all usages
2. Read: Understand context
3. Edit: Make changes (use replace_all for renames)
4. Bash: Run tests
5. Verify: Check for issues
```

## Performance Optimization

### Reduce Tool Calls
```markdown
# Bad: Sequential reads
Read: file1.ts
(wait for response)
Read: file2.ts
(wait for response)

# Good: Parallel reads
Read: file1.ts
Read: file2.ts
Read: file3.ts
```

### Use Appropriate Filters
```markdown
# Bad: Search everything
Grep: pattern "useState"

# Good: Filter by file type
Grep: pattern "useState", type "tsx"

# Better: Specific glob
Grep: pattern "useState", glob "src/components/**/*.tsx"
```

### Limit Output
```markdown
# Use head_limit for large result sets
Grep:
  pattern: "import"
  output_mode: "content"
  head_limit: 50

# Use offset for pagination
Grep:
  pattern: "error"
  output_mode: "content"
  offset: 100
  head_limit: 50
```

## Best Practices Summary

1. **Read Before Write**: Always read existing files before modifying
2. **Parallelize Independent Operations**: Make multiple tool calls simultaneously
3. **Use Specialized Tools**: Don't use Bash for file operations
4. **Exact String Matching**: Edit tool requires precise matches
5. **Absolute Paths**: Always use absolute paths, never relative
6. **Quote Spaces**: Quote paths with spaces in Bash commands
7. **Verify Operations**: Check results after destructive operations
8. **Filter Searches**: Use type/glob filters with Grep for performance
9. **No Emojis**: Don't add emojis unless explicitly requested
10. **Git Safety**: Never force push, skip hooks, or modify config

## Quick Reference Table

| Task | Tool | Example |
|------|------|---------|
| Read file | Read | `Read: /path/file.ts` |
| Create file | Write | `Write: /path/new.ts` |
| Modify file | Edit | `Edit: old→new in /path/file.ts` |
| Search content | Grep | `Grep: pattern "TODO"` |
| Find files | Glob | `Glob: "**/*.test.ts"` |
| Run command | Bash | `Bash: "npm test"` |
| Git status | Bash | `Bash: "git status"` |
| Install deps | Bash | `Bash: "npm install"` |
| Run tests | Bash | `Bash: "npm test"` |

## Tool Restrictions in Agents

Agents can restrict tools for security and focus:

```yaml
# Read-only agent
tools: Read, Grep, Glob

# Code modification agent
tools: Read, Write, Edit, Grep, Glob

# Full access agent (includes MCP)
# Omit tools field to inherit all
```

Benefits:
- **Security**: Prevent unintended modifications
- **Focus**: Keep agent on task
- **Performance**: Reduce available options

## Integration with MCP

When tools field is omitted in agents, ALL tools are inherited including:
- Core Claude Code tools
- MCP server integrations (databases, APIs, etc.)
- Plugin-provided tools

This enables specialized agents to access external systems while maintaining tool restrictions where needed.
