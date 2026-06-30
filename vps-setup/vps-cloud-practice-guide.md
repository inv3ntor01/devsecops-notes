# 🚀 VPS Cloud Practice Guide

**Goal:** Deploy a Laravel Writeups Blog on your VPS using LaraKube CLI, GitHub, and Cloudflare.

**Your VPS:** Ubuntu 24.04, 1GB RAM, 1 vCPU, 20GB free  
**Time to Complete:** ~2-3 weeks (learning at your pace)  
**Prerequisites:** Basic Linux, Docker, Git knowledge

---

## 📋 Learning Roadmap

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PHASE 1: Foundation                          │
│                   (Understand your environment)                     │
├─────────────────────────────────────────────────────────────────────┤
│  1.1  Connect to VPS via SSH                                        │
│  1.2  VPS Hardening (firewall, fail2ban, updates)                    │
│  1.3  Install Docker                                               │
│  1.4  Verify Docker is working                                     │
└─────────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      PHASE 2: Kubernetes                            │
│                    (Learn cluster management)                       │
├─────────────────────────────────────────────────────────────────────┤
│  2.1  Install K3s via LaraKube CLI                                  │
│  2.2  Connect K9s to your cluster                                   │
│  2.3  Setup Traefik (reverse proxy + SSL)                          │
│  2.4  Deploy test nginx pod                                         │
│  2.5  Verify ingress + SSL works                                   │
└─────────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      PHASE 3: Cloudflare                           │
│                    (Domain + DNS + SSL)                             │
├─────────────────────────────────────────────────────────────────────┤
│  3.1  Point domain DNS to VPS IP                                   │
│  3.2  Enable Cloudflare proxy                                       │
│  3.3  Create API token for DNS challenges                          │
│  3.4  Test SSL certificate auto-renewal                            │
└─────────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      PHASE 4: Laravel App                           │
│                  (Build your writeups blog)                         │
├─────────────────────────────────────────────────────────────────────┤
│  4.1  Create Laravel project                                       │
│  4.2  Design database schema                                       │
│  4.3  Implement CRUD for writeups                                   │
│  4.4  Add search with Meilisearch                                   │
│  4.5  Category filtering (difficulty, platform)                     │
│  4.6  Style with Tailwind CSS                                       │
└─────────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      PHASE 5: CI/CD Pipeline                        │
│                  (Automate everything)                              │
├─────────────────────────────────────────────────────────────────────┤
│  5.1  Dockerize Laravel app                                         │
│  5.2  Create Kubernetes manifests                                    │
│  5.3  Setup GitHub Actions                                          │
│  5.4  Add security scanning (Trivy, Gitleaks)                       │
│  5.5  Configure auto-deploy on push                                │
│  5.6  Test full pipeline                                            │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🎓 Learning Principles

1. **Understand before executing** — I'll explain WHY each step matters
2. **Verify at each step** — Don't proceed until current step works
3. **Break it down** — Complex tasks split into tiny, digestible steps
4. **Learn by debugging** — Errors are learning opportunities
5. **Document as you go** — Take notes on what you learn

---

## 📦 What You'll Learn

| Skill | Where You Learn It |
|-------|---------------------|
| SSH & secure connections | Phase 1 |
| Firewall & server hardening | Phase 1 |
| Docker containers | Phase 1-2 |
| Kubernetes basics (Pods, Services, Ingress) | Phase 2 |
| K3s lightweight K8s | Phase 2 |
| DNS & CDN | Phase 3 |
| SSL/TLS certificates | Phase 3 |
| Laravel framework | Phase 4 |
| Full-text search | Phase 4 |
| GitHub Actions CI/CD | Phase 5 |
| Container security scanning | Phase 5 |
| GitOps deployment | Phase 5 |

---

## 🆘 Getting Help

- **Stuck?** Describe what you tried and what happened
- **Error messages?** Share the exact output
- **Want to skip ahead?** Let me know and we'll assess readiness

---

*Let's begin with Phase 1!*
