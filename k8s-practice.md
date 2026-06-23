# 🏋️ Kubernetes Practice Guide

**Project:** writeups (Laravel app on k3s)
**Namespace:** writeups-local
**Tools:** k9s, kubectl

---

## Prerequisites

```bash
# Start k9s
k9s
```

---

# Level 1: Explore the Cluster

**Goal:** Understand your cluster layout

## Task 1.1 — View All Namespaces

```
Command: :namespace
```

**Answer these:**
- How many namespaces do you see?
- Which namespaces are for k3s internal use? 
- Which namespace has your app?

<details>
<summary>My Answers</summary>

1. Namespaces found: 6

2. k8s internal namespaces: kube-node-lease, kube-public, kube-system

3. Your app namespace:  writeups-local

</details>

---

## Task 1.2 — Switch to writeups-local Namespace

```
Press: Enter on writeups-local
```

**Answer these:**
- Which pods are running in writeups-local?

<details>
<summary>My Answers</summary>

Pods in writeups-local: meilisearch, node, postgres, redis, reverb, web

</details>

---

## Task 1.3 — View All Resources

```
Command: :all
```

**Answer these:**
- How many different resource types do you see?
- What resources belong to your app vs k8s system?

<details>
<summary>My Answers</summary>

Resource types: 13

App resources: 8

System resources: 5

</details>

---

## Task 1.4 — View Nodes

```
Command: :nodes
```

**Answer these:**
- What is your node name?
- What OS does it run?
- What version of Kubernetes is it running?

<details>
<summary>My Answers</summary>

Node name: cres-baron

OS: linux

Kubernetes version: v1.30.4+k3s1

</details>

---

# Level 2: Pods

**Goal:** Understand Pods — the smallest deployable unit

## Task 2.1 — View Pods

```
Command: :po
```

**Answer these:**
- Total pods:
- Pod statuses (Running/Terminated/CrashLoopBackOff):

<details>
<summary>My Answers</summary>

Total pods: 13

Statuses: Running

</details>

---

## Task 2.2 — Inspect the Web Pod

```
Select: web pod
Press: d (describe)
```

**Answer these:**
- What is the pod IP?
- What node is it running on?
- What image is being used?
- What port is the container listening on?

<details>
<summary>My Answers</summary>

Pod IP: 10.42.0.134

Node: cres-baron/172.30.60.115

Image: writeups:local

Port: "<none>"

</details>

---

## Task 2.3 — View Pod Logs

```
Select: web pod
Press: l (logs)
```

**Answer these:**
- What logs do you see?
- Any errors or warnings?
- What format are the logs in?

<details>
<summary>My Answers</summary>

Log output: php 10.42.0.1 - - [23/Jun/2026:06:13:30 +0000] "GET /up HTTP/1.1" 200 1840 "-" "kube-probe/1.30" "-"

Errors/Warnings: None

</details>

---

## Task 2.4 — View Pod YAML

```
Select: web pod
Press: y (view YAML)
```

**Answer these:**
- What is the apiVersion?
- What labels does this pod have?
- What volumes are mounted?

<details>
<summary>My Answers</summary>

apiVersion: v1

Labels: web

Volumes: code, storage, kube-api-access-gpfpc

</details>

---

# Level 3: Services

**Goal:** Understand Services — stable network endpoints

## Task 3.1 — View Services

```
Command: :svc
```

**Answer these:**
- How many services? 12
- What type is each service (ClusterIP/NodePort/LoadBalancer)?

<details>
<summary>My Answers</summary>

Services and types: ClusterIP and LoadBalancer

</details>

---

## Task 3.2 — Inspect the Web Service

```
Select: web service
Press: d (describe)
```

**Answer these:**
- What is the ClusterIP?
- What port does it expose?
- How does it find the pods?

<details>
<summary>My Answers</summary>

ClusterIP:  10.43.55.128  

Port: 80

Selector: app=web

</details>

---

## Task 3.3 — Understand Service Types

**Answer these:**

| Question | Answer |
|----------|--------|
| What does ClusterIP mean? | clusterip mean the identity of a namespace |
| Can you access ClusterIP from browser? | no |
| What service type is for external traffic? | LoadBalancer |
| Which service type is your web app using? | ClusterIP |

