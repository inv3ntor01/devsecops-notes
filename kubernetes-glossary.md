# Kubernetes Glossary: DevOps Terms Explained

**For:** inv3ntor01 learning DevOps
**Context:** k3s cluster, writeups project, kubectl/k9s
**Date:** 2026-06-23

---

## Core Concepts

### Namespace

```
What: A "folder" to group resources
Analogy: Project folders in VS Code
Real world: Separate dev, staging, production environments
Example: writeups-local, monitoring, kube-system
CLI: kubectl get namespaces
k9s: :namespace
```

### Pod

```
What: The smallest deployable unit (1+ containers)
Analogy: A running app instance
Real world: One copy of your web application
Example: web-7ff586d8cc-wwgwd
CLI: kubectl get pods
k9s: :po
```

### Container

```
What: Package with your app code + dependencies
Analogy: Docker image running
Real world: PHP container inside a pod
Note: Pods contain 1+ containers
```

### Deployment

```
What: Manages pods, keeps them running
Analogy: A supervisor that ensures X workers are always working
Real world: "Keep 3 web pods running always"
Features: Rolling updates, rollbacks, replicas
CLI: kubectl get deployments
k9s: :deploy
```

### ReplicaSet

```
What: Ensures X pods are always running (managed by Deployment)
Analogy: The foreman assigning workers
Real world: K8s internal, but you see it in events
Note: Deployment manages ReplicaSet, ReplicaSet manages Pods
```

### Service

```
What: Stable IP address for pods
Analogy: A fixed phone number that always routes to available workers
Real world: Load balancer between pods and network
Types:
  - ClusterIP: Internal only (default)
  - NodePort: Exposes via node IP:port
  - LoadBalancer: External cloud load balancer
CLI: kubectl get svc
k9s: :svc
```

### Ingress

```
What: Routes external traffic into the cluster
Analogy: The building receptionist directing visitors
Real world: Routes https://writeups.kube to web service
Controller: Traefik (in your setup)
CLI: kubectl get ingress
k9s: :ing
```

### ConfigMap

```
What: Non-secret configuration data
Analogy: .env file but shared across pods
Real world: DB_HOST, REDIS_HOST, APP_ENV
Example: laravel-config in writeups-local
CLI: kubectl get configmap
k9s: :cm
```

### Secret

```
What: Sensitive data (base64 encoded)
Analogy: Passwords and API keys
Real world: DB_PASSWORD, API_TOKENS
Example: laravel-secrets
Types: Opaque (generic), TLS (certificates)
CLI: kubectl get secret
k9s: :sec
```

### PersistentVolume (PV)

```
What: Storage that outlives pods
Analogy: A hard drive that persists data
Real world: Database files, uploaded images
Note: Pods are ephemeral, PV survives restarts
CLI: kubectl get pv
k9s: N/A (check via PVC)
```

### PersistentVolumeClaim (PVC)

```
What: Request for storage from a PV
Analogy: "I need 10GB of storage"
Real world: writeups-laravel-storage-pvc
Note: Pod mounts PVC, PVC provisions PV
CLI: kubectl get pvc
k9s: :pvc
```

---

## Kubernetes Components

### Node

```
What: A server in the cluster
Analogy: One computer in a server room
Types:
  - Master/Control Plane: Manages the cluster (your k3s has this built-in)
  - Worker: Runs your apps
Your setup: 1 node (cres-baron)
CLI: kubectl get nodes
k9s: :nodes
```

### Control Plane (Master)

```
What: Brain of Kubernetes
Analogy: Server room manager
Components:
  - kube-apiserver: The API everyone talks to
  - etcd: Database storing cluster state
  - kube-scheduler: Decides where pods run
  - kube-controller-manager: Runs controllers
  - cloud-controller-manager: Cloud integrations
Note: In k3s, runs on the same node as workers
```

### Worker Node

```
What: Server running your apps
Components:
  - kubelet: Agent on each node
  - kube-proxy: Network rules
  - container runtime: containerd (runs containers)
Your setup: cres-baron runs worker workloads
```

### kubelet

```
What: Agent on each node
Job: Ensures containers are running in pods
Analogy: Building security guard checking workers
Note: kubeadm joins nodes, kubelet maintains state
```

### kube-proxy

```
What: Network rules on each node
Job: Routes traffic to correct pods
Analogy: Network switch directing traffic
```

### etcd

