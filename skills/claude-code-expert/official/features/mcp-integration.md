# MCP (Model Context Protocol) Integration Guide

> **Source**: Official Claude Code Documentation & MCP Specification
> **Source URL**: https://code.claude.com/docs/en/mcp.md
> **Last Updated**: 2025-01-15

## Overview

The Model Context Protocol (MCP) is an open protocol that standardizes how applications provide context to Large Language Models (LLMs). MCP enables Claude Code to connect to external data sources, tools, and services through a unified interface.

## What is MCP?

MCP creates a standardized way for LLMs to interact with external systems by defining:
- **Resources**: Data and content exposed by servers
- **Prompts**: Reusable prompt templates and workflows
- **Tools**: Functions that LLMs can invoke to perform actions

### Key Benefits

1. **Unified Integration**: Single protocol for all external connections
2. **Composability**: Mix and match different MCP servers
3. **Security**: Controlled access to external systems
4. **Extensibility**: Easy to add new capabilities
5. **Reusability**: Share servers across projects and users

### MCP vs Traditional Integrations

**Traditional Approach**:
- Custom integration per service
- Proprietary protocols
- Tight coupling
- Duplication of effort

**MCP Approach**:
- Standard protocol
- Universal interface
- Loose coupling
- Reusable components

## MCP Architecture

### Three Core Components

```
┌─────────────┐          ┌─────────────┐          ┌─────────────┐
│   Claude    │ ←──MCP──→│ MCP Server  │ ←──────→│  External   │
│    Code     │          │             │          │   System    │
│  (Client)   │          │  (Bridge)   │          │ (Database,  │
│             │          │             │          │  API, etc)  │
└─────────────┘          └─────────────┘          └─────────────┘
```

**Claude Code (MCP Client)**:
- Discovers available MCP servers
- Queries resources and tools
- Executes tool calls
- Manages server lifecycle

**MCP Server**:
- Exposes resources (data)
- Provides tools (actions)
- Offers prompts (templates)
- Handles external system communication

**External System**:
- Database, filesystem, API, or service
- Original source of data/functionality
- Accessed by MCP server

### Communication Model

MCP uses JSON-RPC 2.0 for communication:
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "query_database",
    "arguments": {
      "sql": "SELECT * FROM users"
    }
  },
  "id": 1
}
```

## Core MCP Primitives

### 1. Resources

**Purpose**: Expose data and content to Claude

**Characteristics**:
- Read-only data sources
- URI-based identification
- Support for text and binary content
- Optional templating support

**Example Resource Types**:
```markdown
# File system resource
file:///path/to/document.txt

# Database query result
postgres://localhost/mydb?query=SELECT*FROM users

# API endpoint data
http://api.example.com/v1/users

# Application state
app://current-project/config
```

**Resource Schema**:
```typescript
interface Resource {
  uri: string;              // Unique identifier
  name: string;             // Human-readable name
  description?: string;     // What this resource contains
  mimeType?: string;        // Content type
  text?: string;            // Text content
  blob?: Uint8Array;        // Binary content
}
```

**Use Cases**:
- Exposing documentation
- Providing configuration data
- Sharing database contents
- Making API data available

### 2. Prompts

**Purpose**: Reusable prompt templates and workflows

**Characteristics**:
- Parameterized templates
- Support for dynamic content
- Can include resource references
- Composable workflows

**Example Prompts**:
```markdown
# Code review prompt
name: "code-review"
description: "Review code for quality and security"
arguments:
  - name: "file_path"
    description: "Path to file to review"
    required: true

# Data analysis prompt
name: "analyze-metrics"
description: "Analyze performance metrics"
arguments:
  - name: "metric_type"
    required: true
  - name: "time_range"
    required: false
```

**Prompt Schema**:
```typescript
interface Prompt {
  name: string;
  description?: string;
  arguments?: PromptArgument[];
}