---

# Level 4: Deployments

**Goal:** Understand Deployments — keeping pods running

## Task 4.1 — View Deployments

```
Command: :deploy
```

**Answer these:**
- How many deployments?
- What is the desired state (replicas)?

<details>
<summary>My Answers</summary>

Deployments: 12

Desired replicas: 1

</details>

---

## Task 4.2 — Inspect the Web Deployment

```
Select: web deployment
Press: d (describe)
```

**Answer these:**
- How many replicas are running?
- What is the selector?
- What strategy is used (RollingUpdate/Recreate)?

<details>
<summary>My Answers</summary>

Replicas: 1

Selector: app=web

Strategy: Recreate

</details>

---

# Level 5: ConfigMaps and Secrets

**Goal:** Understand configuration management

## Task 5.1 — View ConfigMaps

```
Command: :cm
```

**Answer these:**
- How many ConfigMaps?
- What does laravel-config contain?

<details>
<summary>My Answers</summary>

ConfigMaps: 13

laravel-config keys: none

</details>

---

## Task 5.2 — View Secrets

```
Command: :sec
```

**Answer these:**
- How many secrets?
- What type is laravel-secrets?

<details>
<summary>My Answers</summary>

Secrets: 7

laravel-secrets type: Opaque

</details>

---

## Task 5.3 — Add an Environment Variable

**Task:** Add `APP_DEBUG=true` to the ConfigMap

```
Select: laravel-config
Press: e (edit)
```

Add this line:
```yaml
APP_DEBUG: "true"
```

Save (Esc → :wq)

**Answer these:**
- Did the save succeed? yes
- Did you restart the pod? no

---

## Task 5.4 — Restart Pod to Pick Up Change

```
Select: web pod
Press: r (restart)
```

**Answer these:**
- How long did the restart take? r command is not working
- Is the new env var visible? i dont know

<details>
<summary>My Answers</summary>

Restart time: it did not restarted

Env var visible (yes/no): i dont know

</details>

---

# Level 6: Ingress

**Goal:** Understand routing external traffic

## Task 6.1 — View Ingresses

```
Command: :ing
```

**Answer these:**
- How many ingresses?
- What hosts are configured?
- What ingress controller is used?

<details>
<summary>My Answers</summary>

Ingresses: 6

Hosts: writeups.kube, meilisearch.writeups.kube, vite.writeups.kube, postgres.writeups.kube, and redis.writeups.kube

Ingress controller:  writeups-local

</details>

---

## Task 6.2 — Inspect the Web Ingress

```
Select: web ingress
Press: d (describe)
```

**Answer these:**
- What host is configured?
- What service does it route to?
- What port?

<details>
<summary>My Answers</summary>

Host: writeups.kube

Service: web

Port: 80

</details>

---

# Level 7: Scaling

**Goal:** Scale pods up and down

## Task 7.1 — Scale Web to 2 Replicas

```
Select: web pod
Press: s (scale)
Enter: 2
```

**Answer these:**
- How many pods now?
- What ReplicaSet is managing them?

<details>
<summary>My Answers</summary>

Pods after scaling: i cant scale

ReplicaSet: i dont know how

</details>

---

## Task 7.2 — Scale Web to 3 Replicas

Scale again to 3.

**Answer these:**
- How long did it take to spin up 3 pods?

<details>
<summary>My Answers</summary>

Time for 3 pods:

</details>

---

## Task 7.3 — Scale Back to 1

```
Press: s
Enter: 1
```

**Answer these:**
- What happens to the extra pods?
- How long did it take?

<details>
<summary>My Answers</summary>

Pod termination:

Time:

</details>

---

# Level 8: Delete and Recover

**Goal:** Understand self-healing

## Task 8.1 — Delete a Pod

```
Select: web pod
Press: Ctrl+d
Confirm: Yes
```

**Answer these:**
- How long until K8s noticed?
- How long until new pod was created?

<details>
<summary>My Answers</summary>

Detection time: 2026-06-23T14:54:28.082295531+08:00

Recovery time:  2026-06-23T14:55:10.717761958+08:00