```
What: Key-value database
Job: Stores cluster state (pods, services, config)
Analogy: Master spreadsheet of everything
Note: Critical - if lost, cluster is lost
```

---

## Networking Terms

### ClusterIP

```
What: Internal IP only reachable inside cluster
Use: Pod-to-pod communication
Example: web service:80 → postgres:5432
Browser access: No (internal only)
```

### NodePort

```
What: Exposes service via node IP:port
Use: External access without cloud LB
Example: nodeIP:30080 → service:80
Range: 30000-32767
```

### LoadBalancer

```
What: External LB integrating with cloud
Use: Production traffic (AWS ELB, GCP LB)
Example: Creates cloud LB, routes to NodePort
Your setup: Traefik uses this type for ingress
```

### Ingress

```
What: HTTP/HTTPS routing rules
Use: Route domain to service
Example: writeups.kube → web service
Controller: Traefik (your setup)
```

### DNS (CoreDNS)

```
What: Cluster DNS for service discovery
Use: Find services by name
Example: postgres means postgres.svc.cluster.local
Note: kube-dns or CoreDNS runs in kube-system
```

### NetworkPolicy

```
What: Firewall rules for pods
Use: Restrict traffic between pods
Example: "Only web pods can talk to postgres"
Analogy: Security guards at doors
```

---

## Workload Types

### Deployment

```
What: Stateless apps (web servers, APIs)
Features:
  - Replicas
  - Rolling updates
  - Rollbacks
  - Scaling
Example: web deployment
Use when: App doesn't store persistent data
```

### StatefulSet

```
What: Stateful apps (databases)
Features:
  - Stable pod names (postgres-0, postgres-1)
  - Stable storage (PVCs persist)
  - Ordered deploy/scale
Example: postgres, redis
Use when: App needs stable identity + storage
```

### DaemonSet

```
What: One pod per node (system daemons)
Use: Node exporter, log collectors
Example: Prometheus node-exporter on every node
```

### Job

```
What: Run once, complete successfully
Use: Database migrations, backups
Example: laravel migrate
CLI: kubectl get jobs
```

### CronJob

```
What: Scheduled jobs (like cron)
Use: Daily backups, weekly reports
Example: Every night at 2AM backup database
Schedule: Cron syntax (0 2 * * *)
```

---

## Autoscaling

### HorizontalPodAutoscaler (HPA)

```
What: Scale pods based on CPU/memory
Use: Handle traffic spikes automatically
Example: web pods 1-5 based on CPU > 70%
Commands:
  kubectl autoscale deployment web --min=1 --max=5 --cpu-percent=70
  kubectl get hpa
k9s: N/A (check via kubectl)
```

### VerticalPodAutoscaler (VPA)

```
What: Adjust pod resources automatically
Use: Optimize resource limits
Note: Less common than HPA
```

### Cluster Autoscaler

```
What: Add/remove nodes automatically
Use: Cloud: Scale cluster based on demand
Note: Your k3s (single node) - limited use
```

---

## Security Terms

### RBAC (Role-Based Access Control)

```
What: Who can do what in the cluster
Components:
  - Role: Permissions within namespace
  - ClusterRole: Cluster-wide permissions
  - RoleBinding: Bind role to user
  - ServiceAccount: Identity for pods
Example: "web pods can read configmaps"
```

### ServiceAccount

```
What: Identity for pods/apps
Use: Pods authenticate to API server
Example: Prometheus uses service account
CLI: kubectl get serviceaccounts
```

### NetworkPolicy

```
What: Firewall for pods
Use: Restrict traffic flow
Example: "Only nginx can talk to backend"
Note: Kubernetes default = allow all
```

### PodSecurityPolicy (PSP)

```
What: Admission controller for pod security
Use: Require non-root containers
Note: Deprecated in K8s 1.21, replaced by PSA
```

### Pod Security Standards (PSS)

```
What: Namespace-level security levels
Levels:
  - privileged: Unrestricted
  - baseline: Minimum restrictions
  - restricted: Heavily restricted
Use: Enforce security on namespaces
```

### Secrets

```
What: Store sensitive data
Types:
  - Opaque: Generic key-value pairs
  - tls.kubernetes.io: TLS certificates
  - kubernetes.io/dockerconfigjson: Image pull secrets
Encoding: base64 (NOT encrypted by default)
Encryption at rest: Requires additional config
Alternatives: Sealed Secrets, Vault
```

---

## Monitoring Terms

### Prometheus

