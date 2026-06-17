# LaraKube CLI - DevSecOps Checklist

> **Project**: [larakube-cli](https://github.com/luchavez-technologies/larakube-cli)
> **Date**: 2026-06-17
> **Status**: Pre-Production

---

## 🎯 Pre-Production Security Checklist

### Critical Issues (Must Fix Before Production)

- [ ] **Merge `feature/devsecops-pipeline` to main**
  - Gitleaks (secrets scanning)
  - Trivy (dependency CVE scanning)
  - Semgrep (SAST)
  - Pre-commit hooks

- [ ] **Restrict k3s API (port 6443) to operator IP only**
  - Currently exposed to `0.0.0.0/0`
  - Add UFW rule: `ufw allow from <OPERATOR_IP> to any port 6443`

- [ ] **Add NetworkPolicies (Default Deny)**
  - Create `network-policy.yaml` template
  - Add allow rules for DNS, services, ingress
  - Update test snapshots

- [ ] **Add Pod Security Standards**
  - Add PSA labels to namespace templates
  - Enforce: `baseline`, Audit: `restricted`

- [ ] **Add Binary Security Scanning**
  - Trivy/Grype scanning of built PHARs
  - Generate SBOM
  - Sign binaries with Cosign

---

### High Priority Issues

- [ ] **Enable k3s secrets encryption at rest**
  ```bash
  # Add to k3s config
  --secrets-encryption=true
  ```

- [ ] **Audit kubelet port (10250) exposure**
  - Restrict access to kubelet API
  - Disable anonymous auth

- [ ] **Add audit logging**
  ```yaml
  # k3s API server flags
  --audit-log-path=/var/log/k3s-audit.log
  --audit-log-maxage=30
  --audit-policy-file=/etc/rancher/k3s/audit.yaml
  ```

- [ ] **Fix k3s kubeconfig permissions (600)**
  ```bash
  chmod 600 /etc/rancher/k3s/k3s.yaml
  ```

- [ ] **Implement secret rotation mechanism**
  - Create `cluster:rotate-secrets` command
  - Document rotation procedure

---

### Medium Priority Issues

- [ ] **Container image signing with Cosign**
- [ ] **Rate limiting on k3s API**
- [ ] **Add LimitRange and default security context**
- [ ] **Malware scanning (ClamAV)**
- [ ] **Regular CVE database updates**

---

## ✅ Completed Items

| Item | Date | PR |
|------|------|-----|
| Server Hardening (UFW, fail2ban, SSH keys) | 2026-06-17 | Built-in |
| RBAC Teammate Access | 2026-06-17 | Built-in |
| Auto SSL (Let's Encrypt) | 2026-06-17 | Built-in |
| Namespace Isolation | 2026-06-17 | Built-in |
| Skipped Test Fix | 2026-06-17 | `fix/skip-prompt-test-v2` |

---

## 📋 Server Hardening Details

### Completed in `InteractsWithServerHardening.php`

```bash
✅ UFW firewall (default deny incoming)
✅ fail2ban (SSH brute-force protection)
✅ SSH key-only authentication
✅ Disable root login
✅ Unattended security upgrades
```

### Still Needed

```bash
⬜ Restrict k3s API (6443) to operator IP
⬜ Audit kubelet (10250) exposure
⬜ k3s secrets encryption
⬜ k3s kubeconfig 600 permissions
```

---

## 📋 NetworkPolicy Plan

### Files to Create

```
resources/views/k8s/base/
├── network-policy.yaml        # Default deny all
├── network-allow-rules.yaml   # DNS, ingress, HTTPS
└── network-allow-services.yaml # DB, Redis, Meilisearch
```

### Rules Needed

| Policy | Purpose |
|--------|---------|
| `default-deny` | Block all traffic by default |
| `allow-dns` | CoreDNS access (port 53) |
| `allow-ingress` | From Traefik only |
| `allow-external-https` | Outbound HTTPS (port 443) |
| `allow-postgres` | App → Database (port 5432) |
| `allow-redis` | App → Cache (port 6379) |
| `allow-intra-namespace` | Horizon, queues, scheduler |

---

## 📋 CI/CD Security Pipeline

### Required Workflows

```yaml
# 1. secrets-scan.yml - Gitleaks
# 2. trivy-scan.yml - Dependency vulnerabilities
# 3. semgrep.yml - SAST (OWASP Top 10)
# 4. pre-commit-hooks.yml - Local enforcement
```

### Branch Protection (Recommended)

- Require PR reviews
- Require status checks to pass
- Require secrets scan to pass
- No force push to main

---

## 🔗 Useful Links

| Resource | URL |
|----------|-----|
| LaraKube Docs | https://larakube.luchtech.dev |
| Security Assessment | `SECURITY_ASSESSMENT.md` |
| Server Hardening Plan | `plans/active/server-hardening.md` |
| RBAC Design | `plans/active/rbac-teammate-access.md` |

---

## 📝 Notes

- `feature/devsecops-pipeline` branch contains security workflow files
- Merge strategy: Cherry-pick security files OR merge entire branch
- Test snapshots will need updating when adding new features

---

*Last Updated: 2026-06-17*