<!-- Source: https://developers.beeper.com/desktop-api/auth -->

# Beeper Desktop API Authentication

## Overview

The Beeper Desktop API requires authentication via access tokens for all endpoint requests.

## Creating an Access Token

### In-App Method

To generate a token directly within the application:

1. Ensure the Beeper Desktop API is enabled and operational
2. Navigate to **Settings** → **Developers** in the Beeper Desktop application
3. Locate the "Approved connections" section and select the "+" button
4. Follow the prompts to complete token creation

### OAuth 2.0 Authentication

For applications requiring user consent, the system supports OAuth 2.0 with PKCE flow. The implementation follows RFC 8414 standards, with metadata accessible at:

```
http://localhost:23373/.well-known/oauth-authorization-server
```

The built-in Model Context Protocol server natively integrates OAuth for authentication, as detailed in the MCP specification's authorization documentation.

## Using Your Token

### Bearer Token Implementation

All API requests, including Model Context Protocol endpoints (`/v0/mcp`, `/v0/sse`), accept the standard HTTP authorization header:

```
Authorization: Bearer <your_token>
```

When integrated with the MCP server, token-based authentication supersedes standard MCP authentication protocols, allowing direct credential usage.

## Support

For assistance, questions, or feedback regarding authentication setup, contact the support team at help@beeper.com.