interface PromptArgument {
  name: string;
  description?: string;
  required?: boolean;
}
```

**Use Cases**:
- Standard analysis workflows
- Consistent review processes
- Parameterized queries
- Template-based generation

### 3. Tools

**Purpose**: Actions that Claude can execute

**Characteristics**:
- Function-like interface
- Input schema definition (JSON Schema)
- Synchronous or asynchronous execution
- Arbitrary side effects allowed

**Example Tools**:
```markdown
# Database query tool
name: "execute_query"
description: "Execute SQL query on database"
input_schema:
  type: "object"
  properties:
    sql: {type: "string"}
    parameters: {type: "array"}

# File operation tool
name: "search_files"
description: "Search files by pattern"
input_schema:
  type: "object"
  properties:
    pattern: {type: "string"}
    directory: {type: "string"}

# API call tool
name: "create_issue"
description: "Create GitHub issue"
input_schema:
  type: "object"
  properties:
    title: {type: "string"}
    body: {type: "string"}
    labels: {type: "array"}
```

**Tool Schema**:
```typescript
interface Tool {
  name: string;
  description?: string;
  inputSchema: {
    type: "object";
    properties?: Record<string, JSONSchema>;
    required?: string[];
  };
}
```

**Use Cases**:
- Database operations
- API interactions
- File system access
- External service integration

## MCP Server Configuration

### Configuration File Location

Claude Code reads MCP configuration from:
```
~/.config/claude/claude_desktop_config.json
```

### Basic Configuration Structure

```json
{
  "mcpServers": {
    "server-name": {
      "command": "command-to-start-server",
      "args": ["arg1", "arg2"],
      "env": {
        "ENV_VAR": "value"
      }
    }
  }
}
```

### Example Configurations

#### PostgreSQL Server
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://localhost/mydb"
      ]
    }
  }
}
```

#### Filesystem Server
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/allowed/directory"
      ]
    }
  }
}
```

#### GitHub Server
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_TOKEN": "your-token-here"
      }
    }
  }
}
```

#### Google Drive Server
```json
{
  "mcpServers": {
    "gdrive": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-gdrive"
      ]
    }
  }
}
```

#### Slack Server
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-slack"
      ],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-token",
        "SLACK_TEAM_ID": "T01234567"
      }
    }
  }
}
```

### Multiple Servers Configuration

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/db1"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/username/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

## Official MCP Servers

### Database Servers

**PostgreSQL** (`@modelcontextprotocol/server-postgres`):
- Execute SQL queries
- Read table schemas
- Manage connections
- Transaction support

**SQLite** (`@modelcontextprotocol/server-sqlite`):
- Local database access
- Schema inspection
- Query execution

### Filesystem Servers

**Filesystem** (`@modelcontextprotocol/server-filesystem`):
- Read/write files
- Directory traversal
- File search
- Path operations

**Memory** (`@modelcontextprotocol/server-memory`):
- In-memory key-value store
- Session persistence
- Temporary storage

### Development Servers

**GitHub** (`@modelcontextprotocol/server-github`):
- Repository access
- Issue management
- Pull request operations
- File browsing

**GitLab** (`@modelcontextprotocol/server-gitlab`):
- Project management
- Merge request operations
- CI/CD integration

**Sentry** (`@modelcontextprotocol/server-sentry`):
- Error tracking
- Issue browsing
- Performance monitoring

### Productivity Servers

**Google Drive** (`@modelcontextprotocol/server-gdrive`):
- Document access
- File search
- Sharing management

**Google Maps** (`@modelcontextprotocol/server-google-maps`):
- Location search
- Geocoding
- Place details

**Slack** (`@modelcontextprotocol/server-slack`):
- Channel access
- Message posting
- User lookup

### AI & Search Servers

**Brave Search** (`@modelcontextprotocol/server-brave-search`):
- Web search
- News search
- Image search

**Fetch** (`@modelcontextprotocol/server-fetch`):
- HTTP requests
- Web scraping
- API calls

**Puppeteer** (`@modelcontextprotocol/server-puppeteer`):
- Browser automation
- Screenshot capture
- Web interaction

## Using MCP in Claude Code

### Tool Discovery

When MCP servers are configured, their tools appear alongside native Claude Code tools:

```markdown
Available tools:
- Read (native)
- Write (native)
- Grep (native)
- mcp__postgres__query (MCP)
- mcp__github__create_issue (MCP)
- mcp__filesystem__read_file (MCP)
```

### Tool Naming Convention

MCP tools follow the pattern: `mcp__{server}__{tool_name}`

Examples:
- `mcp__postgres__execute_query`
- `mcp__github__search_repositories`
- `mcp__slack__post_message`

### Invoking MCP Tools

Claude can automatically invoke MCP tools when appropriate:

```markdown
User: "Query the users table in the database"

