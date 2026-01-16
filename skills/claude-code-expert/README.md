# Claude Code Expert Skill

Knowledge base for Claude Code and the Anthropic ecosystem. Provides official patterns, validation checklists, and synced documentation for creating agents, skills, hooks, and commands.

## What It Does

- **Patterns**: Step-by-step guides for creating Claude Code artifacts
- **Validation**: Checklists to verify your agents/skills/hooks/commands
- **Documentation Sync**: Cached content from official Anthropic sources
- **Auto-invocation**: Activates when you create or validate artifacts

## Quick Start

The skill auto-activates on keywords like:
- "Create a new agent for..."
- "Validate my skill"
- "What are the best practices for hooks?"

## Directory Structure

```
claude-code-expert/
├── skills/claude-code-expert/SKILL.md   # Main skill definition
├── official/                            # Bundled knowledge
│   ├── patterns/                        # Creation guides
│   │   ├── agent-creation.md
│   │   ├── skill-creation.md
│   │   ├── hook-creation.md
│   │   ├── hook-advanced.md
│   │   └── command-creation.md
│   ├── features/                        # Capability guides
│   │   ├── tool-usage.md
│   │   ├── mcp-integration.md
│   │   └── code-execution.md
│   ├── validation/                      # Quality checklists
│   │   ├── agent-checklist.md
│   │   ├── skill-checklist.md
│   │   ├── hook-checklist.md
│   │   └── command-checklist.md
│   └── ecosystem/                       # Version info
│       ├── claude-versions.md
│       └── model-capabilities.md
├── sources/
│   └── registry.json                    # External source definitions
├── scripts/
│   ├── sync-sources.sh                  # Sync all sources
│   ├── fetch-source.sh                  # Fetch single source
│   └── check-updates.sh                 # Check freshness
└── cache/                               # Synced external docs (gitignored)
```

## Documentation Sources

The skill syncs from these official sources (defined in `sources/registry.json`):

| Source | Content |
|--------|---------|
| code.claude.com/docs | Claude Code documentation |
| docs.anthropic.com | API and SDK docs |
| anthropic.com/engineering | Best practices blog posts |
| github.com/anthropics/* | claude-code, skills repos |
| agentskills.io | Skills specification |

## Syncing Documentation

```bash
# Check what's stale
./scripts/check-updates.sh --verbose

# Sync all sources
./scripts/sync-sources.sh

# Sync specific category
./scripts/sync-sources.sh --category=blog
./scripts/sync-sources.sh --priority=1

# Force refresh everything
./scripts/sync-sources.sh --force
```

## Usage Examples

### Creating an Agent
```
> Create an agent for PostgreSQL query optimization

Skill loads official/patterns/agent-creation.md and provides:
- File structure and location
- Required frontmatter fields
- System prompt guidance
- Tool selection recommendations
```

### Validating a Skill
```
> Validate my performance monitoring skill

Skill loads official/validation/skill-checklist.md and checks:
- Directory structure
- SKILL.md frontmatter
- State management
- Auto-invocation triggers
```

### Querying Features
```
> What are the latest MCP integration patterns?

Skill loads official/features/mcp-integration.md with:
- Current MCP capabilities
- Integration methods
- Authentication patterns
```

## Freshness Rules

| Content Type | Max Age |
|--------------|---------|
| Release notes | 1 day |
| Blog posts | 7 days |
| Documentation | 14 days |
| GitHub repos | 7 days |

## Version

- **v1.0.0**: Initial release with official documentation patterns

## License

Content sourced from:
- [Claude Code Documentation](https://code.claude.com/docs)
- [Anthropic Engineering Blog](https://www.anthropic.com/engineering)
- [Agent Skills Specification](https://agentskills.io)
