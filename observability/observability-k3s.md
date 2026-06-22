# 🚀 LGTM Stack on k3s — Full Kubernetes Deployment

**Purpose:** Deploy Grafana, Loki, Tempo, and Mimir as Kubernetes workloads.
**Use Case:** Production-like setup, learn K8s observability, add to LaraKube CLI.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         VPS with k3s                                │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │  k3s Cluster (Single Node)                                   │ │
│  │                                                               │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │ │
│  │  │  Grafana    │  │   Mimir     │  │    Loki     │         │ │
│  │  │  Service    │◄─┤  Deployment │  │  Deployment │         │ │
│  │  │  ClusterIP  │  │  1 replica  │  │  1 replica  │         │ │
│  │  └──────┬──────┘  └─────────────┘  └─────────────┘         │ │
│  │         │                                                       │ │
│  │         ▼                                                       │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │ │
│  │  │   Tempo     │  │ Prometheus  │  │   Node      │         │ │
│  │  │  Deployment │  │  Deployment │  │  Exporter   │         │ │
│  │  │  1 replica  │  │  1 replica  │  │  DaemonSet  │         │ │
│  │  └─────────────┘  └─────────────┘  └─────────────┘         │ │
│  │                                                               │ │
│  │  ┌─────────────────────────────────────────────────────┐    │ │
│  │  │  PersistentVolumeClaims (data persistence)          │    │ │
│  │  │  - mimir-data, loki-data, tempo-data, prom-data    │    │ │
│  │  └─────────────────────────────────────────────────────┘    │ │
│  │                                                               │ │
│  │  ┌─────────────────────────────────────────────────────┐    │ │
│  │  │  Ingress (Traefik) — Only Grafana exposed           │    │ │
│  │  │  grafana.your-domain.com                            │    │ │
│  │  └─────────────────────────────────────────────────────┘    │ │
│  │                                                               │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  Internal Communication: All services talk via DNS names           │
│  External Access: Only Grafana via Ingress                         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

### 1. Install k3s (already have Docker? remove it first)

```bash
# On VPS
curl -sfL https://get.k3s.io | sh -

# Wait for installation
kubectl get nodes

# You should see:
# NAME        STATUS   ROLES                  AGE   VERSION
# your-vps    master   control-plane,master   10s   v1.29.x

# Check pods
kubectl get pods -A
```

### 2. Install Helm (package manager for K8s)

```bash
# On VPS
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh

# Verify
helm version
```

### 3. Create Namespace

```bash
kubectl create namespace observability
kubectl config set-context --current --namespace=observability
```

---

## Option 1: Helm Charts (Recommended)

### Install Grafana, Loki, Tempo, Mimir using Helm

```bash
# Add Grafana Helm repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace
kubectl create namespace observability
```

### Install with Values Files

```bash
# Install Mimir (metrics storage)
helm upgrade --install mimir grafana/mimir-distributed \
  --namespace observability \
  --create-namespace \
  --values - << 'EOF'
# Simplified single-node config
server:
  replicas: 1

ingester:
  replicas: 1

store_gateway:
  replicas: 1

compactor:
  replicas: 1

overrides_exporter:
  enabled: false

minio:
  enabled: false  # Use local filesystem

ingester:
  persistence:
    enabled: true
    size: 10Gi

store_gateway:
  persistence:
    enabled: true
    size: 10Gi

blocksStorage:
  tsdb:
    walCompressionEnabled: true
EOF

# Install Loki (logs)
helm upgrade --install loki grafana/loki \
  --namespace observability \
  --create-namespace \
  --values - << 'EOF'
loki:
  auth_enabled: false

storage:
  type: filesystem

persistence:
  enabled: true
  size: 10Gi

config: |
  schema_config:
    configs:
      - from: 2024-01-01
        store: boltdb-shipper
        object_store: filesystem
        schema: v13
        index:
          prefix: index_
          period: 24h
EOF

# Install Tempo (traces)
helm upgrade --install tempo grafana/tempo \
  --namespace observability \
  --create-namespace \
  --values - << 'EOF'
tempo:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318

persistence:
  enabled: true
  size: 10Gi
  storageClass: local-path

storage:
  trace:
    backend: local
EOF

# Install Grafana
helm upgrade --install grafana grafana/grafana \
  --namespace observability \
  --create-namespace \
  --values - << 'EOF'
adminPassword: "CHANGE_ME_LATER"

ingress:
  enabled: true
  ingressClassName: traefik
  hosts:
    - grafana.your-domain.com

datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Mimir
        type: prometheus
        uid: mimir
        url: http://mimir-server.observability.svc.cluster.local:9000/prometheus
        isDefault: true
        editable: false
      - name: Loki
        type: loki
        uid: loki
        url: http://loki.observability.svc.cluster.local:3100
        editable: false
      - name: Tempo
        type: tempo
        uid: tempo
        url: http://tempo.observability.svc.cluster.local:3200
        editable: false
EOF
```

