# 🚀 LGTM Stack - Local Setup Guide (Step by Step)

**Status:** In Progress
**Start Date:** 2026-06-23
**Goal:** Learn observability by setting up Grafana, Prometheus, Loki, and Tempo locally

---

## 📋 Progress Checklist

| Step | Task | Status |
|------|------|--------|
| 1 | Create Project Folder | ⬜ Not Started |
| 2 | Create docker-compose.yml | ⬜ Not Started |
| 3 | Create Prometheus Config | ⬜ Not Started |
| 4 | Create Grafana Datasources | ⬜ Not Started |
| 5 | Start the Stack | ⬜ Not Started |
| 6 | Access Dashboards | ⬜ Not Started |
| 7 | Test Query in Prometheus | ⬜ Not Started |
| 8 | Import Dashboard in Grafana | ⬜ Not Started |
| 9 | Add Loki (Logs) | ⬜ Not Started |
| 10 | Add Tempo (Traces) | ⬜ Not Started |
| 11 | Send Sample Data | ⬜ Not Started |

---

## 📁 File Locations

```
~/observability/
├── docker-compose.yml          (Step 2)
├── prometheus/
│   └── prometheus.yml          (Step 3)
├── grafana/
│   └── provisioning/
│       └── datasources/
│           └── lgtm.yaml       (Step 4)
├── loki/                       (Step 9 - future)
├── tempo/                      (Step 10 - future)
└── data/                       (Step 11 - future)
```

---

## STEP 1: Create Project Folder

### Command:
```bash
mkdir -p ~/observability
cd ~/observability
mkdir -p loki prometheus grafana tempo data
```

### Verification:
```bash
ls -la ~/observability
```

### Expected Output:
```
drwxr-xr-x 2 user user 4096 Jun 23 10:00 .
drwxr-xr-x 8 user user 4096 Jun 23 10:00 ..
drwxrwxr-xr-x 3 user user 4096 Jun 23 10:00 grafana
drwxr-xr-x 4 user user user 4096 Jun 23 10:00 loki
drwxr-xr-x 2 user user 4096 Jun 23 10:00 prometheus
drwxr-xr-x 2 user user 4096 Jun 23 10:00 tempo
```

### ✅ Done? Check the folder exists and has subfolders.

---

## STEP 2: Create docker-compose.yml

### Command:
```bash
nano ~/observability/docker-compose.yml
```

### Content to Paste:
```yaml
version: "3.8"

services:
  # ============================================
  # GRAFANA - The Dashboard
  # ============================================
  grafana:
    image: grafana/grafana:11.0.0
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin123
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/var/lib/grafana/dashboards
      - grafana_data:/var/lib/grafana
    networks:
      - observability

  # ============================================
  # PROMETHEUS - Metrics Collection
  # ============================================
  prometheus:
    image: prom/prometheus:v2.51.0
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.enable-lifecycle'
    networks:
      - observability

  # ============================================
  # NODE EXPORTER - System Metrics (Host)
  # ============================================
  node-exporter:
    image: prom/node-exporter:v1.7.0
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "9100:9100"
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

networks:
  observability:
    driver: bridge

volumes:
  grafana_data:
  prometheus_data:
```

### How to Save in nano:
1. Copy the content above
2. Press `Ctrl + V` to paste (or right-click)
3. Press `Ctrl + O` to save
4. Press `Enter` to confirm filename
5. Press `Ctrl + X` to exit

### Verification:
```bash
cat ~/observability/docker-compose.yml | head -20
```

### ✅ Done? Check that the file contains "version:"

---

## STEP 3: Create Prometheus Config

### Command:
```bash
nano ~/observability/prometheus/prometheus.yml
```

### Content to Paste:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  # Scrapes Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Scrapes Node Exporter (your computer's metrics)
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

### Save and Exit: `Ctrl + O`, `Enter`, `Ctrl + X`

### Verification:
```bash
cat ~/observability/prometheus/prometheus.yml
```

### ✅ Done? Check for "scrape_configs:" in the output

---

## STEP 4: Create Grafana Datasources

### Commands:
```bash
mkdir -p ~/observability/grafana/provisioning/datasources
nano ~/observability/grafana/provisioning/datasources/lgtm.yaml
```

### Content to Paste:
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    uid: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
```

### Save and Exit: `Ctrl + O`, `Enter`, `Ctrl + X`

### Verification:
```bash
cat ~/observability/grafana/provisioning/datasources/lgtm.yaml
```

### ✅ Done? Check for "datasources:" in the output

---

## STEP 5: Start the Stack

### Command:
```bash
cd ~/observability
docker compose up -d
```

### Expected Output:
```
[+] Running 4/4
 ✔ Network observability_default  Created
 ✔ Container grafana              Started
 ✔ Container prometheus           Started
 ✔ Container node-exporter        Started
