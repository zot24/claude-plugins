<!-- Source: https://chat-sdk.dev/docs/architecture -->

# Architecture

Chat SDK is built on Next.js App Router with a modular architecture designed for extensibility.

## Project Structure

```
ai-chatbot/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Authentication routes
│   ├── (chat)/            # Chat interface routes
│   ├── api/               # API routes
│   └── layout.tsx         # Root layout
├── components/            # React components
│   ├── ui/               # shadcn/ui components
│   ├── chat/             # Chat-specific components
│   └── artifacts/        # Artifact components
├── lib/                   # Shared utilities
│   ├── ai/               # AI SDK configuration
│   ├── db/               # Database utilities
│   └── utils/            # Helper functions
├── hooks/                 # Custom React hooks
└── public/               # Static assets
```

## Key Components

### Chat Interface
- `components/chat/chat.tsx` - Main chat container
- `components/chat/messages.tsx` - Message list
- `components/chat/input.tsx` - User input area
- `components/chat/message.tsx` - Individual message

### AI Integration
- `lib/ai/models.ts` - Model configuration
- `lib/ai/providers.ts` - Provider setup
- `app/api/chat/route.ts` - Chat API endpoint

### Data Layer
- `lib/db/schema.ts` - Database schema (Drizzle ORM)
- `lib/db/queries.ts` - Database queries
- `drizzle.config.ts` - Drizzle configuration

## Data Flow

1. User sends message via chat input
2. Message is sent to `/api/chat` endpoint
3. AI SDK processes with configured model
4. Response streams back via Server-Sent Events
5. Messages persist to Neon Postgres
6. UI updates in real-time

## Server Components vs Client Components

- **Server Components**: Data fetching, database queries, heavy computations
- **Client Components**: Interactive UI, real-time updates, user input

## Streaming Architecture

Chat SDK uses resumable streams for reliable message delivery:
- Automatic reconnection on network issues
- State preservation during interruptions
- Progressive rendering of AI responses