### Install Prometheus + Node Exporter

```bash
# Prometheus
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace observability \
  --create-namespace \
  --values - << 'EOF'
server:
  persistentVolume:
    enabled: true
    size: 10Gi
  replicaCount: 1

alertmanager:
  enabled: false

nodeExporter:
  enabled: true

pushgateway:
  enabled: false

serverFiles:
  prometheus.yml:
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']
      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
          - role: node
        relabel_configs:
          - source_labels: [__address__]
            regex: '(.+):10250'
            replacement: '${1}:9100'
            target_label: __address__
      - job_name: 'mimir'
        static_configs:
          - targets: ['mimir-server.observability.svc.cluster.local:9000']
      - job_name: 'loki'
        static_configs:
          - targets: ['loki.observability.svc.cluster.local:3100']
      - job_name: 'tempo'
        static_configs:
          - targets: ['tempo.observability.svc.cluster.local:3200']
EOF
```

### Verify Installation

```bash
# Check all pods
kubectl get pods -n observability

# Should see:
# NAME                        READY   STATUS    RESTARTS   AGE
# grafana-xxxxx               1/1     Running   0          2m
# loki-xxxxx                  1/1     Running   0          2m
# tempo-xxxxx                 1/1     Running   0          2m
# mimir-xxxxx                 1/1     Running   0          2m
# prometheus-xxxxx            1/1     Running   0          2m
# prometheus-node-exporter-xxx 1/1     Running   0          2m

# Check services
kubectl get svc -n observability

# Check persistent volumes
kubectl get pvc -n observability
```

---

## Option 2: Raw Kubernetes Manifests

### Directory Structure

```bash
mkdir -p ~/observability-k8s/{namespaces,configmaps,deployments,services,ingress,pvc}
cd ~/observability-k8s
```

### Namespace

```yaml
# ~/observability-k8s/00-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: observability
  labels:
    name: observability
    app.kubernetes.io/name: lgtm-stack
```

### ConfigMaps

```yaml
# ~/observability-k8s/01-mimir-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mimir-config
  namespace: observability
data:
  mimir.yaml: |
    server:
      http_listen_port: 9000
      grpc_listen_port: 9095
    common:
      storage:
        filesystem:
          chunks_directory: /data/chunks
          index_directory: /data/index
    blocks_storage:
      backend: filesystem
      filesystem:
        directory: /data/tsdb
    ruler:
      storage:
        local:
          directory: /data/ruler
```

```yaml
# ~/observability-k8s/02-loki-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: loki-config
  namespace: observability
data:
  loki.yaml: |
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
```

```yaml
# ~/observability-k8s/03-tempo-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: tempo-config
  namespace: observability
data:
  tempo.yaml: |
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

```yaml
# ~/observability-k8s/04-prometheus-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: observability
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']
      - job_name: 'mimir'
        static_configs:
          - targets: ['mimir.observability.svc.cluster.local:9000']
      - job_name: 'loki'
        static_configs:
          - targets: ['loki.observability.svc.cluster.local:3100']
      - job_name: 'tempo'
        static_configs:
          - targets: ['tempo.observability.svc.cluster.local:3200']
