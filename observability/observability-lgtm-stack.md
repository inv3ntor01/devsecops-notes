# 🚀 Observability Lab: LGTM Stack on VPS

**Purpose:** Set up Grafana, Loki, Tempo, and Mimir (Prometheus) on your VPS for learning DevOps/SRE observability skills.

**Cost:** Free (all open-source tools)
**Time:** ~2-3 hours
**Prerequisites:** Ubuntu 22.04 VPS with Docker installed

---

## What is LGTM Stack?

```
┌─────────────────────────────────────────────────────────────────────┐
│                     THE FOUR SIGNALS OF OBSERVABILITY              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   📊 METRICS          📝 LOGS           🔍 TRACES       📈 HEALTH  │
│   (Mimir/Prometheus)  (Loki)           (Tempo)                    │
│                                                                     │
│   "How is it doing?"   "What happened?"  "Where did it go?"         │
│   CPU, RAM, requests   Events, errors    Request flow              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         THE LGTM STACK                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐          │
│   │   MIMIR     │     │    LOKI     │     │   TEMPO     │          │
│   │  (Metrics)  │     │   (Logs)    │     │  (Traces)   │          │
│   │ Prometheus- │     │  LogQL     │     │   OTLP      │          │
│   │ compatible  │     │  queries    │     │  protocol   │          │
│   └──────┬──────┘     └──────┬──────┘     └──────┬──────┘          │
│          │                    │                    │                 │
│          └────────────────────┼────────────────────┘                 │
│                               ▼                                      │
│                    ┌─────────────────────┐                          │
│                    │     GRAFANA         │                          │
│                    │  Dashboards & More │                          │
│                    │  Explore (Traces)  │                          │
│                    │  Alerting          │                          │
│                    └─────────────────────┘                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         YOUR VPS                                    │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  Docker Compose Stack                                         │ │
│  │                                                                │ │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐              │ │
│  │  │  Grafana   │  │   Mimir    │  │   Loki     │              │ │
│  │  │   :3000    │◄─┤  :9000     │  │   :3100    │              │ │
│  │  │            │  │ (PromQL)   │  │  (LogQL)   │              │ │
│  │  └────────────┘  └────────────┘  └────────────┘              │ │
│  │       ▲                                              ┌────────────┐│
│  │       │                                              │   Tempo    ││
│  │       │                                              │   :3200    ││
│  │       └──────────────────────────────────────────────┤ (OTLP)    ││
│  │                                                          └────────────┘│
│  │                                                                │     │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐              │     │
│  │  │ Prometheus │  │  Node      │  │  App       │              │     │
│  │  │  Scraper   │  │  Exporter  │  │  SDK       │              │     │
│  │  │            │  │  :9100     │  │  (OTLP)    │              │     │
│  │  └────────────┘  └────────────┘  └────────────┘              │     │
│  │                                                                │     │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  Firewall: Only expose Grafana (3000) to your IP!                 │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Part 1: Prerequisites

### 1.1 Docker & Docker Compose on VPS

```bash
# SSH into your VPS
ssh user@your-vps-ip

# Install Docker if not already installed
curl -fsSL https://get.docker.com | sh

# Install Docker Compose v2
sudo apt update && sudo apt install -y docker-compose-v2

# Verify installation
docker --version
docker compose version
```

### 1.2 Firewall Setup

```bash
# Block all ingress except SSH and your IP for Grafana
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow from YOUR_LOCAL_IP to any port 3000  # Grafana
sudo ufw enable

# Verify
sudo ufw status verbose
```

**Get your local IP:**
```bash
# On your LOCAL machine (not VPS)
curl -s ifconfig.me
```

---

## Part 2: Create Directory Structure

```bash
# On VPS
mkdir -p ~/observability/{loki,tempo,mimir,prometheus,grafana,data}
cd ~/observability

# Create directories for each component's data
mkdir -p data/loki data/tempo data/mimir data/prometheus
```

---

## Part 3: Docker Compose Configuration

### 3.1 Main docker-compose.yml

```yaml
# ~/observability/docker-compose.yml
version: "3.8"

