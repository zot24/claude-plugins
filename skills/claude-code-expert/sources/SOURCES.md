# Claude/Anthropic Source Registry

> This document defines all authoritative sources for Claude Code and Anthropic ecosystem documentation.
> For machine-readable version, see `registry.json`

## Source Hierarchy

Sources are prioritized in this order:
1. **Official Documentation** - Always authoritative
2. **Engineering Blog** - Best practices and deep dives
3. **GitHub Repositories** - Examples and reference implementations
4. **Community Resources** - Useful but not authoritative

---

## Priority 1: Official Documentation

### code.claude.com/docs/en/
**Claude Code Documentation** - Primary source for Claude Code features

| Page | Description | Category | Status |
|------|-------------|----------|--------|
| `overview.md` | Claude Code overview | Core | Track |
| `hooks.md` | Hooks reference | Hooks | Track |
| `sub-agents.md` | Subagents/agents | Agents | Track |
| `skills.md` | Skills documentation | Skills | Track |
| `slash-commands.md` | Slash commands | Commands | Track |
| `mcp.md` | MCP integration | MCP | Track |
| `permissions.md` | Permissions system | Security | Track |
| `memory.md` | Memory and CLAUDE.md | Core | Track |
| `common-workflows.md` | Common workflows | Workflows | Track |

**Sitemap**: https://code.claude.com/docs/en/claude_code_docs_map.md

---

### docs.anthropic.com
**Anthropic API Documentation** - SDK and API reference

#### Claude Code Section
| Page | Description | Category |
|------|-------------|----------|
| `/claude-code/sdk` | Agent SDK overview | SDK |
| `/claude-code/sdk/sdk-python` | Python SDK reference | SDK |
| `/claude-code/sub-agents` | Subagents reference | Agents |

#### Agents and Tools Section
| Page | Description | Category |
|------|-------------|----------|
| `/agents-and-tools/claude-code/overview` | Claude Code in agents context | Core |
| `/agents-and-tools/tool-use` | Tool use patterns | Tools |
| `/agents-and-tools/mcp` | MCP documentation | MCP |

#### Release Notes (HIGH PRIORITY)
| Page | Description | Check Frequency |
|------|-------------|-----------------|
| `/release-notes/claude-code` | Claude Code changelog | Daily |

---

## Priority 1: Engineering Blog

### anthropic.com/engineering
**Anthropic Engineering Blog** - Authoritative best practices