```

### Persistent Volume Claims

```yaml
# ~/observability-k8s/10-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mimir-data
  namespace: observability
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: loki-data
  namespace: observability
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: tempo-data
  namespace: observability
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
  namespace: observability
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

### Deployments

```yaml
# ~/observability-k8s/20-mimir.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mimir
  namespace: observability
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mimir
  template:
    metadata:
      labels:
        app: mimir
    spec:
      containers:
        - name: mimir
          image: grafana/mimir:2.11.0
          ports:
            - containerPort: 9000
              name: http
            - containerPort: 9095
              name: grpc
          volumeMounts:
            - name: config
              mountPath: /etc/mimir.yaml
              subPath: mimir.yaml
            - name: data
              mountPath: /data
          resources:
            requests:
              cpu: 100m
              memory: 512Mi
            limits:
              cpu: 1000m
              memory: 2Gi
          args:
            - -config.file=/etc/mimir.yaml
      volumes:
        - name: config
          configMap:
            name: mimir-config
        - name: data
          persistentVolumeClaim:
            claimName: mimir-data
---
apiVersion: v1
kind: Service
metadata:
  name: mimir
  namespace: observability
spec:
  ports:
    - port: 9000
      targetPort: 9000
      name: http
    - port: 9095
      targetPort: 9095
      name: grpc
  selector:
    app: mimir
```

```yaml
# ~/observability-k8s/21-loki.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: loki
  namespace: observability
spec:
  replicas: 1
  selector:
    matchLabels:
      app: loki
  template:
    metadata:
      labels:
        app: loki
    spec:
      containers:
        - name: loki
          image: grafana/loki:3.0.0
          ports:
            - containerPort: 3100
              name: http
          volumeMounts:
            - name: config
              mountPath: /etc/loki/local-config.yaml
              subPath: loki.yaml
            - name: data
              mountPath: /loki
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 1Gi
          args:
            - -config.file=/etc/loki/local-config.yaml
      volumes:
        - name: config
          configMap:
            name: loki-config
        - name: data
          persistentVolumeClaim:
            claimName: loki-data
---
apiVersion: v1
kind: Service
metadata:
  name: loki
  namespace: observability
spec:
  ports:
    - port: 3100
      targetPort: 3100
      name: http
  selector:
    app: loki
```

```yaml
# ~/observability-k8s/22-tempo.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tempo
  namespace: observability
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tempo
  template:
    metadata:
      labels:
        app: tempo
    spec:
      containers:
        - name: tempo
          image: grafana/tempo:2.4.0
          ports:
            - containerPort: 3200
              name: http
            - containerPort: 4317
              name: otlp-grpc
            - containerPort: 4318
              name: otlp-http
            - containerPort: 9411
              name: zipkin
          volumeMounts:
            - name: config
              mountPath: /etc/tempo.yaml
              subPath: tempo.yaml
            - name: data
              mountPath: /var/tempo
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 1Gi
          args:
            - -config.file=/etc/tempo.yaml
      volumes:
        - name: config
          configMap:
            name: tempo-config
        - name: data
          persistentVolumeClaim:
            claimName: tempo-data
---
apiVersion: v1
kind: Service
metadata:
  name: tempo
  namespace: observability
spec:
  ports:
    - port: 3200
      targetPort: 3200
      name: http
    - port: 4317
      targetPort: 4317
      name: otlp-grpc
    - port: 4318
      targetPort: 4318
      name: otlp-http
    - port: 9411
      targetPort: 9411
      name: zipkin
  selector:
    app: tempo
```