networks:
  observability:
    driver: bridge

volumes:
  mimir_data:
  loki_data:
  tempo_data:
  prometheus_data:
  grafana_data:

services:
  # ============================================
  # GRAFANA - The UI for everything
  # ============================================
  grafana:
    image: grafana/grafana:11.0.0
    container_name: grafana
    restart: unless-stopped
    ports:
      - "127.0.0.1:3000:3000"  # Bind to localhost only!
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=CHANGE_ME_LATER
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/var/lib/grafana/dashboards
      - grafana_data:/var/lib/grafana
    networks:
      - observability
    depends_on:
      - mimir
      - loki
      - tempo

  # ============================================
  # MIMIR - Metrics storage (Prometheus-compatible)
  # ============================================
  mimir:
    image: grafana/mimir:2.11.0
    container_name: mimir
    restart: unless-stopped
    command: >
      -config.file=/etc/mimir.yaml
      -target=all
    ports:
      - "127.0.0.1:9000:9000"  # Mimir API
      - "127.0.0.1:9095:9095"  # Grafana Agent/Ruler
    volumes:
      - ./mimir/mimir.yaml:/etc/mimir.yaml
      - mimir_data:/data
    networks:
      - observability

  # ============================================
  # LOKI - Log aggregation
  # ============================================
  loki:
    image: grafana/loki:3.0.0
    container_name: loki
    restart: unless-stopped
    ports:
      - "127.0.0.1:3100:3100"  # Loki API
    volumes:
      - ./loki/loki.yaml:/etc/loki/local-config.yaml
      - loki_data:/data
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - observability

  # ============================================
  # TEMPO - Distributed tracing
  # ============================================
  tempo:
    image: grafana/tempo:2.4.0
    container_name: tempo
    restart: unless-stopped
    ports:
      - "127.0.0.1:3200:3200"     # Tempo API
      - "127.0.0.1:4317:4317"     # OTLP gRPC
      - "127.0.0.1:4318:4318"     # OTLP HTTP
      - "127.0.0.1:9411:9411"     # Zipkin compatible
    volumes:
      - ./tempo/tempo.yaml:/etc/tempo.yaml
      - tempo_data:/data
    command: -config.file=/etc/tempo.yaml
    networks:
      - observability

  # ============================================
  # PROMETHEUS - Metrics scraper
  # ============================================
  prometheus:
    image: prom/prometheus:v2.51.0
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "127.0.0.1:9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/rules:/etc/prometheus/rules
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    networks:
      - observability

  # ============================================
  # NODE EXPORTER - System metrics
  # ============================================
  node-exporter:
    image: prom/node-exporter:v1.7.0
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "127.0.0.1:9100:9100"
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - observability

  # ============================================
  # VICTORIA METRICS (Alternative to Prometheus)
  # ============================================
  # Uncomment if you want to compare:
  # victoriametrics:
  #   image: victoriametrics/victorialogs-datasource:latest
  #   container_name: victoriametrics
  #   restart: unless-stopped
  #   ports:
  #     - "127.0.0.1:8428:8428"
  #   command:
  #     - '--storageDataPath=/storage'
  #   volumes:
  #     - victoria_data:/storage'
```

---

## Part 4: Configuration Files

### 4.1 Mimir Configuration (`mimir/mimir.yaml`)

```yaml
# ~/observability/mimir/mimir.yaml

# Minimal Mimir config for single instance
server:
  http_listen_port: 9000
  grpc_listen_port: 9095

distributor:
  receiver_address: ''

ingester:
  address: ''
  ring:
    instance_addr: 127.0.0.1
    replication_factor: 1
    etcd:
      enabled: false

storage:
  engine: blocks

blocks_storage:
  backend: filesystem
  filesystem:
    directory: /data/tsdb
  bucket_store:
    sync_dir: /data/tsdb-sync
  tsdb:
    dir: /data/tsdb

# Backwards compatibility with Prometheus
common:
  storage:
    filesystem:
      chunks_directory: /data/chunks
      metadata_directory: /data/metadata
      index_directory: /data/index

