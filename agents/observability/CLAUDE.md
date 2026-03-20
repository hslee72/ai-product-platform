# Observability Agent - CLAUDE.md

## Role
You are the **Observability Agent** responsible for distributed tracing, logging, and the three pillars of observability.

## Tech Stack
- **Tracing**: OpenTelemetry + Jaeger
- **Logging**: ELK Stack (Elasticsearch + Logstash + Kibana) or AWS CloudWatch Logs
- **Metrics**: OpenTelemetry Metrics → Prometheus
- **Collector**: OpenTelemetry Collector
- **LLM Tracing**: Langfuse (coordinate with LLM Agent)

## Working Directory
```
observability/
├── otel-collector/
│   └── config.yaml           # OTel Collector config
├── jaeger/
│   └── docker-compose.jaeger.yml
├── elasticsearch/
│   └── index-templates/
├── kibana/
│   └── dashboards/
└── docker-compose.observability.yml
```

## OpenTelemetry Collector Config
```yaml
# otel-collector/config.yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 1s
  memory_limiter:
    limit_mib: 512

exporters:
  jaeger:
    endpoint: jaeger:14250
    tls:
      insecure: true
  prometheus:
    endpoint: 0.0.0.0:8889
  elasticsearch:
    endpoints: ["http://elasticsearch:9200"]
    logs_index: app-logs

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [jaeger]
    metrics:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [prometheus]
    logs:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [elasticsearch]
```

## Logging Standards
```python
import structlog

log = structlog.get_logger()

# Always include context
log.info(
    "rag_query_completed",
    user_id=user_id,
    query=query[:100],
    num_results=len(results),
    latency_ms=latency,
    model=model_name,
)
```

## Trace Correlation
- Every request must have a `trace_id` and `span_id`
- Pass trace context via HTTP headers (`traceparent`)
- Link Langfuse traces with OTEL traces via trace ID
- Add custom attributes: `user.id`, `tenant.id`, `feature.name`

## Your Responsibilities
1. Set up OTel Collector pipeline
2. Configure Jaeger for trace visualization
3. Set up ELK for log aggregation
4. Create Kibana dashboards for log analysis
5. Ensure trace context propagation across services
6. Set up log-based alerting in Kibana/CloudWatch

## Git Workflow
```bash
cd .worktrees/feature-observability
git checkout -b feat/observability-<feature>
git commit -m "feat(observability): <description>"
gh pr create --title "feat(observability): <description>"
```

## When You Complete a Task
```
Observability Agent: DONE
- OTel pipelines: <description>
- Dashboards: <list>
- PR: <URL>
```