```yaml
# ~/observability-k8s/23-prometheus.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: observability
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
        - name: prometheus
          image: prom/prometheus:v2.51.0
          ports:
            - containerPort: 9090
              name: http
          volumeMounts:
            - name: config
              mountPath: /etc/prometheus/prometheus.yml
              subPath: prometheus.yml
            - name: data
              mountPath: /prometheus
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 1Gi
          args:
            - '--config.file=/etc/prometheus/prometheus.yml'
            - '--storage.tsdb.path=/prometheus'
            - '--web.enable-lifecycle'
      volumes:
        - name: config
          configMap:
            name: prometheus-config
        - name: data
          persistentVolumeClaim:
            claimName: prometheus-data
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: observability
spec:
  ports:
    - port: 9090
      targetPort: 9090
      name: http
  selector:
    app: prometheus
```

```yaml
# ~/observability-k8s/24-grafana.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: observability
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
        - name: grafana
          image: grafana/grafana:11.0.0
          ports:
            - containerPort: 3000
              name: http
          env:
            - name: GF_SECURITY_ADMIN_USER
              value: admin
            - name: GF_SECURITY_ADMIN_PASSWORD
              value: "CHANGE_ME_LATER"
            - name: GF_USERS_ALLOW_SIGN_UP
              value: "false"
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 1Gi
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: observability
spec:
  ports:
    - port: 3000
      targetPort: 3000
      name: http
  selector:
    app: grafana
```

### Node Exporter (DaemonSet)

```yaml
# ~/observability-k8s/25-node-exporter.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: observability
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      hostPID: true
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet
      containers:
        - name: node-exporter
          image: prom/node-exporter:v1.7.0
          args:
            - '--path.procfs=/host/proc'
            - '--path.sysfs=/host/sys'
            - '--path.rootfs=/rootfs'
            - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
          ports:
            - containerPort: 9100
              hostPort: 9100
              name: http
          resources:
            requests:
              cpu: 100m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 128Mi
          volumeMounts:
            - name: proc
              mountPath: /host/proc
              readOnly: true
            - name: sys
              mountPath: /host/sys
              readOnly: true
            - name: rootfs
              mountPath: /rootfs
              readOnly: true
      volumes:
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
        - name: rootfs
          hostPath:
            path: /
---
apiVersion: v1
kind: Service
metadata:
  name: node-exporter
  namespace: observability
  annotations:
    prometheus.io/scrape: "true"
spec:
  ports:
    - port: 9100
      hostPort: 9100
      name: http
  selector:
    app: node-exporter
```

### Ingress (Expose Grafana)

```yaml
# ~/observability-k8s/30-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  namespace: observability
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
spec:
  tls:
    - hosts:
        - grafana.your-domain.com
      secretName: grafana-tls
  rules:
    - host: grafana.your-domain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: grafana
                port:
                  number: 3000
```

### Deploy Everything

```bash
# Apply all manifests
kubectl apply -f ~/observability-k8s/

# Watch pods
kubectl get pods -n observability -w

# Check services
kubectl get svc -n observability
```

---

## Access Grafana

### Option A: Port Forward (Quick)

```bash
# From your local machine
kubectl port-forward -n observability svc/grafana 3000:3000

# Open browser: http://localhost:3000
```

### Option B: NodePort (Simple)

```bash
# Change service type
kubectl patch svc grafana -n observability -p '{"spec":{"type":"NodePort"}}'

# Get port
kubectl get svc grafana -n observability

# Access: http://your-vps-ip:30000
```

### Option C: Ingress (Production)

```bash
# Install cert-manager for TLS
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.yaml

# Wait for cert-manager to be ready
kubectl get pods -n cert-manager

# Apply ingress (update your-domain.com first)
kubectl apply -f ~/observability-k8s/30-ingress.yaml

# Access: https://grafana.your-domain.com
```

---

## Add Grafana Datasources via ConfigMap