# Enable the ruler for recording rules & alerts
ruler:
  storage:
    method: local
    local:
      directory: /data/ruler
  rule_path: /data/ruler
  evaluation:
    interval: 15s
```

### 4.2 Loki Configuration (`loki/loki.yaml`)

```yaml
# ~/observability/loki/loki.yaml

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  instance_addr: 127.0.0.1
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
      rules_directory: /tmp/loki/rules
  replication_factor: 1
  compactor_address: http://127.0.0.1:3100

schema_config:
  configs:
    - from: 2024-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /tmp/loki/index
    cache_location: /tmp/loki/index_cache
    resync_interval: 5s
    shared_store: filesystem
  filesystem:
    directory: /tmp/loki/chunks

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  ingestion_rate_mb: 50
  max_streams_per_user: 10000

query_range:
  align_queries_with_step: true

# Enable log caching
cache_results: true

# Compaction settings
compactor:
  working_directory: /tmp/loki/compactor
  shared_store: filesystem
```

### 4.3 Tempo Configuration (`tempo/tempo.yaml`)

```yaml
# ~/observability/tempo/tempo.yaml

server:
  http_listen_port: 3200
  grpc_listen_port: 9096

distributor:
  receivers:
    # Accept OTLP (OpenTelemetry Protocol)
    otlp:
      protocols:
        http:
          endpoint: 0.0.0.0:4318
        grpc:
          endpoint: 0.0.0.0:4317
    # Accept Zipkin (legacy)
    zipkin:
      endpoint: 0.0.0.0:9411
    # Accept Jaeger (legacy)
    jaeger:
      protocols:
        thrift_http:
          endpoint: 0.0.0.0:14268
        grpc:
          endpoint: 0.0.0.0:14250

storage:
  trace:
    backend: local
    local:
      path: /var/tempo/traces
    pool:
      max_workers: 100
      queue_depth: 10000

overrides:
  defaults:
    max_bytes_per_trace: 5000000
```

### 4.4 Prometheus Configuration (`prometheus/prometheus.yml`)

```yaml
# ~/observability/prometheus/prometheus.yml

global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers: []

rule_files: []

scrape_configs:
  # Scrapes Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Scrapes Node Exporter (system metrics)
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
    relabel_configs:
      - source_labels: [__address__]
        target_label: instance
        regex: '(.+):\d+'
        replacement: '${1}'

  # Scrapes Mimir for its own metrics
  - job_name: 'mimir'
    static_configs:
      - targets: ['mimir:9000']

  # Scrapes Loki
  - job_name: 'loki'
    static_configs:
      - targets: ['loki:3100']

  # Scrapes Tempo
  - job_name: 'tempo'
    static_configs:
      - targets: ['tempo:3200']

  # Example: Scrape your own application
  # - job_name: 'my-laravel-app'
  #   static_configs:
  #     - targets: ['your-app:8080']
  #   metrics_path: '/metrics'
```

---

## Part 5: Grafana Provisioning

### 5.1 Datasources Provisioning

```bash
mkdir -p ~/observability/grafana/provisioning/datasources
mkdir -p ~/observability/grafana/provisioning/dashboards
mkdir -p ~/observability/grafana/dashboards
```

```yaml
# ~/observability/grafana/provisioning/datasources/lgtm.yaml

apiVersion: 1

datasources:
  - name: Mimir
    type: prometheus
    uid: mimir
    access: proxy
    url: http://mimir:9000/prometheus
    isDefault: true
    editable: false
    jsonData:
      httpMethod: POST
      timeInterval: 15s

  - name: Loki
    type: loki
    uid: loki
    access: proxy
    url: http://loki:3100
    editable: false
    jsonData:
      maxLines: 1000
      derivedFields:
        - matcherRegex: ".*"
          name: TraceID
          url: "$${__value.raw}"
          datasourceUid: tempo

  - name: Tempo
    type: tempo
    uid: tempo
    access: proxy
    url: http://tempo:3200
    editable: false
    jsonData:
      httpMethod: GET
      tracesToLogs:
        datasourceUid: 'loki'
        mappedTags: [{ key: 'cluster' }]
        mapTagValuesEnabled: false
        spanStartTimeShift: '1h'
        spanEndTimeShift: '1h'
        filterByTraceID: true
        filterBySpanID: false
      serviceMap:
        datasourceUid: 'mimir'
      nodeGraph:
        enabled: true
      search:
        hide: false
      serviceMapPreloaded:
        datasourceUid: 'mimir'