Claude uses: mcp__postgres__query
Parameters: {sql: "SELECT * FROM users LIMIT 10"}
```

### Accessing MCP Resources

Resources are available for Claude to read:

```markdown
User: "Analyze the project documentation"

Claude accesses: mcp__gdrive__resource://docs/project-spec
```

### Using MCP Prompts

Invoke pre-configured workflows:

```markdown
User: "Run the code review workflow on main.ts"

Claude uses: mcp__server__prompt://code-review
Arguments: {file_path: "main.ts"}
```

## MCP in Subagents

### Inheriting MCP Tools

Agents inherit MCP tools when `tools` field is omitted:

```yaml
---
name: database-analyst
description: Analyze database queries and performance
# tools field omitted - inherits all tools including MCP
model: sonnet
---

You are a database analyst with access to PostgreSQL tools.
Use the database query tools to analyze data and performance.
```

### Restricting MCP Access

Limit agent to specific tools:

```yaml
---
name: readonly-reviewer
description: Review code without modification capabilities
tools: Read, Grep, Glob, mcp__github__get_file
model: sonnet
---

You can read files and access GitHub for code review,
but cannot modify files or create issues.
```

### MCP-Specialized Agents

Create agents focused on MCP capabilities:

```yaml
---
name: slack-notifier
description: Post updates to Slack channels
tools: mcp__slack__post_message, mcp__slack__get_channels
model: haiku
---

You notify team members via Slack.
Post concise, well-formatted updates to appropriate channels.
```

## Building Custom MCP Servers

### Server Implementation Options

**Node.js/TypeScript**:
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server({
  name: "my-server",
  version: "1.0.0"
}, {
  capabilities: {
    tools: {}
  }
});

// Define tools
server.setRequestHandler("tools/list", async () => ({
  tools: [{
    name: "my_tool",
    description: "Does something useful",
    inputSchema: {
      type: "object",
      properties: {
        param: { type: "string" }
      }
    }
  }]
}));

// Start server
const transport = new StdioServerTransport();
await server.connect(transport);
```

**Python**:
```python
from mcp.server import Server
from mcp.types import Tool, TextContent

server = Server("my-server")

@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="my_tool",
            description="Does something useful",
            inputSchema={
                "type": "object",
                "properties": {
                    "param": {"type": "string"}
                }
            }
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name == "my_tool":
        result = do_something(arguments["param"])
        return [TextContent(type="text", text=result)]
```

### Server Development Best Practices

1. **Clear Tool Descriptions**: Help Claude understand when to use tools
2. **Comprehensive Schemas**: Define all parameters with types and descriptions
3. **Error Handling**: Return meaningful error messages
4. **Security**: Validate inputs, limit access, use authentication
5. **Documentation**: Provide usage examples and limitations
6. **Testing**: Verify tool behavior with various inputs
7. **Logging**: Track usage for debugging and optimization

### Publishing Servers

1. **Package**: Create npm package or PyPI distribution
2. **Document**: Provide clear installation and configuration guide
3. **Examples**: Include sample configurations
4. **Version**: Use semantic versioning
5. **License**: Choose appropriate open source license
6. **Share**: Submit to MCP server directory

## Security Considerations

### Authentication

```json
{
  "mcpServers": {
    "secure-api": {
      "command": "npx",
      "args": ["-y", "@company/mcp-server"],
      "env": {
        "API_KEY": "${API_KEY}",
        "API_SECRET": "${API_SECRET}"
      }
    }
  }
}
```

### Access Control

- **Filesystem servers**: Limit to specific directories
- **Database servers**: Use read-only credentials when possible
- **API servers**: Implement rate limiting and scoping

