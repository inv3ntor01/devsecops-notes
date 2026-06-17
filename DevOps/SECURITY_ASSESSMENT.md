# 🚨 Security Assessment: LaraKube CLI
## Pre-Production Security Gap Analysis

> **Status**: NOT READY FOR PRODUCTION
> **Critical Issues**: 5 | **High Priority**: 8 | **Medium**: 6

---

## 📊 Executive Summary

| Category | Status | Details |
|----------|--------|---------|
| **Secrets Scanning** | ⚠️ In Development | `feature/devsecops-pipeline` branch, NOT merged |
| **Dependency Scanning** | ⚠️ In Development | Trivy on feature branch, NOT merged |
| **Server Hardening** | 🔶 Partial | UFW, SSH keys, fail2ban done; k3s API exposure TODO |
| **RBAC** | ✅ Implemented | ServiceAccount-based teammate access |
| **Network Security** | ❌ Missing | No NetworkPolicies, no default deny |
| **Secret Management** | ⚠️ Basic | No rotation, no external secrets |
| **Binary Security** | ❌ Missing | No binary scanning, no SBOM |
| **Audit Logging** | ❌ Missing | No audit trail for sensitive operations |

---

## 🔴 Critical Issues (Must Fix Before Production)

### 1. Secrets Scanning Not in Main CI Pipeline
**Status**: In `feature/devsecops-pipeline` branch, NOT merged to main

**Current State**:
```yaml
# .github/workflows/ci.yml - MISSING
# No gitleaks, no secrets scanning
```

**Required State**:
```yaml
# Should be in main CI
jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history
      - name: Run gitleaks
        run: gitleaks detect --source . --report-format sarif
```

**Action**: Merge `feature/devsecops-pipeline` to main OR cherry-pick the security workflows.

---

### 2. Dependency Vulnerability Scanning Missing
**Status**: In `feature/devsecops-pipeline` branch, NOT merged to main

**Current State**: No Trivy scanning in CI
**Risk**: Known CVEs in dependencies could be deployed to production

**Required**: Add Trivy scanning for Composer/npm dependencies.

---

### 3. k3s API Server Exposed to 0.0.0.0/0
**Status**: Documented in `plans/active/server-hardening.md`, NOT implemented

```bash
# Current: k3s API (port 6443) is open to the world
# Risk: Anyone can try to authenticate to your cluster control plane
```

**Required**: Restrict k3s API to operator's IP only:
```bash
# In cloud:provision or cloud:harden
ufw allow from <OPERATOR_IP> to any port 6443
ufw deny 6443
```

---

### 4. No Network Policies (Default Allow)
**Status**: Not implemented

**Risk**: Compromised pod can talk to any other pod in the cluster.

**Required**: Add default-deny NetworkPolicy:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: <project-namespace>
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

---

### 5. No Binary Security Scanning
**Status**: Not implemented

**Risk**: Built PHAR binaries could contain vulnerabilities or be tampered with.

**Required**:
- [ ] Add Trivy/ Grype scanning of built binaries
- [ ] Generate SBOM (Software Bill of Materials)
- [ ] Sign binaries with cosign
- [ ] Publish to GitHub Releases with provenance

---

## 🟠 High Priority Issues

### 6. k3s Secrets Not Encrypted at Rest
**Status**: Not implemented

**Risk**: Secrets stored in etcd are readable if disk is compromised.

**Required**:
```bash
# In k3s config, add:
--secrets-encryption-dir=/var/lib/rancher/k3s/server/db
--secrets-encryption=true
```

---

### 7. Kubelet Port (10250) Exposure
**Status**: Not audited/secured

**Risk**: Kubelet API can be used for container escape attacks.

**Required**: Audit and restrict kubelet access.

---

### 8. No SAST (Static Application Security Testing)
**Status**: In `feature/devsecops-pipeline` branch (Semgrep), NOT merged

**Risk**: Code vulnerabilities like SQL injection, XSS not caught in CI.

**Required**: Add Semgrep scanning to main CI.

---

### 9. Pre-commit Hooks Not Enforced
**Status**: `.pre-commit-config.yaml` in feature branch, NOT in main

**Risk**: Developers can accidentally commit secrets before CI catches them.

**Required**: Add `.pre-commit-config.yaml` to main and document setup.

---

### 10. No Pod Security Standards Enforcement
**Status**: Not implemented

**Risk**: Privileged pods, hostPath mounts, etc. could be deployed.