```

### 5.2 Dashboard Provisioning

```yaml
# ~/observability/grafana/provisioning/dashboards/lgtm.yaml

apiVersion: 1

providers:
  - name: 'LGTM Dashboards'
    orgId: 1
    folder: ''
    folderUid: ''
    type: file
    disableDeletion: false
    editable: true
    options:
      path: /var/lib/grafana/dashboards
```

### 5.3 Sample Dashboard JSON

```json
{
  "annotations": {
    "list": []
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": null,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "mimir"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "tooltip": false,
              "viz": false,
              "legend": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 1,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "mimir"
          },
          "expr": "rate(node_cpu_seconds_total{mode!=\"idle\"}[5m]) * 100",
          "legendFormat": "CPU Usage",
          "refId": "A"
        }
      ],
      "title": "CPU Usage",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "mimir"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": {
              "tooltip": false,
              "viz": false,
              "legend": false
            },
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "id": 2,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "mode": "single",
          "sort": "none"
        }
      },
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "mimir"
          },
          "expr": "node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100",
          "legendFormat": "Memory Available",
          "refId": "A"
        }
      ],
      "title": "Memory Usage",
      "type": "timeseries"
    }
  ],
  "refresh": "10s",
  "schemaVersion": 38,
  "style": "dark",
  "tags": ["lgtm", "observability"],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "LGTM Stack Overview",
  "uid": "lgtm-overview",
  "version": 1,
  "weekStart": ""
}
```

Save this as: `~/observability/grafana/dashboards/lgtm-overview.json`

---

## Part 6: Start the Stack

```bash
# On VPS
cd ~/observability

# Pull images and start
docker compose up -d

# Watch logs
docker compose logs -f

# Check status
docker compose ps
```

Expected output:
```
NAME                STATUS          PORTS
grafana             running         127.0.0.1:3000->3000/tcp
mimir               running         127.0.0.1:9000->9000/tcp, ...
loki                running         127.0.0.1:3100->3100/tcp
tempo               running         127.0.0.1:3200->3200/tcp, ...
prometheus          running         127.0.0.1:9090->9090/tcp
node-exporter       running         127.0.0.1:9100->9100/tcp
```

---

## Part 7: Access Grafana

### 7.1 Create SSH Tunnel (Recommended)

```bash
# On your LOCAL machine
ssh -L 3000:localhost:3000 user@your-vps-ip
```

Then open browser: `http://localhost:3000`

### 7.2 Login

```
Username: admin
Password: CHANGE_ME_LATER
```

**⚠️ Change password immediately on first login!**

---

## Part 8: Verify Each Component

### 8.1 Check Prometheus (Metrics)

1. In Grafana → **Connections** → **Data Sources** → **Mimir**
2. Click **Save & test**
3. Go to **Explore** → Select **Mimir**
4. Run query: `up`
5. Should return: `up{job="prometheus"} = 1`

### 8.2 Check Loki (Logs)

1. Go to **Explore** → Select **Loki**
2. Run query: `{container_name=~".+"}`
3. Should see container logs streaming

### 8.3 Check Tempo (Traces)

1. Go to **Explore** → Select **Tempo**
2. Click **Search**
3. Should show "No traces found" (expected if no app sending traces)

### 8.4 Check Node Exporter Metrics

```bash
# On VPS, verify node-exporter is working
curl localhost:9100/metrics | head -20
```

Look for:
```
# HELP node_cpu_seconds_total
# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 1234.56
```

---

## Part 9: Send Sample Data

### 9.1 Generate Fake Metrics

```bash
# On VPS - install promtool
docker exec prometheus promtool --version

# Push custom metrics using curl
docker exec prometheus promtool query instant \
  --server=http://localhost:9090 \
  'up'
```