```

### Check Status:
```bash
docker compose ps
```

### Expected Output:
```
NAME                STATUS          PORTS
grafana             running         0.0.0.0:3000->3000/tcp
prometheus          running         0.0.0.0:9090->9090/tcp
node-exporter       running         0.0.0.0:9100->9100/tcp
```

### ✅ Done? All containers should show "running"

---

## STEP 6: Access the Dashboards

### Open your browser:

| Service | URL | Expected |
|---------|-----|----------|
| **Prometheus** | http://localhost:9090 | Prometheus interface with query bar |
| **Grafana** | http://localhost:3000 | Login screen |
| **Node Exporter** | http://localhost:9100 | Metrics text page |

### Grafana Login:
- Username: `admin`
- Password: `admin123`

### ✅ Done? Can you access all three URLs?

---

## STEP 7: Test Query in Prometheus

### Steps:
1. Open **Prometheus** (http://localhost:9090)
2. Click **"Explore"** button (top left, looks like a compass)
3. In the query box, type: `up`
4. Click **"Execute"** button
5. Look at the Table or Graph tabs below

### Expected Results:
```
up{job="prometheus"} = 1
up{job="node-exporter"} = 1
```

### More Queries to Try:
```promql
# CPU usage
rate(node_cpu_seconds_total{mode!="idle"}[5m]) * 100

# Memory usage
node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100

# Disk usage
100 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"} * 100)
```

### ✅ Done? Do you see metrics appearing?

---

## STEP 8: Import Dashboard in Grafana

### Steps:
1. Open **Grafana** (http://localhost:3000)
2. Login with `admin` / `admin123`
3. Click **"Dashboards"** (left sidebar, square icon)
4. Click **"Import"**
5. Enter Dashboard ID: `1860`
6. Click **"Load"**
7. Select **"Prometheus"** as data source
8. Click **"Import"**

### Alternative - Node Exporter Dashboard ID:
Try these IDs:
- `1860` - Node Exporter Full
- `11074` - Node Exporter Metrics
- `14055` - Prometheus Stats

### ✅ Done? Do you see charts for CPU, Memory, Disk?

---

## STEP 9: Add Loki (Logs) - FUTURE STEP

### Add to docker-compose.yml:
```yaml
  # ============================================
  # LOKI - Log Aggregation
  # ============================================
  loki:
    image: grafana/loki:3.0.0
    container_name: loki
    restart: unless-stopped
    ports:
      - "3100:3100"
    volumes:
      - ./loki/loki.yaml:/etc/loki/local-config.yaml
      - loki_data:/loki
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - observability

volumes:
  loki_data:
```

### Create Loki Config:
```bash
nano ~/observability/loki/loki.yaml
```

```yaml
server:
  http_listen_port: 3100

common:
  path_prefix: /loki
  storage:
    filesystem:
      chunks_directory: /loki/chunks
      rules_directory: /loki/rules
  replication_factor: 1

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
    shared_store: filesystem

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
```

### Update Grafana Datasources:
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    uid: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false

  - name: Loki
    type: loki
    uid: loki
    access: proxy
    url: http://loki:3100
    editable: false
```

### Restart:
```bash
cd ~/observability
docker compose down
docker compose up -d
```

### Test Loki in Grafana:
1. Go to Explore
2. Select "Loki" from dropdown
3. Query: `{container_name=~".+"}`

### ✅ Done? Do you see container logs?

---

## STEP 10: Add Tempo (Traces) - FUTURE STEP

### Add to docker-compose.yml:
```yaml
  # ============================================
  # TEMPO - Distributed Tracing
  # ============================================
  tempo:
    image: grafana/tempo:2.4.0
    container_name: tempo
    restart: unless-stopped
    ports:
      - "3200:3200"     # Tempo API
      - "4317:4317"     # OTLP gRPC
      - "4318:4318"     # OTLP HTTP
    volumes:
      - ./tempo/tempo.yaml:/etc/tempo.yaml
      - tempo_data:/var/tempo
    command: -config.file=/etc/tempo.yaml
    networks:
      - observability

volumes:
  tempo_data:
```

### Create Tempo Config:
```bash
nano ~/observability/tempo/tempo.yaml
```

```yaml
server:
  http_listen_port: 3200
  grpc_listen_port: 9096

distributor:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318

storage:
  trace:
    backend: local
    local:
      path: /var/tempo/traces
```