```
What: Metrics collection and storage
Use: Scrape + store time-series data
Metrics: CPU%, memory, request counts
Query: PromQL (Prometheus Query Language)
Example: rate(http_requests_total[5m])
```

### Grafana

```
What: Visualization dashboard
Use: Charts, graphs, alerts
Data sources: Prometheus, Loki, Tempo, etc.
Example: CPU usage dashboard
Access: kubectl port-forward svc/grafana 3000
```

### Loki

```
What: Log aggregation
Use: Searchable logs from all pods
Query: LogQL (Loki Query Language)
Example: {app="web"} |= "ERROR"
Alternative: ELK (Elasticsearch + Logstash + Kibana)
```

### Tempo

```
What: Distributed tracing
Use: Request flow across services
Traces: Spans showing timing per service
Example: Request journey: nginx → web → postgres
```

### Alertmanager

```
What: Routes alerts to destinations
Use: PagerDuty, Slack, Email
Alert sources: Prometheus rules
Example: CPU > 90% → Slack #alerts channel
```

### metrics-server

```
What: Collects pod/node metrics
Use: kubectl top, HPA decisions
Note: Required for kubectl top
Your k3s: metrics-server installed by default
```

---

## Deployment Strategies

### Rolling Update

```
What: Replace pods one by one
Use: Zero-downtime deployments
Example: web v1 (3 pods) → web v2 (3 pods) gradually
Default: Deployment strategy
```

### Blue-Green Deployment

```
What: Two identical environments, switch traffic
Use: Instant rollback
Cost: 2x resources during switch
Example: Blue (live) → Green (new) → switch → Blue (old)
```

### Canary Deployment

```
What: Small % of traffic to new version
Use: Test in production safely
Example: 5% canary → 100% if healthy
Tools: Argo Rollouts, Flagger
```

### Recreate

```
What: Kill all old, start all new
Use: Databases (stateful)
Downtime: Yes
Example: Your writeups web deployment strategy
```

---

## GitOps Terms

### ArgoCD

```
What: GitOps continuous delivery tool
Use: Git repo is source of truth
Flow: Git push → ArgoCD detects → deploys
Example: Push to main → K8s updates automatically
Alternative: Flux
```

### Argo Rollouts

```
What: Advanced deployment strategies
Use: Canary, blue-green, A/B testing
Features: Automated analysis, rollback
```

### Kustomize

```
What: Kubernetes configuration manager
Use: Dev/staging/prod overlays
Example: Base config + staging patches + prod patches
Commands: kubectl kustomize
```

### Helm

```
What: Package manager for K8s
Use: Install apps with one command
Charts: Packaged K8s apps (nginx, prometheus, etc.)
Example: helm install prometheus prometheus-community/kube-prometheus-stack
Alternative: Kustomize
```

### Flux

```
What: GitOps operator for K8s
Use: Sync git repo to cluster automatically
Alternative to ArgoCD
```

---

## CI/CD Terms

### GitHub Actions

```
What: CI/CD from GitHub
Use: Build, test, deploy
Workflows: YAML in .github/workflows/
Example: Trivy scan, gitleaks, deployment
```

### ArgoCD vs GitHub Actions

```
GitHub Actions: Push-based (git push triggers pipeline)
ArgoCD: Pull-based (ArgoCD watches git)
```

### Security Gates

```
What: Checks before deployment
Tools: Trivy (CVEs), Gitleaks (secrets), Semgrep (code quality)
Example: Block deploy if CRITICAL CVEs found
```

---

## kubectl Commands

### Get Resources

```bash
kubectl get pods                    # List pods
kubectl get svc                    # List services
kubectl get deploy                 # List deployments
kubectl get ing                   # List ingresses
kubectl get cm                    # List configmaps
kubectl get secret                 # List secrets
kubectl get pvc                    # List persistent volume claims
kubectl get nodes                  # List nodes
kubectl get all -n namespace       # All resources in namespace
kubectl get pods -n namespace -l app=web  # Filter by label
```

### Describe

```bash
kubectl describe pod web-xxx           # Pod details + events
kubectl describe svc web                # Service endpoints
kubectl describe deploy web            # Deployment spec
kubectl describe ing web              # Ingress rules
```

### Logs

```bash
kubectl logs pod/web-xxx              # Pod logs
kubectl logs -f pod/web-xxx            # Follow logs
kubectl logs --previous pod/web-xxx     # Previous container logs
```

### Edit