### 9.2 Send Sample Logs to Loki

```bash
# Using curl to send logs to Loki
curl -X POST 'http://localhost:3100/loki/api/v1/push' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "streams": [
      {
        "stream": {
          "job": "test-app",
          "level": "info"
        },
        "values": [
          ["'$(date +%s)'000000000", "Application started successfully"],
          ["'$(date +%s)'000000000", "User logged in from 192.168.1.1"]
        ]
      }
    ]
  }'
```

Then in Grafana → Loki → Query: `{job="test-app"}`

### 9.3 Send Sample Trace to Tempo

```bash
# Using curl to send trace via OTLP HTTP
curl -X POST http://localhost:4318/v1/traces \
  -H 'Content-Type: application/json' \
  -d '{
    "resourceSpans": [{
      "resource": {
        "attributes": [
          {"key": "service.name", "value": {"stringValue": "test-service"}},
          {"key": "service.version", "value": {"stringValue": "1.0.0"}}
        ]
      },
      "scopeSpans": [{
        "scope": {"name": "test"},
        "spans": [{
          "traceId": "00000000000000000000000000000001",
          "spanId": "0000000000000001",
          "name": "test-span",
          "kind": "SPAN_KIND_CLIENT",
          "status": {}
        }]
      }]
    }]
  }'
```

In Grafana → Tempo → Search for service.name=test-service

---

## Part 10: Instrument a Sample App

### 10.1 Create a Simple Node.js App with OTEL

```bash
# ~/observability/sample-app/app.js
const http = require('http');
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-http');
const { Resource } = require('@opentelemetry/resources');
const { SemanticResourceAttributes } = require('@opentelemetry/semantic-conventions');
const { SimpleSpanProcessor } = require('@opentelemetry/sdk-trace-node');

// Configure OTLP exporter (sends to Tempo)
const traceExporter = new OTLPTraceExporter({
  url: 'http://localhost:4318/v1/traces',
});

// Create SDK
const sdk = new NodeSDK({
  resource: new Resource({
    [SemanticResourceAttributes.SERVICE_NAME]: 'sample-app',
    [SemanticResourceAttributes.SERVICE_VERSION]: '1.0.0',
  }),
  spanProcessor: new SimpleSpanProcessor(traceExporter),
});

// Start SDK
sdk.start();

// Your app
const server = http.createServer((req, res) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  res.end('Hello from observability sample app!\n');
});

server.listen(8080, () => {
  console.log('Server running on port 8080');
  console.log('Sending traces to Tempo at localhost:4318');
});

// Graceful shutdown
process.on('SIGTERM', () => {
  sdk.shutdown()
    .then(() => console.log('Tracing terminated'))
    .finally(() => process.exit(0));
});
```

### 10.2 Dockerfile for Sample App

```dockerfile
# ~/observability/sample-app/Dockerfile
FROM node:20-alpine

WORKDIR /app

# Install OTEL dependencies
RUN npm install @opentelemetry/sdk-node \
                 @opentelemetry/exporter-trace-otlp-http \
                 @opentelemetry/resources \
                 @opentelemetry/semantic-conventions \
                 @opentelemetry/sdk-trace-node

COPY app.js .

EXPOSE 8080

CMD ["node", "app.js"]
```

### 10.3 Run the Sample App

```bash
# Build and run
cd ~/observability/sample-app
docker build -t sample-app .
docker run -d --name sample-app --network observability_observability sample-app

# Generate traffic
curl localhost:8080
curl localhost:8080/test
curl localhost:8080/api/users
```

Now in Grafana → Tempo, you should see traces!

---

## Part 11: Import Pre-Built Dashboards

### 11.1 Node Exporter Dashboard (ID: 1860)

1. Grafana → **Dashboards** → **Import**
2. Enter Dashboard ID: `1860`
3. Select **Prometheus** data source
4. Click **Import**

### 11.2 Loki Dashboard (ID: 14041)

1. Grafana → **Dashboards** → **Import**
2. Enter Dashboard ID: `14041`
3. Select **Loki** data source
4. Click **Import**