### Data Privacy

- **Local processing**: MCP servers run locally
- **Credential management**: Store secrets in environment variables
- **Audit logging**: Track MCP tool usage
- **Data retention**: Configure according to requirements

## Troubleshooting

### Server Not Starting

```bash
# Check server installation
npx -y @modelcontextprotocol/server-postgres --version

# Verify configuration syntax
cat ~/.config/claude/claude_desktop_config.json | jq .

# Check environment variables
echo $GITHUB_TOKEN
```

### Tools Not Appearing

1. Verify server is in configuration file
2. Restart Claude Code
3. Check server logs for errors
4. Validate JSON syntax

### Tool Execution Failures

1. Check input schema matches arguments
2. Verify credentials and permissions
3. Review server logs
4. Test tool independently

### Performance Issues

1. Add caching in server implementation
2. Limit data returned from resources
3. Use pagination for large datasets
4. Optimize database queries

## Best Practices

### Configuration Management

```markdown
✅ DO:
- Store config in version control (without secrets)
- Use environment variables for credentials
- Document required environment variables
- Provide example configurations

❌ DON'T:
- Hardcode secrets in config files
- Share production credentials
- Forget to document setup steps
```

### Tool Design

```markdown
✅ DO:
- Provide clear, specific tool descriptions
- Use descriptive parameter names
- Include examples in descriptions
- Return structured, parseable results
- Validate inputs before processing

❌ DON'T:
- Create overly generic tools
- Use ambiguous parameter names
- Return unstructured text blobs
- Assume inputs are valid
```

### Agent Integration

```markdown
✅ DO:
- Create MCP-specialized agents for complex workflows
- Document which MCP servers agents require
- Test agents with MCP tools
- Provide setup instructions

❌ DON'T:
- Assume MCP servers are always available
- Create agent dependencies on optional servers
- Skip error handling for MCP tools
```

## Example Workflows

### Database Analysis Workflow

```markdown
1. Configure PostgreSQL MCP server
2. Create database-analyst agent
3. Agent uses mcp__postgres__query to fetch data
4. Agent analyzes results
5. Agent generates insights and recommendations
```

### Code Review Workflow

```markdown
1. Configure GitHub MCP server
2. Create code-reviewer agent with GitHub access
3. Agent uses mcp__github__get_pull_request
4. Agent reads changed files
5. Agent posts review comments via mcp__github__create_comment
```

### Documentation Workflow

```markdown
1. Configure Google Drive MCP server
2. Create documentation-writer agent
3. Agent reads project files with Read tool
4. Agent accesses docs via mcp__gdrive__read
5. Agent updates documentation
6. Agent saves back to Drive via mcp__gdrive__write
```

## Future Developments

### Planned MCP Features

- Enhanced resource templating
- Streaming support for large responses
- Binary data handling improvements
- Server discovery mechanisms
- Cross-server coordination

### Community Servers

The MCP ecosystem is growing with community-contributed servers for:
- Additional databases (MongoDB, Redis, etc.)
- Cloud platforms (AWS, Azure, GCP)
- Development tools (Jira, Linear, etc.)
- Analytics platforms
- Custom business systems

## Resources

### Official Documentation
- MCP Specification: https://modelcontextprotocol.io/
- Server SDK: https://github.com/modelcontextprotocol/sdk
- Example Servers: https://github.com/modelcontextprotocol/servers

### Community
- Server Directory: https://modelcontextprotocol.io/servers
- GitHub Discussions: Community support and examples
- Sample Implementations: Reference code and patterns

## Quick Reference

### Enable MCP Server
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@org/server-package"],
      "env": {"KEY": "value"}
    }
  }
}
```

### Use MCP Tool in Agent
```yaml
---
name: mcp-agent
description: Agent with MCP access
# Omit tools to inherit MCP tools
---
```

### Invoke MCP Tool
```markdown
Claude automatically selects appropriate MCP tools based on:
- Tool descriptions
- User request context
- Available parameters
```

### Check Available MCP Tools
Look for tools prefixed with `mcp__` in tool listings.
