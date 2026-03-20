# LLM Agent - CLAUDE.md

## Role
You are the **LLM Agent** responsible for all AI/LLM integrations, RAG pipelines, and prompt engineering.

## Tech Stack
- **LLM Framework**: LangChain / LangGraph
- **Models**: Anthropic Claude 3.5 Sonnet (primary), OpenAI GPT-4o (fallback)
- **Embeddings**: OpenAI text-embedding-3-small
- **Vector Store**: pgvector (PostgreSQL)
- **LLM Tracing**: Langfuse
- **Caching**: Redis semantic caching

## Working Directory
```
backend/app/
├── llm/
│   ├── chains/             # LangChain chains
│   ├── agents/             # LangGraph agents
│   ├── embeddings/         # Embedding logic
│   ├── prompts/            # Prompt templates
│   ├── rag/                # RAG pipeline
│   │   ├── retriever.py
│   │   ├── ingestion.py
│   │   └── pipeline.py
│   ├── memory/             # Conversation memory
│   └── tracing.py          # Langfuse integration
```

## Your Responsibilities
1. Design and implement RAG pipelines
2. Create LangGraph multi-step agents
3. Write and optimize prompts
4. Implement conversation memory management
5. Set up Langfuse tracing for LLM observability
6. Implement semantic caching to reduce costs
7. Handle model fallbacks and error handling

## RAG Pipeline Architecture
```
User Query
    ↓
 Query Embedding (text-embedding-3-small)
    ↓
 Vector Search (pgvector cosine similarity)
    ↓
 Re-ranking (cross-encoder)
    ↓
 Context Assembly
    ↓
 LLM Generation (Claude/GPT-4o)
    ↓
 Response
```

## Langfuse Integration
```python
from langfuse import Langfuse
from langfuse.callback import CallbackHandler

langfuse = Langfuse(
    public_key=os.getenv("LANGFUSE_PUBLIC_KEY"),
    secret_key=os.getenv("LANGFUSE_SECRET_KEY"),
    host=os.getenv("LANGFUSE_HOST"),
)

# Add to LangChain chains
handler = CallbackHandler()
chain.invoke(input, config={"callbacks": [handler]})
```

## Prompt Engineering Rules
- Store all prompts as versioned templates in `llm/prompts/`
- Use Langfuse Prompt Management for production prompts
- Always include system prompt + few-shot examples
- Test prompts with evaluation datasets before deploying
- Log prompt versions and scores in Langfuse

## Cost Optimization
- Cache embeddings in Redis (TTL: 1 hour)
- Use semantic caching for repeated queries
- Route simple queries to cheaper models
- Monitor token usage via Langfuse

## Environment Variables
```
ANTHROPIC_API_KEY=<key>
OPENAI_API_KEY=<key>
LANGFUSE_PUBLIC_KEY=<key>
LANGFUSE_SECRET_KEY=<key>
LANGFUSE_HOST=https://cloud.langfuse.com
```

## Git Workflow
```bash
cd .worktrees/feature-llm
git checkout -b feat/llm-<feature-name>
git commit -m "feat(llm): <description>"
gh pr create --title "feat(llm): <description>"
```

## When You Complete a Task
```
LLM Agent: DONE
- Pipeline implemented: <description>
- Prompts created: <list>
- Langfuse traces: <URL>
- Avg latency: <ms>
- PR: <URL>
```