### 11.3 Tempo Dashboard (ID: 15513)

1. Grafana → **Dashboards** → **Import**
2. Enter Dashboard ID: `15513`
3. Select **Tempo** data source
4. Click **Import**

---

## Part 12: Set Up Alerting

### 12.1 Configure Alerting in Grafana

```yaml
# ~/observability/grafana/provisioning/datasources/alerting.yaml
apiVersion: 1

datasources:
  - name: Mimir Alerting
    type: prometheus
    uid: mimir
    access: proxy
    url: http://mimir:9000
    isDefault: false
    editable: false
```

### 12.2 Create Alert Rules

In Grafana:
1. **Alerting** → **Alert rules** → **Create alert rule**
2. Query: `node_cpu_seconds_total{mode="idle"} < 20`
3. Condition: `last() of query(A) is below threshold 20`
4. Evaluation: every 1 minute
5. For: 5 minutes
6. Labels: `severity=critical`
7. Annotations: `summary=High CPU usage detected`

### 12.3 Recording Rules (for Mimir)

```yaml
# ~/observability/prometheus/rules/cpu-alerts.yaml
groups:
  - name: node-cpu
    interval: 30s
    rules:
      - expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
        record: instance:cpu_usage_percent:avg5m
        labels:
          service: node-exporter
        annotations:
          summary: "CPU usage is {{ $value }}% on {{ $labels.instance }}"
```

---

## Part 13: Security Hardening

### 13.1 Use Environment Variables for Secrets

```yaml
# docker-compose.yml - Update grafana section
  grafana:
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    secrets:
      - grafana_password

secrets:
  grafana_password:
    file: ./secrets/grafana_password.txt
```

```bash
# Create secrets directory
mkdir -p ~/observability/secrets
echo "your-secure-password-here" > ~/observability/secrets/grafana_password.txt
chmod 600 ~/observability/secrets/grafana_password.txt
```

### 13.2 Enable HTTPS with Reverse Proxy

```yaml
# ~/observability/nginx/nginx.conf
server {
    listen 443 ssl;
    server_name observability.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 13.3 IP Whitelist Only

```bash
# UFW - allow only your IP for Grafana
sudo ufw delete allow 3000
sudo ufw allow from YOUR_HOME_IP to any port 3000

# If using Cloudflare, also allow Cloudflare IPs
sudo ufw allow from 103.21.244.0/22 to any port 3000
sudo ufw allow from 103.22.200.0/22 to any port 3000
# ... add all Cloudflare IP ranges
```

---

## Part 14: Backup & Maintenance

### 14.1 Backup Script

```bash
# ~/observability/backup.sh
#!/bin/bash
set -euo pipefail

BACKUP_DIR="/root/observability-backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

# Stop services
cd ~/observability
docker compose stop

# Backup data directories
tar -czf "$BACKUP_DIR/observability_data_$DATE.tar.gz" data/

# Backup configs
tar -czf "$BACKUP_DIR/observability_config_$DATE.tar.gz" \
  docker-compose.yml \
  grafana/provisioning \
  grafana/dashboards \
  prometheus/prometheus.yml \
  loki/loki.yaml \
  tempo/tempo.yaml \
  mimir/mimir.yaml

# Restart services
docker compose start

# Keep only last 7 backups
cd "$BACKUP_DIR"
ls -t | tail -n +8 | xargs -r rm

echo "Backup complete: observability_data_$DATE.tar.gz"
```

```bash
chmod +x ~/observability/backup.sh
```

### 14.2 Restore Script

```bash
# ~/observability/restore.sh
#!/bin/bash
set -euo pipefail

BACKUP_FILE=$1

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file.tar.gz>"
    exit 1
fi

cd ~/observability
docker compose down

# Restore configs
tar -xzf "$BACKUP_FILE" --strip-components=1 -C .

# Start services
docker compose up -d

echo "Restore complete from $BACKUP_FILE"
```

### 14.3 Schedule Backups

```bash
# Add to crontab
crontab -e

# Add line:
0 2 * * * /root/observability/backup.sh >> /var/log/observability_backup.log 2>&1
```

---

## Part 15: Monitoring the Monitors

### 15.1 Health Checks

```bash
# ~/observability/health-check.sh
#!/bin/bash