```yaml
# ~/observability-k8s/26-grafana-datasources.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources
  namespace: observability
data:
  datasources.yaml: |
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
      - name: Loki
        type: loki
        uid: loki
        access: proxy
        url: http://loki:3100
        editable: false
      - name: Tempo
        type: tempo
        uid: tempo
        access: proxy
        url: http://tempo:3200
        editable: false
```

Mount it to Grafana pod:

```yaml
# Update grafana deployment
volumeMounts:
  - name: datasources
    mountPath: /etc/grafana/provisioning/datasources
    readOnly: false
volumes:
  - name: datasources
    configMap:
      name: grafana-datasources
```

---

## Add Grafana Dashboard

```yaml
# ~/observability-k8s/27-grafana-dashboards.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboards
  namespace: observability
  labels:
    grafana_dashboard: "1"
data:
  kubernetes-pods.json: |
    {
      "dashboard": {
        "title": "Kubernetes Pods",
        "panels": [...],
        "templating": {...}
      }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  ...
spec:
  template:
    spec:
      containers:
        - name: grafana
          ...
          volumeMounts:
            - name: dashboards
              mountPath: /var/lib/grafana/dashboards
      volumes:
        - name: dashboards
          configMap:
            name: grafana-dashboards
```

---

## Monitoring Your k3s Cluster

### Metrics Server (Already in k3s)

```bash
# k3s includes metrics-server by default
kubectl top nodes
kubectl top pods -A
```

### kube-state-metrics

```yaml
# ~/observability-k8s/28-kube-state.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-state-metrics
  namespace: observability
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kube-state-metrics
  template:
    metadata:
      labels:
        app: kube-state-metrics
    spec:
      containers:
        - name: kube-state-metrics
          image: registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.11.0
          ports:
            - containerPort: 8080
              name: http
---
apiVersion: v1
kind: Service
metadata:
  name: kube-state-metrics
  namespace: observability
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: kube-state-metrics
```

Update Prometheus config to scrape kube-state-metrics.

---

## Cleanup

```bash
# Delete all resources
kubectl delete -f ~/observability-k8s/

# Delete namespace
kubectl delete namespace observability

# Remove Helm releases
helm ls -n observability
helm uninstall grafana loki tempo mimir prometheus -n observability
```

---

## Comparison: Docker vs k3s

| Aspect | Docker Compose | k3s + Helm/kubectl |
|--------|---------------|-------------------|
| **Setup Time** | 15 minutes | 30-60 minutes |
| **Resources** | ~500MB RAM | ~1-2GB RAM |
| **Learning Curve** | Easy | Medium |
| **Portability** | Docker-dependent | Standard K8s |
| **Scalability** | Single node | Multi-node ready |
| **Auto-healing** | ❌ | ✅ (Health checks) |
| **Rolling Updates** | Manual | ✅ (Deployments) |
| **Secrets** | .env files | K8s Secrets |
| **ConfigMaps** | Volume mounts | Native |
| **Service Discovery** | Manual links | DNS-based |

---

## Which to Choose?

```
┌─────────────────────────────────────────────────────────────────┐
│                     RECOMMENDATION                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   🟢 Beginners / Learning observability basics                  │
│      → Use Docker Compose (observability-lgtm-stack.md)         │
│                                                                 │
│   🔵 LaraKube CLI integration                                   │
│      → Use k3s manifests (this file)                            │
│                                                                 │
│   🟡 Production on VPS                                          │
│      → Use k3s + Helm (Grafana Operator)                       │
│                                                                 │
│   🔴 Multi-node cluster                                         │
│      → Must use k3s (Docker can't do this)                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Add to LaraKube CLI

Want me to create the k3s manifests as Laravel Blade templates for LaraKube CLI?

```
resources/views/k8s/observability/
├── namespace.yaml.blade
├── mimir.yaml.blade
├── loki.yaml.blade
├── tempo.yaml.blade
├── prometheus.yaml.blade
├── grafana.yaml.blade
└── ingress.yaml.blade
```

---

*Last updated: 2026-06-22*