| Article | Published | Category | Priority |
|---------|-----------|----------|----------|
| [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices) | 2025-02-24 | Best Practices | HIGH |
| [Building agents with the Claude Agent SDK](https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk) | 2025-09-29 | SDK | HIGH |
| [Equipping agents for the real world with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) | 2025-12-18 | Skills | HIGH |
| [Making Claude Code more secure and autonomous](https://www.anthropic.com/engineering/claude-code-sandboxing) | 2025-06-15 | Security | HIGH |
| [The think tool: Enabling Claude to stop and think](https://www.anthropic.com/engineering/claude-think-tool) | 2025-05-20 | Tools | Medium |
| [Code execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp) | 2024-11-04 | MCP | HIGH |
| [Advanced tool use on the Claude Developer Platform](https://www.anthropic.com/engineering/advanced-tool-use) | 2024-10-15 | Tools | Medium |

---

## Priority 1: GitHub Repositories

### github.com/anthropics

| Repository | Description | Key Paths |
|------------|-------------|-----------|
| [claude-code](https://github.com/anthropics/claude-code) | Main Claude Code repository | `examples/hooks/`, `plugins/`, `CHANGELOG.md` |
| [skills](https://github.com/anthropics/skills) | Public skills repository (20k+ stars) | `skills/`, `README.md` |
| [claude-cookbooks](https://github.com/anthropics/claude-cookbooks) | Practical examples | `skills/` |
| [anthropic-sdk-python](https://github.com/anthropics/anthropic-sdk-python) | Python SDK | `README.md` |

### Key Files to Track

#### claude-code Repository
- `examples/hooks/` - Official hook examples
- `examples/hooks/bash_command_validator_example.py` - Hook implementation example
- `plugins/plugin-dev/` - Plugin development toolkit
- `plugins/plugin-dev/skills/hook-development/SKILL.md` - Hook development guide
- `CHANGELOG.md` - Version changes (CRITICAL for tracking new features)

#### skills Repository
- `README.md` - Skills specification
- `skills/` - Community and official skills

---

## Priority 2: Announcements

### anthropic.com/news
**Product Announcements**

| Article | Published | Topic |
|---------|-----------|-------|
| [Introducing Agent Skills](https://www.anthropic.com/news/skills) | 2025-12-18 | Skills |
| [Claude Opus 4.5](https://www.anthropic.com/news/claude-opus-4-5) | 2025-02-24 | Models |

### claude.com/blog
**Claude Product Blog** - Check periodically for updates

---

## Priority 3: Community Resources

| Resource | URL | Type | Notes |
|----------|-----|------|-------|
| awesome-claude-code | [GitHub](https://github.com/hesreallyhim/awesome-claude-code) | Curated list | Commands, workflows |
| claude-code-hooks-mastery | [GitHub](https://github.com/disler/claude-code-hooks-mastery) | Examples | Hook patterns |
| alexfazio hooks gist | [Gist](https://gist.github.com/alexfazio/653c5164d726987569ee8229a19f451f) | Documentation | v2.1.0+ hooks (ALREADY CACHED) |

---

## Release Timeline

Understanding the release timeline helps contextualize documentation:

| Date | Event | Impact |
|------|-------|--------|
| 2024-03 | MCP introduced | External tool integration |
| 2024-10 | Advanced tool use | Enhanced tool capabilities |
| 2024-11 | Code execution with MCP | Jupyter, Python execution |
| 2025-02 | Claude Code public release | CLI tool available |
| 2025-02 | Claude Opus 4.5 | New model capabilities |
| 2025-05 | Think tool | Extended thinking patterns |
| 2025-06 | Sandboxing | Security features |
| 2025-09 | Claude Agent SDK | Programmatic agent building |
| 2025-10 | Plugin system | Extensions (later deprecated) |
| 2025-12 | Agent Skills open standard | Modular capabilities |

---

## Feature Status Tracking

Features can be in different states:

| Status | Meaning |
|--------|---------|
| `announced` | Mentioned in blog/news, not yet available |
| `beta` | Available for testing, may change |
| `released` | Generally available, stable |
| `deprecated` | Being phased out |
| `removed` | No longer available |

### Current Feature Status

| Feature | Status | Since | Notes |
|---------|--------|-------|-------|
| Hooks (command) | released | 2025-02 | Shell-based hooks |
| Hooks (prompt) | released | 2025-10 | v2.1.0+ LLM-based hooks |
| Hooks (agent) | released | 2025-10 | v2.1.0+ subagent hooks |
| Skills | released | 2025-12 | Open standard |
| Plugins | deprecated | 2025-10 | Deprecated Oct 2025 |
| MCP | released | 2024-03 | External integrations |
| Sandboxing | released | 2025-06 | Container isolation |
| Agent SDK | released | 2025-09 | Python SDK |

---

## Caching Strategy

### What to Cache Locally
1. **Always cache**: Engineering blog posts, release notes, changelogs
2. **Cache on demand**: Documentation pages when accessed
3. **Don't cache**: Dynamic content (repo file listings)

### Cache Location
```
cache/
├── blog/                     # Engineering blog articles
├── news/                     # Product announcements
├── docs/
│   ├── code-claude-com/      # code.claude.com docs
│   └── anthropic/            # docs.anthropic.com
├── github/
│   ├── claude-code/          # Key files from claude-code repo
│   ├── skills/               # Skills repo content
│   └── claude-cookbooks/     # Cookbook examples
└── community/                # Community resources
```

### Freshness Rules
| Content Type | Check Frequency | Max Age |
|--------------|-----------------|---------|
| Release notes | Daily | 1 day |
| Blog posts | Weekly | 7 days |
| Documentation | Bi-weekly | 14 days |
| GitHub repos | Weekly | 7 days |
| Community | Monthly | 30 days |

---

## How to Use This Registry

### For Skill Auto-Invocation
When the skill activates, it should:
1. Check `registry.json` for relevant sources
2. Load cached content if fresh
3. Fetch and cache if stale
4. Provide context-aware guidance

### For Manual Updates
```bash
# Check for updates (implement in scripts/)
./scripts/check-updates.sh

# Fetch specific source
./scripts/fetch-source.sh anthropic.com/engineering/claude-code-best-practices

# Fetch all priority 1 sources
./scripts/fetch-all.sh --priority=1
```

### For Validation
When validating artifacts:
1. Load relevant cached docs
2. Compare against official patterns
3. Report deviations with source links