check_service() {
    local name=$1
    local port=$2
    local endpoint=${3:-/}

    if curl -sf "http://localhost:$port$endpoint" > /dev/null 2>&1; then
        echo "✅ $name is healthy"
        return 0
    else
        echo "❌ $name is DOWN"
        return 1
    fi
}

echo "=== LGTM Stack Health Check ==="
echo ""

failed=0

check_service "Grafana" "3000" || ((failed++))
check_service "Mimir" "9000" || ((failed++))
check_service "Loki" "3100" || ((failed++))
check_service "Tempo" "3200" || ((failed++))
check_service "Prometheus" "9090" || ((failed++))
check_service "Node Exporter" "9100" || ((failed++))

echo ""
if [ $failed -eq 0 ]; then
    echo "🎉 All services healthy!"
    exit 0
else
    echo "⚠️  $failed service(s) down"
    exit 1
fi
```

### 15.2 Auto-Restart on Failure

```yaml
# Add to docker-compose.yml services section
services:
  grafana:
    restart: unless-stopped  # Already configured
```

---

## Part 16: Cleanup & Teardown

```bash
# Stop all services
cd ~/observability
docker compose down

# Remove volumes (CAREFUL - deletes all data!)
docker compose down -v

# Remove images
docker compose down --rmi all

# Complete teardown
docker compose down -v --rmi all
rm -rf ~/observability
```

---

## Learning Exercises

### Exercise 1: Explore the Three Pillars
- [ ] Query metrics: `rate(http_requests_total[5m])` in Mimir
- [ ] Query logs: `{app="sample-app"} |= "error"` in Loki
- [ ] View traces: Search for `test-service` in Tempo

### Exercise 2: Create Custom Dashboard
- [ ] Add a panel showing request rate
- [ ] Add a panel showing error rate
- [ ] Add a panel showing log volume by level

### Exercise 3: Set Up Alerts
- [ ] Alert when CPU > 80%
- [ ] Alert when error rate > 1%
- [ ] Alert when Loki receives no logs

### Exercise 4: Instrument Your App
- [ ] Add OpenTelemetry to your Laravel/PHP app
- [ ] Send traces to Tempo
- [ ] Correlate traces with logs

### Exercise 5: Compare Prometheus vs Mimir
- [ ] Point Prometheus to query Mimir
- [ ] Run same queries on both
- [ ] Note performance differences

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Grafana shows "Data source not found" | Check datasource UID matches provisioning file |
| No logs appearing in Loki | Check container is on same network |
| Traces not showing | Verify OTLP endpoint is correct |
| High memory usage | Reduce retention period in Loki/Tempo config |
| Query timeout | Increase `timeout` in datasource settings |

---

## Next Steps

```
┌─────────────────────────────────────────────────────────────────┐
│                     LGTM STACK COMPLETE!                         │
│                                                                 │
│   What you learned:                                             │
│   ✅ Deploy full observability stack                            │
│   ✅ Understand metrics, logs, traces                            │
│   ✅ Connect OpenTelemetry to Tempo                             │
│   ✅ Create dashboards and alerts                               │
│   ✅ Secure sensitive endpoints                                │
│                                                                 │
│   What's next?                                                  │
│   🔜 Add Grafana AlertManager for alerting                      │
│   🔜 Set up Loki Promtail for log collection                   │
│   🔜 Add Grafana OnCall for incident management                 │
│   🔜 Integrate with your Laravel app                            │
│   🔜 Add to LaraKube CLI as optional feature                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Resources

| Resource | URL |
|----------|-----|
| Grafana Docs | https://grafana.com/docs/ |
| Loki Docs | https://grafana.com/docs/loki/ |
| Tempo Docs | https://grafana.com/docs/tempo/ |
| Mimir Docs | https://grafana.com/docs/mimir/ |
| Prometheus Docs | https://prometheus.io/docs/ |
| OpenTelemetry | https://opentelemetry.io/ |

---

*Last updated: 2026-06-22*
