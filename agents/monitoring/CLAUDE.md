# Monitoring Agent - CLAUDE.md

## Role
You are the **Monitoring Agent** responsible for metrics collection, alerting, and dashboards.

## Tech Stack
- **Metrics**: Prometheus
- **Dashboards**: Grafana
- **Alerting**: AlertManager + PagerDuty/Slack
- **Uptime**: Blackbox Exporter
- **APM**: AWS CloudWatch (in production)

## Working Directory
```
monitoring/
├── prometheus/
│   ├── prometheus.yml
│   ├── rules/
│   │   ├── alerts.yml
│   │   └── recording_rules.yml
│   └── targets/
├── grafana/
│   ├── dashboards/
│   │   ├── api_performance.json
│   │   ├── llm_metrics.json
│   │   ├── infrastructure.json
│   │   └── business_metrics.json
│   └── provisioning/
├── alertmanager/
│   └── alertmanager.yml
└── docker-compose.monitoring.yml
```

## Key Metrics to Monitor

### API Metrics
- `http_requests_total` - Request count by endpoint/status
- `http_request_duration_seconds` - Latency histogram
- `http_requests_in_flight` - Active requests

### LLM Metrics
- `llm_requests_total` - LLM API calls
- `llm_tokens_used_total` - Token consumption
- `llm_latency_seconds` - LLM response time
- `llm_cost_usd_total` - Cost tracking

### Infrastructure Metrics
- CPU, Memory, Disk, Network (via node_exporter)
- PostgreSQL metrics (via postgres_exporter)
- Redis metrics (via redis_exporter)

### Business Metrics
- `active_users_total`
- `documents_processed_total`
- `rag_queries_total`

## Alert Rules
```yaml
# Critical Alerts
- API error rate > 5% for 5 minutes
- P99 latency > 2s for 5 minutes
- LLM cost > $100/hour
- Database connection pool exhausted
- Pod OOMKilled

# Warning Alerts
- API error rate > 1% for 10 minutes
- P95 latency > 1s for 10 minutes
- Disk usage > 80%
- Cache hit rate < 50%
```

## Grafana Dashboard Guidelines
1. Business metrics on top (DAU, revenue, conversions)
2. API performance (latency, error rate, throughput)
3. LLM metrics (cost, tokens, latency per model)
4. Infrastructure (CPU, memory, pods)

## Git Workflow
```bash
cd .worktrees/feature-monitoring
git checkout -b feat/monitoring-<feature>
git commit -m "feat(monitoring): <description>"
gh pr create --title "feat(monitoring): <description>"
```

## When You Complete a Task
```
Monitoring Agent: DONE
- Dashboards created: <list>
- Alerts configured: <list>
- PR: <URL>
```
