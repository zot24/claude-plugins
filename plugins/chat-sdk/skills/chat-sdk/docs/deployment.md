<!-- Source: https://chat-sdk.dev/docs/deploying -->

# Deployment

Deploy Chat SDK to Vercel or self-host on your own infrastructure.

## Vercel Deployment (Recommended)

### One-Click Deploy

Use the "Deploy with Vercel" button in the repository:
1. Click the deploy button
2. Connect your GitHub account
3. Configure environment variables
4. Vercel provisions Neon database and Blob storage
5. Deploy automatically

### Manual Vercel Deployment

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Follow prompts to configure project
```

### Environment Variables on Vercel

Set these in your Vercel project settings:

| Variable | Description |
|----------|-------------|
| `AUTH_SECRET` | Authentication secret (generate with `npx auth secret`) |
| `XAI_API_KEY` | xAI API key (or other provider) |
| `DATABASE_URL` | Neon Postgres connection string |
| `BLOB_READ_WRITE_TOKEN` | Vercel Blob token |

### Vercel Integrations

Enable these integrations for automatic configuration:
- **Neon**: Serverless Postgres database
- **Vercel Blob**: File storage

## Self-Hosting

### Docker

```dockerfile
FROM node:20-alpine

WORKDIR /app
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm build

EXPOSE 3000
CMD ["pnpm", "start"]
```

```bash
docker build -t chat-sdk .
docker run -p 3000:3000 --env-file .env.local chat-sdk
```

### Node.js Server

```bash
# Build
pnpm build

# Start production server
pnpm start
```

### Database Options

For self-hosting, you can use:
- Neon Serverless Postgres (recommended)
- Supabase Postgres
- PlanetScale MySQL
- Any PostgreSQL-compatible database

Update `drizzle.config.ts` and `lib/db/index.ts` for your database.

## Production Checklist

- [ ] Set strong `AUTH_SECRET`
- [ ] Configure production database
- [ ] Enable HTTPS
- [ ] Set up monitoring (Vercel Analytics, Sentry)
- [ ] Configure rate limiting
- [ ] Review security headers
- [ ] Test authentication flow
- [ ] Verify file upload limits

## Scaling Considerations

- **Database**: Neon auto-scales; for others, configure connection pooling
- **Storage**: Vercel Blob scales automatically
- **Compute**: Vercel serverless functions scale automatically
- **Caching**: Consider Redis for session/response caching at scale
