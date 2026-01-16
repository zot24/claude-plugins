<!-- Source: https://chat-sdk.dev/docs/customization/theming -->

# Theming

Chat SDK uses Tailwind CSS and CSS variables for easy customization.

## Color System

Colors are defined using CSS variables in `app/globals.css`:

```css
:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --card: 0 0% 100%;
  --card-foreground: 222.2 84% 4.9%;
  --popover: 0 0% 100%;
  --popover-foreground: 222.2 84% 4.9%;
  --primary: 222.2 47.4% 11.2%;
  --primary-foreground: 210 40% 98%;
  --secondary: 210 40% 96.1%;
  --secondary-foreground: 222.2 47.4% 11.2%;
  --muted: 210 40% 96.1%;
  --muted-foreground: 215.4 16.3% 46.9%;
  --accent: 210 40% 96.1%;
  --accent-foreground: 222.2 47.4% 11.2%;
  --destructive: 0 84.2% 60.2%;
  --destructive-foreground: 210 40% 98%;
  --border: 214.3 31.8% 91.4%;
  --input: 214.3 31.8% 91.4%;
  --ring: 222.2 84% 4.9%;
  --radius: 0.5rem;
}

.dark {
  --background: 222.2 84% 4.9%;
  --foreground: 210 40% 98%;
  /* ... dark mode values */
}
```

## Customizing Colors

Update the CSS variables to match your brand:

```css
:root {
  --primary: 221.2 83.2% 53.3%; /* Your brand color */
  --primary-foreground: 210 40% 98%;
}
```

## Fonts

### Changing Fonts

1. Import your font in `app/layout.tsx`:

```typescript
import { Inter, Fira_Code } from 'next/font/google';

const inter = Inter({ subsets: ['latin'] });
const firaCode = Fira_Code({ subsets: ['latin'], variable: '--font-mono' });
```

2. Apply to the body:

```typescript
<body className={`${inter.className} ${firaCode.variable}`}>
```

3. Use in Tailwind:

```css
/* tailwind.config.js */
fontFamily: {
  mono: ['var(--font-mono)', 'monospace'],
}
```

## Component Theming

shadcn/ui components can be customized in `components/ui/`:

```typescript
// components/ui/button.tsx
const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        // Add custom variants
        brand: "bg-brand-500 text-white hover:bg-brand-600",
      },
    },
  }
);
```

## Dark Mode

Chat SDK supports dark mode out of the box:

```typescript
// Use next-themes for mode switching
import { ThemeProvider } from 'next-themes';

<ThemeProvider attribute="class" defaultTheme="system">
  {children}
</ThemeProvider>
```

Toggle with the theme switcher component in the UI.

## Layout Customization

Modify the chat layout in `app/(chat)/layout.tsx`:
- Sidebar width
- Header height
- Message container width
- Input area height
