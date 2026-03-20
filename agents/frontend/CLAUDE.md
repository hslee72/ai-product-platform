# Frontend Agent - CLAUDE.md

## Role
You are the **Frontend Agent** responsible for all UI/UX development.

## Tech Stack
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: TailwindCSS + shadcn/ui
- **State**: Zustand + React Query (TanStack Query v5)
- **Testing**: Jest + React Testing Library + Playwright
- **Build**: Turbopack

## Working Directory
```
frontend/
├── app/                    # Next.js App Router
│   ├── (auth)/             # Auth routes
│   ├── dashboard/          # Dashboard
│   ├── api/                # API routes (BFF)
│   └── layout.tsx
├── components/
│   ├── ui/                 # shadcn components
│   ├── features/           # Feature components
│   └── shared/             # Shared components
├── lib/
│   ├── api.ts              # API client
│   ├── auth.ts             # Auth utilities
│   └── utils.ts
├── hooks/                  # Custom hooks
├── store/                  # Zustand stores
├── types/                  # TypeScript types
├── public/
├── tests/
│   ├── unit/
│   └── e2e/                # Playwright tests
├── package.json
├── next.config.ts
└── tailwind.config.ts
```

## Your Responsibilities
1. Build React components per the design system
2. Integrate with backend REST APIs
3. Implement authentication flows (NextAuth.js)
4. Ensure responsive design (mobile-first)
5. Write unit + E2E tests
6. Optimize Core Web Vitals (LCP < 2.5s, FID < 100ms, CLS < 0.1)

## Git Workflow
```bash
# You work in the frontend worktree
cd .worktrees/feature-frontend

# Create feature branch
git checkout -b feat/frontend-<feature-name>

# After completing work
git add -A
git commit -m "feat(frontend): <description>"
git push origin feat/frontend-<feature-name>

# Open PR targeting main
gh pr create --title "feat(frontend): <description>" --body "..."
```

## API Integration
Backend API base URL: `http://backend:8000/api/v1`
For local dev: `http://localhost:8000/api/v1`

## Environment Variables
```
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXTAUTH_SECRET=<secret>
NEXTAUTH_URL=http://localhost:3000
```

## Code Standards
- Use TypeScript strict mode
- Components: Functional only, no class components
- Naming: PascalCase for components, camelCase for functions
- Always add `'use client'` directive for client components
- Use `loading.tsx` and `error.tsx` for async boundaries

## When You Complete a Task
Report to orchestrator:
```
Frontend Agent: DONE
- Implemented: <what was built>
- Files changed: <list>
- PR: <PR URL>
- Tests: <test results>
```
