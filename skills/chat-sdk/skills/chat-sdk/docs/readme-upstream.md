<!-- Source: https://github.com/vercel/ai-chatbot/blob/main/README.md -->

# Chat SDK

A free, open-source template built with Next.js and the AI SDK that helps you quickly build powerful chatbot applications.

## Features

- [Next.js](https://nextjs.org) App Router
  - Advanced routing for seamless navigation and performance
  - React Server Components (RSCs) and Server Actions for server-side rendering and increased performance
- [AI SDK](https://sdk.vercel.ai/docs)
  - Unified API for generating text, structured objects, and tool calls with LLMs
  - Hooks for building dynamic chat and generative user interfaces
  - Supports xAI (default), OpenAI, Anthropic, Cohere, and other model providers
- [shadcn/ui](https://ui.shadcn.com)
  - Styling with [Tailwind CSS](https://tailwindcss.com)
  - Component primitives from [Radix UI](https://radix-ui.com) for accessibility and flexibility
- Data Persistence
  - [Neon Serverless Postgres](https://neon.tech) for saving chat history and user data
  - [Vercel Blob](https://vercel.com/storage/blob) for efficient file storage
- [Auth.js](https://authjs.dev) for simple and secure authentication

## Model Providers

This template ships with xAI `grok-2-vision-1212` as the default chat model, along with `grok-3-mini` for title generation and suggestions, but you can switch to any other supported model provider by updating just a few lines of code. Learn more about the AI SDK's [model providers](https://sdk.vercel.ai/providers).

## Deploy Your Own

You can deploy your own version of the Chat SDK to Vercel with one click:

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fvercel%2Fai-chatbot&env=AUTH_SECRET&envDescription=Generate%20a%20random%20secret%3A%20https%3A%2F%2Fgenerate-secret.vercel.app%2F32%20or%20%60npx%20auth%20secret%60.%20See%20https%3A%2F%2Fchat-sdk.dev%20for%20more%20information.&envLink=https://chat-sdk.dev&project-name=my-chat-sdk&repository-name=my-chat-sdk&demo-title=Chat%20SDK&demo-description=A%20full-featured%2C%20hackable%20Next.js%20AI%20chatbot&demo-url=https%3A%2F%2Fchat-sdk.dev&products=blob,neon,fluid&teamSlug=vercel)

## Running locally

You will need to use the environment variables [defined in `.env.example`](.env.example) to run the Chat SDK. It's recommended you use [Vercel Environment Variables](https://vercel.com/docs/projects/environment-variables) for this, but a `.env.local` file is all that is necessary.

> Note: You should not commit your `.env.local` file or it will expose secrets that will allow others to control access to your various AI and authentication provider accounts.

1. Install Vercel CLI: `npm i -g vercel`
2. Link local instance with Vercel and GitHub accounts (creates `.vercel` directory): `vercel link`
3. Download your environment variables: `vercel env pull`

```bash
pnpm install
pnpm db:migrate
pnpm dev
```

Your app template should now be running on [localhost:3000](http://localhost:3000/).
