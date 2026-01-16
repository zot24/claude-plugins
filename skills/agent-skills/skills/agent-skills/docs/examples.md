# Example Skills

> Source: Curated from https://github.com/anthropics/skills

## Overview

This document provides example skills to help you understand how to structure and write effective SKILL.md files.

## Example 1: PDF Processing Skill

A complete example of a PDF processing skill:

```
pdf-processing/
├── SKILL.md
├── scripts/
│   ├── analyze_form.py
│   ├── fill_form.py
│   └── validate.py
└── references/
    ├── FORMS.md
    └── REFERENCE.md
```

**SKILL.md:**
```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick start

Extract text with pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Form filling workflow

1. Analyze form: `python scripts/analyze_form.py input.pdf`
2. Edit fields.json with values
3. Validate: `python scripts/validate.py fields.json`
4. Fill form: `python scripts/fill_form.py input.pdf fields.json output.pdf`

## Advanced features

- **Form filling guide**: See [references/FORMS.md](references/FORMS.md)
- **API reference**: See [references/REFERENCE.md](references/REFERENCE.md)
```

## Example 2: Code Review Skill

A minimal skill for code review guidance:

```yaml
---
name: code-review
description: Perform thorough code reviews with consistent standards. Use when reviewing pull requests, analyzing code changes, or providing feedback on code quality.
---

# Code Review

## Process

1. Understand the context and purpose of the change
2. Check for correctness and potential bugs
3. Evaluate code organization and readability
4. Verify test coverage
5. Provide constructive feedback

## Review checklist

- [ ] Does the code do what it's supposed to do?
- [ ] Are there any obvious bugs or edge cases?
- [ ] Is the code readable and well-organized?
- [ ] Are there appropriate tests?
- [ ] Does it follow project conventions?

## Feedback style

- Be specific: Point to exact lines
- Be constructive: Suggest improvements, not just problems
- Be respectful: Assume good intent
- Prioritize: Distinguish blocking issues from suggestions
```

## Example 3: Data Analysis Skill

A skill with domain-specific reference files:

```
data-analysis/
├── SKILL.md
└── reference/
    ├── finance.md
    ├── sales.md
    └── product.md
```

**SKILL.md:**
```yaml
---
name: data-analysis
description: Analyze datasets, generate insights, and create visualizations. Use when working with data, spreadsheets, or when the user needs analytical insights.
---

# Data Analysis

## Quick start

```python
import pandas as pd

df = pd.read_csv("data.csv")
print(df.describe())
```

## Domain references

Select the appropriate reference based on the data domain:

- **Finance data**: See [reference/finance.md](reference/finance.md) for revenue, billing metrics
- **Sales data**: See [reference/sales.md](reference/sales.md) for pipeline, opportunities
- **Product data**: See [reference/product.md](reference/product.md) for usage analytics

## Common operations

### Summary statistics
```python
df.describe()
df.groupby('category').agg({'value': ['mean', 'sum', 'count']})
```

### Visualization
```python
import matplotlib.pyplot as plt
df.plot(kind='bar', x='category', y='value')
plt.savefig('chart.png')
```
```

## Example 4: Git Commit Helper

A focused skill for a specific task:

```yaml
---
name: git-commit-helper
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
---

# Git Commit Helper

## Format

```
type(scope): brief description

Detailed explanation if needed
```

## Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting (no code change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

## Examples

**Input:** Added user authentication with JWT tokens
**Output:**
```
feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware
```

**Input:** Fixed bug where dates displayed incorrectly
**Output:**
```
fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation
```

## Workflow

1. Run `git diff --staged` to see changes
2. Analyze the nature of the changes
3. Generate commit message following the format
4. Present for user review
```

## Key Patterns Demonstrated

1. **Progressive disclosure**: Main instructions in SKILL.md, details in reference files
2. **Clear structure**: Frontmatter → Quick start → Workflows → References
3. **Concrete examples**: Input/output pairs, code snippets
4. **Checklists**: For multi-step processes
5. **Domain organization**: Separate files for different domains/topics

## Resources

- **Official examples**: https://github.com/anthropics/skills
- **Specification**: https://agentskills.io/specification
- **Best practices**: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
