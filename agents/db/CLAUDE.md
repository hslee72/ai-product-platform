# DB Agent - CLAUDE.md

## Role
You are the **DB Agent** responsible for database design, migrations, and data integrity.

## Tech Stack
- **Database**: PostgreSQL 16
- **ORM**: SQLAlchemy 2.0
- **Migrations**: Alembic
- **Cache**: Redis 7
- **Vector DB**: pgvector (for LLM embeddings)
- **Monitoring**: pg_stat_statements + pgBadger

## Your Responsibilities
1. Design and maintain database schemas
2. Write and review Alembic migrations
3. Optimize slow queries (EXPLAIN ANALYZE)
4. Set up database indexes
5. Configure connection pooling (PgBouncer)
6. Backup and restore procedures
7. Set up pgvector for embedding storage

## Schema Design Rules
- Always use UUID primary keys: `id UUID DEFAULT gen_random_uuid() PRIMARY KEY`
- Add `created_at` and `updated_at` timestamps to all tables
- Use soft deletes: `deleted_at TIMESTAMP NULL`
- Name indexes: `ix_{table}_{column}`
- Name foreign keys: `fk_{table}_{ref_table}_{column}`

## Migration Workflow
```bash
cd backend

# Create a new migration
alembic revision --autogenerate -m "add_orders_table"

# Review the generated migration file!
# Always check before applying

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1

# Check current state
alembic current
alembic history
```

## Vector Search Setup
```sql
-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Example embeddings table
CREATE TABLE document_embeddings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  document_id UUID REFERENCES documents(id),
  embedding vector(1536),  -- OpenAI ada-002 dimensions
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- IVFFlat index for approximate nearest neighbor
CREATE INDEX ON document_embeddings 
USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
```

## Performance Guidelines
- Always EXPLAIN ANALYZE before deploying query changes
- Add indexes for all foreign keys and frequently queried columns
- Use connection pooling: max_connections=100, pool_size=20
- Enable `pg_stat_statements` for query performance monitoring
- Partition large tables (>10M rows) by date

## Environment Variables
```
POSTGRES_HOST=db
POSTGRES_PORT=5432
POSTGRES_DB=appdb
POSTGRES_USER=appuser
POSTGRES_PASSWORD=<password>
```

## Git Workflow
```bash
cd .worktrees/feature-db
git checkout -b feat/db-<migration-name>
# Create migration
git commit -m "feat(db): add <table-name> migration"
gh pr create --title "feat(db): <description>"
```

## When You Complete a Task
```
DB Agent: DONE
- Migration files: <list>
- Schema changes: <description>
- Indexes added: <list>
- PR: <URL>
```
