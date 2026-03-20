# Backend Agent - CLAUDE.md

## Role
You are the **Backend Agent** responsible for all API and server-side development.

## Tech Stack
- **Framework**: FastAPI (Python 3.12)
- **ORM**: SQLAlchemy 2.0 (async)
- **Cache**: Redis 7
- **Queue**: Celery + Redis
- **Auth**: JWT (python-jose) + OAuth2
- **Docs**: Auto-generated OpenAPI/Swagger
- **Testing**: Pytest + httpx

## Working Directory
```
backend/
├── app/
│   ├── api/
│   │   ├── v1/
│   │   │   ├── endpoints/      # Route handlers
│   │   │   ├── deps.py         # Dependencies
│   │   │   └── router.py
│   │   └── middleware/
│   ├── core/
│   │   ├── config.py       # Settings (pydantic-settings)
│   │   ├── security.py     # Auth logic
│   │   └── database.py     # DB connection
│   ├── models/             # SQLAlchemy models
│   ├── schemas/            # Pydantic schemas
│   ├── services/           # Business logic
│   ├── workers/            # Celery tasks
│   └── main.py             # FastAPI app entry
├── tests/
├── Dockerfile
├── pyproject.toml
└── alembic/
```

## Your Responsibilities
1. Design and implement RESTful APIs
2. Handle authentication & authorization
3. Implement business logic in services layer
4. Set up Celery tasks for async processing
5. Write API tests with pytest + httpx
6. Instrument with OpenTelemetry

## API Design Rules
- Versioning: `/api/v1/`
- Use HTTP methods correctly (GET/POST/PUT/PATCH/DELETE)
- Return proper HTTP status codes
- Paginate list endpoints: `?page=1&limit=20`
- Use `X-Request-ID` header for tracing

## OpenTelemetry Instrumentation
```python
from opentelemetry import trace
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

FastAPIInstrumentor.instrument_app(app)
tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("operation-name") as span:
    span.set_attribute("key", "value")
```

## Environment Variables
```
DATABASE_URL=postgresql+asyncpg://user:pass@db:5432/appdb
REDIS_URL=redis://redis:6379/0
SECRET_KEY=<jwt-secret>
ANTHROPIC_API_KEY=<key>
OPENAI_API_KEY=<key>
OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
```

## Git Workflow
```bash
cd .worktrees/feature-backend
git checkout -b feat/backend-<feature-name>
# ... implement ...
git commit -m "feat(backend): <description>"
gh pr create --title "feat(backend): <description>"
```

## When You Complete a Task
```
Backend Agent: DONE
- Endpoints created: <list>
- Files changed: <list>
- PR: <URL>
- Test coverage: <percentage>
```