</details>

---

## Task 8.2 — Delete PostgreSQL Pod

```
Select: postgres pod
Press: Ctrl+d
Confirm: Yes
```

**Answer these:**
- Did the web pod restart too?
- Did any errors appear?

<details>
<summary>My Answers</summary>

Web pod affected:

Errors:

</details>

---

# Level 9: Breaking Things (CrashLoopBackOff)

**Goal:** Understand what causes failures and how to diagnose

## Task 9.1 — Break Memory Limits

```
Select: web pod
Press: e (edit)
```

Find and change:
```yaml
resources:
  limits:
    memory: "10Mi"    # Change from 1Gi to 10Mi
```

Save.

**Answer these:**
- What status did the pod go to? it did not change
- How many restarts? it did not restart because the memory limit did not work

<details>
<summary>My Answers</summary>

Status:

Restarts:

</details>

---

## Task 9.2 — Check Logs for OOM

```
Select: crashing web pod
Press: l (logs)
```

**Answer these:**
- What error do you see?

<details>
<summary>My Answers</summary>

Error message: no error logs

</details>

---

## Task 9.3 — Describe the Pod

```
Press: d (describe)
```

Look at the Events section.

**Answer these:**
- What warning events do you see?
- What is the last state?

<details>
<summary>My Answers</summary>

Warning events:

Last state:

</details>

---

## Task 9.4 — Fix the Memory Limit

```
Press: e (edit)
```

Change back:
```yaml
resources:
  limits:
    memory: "1Gi"
```

Save.

**Answer these:**
- How long until recovery?
- What is the final status?

<details>
<summary>My Answers</summary>

Recovery time:

Final status:

</details>

---

# Level 10: CPU Limits

**Goal:** Understand resource constraints

## Task 10.1 — Break CPU Limits

```
Select: web pod
Press: e (edit)
```

Change:
```yaml
resources:
  limits:
    cpu: "10m"    # Very low CPU
```

Save.

**Answer these:**
- Did the pod crash? it did not change
- Test in browser — how fast is the response?

<details>
<summary>My Answers</summary>

Status:

Browser response:

</details>

---

## Task 10.2 — Fix CPU Limits

```
Press: e (edit)
```

Change back:
```yaml
resources:
  limits:
    cpu: "1"
```

Save.

**Answer these:**
- Is the app responsive again?

<details>
<summary>My Answers</summary>

App responsive (yes/no):

</details>

---

# Level 11: Readiness Probes

**Goal:** Understand traffic routing based on health

## Task 11.1 — Break Readiness Probe

```
Select: web pod
Press: e (edit)
```

Find readinessProbe and change:
```yaml
readinessProbe:
  httpGet:
    path: /BROKEN    # Change from /up
    port: 8080
```

Save.

**Answer these:**
- What is the pod status?
- Check service endpoints: `k9s → :svc → web → d`

<details>
<summary>My Answers</summary>

Pod status: i cant edit the yaml file

Endpoints count:

</details>

---

## Task 11.2 — Fix Readiness Probe

```
Press: e (edit)
```

Change back:
```yaml
readinessProbe:
  httpGet:
    path: /up    # Back to /up
    port: 8080
```

Save.

**Answer these:**
- What is the pod status now?
- Endpoints count?

<details>
<summary>My Answers</summary>

Pod status:

Endpoints count:

</details>

---

# Level 12: Init Containers

**Goal:** Understand startup dependencies

## Task 12.1 — View Init Containers

```
Select: web pod
Press: d (describe)
```

Look at Init Containers section.

**Answer these:**
- What does the init container do?
- How long does it wait?

<details>
<summary>My Answers</summary>

Init container purpose:

Wait time:

</details>

---

# Level 13: Events

**Goal:** Understand cluster-wide activity

## Task 13.1 — View Recent Events

```
Command: :events
```

**Answer these:**
- What is the most recent event?
- What type of events do you see most?
- Any warnings?

<details>
<summary>My Answers</summary>

Most recent event:

Most common event type:

Warnings:

</details>

---

# Level 14: Volumes and PVC

**Goal:** Understand data persistence

## Task 14.1 — View PVCs

