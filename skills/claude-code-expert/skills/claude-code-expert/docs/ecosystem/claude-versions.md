# Claude Versions and Capabilities

> **Source**: Official Claude Code Documentation & Anthropic Release Notes
> **Source URL**: https://code.claude.com/docs/en/overview.md
> **Last Updated**: 2025-01-15

## Current Claude Models

### Claude Sonnet 4.5 (Recommended)

**Model ID**: `claude-sonnet-4-5-20250929`

**Release Date**: September 29, 2024

**Key Capabilities**:
- Latest frontier model from Anthropic
- Balanced performance and speed
- Excellent for coding tasks
- Strong reasoning capabilities
- Extended context window
- Multimodal (text and images)

**Best For**:
- General-purpose development tasks
- Code review and analysis
- Complex reasoning
- Agent workflows
- Production applications

**Context Window**: 200K tokens

**Knowledge Cutoff**: January 2025

### Claude Opus (Most Capable)

**Model ID**: `claude-3-opus-20240229`

**Key Capabilities**:
- Highest capability model
- Best for complex tasks requiring deep reasoning
- Superior performance on difficult problems
- Longer processing time
- Higher cost

**Best For**:
- Complex architectural decisions
- Critical code reviews
- Research and analysis
- Tasks requiring maximum accuracy

### Claude Haiku (Fastest)

**Model ID**: `claude-3-5-haiku-20241022`

**Key Capabilities**:
- Fastest response time
- Lower cost
- Good for straightforward tasks
- Quick iterations

**Best For**:
- Simple, well-defined tasks
- Quick edits and refactors
- Repetitive operations
- Cost-sensitive applications
- High-volume requests

## Claude Code Versions

### Current Version Features

**Tool Ecosystem**:
- Read: File content access
- Write: File creation
- Edit: Precise file modifications
- Grep: Fast content search (ripgrep-based)
- Glob: File pattern matching
- Bash: System command execution

**MCP Integration**:
- Model Context Protocol support
- Hundreds of MCP servers available
- HTTP, SSE, and Stdio transports
- OAuth 2.0 authentication
- Resource and prompt support

**Code Execution**:
- Jupyter integration
- Python code execution
- Interactive programming
- Data analysis capabilities

**Agent Features**:
- Subagents for specialized tasks
- Agent resumption with transcripts
- Parallel agent execution
- Agent coordination

**Skills System**:
- Dynamic skill loading
- Persistent context
- Auto-invocation triggers
- Progressive disclosure

**Hooks System**:
- 9 lifecycle events
- Pre/post tool execution
- Command validation
- Custom workflows

**Custom Commands**:
- Slash command support
- Parameterized prompts
- Bash execution in commands
- File references

**Sandboxing** (Beta):
- Filesystem isolation
- Network isolation
- Security boundaries
- Custom proxy rules

## Version History Highlights

### Recent Major Features

**2024-11**: Code Execution with MCP
- File-based tool organization
- Progressive tool loading
- 98.7% token reduction capability
- State persistence across operations

**2024-10**: Sandboxing (Beta)
- Pre-defined security boundaries
- 84% reduction in permission prompts
- OS-level isolation primitives
- Git integration with credential proxy

**2024-09**: Agent Skills
- Organized capability folders
- Three-tier disclosure pattern
- Unbounded context potential
- Dynamic discovery

**2024-08**: MCP Launch
- Open protocol standard
- Standardized integrations
- Community adoption
- SDK availability

## Feature Availability Matrix

| Feature | Sonnet 4.5 | Opus | Haiku |
|---------|-----------|------|-------|
| Extended Thinking | ✅ | ✅ | ✅ |
| Multimodal (Images) | ✅ | ✅ | ✅ |
| Code Execution | ✅ | ✅ | ✅ |
| MCP Integration | ✅ | ✅ | ✅ |
| Subagents | ✅ | ✅ | ✅ |
| Skills | ✅ | ✅ | ✅ |
| Hooks | ✅ | ✅ | ✅ |
| Sandboxing | ✅ | ✅ | ✅ |
| Tool Ecosystem | ✅ | ✅ | ✅ |

## Model Selection Guidance

### When to Use Sonnet 4.5
**Default choice for most tasks**:
- Balanced performance and cost
- Latest capabilities
- General development work
- Production applications
- Most agent workflows

### When to Use Opus
**Maximum capability needed**:
- Complex architectural decisions
- Critical security reviews
- Research and deep analysis
- Tasks where accuracy is paramount
- Budget allows for higher cost

### When to Use Haiku
**Speed and cost optimization**:
- Simple, repetitive tasks
- Quick edits and formatting
- Straightforward refactors
- High-volume operations
- Cost-sensitive projects
- Fast iteration cycles

## Platform Support

### Claude Code CLI
- macOS, Linux, Windows
- Terminal-native operation
- Git integration
- CI/CD compatible

### Claude.ai Web
- Browser-based access
- Team collaboration
- File uploads
- Project organization

### Claude Desktop
- Desktop application
- MCP extensions
- Local file access
- Enhanced privacy

### IDE Extensions
- VS Code integration
- JetBrains plugin
- In-editor assistance

### API Access
- Direct API integration
- Claude Agent SDK
- Custom integrations
- Programmatic access

## Community & Ecosystem

### MCP Ecosystem
- **Thousands of MCP servers** built by community
- **SDKs available** in all major languages
- **Industry adoption** as de-facto standard
- **Active community** at modelcontextprotocol.io

### Plugin Marketplace
- Community plugins
- Team-shareable skills
- Pre-built agents
- Workflow templates

### Open Source
- MCP protocol is open source
- Community contributions
- Extensible architecture

## Staying Current

### Official Channels
- Anthropic Engineering Blog: https://www.anthropic.com/engineering
- Claude Code Docs: https://code.claude.com/docs
- MCP Community: modelcontextprotocol.io/community

### Update Frequency
- **Documentation**: Regularly updated with new features
- **Models**: New versions released periodically
- **Features**: Continuous improvements and additions

### Breaking Changes
- **Rare**: Anthropic maintains backward compatibility
- **Documented**: Changes announced in advance
- **Migration guides**: Provided for major updates

## Version Tracking

**Current Documentation Version**: 2025-01-15

**Last Major Claude Code Update**: November 2024 (Code Execution with MCP)

**Latest Model**: Claude Sonnet 4.5 (september-2024-20250929)

**Knowledge Cutoff**: January 2025

## Recommended Practices

### Model Selection in Agents
```yaml
---
model: sonnet  # Default recommendation
---
```

### Model Selection in Skills
```yaml
---
model: haiku  # For simple, frequent operations
---
```

### Model Override
Use `opus` for critical operations:
```yaml
---
model: opus  # When maximum accuracy needed
---
```

### Model Inheritance
Omit model field to inherit from main conversation:
```yaml
---
# model field omitted - uses parent model
---
```

## Future Roadmap Indicators

**Potential Upcoming Features** (based on blog discussions):
- Enhanced code execution capabilities
- Expanded MCP ecosystem
- Additional security features
- Improved agent coordination
- More skill templates

**Community Requests**:
- Additional MCP integrations
- Enhanced debugging tools
- Performance optimizations
- Extended platform support

---

**Note**: This document reflects capabilities as of January 2025. For the absolute latest information, always refer to:
- https://code.claude.com/docs
- https://www.anthropic.com/engineering
