# AI Product Platform - Claude Code Orchestration

## Overview
This repository implements a **Multi-Agent AI Product Development Platform** where you (PO/Orchestrator) coordinate specialized sub-agents using Claude Code.

## Agent Hierarchy
```
PO / Orchestrator (You)
├── frontend-agent    → Next.js 14 + TypeScript + TailwindCSS
├── backend-agent     → FastAPI + Python + Redis
├── db-agent          → PostgreSQL + Alembic migrations
├── llm-agent         → LangChain + OpenAI/Anthropic + Langfuse
├── monitoring-agent  → Prometheus + Grafana + AlertManager
├── observability-agent → OpenTelemetry + Jaeger + ELK Stack
└── qa-agent          → Pytest + Playwright + k6 load testing
```

## Claude Code Setup

### Prerequisites
```bash
npm install -g @anthropic-ai/claude-code
```

### MCP Plugins Used
- `@modelcontextprotocol/server-github` - GitHub integration
- `@modelcontextprotocol/server-filesystem` - File operations
- `@modelcontextprotocol/server-postgres` - DB introspection
- `@modelcontextprotocol/server-aws-kb-retrieval` - AWS docs
- `mcp-server-terraform` - Terraform operations

### Initialize
```bash
# Clone and setup
git clone https://github.com/hslee72/ai-product-platform.git
cd ai-product-platform
./scripts/setup.sh
```

## Orchestrator Commands

When you run `claude` in the project root, you become the PO/Orchestrator.
Use these commands to delegate to sub-agents:

```
# Spawn frontend agent
claude --agent frontend "Build the user dashboard component"

# Spawn backend agent  
claude --agent backend "Create REST API for user management"

# Spawn db agent
claude --agent db "Create migration for new orders table"

# Spawn llm agent
claude --agent llm "Add RAG pipeline for document Q&A"

# Spawn all agents in parallel via worktrees
./scripts/spawn-agents.sh
```

## Git Worktree Strategy

Each agent works in its own git worktree to enable parallel development:

```
ai-product-platform/          ← main branch (orchestrator)
├── .worktrees/
│   ├── feature-frontend/     ← frontend agent worktree
│   ├── feature-backend/      ← backend agent worktree
│   ├── feature-db/           ← db agent worktree
│   ├── feature-llm/          ← llm agent worktree
│   ├── feature-monitoring/   ← monitoring agent worktree
│   ├── feature-observability/ ← observability agent worktree
│   └── feature-qa/           ← qa agent worktree
```

## Project Structure
```
.
├── CLAUDE.md                    ← This file (Orchestrator instructions)
├── agents/                      ← Sub-agent CLAUDE.md files
│   ├── frontend/CLAUDE.md
│   ├── backend/CLAUDE.md
│   ├── db/CLAUDE.md
│   ├── llm/CLAUDE.md
│   ├── monitoring/CLAUDE.md
│   ├── observability/CLAUDE.md
│   └── qa/CLAUDE.md
├── frontend/                    ← Next.js application
├── backend/                     ← FastAPI application
├── infra/                       ← Terraform AWS infrastructure
├── scripts/                     ← Automation scripts
├── .github/workflows/           ← CI/CD pipelines
├── monitoring/                  ← Prometheus/Grafana configs
├── observability/               ← OpenTelemetry/Jaeger configs
└── docs/                        ← Architecture documentation
```

## Orchestrator Workflow

1. **Plan**: Break down the feature into agent tasks
2. **Spawn**: Create worktrees and assign tasks to sub-agents
3. **Review**: Each agent opens a PR for your review
4. **Merge**: Approve and merge PRs after review
5. **Deploy**: GitHub Actions handles CI/CD to AWS

## Environment Variables
See `.env.example` for required environment variables.

## Deployment
See `docs/deployment.md` for AWS deployment instructions.
