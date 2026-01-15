<!-- Source: https://chat-sdk.dev/docs/setup -->

# Setup

This guide covers setting up Chat SDK for local development and production deployment.

## Prerequisites

- Node.js 18+
- pnpm (recommended) or npm
- A database (Neon Postgres recommended)
- AI provider API key (xAI, OpenAI, Anthropic, etc.)

## Quick Start

### Option 1: Deploy to Vercel (Recommended)

Click the "Deploy with Vercel" button in the repository to:
1. Clone the repository to your GitHub
2. Set up environment variables
3. Provision Neon database and Vercel Blob storage
4. Deploy automatically

### Option 2: Local Development

```bash
# Clone the repository
git clone https://github.com/vercel/ai-chatbot.git
cd ai-chatbot

# Install dependencies
pnpm install

# Copy environment variables
cp .env.example .env.local
```

## Environment Variables

Required variables in `.env.local`:

```bash
# Authentication
AUTH_SECRET=your-auth-secret  # Generate with: npx auth secret

# AI Provider (choose one)
XAI_API_KEY=your-xai-key
# or
OPENAI_API_KEY=your-openai-key
# or
ANTHROPIC_API_KEY=your-anthropic-key

# Database
DATABASE_URL=your-neon-postgres-url

# Storage
BLOB_READ_WRITE_TOKEN=your-vercel-blob-token
```

## Database Setup

Run migrations to create the required tables:

```bash
pnpm db:migrate
```

## Running the Development Server

```bash
pnpm dev
```

The app will be available at [http://localhost:3000](http://localhost:3000).

## Authentication Setup

Chat SDK uses Auth.js for authentication. By default, it supports:
- Email/password registration
- Magic links
- OAuth providers (GitHub, Google, etc.)

Configure additional providers in `auth.config.ts`.

## Vercel CLI Workflow

For the best experience with environment variables:

```bash
# Install Vercel CLI
npm i -g vercel

# Link to your Vercel project
vercel link

# Pull environment variables
vercel env pull
```

This automatically syncs your production environment variables locally.
