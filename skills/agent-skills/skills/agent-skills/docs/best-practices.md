# Skill Authoring Best Practices

> Source: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

Learn how to write effective Skills that Claude can discover and use successfully.

## Core Principles

### Concise is Key

The context window is a shared resource. Your Skill competes with:
- The system prompt
- Conversation history
- Other Skills' metadata
- The user's actual request

**Default assumption**: Claude is already very smart. Only add context Claude doesn't already have.

**Good example (concise, ~50 tokens):**
```markdown
## Extract PDF text

Use pdfplumber for text extraction:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Bad example (verbose, ~150 tokens):**
```markdown
## Extract PDF text

PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available for PDF processing...
```

### Set Appropriate Degrees of Freedom

Match specificity to the task's fragility and variability.

**High freedom** (text instructions): Multiple approaches valid, decisions depend on context
**Medium freedom** (pseudocode/parameterized scripts): Preferred pattern exists, some variation OK
**Low freedom** (specific scripts): Operations are fragile, consistency critical

### Test with All Models

Skills effectiveness depends on the underlying model:
- **Claude Haiku**: Does the Skill provide enough guidance?
- **Claude Sonnet**: Is the Skill clear and efficient?
- **Claude Opus**: Does the Skill avoid over-explaining?

## Skill Structure

### Naming Conventions

Use **gerund form** (verb + -ing) for skill names:
- `processing-pdfs`
- `analyzing-spreadsheets`
- `managing-databases`

**Avoid:**
- Vague names: `helper`, `utils`, `tools`
- Reserved words: `anthropic-helper`, `claude-tools`

### Writing Effective Descriptions

**Always write in third person** (description is injected into system prompt):
- Good: "Processes Excel files and generates reports"
- Avoid: "I can help you process Excel files"

**Be specific and include key terms:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

### Progressive Disclosure Patterns

SKILL.md serves as an overview pointing to detailed materials.

**Pattern 1: High-level guide with references**
```markdown
## Quick start
[Brief example]

## Advanced features
**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
```

**Pattern 2: Domain-specific organization**
```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md
    ├── sales.md
    └── product.md
```

**Pattern 3: Conditional details**
```markdown
## Creating documents
Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents
For simple edits, modify the XML directly.
**For tracked changes**: See [REDLINING.md](REDLINING.md)
```

### Avoid Deeply Nested References

Keep references one level deep from SKILL.md. All reference files should link directly from SKILL.md.

### Structure Longer Files with TOC

For files over 100 lines, include a table of contents at the top.

## Workflows and Feedback Loops

### Use Workflows for Complex Tasks

Break complex operations into clear, sequential steps with checklists:

```markdown
## Research synthesis workflow

Copy this checklist:
- [ ] Step 1: Read all source documents
- [ ] Step 2: Identify key themes
- [ ] Step 3: Cross-reference claims
- [ ] Step 4: Create structured summary
- [ ] Step 5: Verify citations
```

### Implement Feedback Loops

**Common pattern**: Run validator → fix errors → repeat

```markdown
## Document editing process

1. Make your edits
2. **Validate immediately**: `python scripts/validate.py`
3. If validation fails: Fix issues, run validation again
4. **Only proceed when validation passes**
```

## Content Guidelines

### Avoid Time-Sensitive Information

Use "old patterns" sections instead of dates:
```markdown
## Current method
Use the v2 API endpoint.

## Old patterns
<details>
<summary>Legacy v1 API (deprecated)</summary>
The v1 API used: `api.example.com/v1/messages`
</details>
```

### Use Consistent Terminology

Choose one term and use it throughout:
- Always "API endpoint" (not mixing "URL", "route", "path")
- Always "field" (not mixing "box", "element", "control")

## Common Patterns

### Template Pattern

```markdown
## Report structure

ALWAYS use this exact template:
```markdown
# [Analysis Title]
## Executive summary
## Key findings
## Recommendations
```
```

### Examples Pattern

```markdown
## Commit message format

**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Conditional Workflow Pattern

```markdown
## Document modification workflow

**Creating new content?** → Follow "Creation workflow"
**Editing existing?** → Follow "Editing workflow"
```

## Evaluation and Iteration

### Build Evaluations First

1. **Identify gaps**: Run Claude without a Skill, document failures
2. **Create evaluations**: Build 3 scenarios testing these gaps
3. **Establish baseline**: Measure performance without Skill
4. **Write minimal instructions**: Address gaps, pass evaluations
5. **Iterate**: Execute evaluations, compare, refine

### Develop Iteratively with Claude

Work with "Claude A" to create Skills, test with "Claude B":
1. Complete a task without a Skill
2. Identify the reusable pattern
3. Ask Claude A to create a Skill
4. Review for conciseness
5. Test with Claude B
6. Iterate based on observation

## Anti-Patterns to Avoid

- **Windows-style paths**: Use forward slashes (`scripts/helper.py`)
- **Too many options**: Provide a default, mention alternatives only when needed
- **Assuming tools installed**: Always document dependencies
- **Magic numbers**: Document all configuration values

## Checklist for Effective Skills

### Core Quality
- [ ] Description is specific with key terms
- [ ] SKILL.md body under 500 lines
- [ ] Additional details in separate files
- [ ] No time-sensitive information
- [ ] Consistent terminology
- [ ] File references one level deep
- [ ] Workflows have clear steps

### Code and Scripts
- [ ] Scripts handle errors explicitly
- [ ] Required packages listed
- [ ] No Windows-style paths
- [ ] Validation steps for critical operations

### Testing
- [ ] At least 3 evaluations created
- [ ] Tested with multiple models
- [ ] Tested with real scenarios
