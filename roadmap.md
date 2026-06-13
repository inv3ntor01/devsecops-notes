# DevSecOps Learning Roadmap — LaraKube CLI

**Started:** 2026-06-12
**Mentee:** inv3ntor01 (inv3ntor01@users.noreply.github.com)
**Project:** LaraKube CLI — Laravel Kubernetes orchestrator (PHP 8.4, Laravel Zero)
**Repo:** https://github.com/luchavez-technologies/larakube-cli
**Fork:** https://github.com/inv3ntor01/larakube-cli

---

## Skill Assessment (2026-06-12)

| Skill | Level | Status |
|---|---|---|
| Linux/SysAdmin | Comfortable | ✅ |
| Security (tools, reading reports) | Intermediate | 🟡 |
| Containers/Docker | Beginner | 🔴 |
| Kubernetes | New | 🔴 |
| CI/CD | New | 🔴 |

---

## Completed Sessions

### Session 1 (2026-06-12) — Foundations
- Dockerfile analysis (multi-stage builds, USER root vs www-data, ARG USER_ID/GROUP_ID)
- Trivy scanning (CRITICAL shell-quote CVE, HIGH OpenSSL CVE)
- CI/CD pipeline building (gitleaks, pre-commit, semgrep)
- Git workflow (sync with upstream, rebase, clean branch)
- Branch: `feature/devsecops-pipeline` created

### Session 2 (2026-06-13) — Security Gates Built
**What we built:**
1. ✅ **Trivy CI workflow** — filesystem scan of Composer/npm dependencies
   - Blocks on CRITICAL, tracks HIGH in GitHub Security tab
   - Scans 3 base image variations via matrix strategy
   - Learned: scan the right thing (tool deps, not base images)
2. ✅ **gitleaks secrets scanning** — `protect` for PRs, `detect` for pushes
   - Caught 3 real secrets in upstream git history
   - Learned: `gitleaks protect` vs `gitleaks detect`, organization license requirement
3. ✅ **Pre-commit hooks** — YAML/JSON validation, gitleaks, semgrep SAST
   - Fixed upstream file issues (trailing whitespace, missing newlines)
   - Learned: pre-commit scans all files in CI, exclude patterns
4. ✅ **PR submitted** — all 4 CI checks passing
   - Clean single commit, proper PR description
   - Fixed gitleaks download URL, pre-commit exclusions, upstream file fixes

**Key lessons learned:**
- Security gates catch real things (gitleaks found 3 secrets)
- Scan the right thing, not the easy thing
- CI fatigue is real — tune gates to be actionable
- Pre-existing technical debt will bite you
- Tools change under you (gitleaks license requirement)
- YAML formatting matters (comma-space vs comma-no-space)
- Your pipeline should match your workflow

---

## Pending Exercises

### Exercise 2: Dockerfile HEALTHCHECK
- Add HEALTHCHECK to `resources/views/docker/php.blade.php` deploy stage
- `--interval=30s --timeout=3s --start-period=40s --retries=3`
- Test: verify generated Dockerfile includes it

### Exercise 3: Dependabot Configuration
- Create `.github/dependabot.yml`
- Configure for Composer (PHP) and npm (frontend) dependencies
- Set update schedule, reviewers, labels

### Exercise 4: Branch Protection Rules
- Require PR reviews before merge
- Require CI checks to pass (all 4 workflows)
- Prevent force-push to main/develop
- Require signed commits (optional)

### Exercise 5: K8s Manifest Security
- securityContext in generated pods (non-root, read-only FS, capabilities drop)
- Resource limits (requests/limits for CPU/memory)
- NetworkPolicies (deny-all by default, allow only needed traffic)
- Pod Security Standards/Admission

### Exercise 6: Supply Chain Security
- Binary checksums for GitHub Releases
- SBOM generation (syft)
- Image signing (Cosign)
- SLSA provenance attestation

### Exercise 7: Secrets Management
- Replace `.env` injection into K8s manifests
- Implement Sealed Secrets or SOPS
- Vault integration for production

### Exercise 8: Policy as Code
- OPA/Gatekeeper policies for K8s
- Enforce: no root containers, all images signed, resource limits required
- CI check for policy compliance

---

## Career Roadmap

### Months 1-3: Foundation (Current)
- [x] CI/CD security gates
- [x] Container scanning
- [x] Secrets detection
- [ ] Dockerfile hardening (Exercise 2)
- [ ] Dependabot (Exercise 3)
- [ ] Branch protection (Exercise 4)

### Months 4-6: Cloud + K8s Security
- [ ] AWS fundamentals (EC2, S3, IAM, EKS)
- [ ] K8s security (Exercises 5)
- [ ] Terraform/ IaC security
- [ ] Get Terraform Associate or AWS Security cert

### Months 7-12: Advanced
- [ ] Secrets management (Exercise 7)
- [ ] Policy as code (Exercise 8)
- [ ] Supply chain security (Exercise 6)
- [ ] Incident response simulation
- [ ] Open-source security contribution
- [ ] Apply to "DevOps with security focus" roles

---

## Interview-Ready Evidence

By the end of this journey, you can say:

- "I built security gates that caught 3 leaked secrets in a production repo"
- "I designed a CI pipeline that scans dependencies, blocks CRITICAL CVEs, and tracks HIGH ones"
- "I implemented pre-commit hooks that prevent secrets from being committed locally"
- "I secured Kubernetes manifests with securityContexts, resource limits, and network policies"
- "I managed secrets for a multi-environment K8s platform using [Vault/SOPS]"
- "I contributed to securing an open-source tool used by developers"

---

*This document is updated after each session. Keep it with you.*