```
Command: :pvc
```

**Answer these:**
- How many PVCs?
- What is the storage size?

<details>
<summary>My Answers</summary>

PVCs:

Storage size:

</details>

---

## Task 14.2 — View Pod Volumes

```
Select: web pod
Press: d (describe)
```

Look at Volumes section.

**Answer these:**
- What volumes are mounted?
- Where is the app code mounted from?

<details>
<summary>My Answers</summary>

Volumes:

App code source:

</details>

---

# Level 15: Rollback

**Goal:** Recover from bad changes

## Task 15.1 — Make a Bad Change

Make any change to the deployment that breaks it.

**What did you change?**

<details>
<summary>My Change</summary>

Bad change:

</details>

---

## Task 15.2 — View Rollback History

```
Select: web pod
Press: Shift+u (show history)
```

**Answer these:**
- How many revisions are there?
- What changed in each revision?

<details>
<summary>My Answers</summary>

Revisions:

</details>

---

## Task 15.3 — Rollback

```
Select: a working revision
Press: Enter
```

**Answer these:**
- How long did rollback take?
- Is the app working again?

<details>
<summary>My Answers</summary>

Rollback time:

App working (yes/no):

</details>

---

# Level 16: Full Disaster Recovery

**Scenario:** Everything is broken.

## Checklist

| Step | Task | Status |
|------|------|--------|
| 1 | Check events: `k9s → :events` | ⬜ |
| 2 | Identify crashing pods | ⬜ |
| 3 | Check pod logs | ⬜ |
| 4 | Check pod describe | ⬜ |
| 5 | Fix resources (memory/CPU) | ⬜ |
| 6 | Restart affected pods | ⬜ |
| 7 | Verify app is working | ⬜ |

---

## What I Fixed

<details>
<summary>Document what was broken and how you fixed it</summary>

1. Problem:

2. Diagnosis:

3. Fix:

4. Result:

</details>

---

# Summary

## Concepts Mastered

Mark what you understand now:

| Concept | Understood | Notes |
|---------|-----------|-------|
| Pods | ⬜ | |
| Services | ⬜ | |
| Deployments | ⬜ | |
| ConfigMaps | ⬜ | |
| Secrets | ⬜ | |
| Ingress | ⬜ | |
| Scaling | ⬜ | |
| Self-healing | ⬜ | |
| Resource limits | ⬜ | |
| Readiness probes | ⬜ | |
| Init containers | ⬜ | |
| Events | ⬜ | |
| Rollback | ⬜ | |

---

## kubectl Commands Learned

```bash
# Get resources
kubectl get pods -n writeups-local
kubectl get svc -n writeups-local
kubectl get deploy -n writeups-local
kubectl get ing -n writeups-local
kubectl get pvc -n writeups-local

# Describe
kubectl describe pod <name> -n writeups-local

# Logs
kubectl logs <pod> -n writeups-local

# Scale
kubectl scale deployment web --replicas=3 -n writeups-local

# Restart
kubectl rollout restart deployment web -n writeups-local

# Rollback
kubectl rollout undo deployment web -n writeups-local

# Edit
kubectl edit deployment web -n writeups-local

# Delete
kubectl delete pod <name> -n writeups-local

# Events
kubectl get events -n writeups-local --sort-by='.lastTimestamp'
```

---

# Next Steps

## Advanced Topics to Learn

- [ ] Horizontal Pod Autoscaler (HPA)
- [ ] Network Policies
- [ ] Resource Quotas
- [ ] Pod Disruption Budgets
- [ ] PersistentVolumes
- [ ] Jobs and CronJobs
- [ ] StatefulSets
- [ ] ServiceAccounts
- [ ] RBAC (Roles and RoleBindings)
- [ ] Network Policies
- [ ] Ingress Controllers (beyond Traefik)
- [ ] Helm Charts
- [ ] Kustomize
- [ ] ArgoCD / Flux (GitOps)
- [ ] Prometheus / Grafana (Monitoring)
- [ ] Fluentd / Loki (Logging)
- [ ] Service Mesh (Istio)

---

*Practice completed: ___________________*
*Instructor sign-off: ___________________*