### Update Grafana Datasources:
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    uid: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true

  - name: Loki
    type: loki
    uid: loki
    access: proxy
    url: http://loki:3100

  - name: Tempo
    type: tempo
    uid: tempo
    access: proxy
    url: http://tempo:3200
    editable: false
```

### Restart:
```bash
cd ~/observability
docker compose down
docker compose up -d
```

### Test Tempo:
1. Go to Explore
2. Select "Tempo"
3. Click "Search"
4. You should see "No traces found" (expected without app sending traces)

### ✅ Done? Is Tempo showing "No traces found"?

---

## STEP 11: Send Sample Data - FUTURE STEP

### Send Logs to Loki:
```bash
curl -X POST 'http://localhost:3100/loki/api/v1/push' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "streams": [
      {
        "stream": {"job": "test-app", "level": "info"},
        "values": [
          ["'$(date +%s)'000000000", "Application started"],
          ["'$(date +%s)'000000000", "User logged in from 192.168.1.1"]
        ]
      },
      {
        "stream": {"job": "test-app", "level": "error"},
        "values": [
          ["'$(date +%s)'000000000", "Connection failed to database"]
        ]
      }
    ]
  }'
```

### Verify in Grafana:
1. Go to Explore
2. Select Loki
3. Query: `{job="test-app"}`

### Send Trace to Tempo:
```bash
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

### Verify in Grafana:
1. Go to Explore
2. Select Tempo
3. Search for "test-service"

### ✅ Done? Do you see logs and traces appearing?

---

## Troubleshooting

### Containers Won't Start:
```bash
docker compose logs
docker compose down
docker compose up -d
```

### Can't Access localhost:3000, 9090, etc:
```bash
# Check if ports are in use
docker compose ps

# Check if containers are actually running
docker ps
```

### Grafana Not Loading:
```bash
docker compose restart grafana
docker compose logs grafana
```

### Prometheus Not Scraping:
```bash
# Check targets
curl localhost:9090/api/v1/targets
```

### Loki Not Receiving Logs:
```bash
docker compose logs loki
curl localhost:3100/ready
```

### Reset Everything:
```bash
cd ~/observability
docker compose down -v
docker compose up -d
```

---

## Useful Commands Reference

```bash
# Navigate to observability folder
cd ~/observability

# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f

# View logs for specific service
docker compose logs -f prometheus
docker compose logs -f grafana
docker compose logs -f loki

# Restart a specific service
docker compose restart grafana

# Check status
docker compose ps

# Open shell in container
docker exec -it prometheus sh
docker exec -it grafana sh

# View resource usage
docker stats

# Rebuild after config changes
docker compose down
docker compose up -d

# Delete everything including data
docker compose down -v
```

---

## Learning Resources

| Topic | URL |
|-------|-----|
| Prometheus Queries | https://prometheus.io/docs/prometheus/latest/querying/basics/ |
| Grafana Dashboard IDs | https://grafana.com/grafana/dashboards |
| Loki LogQL | https://grafana.com/docs/loki/latest/query/ |
| Tempo Traces | https://grafana.com/docs/tempo/latest/ |

---

## What Each Component Does

```
┌─────────────────────────────────────────────────────────────────────┐
│                        THE THREE PILLARS                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   📊 METRICS (Prometheus + Node Exporter)                          │
│   └── "What are the numbers?"                                       │
│       - CPU usage: 45%                                              │
│       - Memory: 2.1 GB used                                        │
│       - Requests/sec: 150                                           │
│       - Error rate: 0.5%                                           │
│                                                                     │
│   📝 LOGS (Loki)                                                   │
│   └── "What happened?"                                              │
│       - [10:30:15] User logged in from 192.168.1.1                 │
│       - [10:30:22] POST /api/users 200 OK                           │
│       - [10:30:45] ERROR: Connection refused to database           │
│                                                                     │
│   🔍 TRACES (Tempo)                                                │
│   └── "Where did the request go?"                                   │
│       - API received request                                        │
│       - → Auth service (50ms)                                       │
│       - → Database query (120ms)                                   │
│       - → Cache lookup (5ms)                                       │
│       - → Response sent (175ms total)                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Next Steps After This Guide

1. ✅ Set up LGTM locally (this guide)
2. ⬜ Instrument your Laravel app to send metrics
3. ⬜ Add logging to your Laravel app
4. ⬜ Add tracing to your Laravel app
5. ⬜ Set up alerts in Grafana
6. ⬜ Move to VPS with k3s

---

*Last Updated: 2026-06-23*
*File Location: ~/observability/observability-local-guide.md*