```bash
kubectl edit deployment web -n namespace       # Edit deployment YAML
kubectl edit svc web -n namespace         # Edit service
kubectl edit configmap laravel-config    # Edit configmap
kubectl patch deployment web --type=merge -p '{"spec":{"replicas":3}}'  # Patch specific fields
```

### Apply/Delete

```bash
kubectl apply -f deployment.yaml         # Apply from file
kubectl apply -f directory/             # Apply all files in directory
kubectl delete pod web-xxx              # Delete pod
kubectl delete deployment web            # Delete deployment
kubectl delete namespace monitoring      # Delete namespace + everything in it
```

### Scaling

```bash
kubectl scale deployment web --replicas=5  # Scale to 5 pods
kubectl autoscale deployment web --min=1 --max=10 --cpu-percent=70  # HPA
```

### Rollout

```bash
kubectl rollout status deployment/web         # Watch rollout
kubectl rollout history deployment/web       # Show versions
kubectl rollout undo deployment/web          # Rollback to previous
kubectl rollout restart deployment/web       # Restart all pods
```

### Debugging

```bash
kubectl exec -it web-xxx -- /bin/sh        # Shell into pod
kubectl cp file.txt pod:/path/             # Copy file to pod
kubectl top pods                               # Pod metrics
kubectl top nodes                             # Node metrics
kubectl get events --sort-by='.lastTimestamp'  # Cluster events
kubectl logs -f --all-containers pod/web-xxx  # All containers
```

### Context/Config

```bash
kubectl config get-contexts                    # List contexts
kubectl config current-context                 # Current context
kubectl config use-context context-name         # Switch context
kubectl config set-context --current --namespace=monitoring  # Default namespace
```

---

## k9s Terms

### Views

```
:po         Pods
:svc        Services
:deploy     Deployments
:ing        Ingresses
:cm         ConfigMaps
:sec        Secrets
:pvc        PersistentVolumeClaims
:nodes      Nodes
:events     Events
:all        All resources
```

### Actions

```
d           Describe selected resource
y           View YAML
l           Logs
e           Edit resource
s           Scale (pods/deployments)
r           Restart pod
c           Create new resource
Ctrl+d      Delete selected resource
?           Help
Esc         Back/Close
q           Quit
```

---

## Common Patterns

### Pod Lifecycle

```
Pending → Running → Succeeded/Failed/Terminated
         ↓
    CrashLoopBackOff (restarting repeatedly)
    ImagePullBackOff (can't pull image)
    OOMKilled (out of memory)
    Terminating (being deleted)
```

### Pod States

```
Running: Pod is running
Pending: Pod being scheduled or containers starting
Succeeded: All containers completed
Failed: Container exited with error
CrashLoopBackOff: Container restarting repeatedly
```

### Conditions

```
PodReady: Pod can receive traffic
Initialized: Init containers finished
ContainersReady: All containers ready
```

---

## Real-World DevOps Checklist

### Daily

- [ ] kubectl get pods (any crashes?)
- [ ] kubectl get events (warnings?)
- [ ] kubectl top pods (resource usage)
- [ ] kubectl logs (errors)
- [ ] Check HPA scaled anything?

### Weekly

- [ ] Review resource limits (too high/low?)
- [ ] Check PVC usage (running out of space?)
- [ ] Review deployment rollouts
- [ ] Check secret rotation
- [ ] Verify backups ran

### Monthly

- [ ] Kubernetes version upgrades
- [ ] Security patches
- [ ] Cost optimization (right-sized resources)
- [ ] Disaster recovery test
- [ ] Documentation update

### Incidents

1. kubectl describe pod
2. kubectl logs
3. kubectl events
4. kubectl top pods/nodes
5. Check recent changes (kubectl rollout history)

---

## Quick Reference

```
Cluster: Your k3s installation
Node: The server (cres-baron)
Namespace: Project folder (writeups-local)
Pod: Running container
Deployment: "Keep X pods running"
Service: Fixed IP for pods
Ingress: Route traffic in
ConfigMap: .env variables
Secret: Passwords/keys
PVC: Persistent storage
HPA: Autoscaling
RBAC: Who can do what
NetworkPolicy: Firewall rules
Metrics-server: CPU/memory data
Prometheus: Store metrics
Grafana: Visualize metrics
Loki: Store logs
ArgoCD: GitOps deployment
Helm: Package manager
```

---

*Last updated: 2026-06-23*
