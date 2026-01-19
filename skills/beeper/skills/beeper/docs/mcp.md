<!-- Source: https://developers.beeper.com/desktop-api/mcp -->

# Beeper Desktop MCP Integration Guide

## Overview

The Beeper Desktop API includes a built-in Model Context Protocol (MCP) server that enables integration with AI assistants including Claude Desktop, Claude Code, Cursor, and other compatible applications.

### What is MCP?

"MCP is an open protocol that standardizes how applications provide context to large language models (LLMs)." The protocol functions analogously to a USB-C port—offering a standardized method for connecting AI models to various data sources and tools.

## Quick Start

1. **Install Beeper Desktop** from https://www.beeper.com/download

2. **Enable the API**
   - Navigate to Settings → Developers
   - Toggle "Beeper Desktop API" to enable
   - Alternatively, use the direct link: `beeper://connect`

3. **Connect your MCP client** using one of the provided installation options for your specific platform

## Server Configuration

### Base URL
```
http://localhost:23373/v0/mcp
```

### Streamable HTTP Setup

The MCP server supports streamable HTTP connections without manual token configuration. Authentication is handled automatically through OAuth.

```json
{
  "mcpServers": {
    "beeper": {
      "url": "http://localhost:23373/v0/mcp"
    }
  }
}
```

### Manual Token Authentication

For custom authentication workflows, you can bypass automatic authentication by manually specifying an access token.

```json
{
  "mcpServers": {
    "beeper": {
      "url": "http://localhost:23373/v0/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_TOKEN_HERE"
      }
    }
  }
}
```

## Client-Specific Instructions

### Claude Code

Install globally:
```bash
claude mcp add beeper http://localhost:23373/v0/mcp -t http -s user
```

Install within a directory:
```bash
claude mcp add beeper http://localhost:23373/v0/mcp -t http -s local
```

### Claude Desktop

Configuration file: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS)

```json
{
  "mcpServers": {
    "beeper": {
      "url": "http://localhost:23373/v0/mcp"
    }
  }
}
```

### Cursor

Configuration file: `~/.cursor/mcp.json`

```json
{
  "mcpServers": {
    "beeper": {
      "url": "http://localhost:23373/v0/mcp"
    }
  }
}
```

### Visual Studio Code

Configuration file: `.vscode/mcp.json`

```json
{
  "servers": {
    "beeper": {
      "type": "http",
      "url": "http://localhost:23373/v0/mcp"
    }
  }
}
```

### Windsurf

Configuration file: `~/.codeium/windsurf/mcp_config.json`

```json
{
  "mcpServers": {
    "beeper": {
      "url": "http://localhost:23373/v0/mcp"
    }
  }
}
```

### CLI-Based Clients (Warp, Codex, Gemini CLI)

These clients require Node.js installation and use the `@beeper/mcp-remote` package:

```json
{
  "mcpServers": {
    "beeper": {
      "command": "npx",
      "args": ["@beeper/mcp-remote"]
    }
  }
}
```

## Important Notes

- The Beeper Desktop MCP server requires Beeper Desktop to be actively running
- OAuth-based authentication is automatically managed for compatible clients
- For stdio-based connections, Node.js must be installed on your system
- Pre-configured quick-start links are available for major platforms in the settings interface