**Required**: Enforce baseline or restricted PSA:
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: <project-namespace>
  labels:
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted
```

---

### 11. No Secret Rotation Mechanism
**Status**: Long-lived tokens, documented but no rotation tooling

**Risk**: Compromised tokens remain valid indefinitely.

**Required**: Implement `cluster:rotate-secrets` command.

---

### 12. No Audit Logging
**Status**: Not implemented

**Risk**: No trail for security incidents, compliance issues.

**Required**: Enable Kubernetes audit logging:
```yaml
# k3s API server flags
--audit-log-path=/var/log/k3s-audit.log
--audit-log-maxage=30
--audit-log-maxbackup=10
--audit-policy-file=/etc/rancher/k3s/audit.yaml
```

---

### 13. k3s Kubeconfig World-Readable
**Status**: Documented in `server-hardening.md`, NOT fixed

**Risk**: On the server, `/etc/rancher/k3s/k3s.yaml` is readable by any user.

**Required**: 
```bash
chmod 600 /etc/rancher/k3s/k3s.yaml
```

---

## 🟡 Medium Priority Issues

### 14. No Container Image Signing
**Status**: Not implemented

**Risk**: Unsigned images could be deployed.

**Required**: Use Cosign to sign built images.

---

### 15. No Vulnerability Database Updates
**Status**: Trivy/other tools would need regular CVE database updates

**Risk**: New CVEs not detected.

**Required**: Schedule daily vulnerability database updates.

---

### 16. No Rate Limiting on k3s API
**Status**: Not configured

**Risk**: Brute force attacks against API server.

**Required**: Configure API server rate limiting.

---

### 17. No Security Context Defaults
**Status**: Not enforced at namespace level

**Risk**: Pods deployed without security context.

**Required**: Add LimitRange and default security context.

---

### 18. SSH Root Login Disabled Check Not Atomic
**Status**: In `InteractsWithServerHardening`, guarded check

**Risk**: Race condition possible if sudo fails.

**Required**: Make the check more robust.

---

### 19. No Malware Scanning
**Status**: Not implemented

**Risk**: Malware could be introduced in build process.

**Required**: Add ClamAV or similar scanning.

---

## ✅ Completed Security Features

| Feature | Status | Location |
|---------|--------|----------|
| UFW Firewall | ✅ Done | `InteractsWithServerHardening` |
| SSH Key-only Auth | ✅ Done | `InteractsWithServerHardening` |
| fail2ban | ✅ Done | `InteractsWithServerHardening` |
| Disable Root Login | ✅ Done | `InteractsWithServerHardening` |
| Unattended Upgrades | ✅ Done | `InteractsWithServerHardening` |
| RBAC Teammate Access | ✅ Done | `InteractsWithTeammateRbac` |
| Auto SSL (Let's Encrypt) | ✅ Done | Traefik setup |
| Namespace Isolation | ✅ Done | Per-project namespaces |
| Local CA Trust | ✅ Done | `trust` command |

---

## 🎯 Recommended Action Plan

### Phase 1: Immediate (Before Any Production) - 1-2 days
1. **Merge `feature/devsecops-pipeline`** to main
   - Secrets scanning (gitleaks)
   - Dependency scanning (Trivy)
   - Pre-commit hooks
   - SAST (Semgrep)

2. **Fix k3s API exposure**
   - Restrict port 6443 to operator IP

3. **Add NetworkPolicies**
   - Default deny ingress/egress

### Phase 2: Pre-Production (1 week)
4. **Enable k3s secrets encryption**
5. **Add Pod Security Standards**
6. **Implement audit logging**
7. **Fix k3s kubeconfig permissions**
8. **Audit kubelet exposure**

### Phase 3: Post-Launch (1 month)
9. **Binary signing with Cosign**
10. **Generate SBOM**
11. **Secret rotation mechanism**
12. **Rate limiting on API**
13. **Security dashboard/monitoring**

---

## 📋 Checklist: Production Readiness

### Security Scanning ✅/❌
- [ ] Gitleaks in CI (PR and push)
- [ ] Trivy dependency scan in CI
- [ ] Semgrep SAST in CI
- [ ] Pre-commit hooks installed
- [ ] Container image scanning

### Server Hardening ✅/❌
- [ ] UFW with default deny
- [ ] SSH key-only auth
- [ ] fail2ban enabled
- [ ] Root login disabled
- [ ] k3s API restricted to operator IP
- [ ] kubelet audited/restricted
- [ ] k3s secrets encryption enabled
- [ ] k3s kubeconfig 600 permissions
- [ ] Unattended upgrades enabled

### Kubernetes Security ✅/❌
- [ ] NetworkPolicy: default deny
- [ ] Pod Security Standards enforced
- [ ] Audit logging configured
- [ ] Resource limits set
- [ ] Security context defaults

### Secrets Management ✅/❌
- [ ] No long-lived credentials in code
- [ ] External secrets integration (optional)
- [ ] Secret rotation mechanism
- [ ] No .env files committed

### Binary Security ✅/❌
- [ ] Binary vulnerability scanning
- [ ] SBOM generation
- [ ] Binary signing
- [ ] Provenance attestation

### Monitoring & Response ✅/❌
- [ ] Security event monitoring
- [ ] Audit log retention
- [ ] Incident response plan
- [ ] Backup and recovery tested

---

## 🔗 Related Documentation

- `plans/active/server-hardening.md` - Server hardening checklist
- `plans/active/rbac-teammate-access.md` - RBAC design
- `plans/active/scoped-rbac-deploy.md` - Deploy token scoping
- `origin/feature/devsecops-pipeline` - Security pipeline (pending merge)

---

## 📞 Questions/Decisions Needed

1. **Merge strategy**: Merge `feature/devsecops-pipeline` to main before production?
2. **External secrets**: Plan to integrate with HashiCorp Vault, AWS Secrets Manager, or external?
3. **Secret rotation**: Implement manual rotation or automated?
4. **Binary signing**: Use Cosign? Self-signed or CA?
5. **Monitoring**: What security monitoring is planned? Datadog? Prometheus?

---

*Assessment Date: 2026-06-17*
*Prepared for: LaraKube Production Readiness Review*