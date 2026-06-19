# 🔒 DevSecOps Workflows

This folder contains GitHub Actions workflows for automated security scanning.

## 📁 Workflows

| File | Purpose | Runs On |
|------|---------|---------|
| `trivy-scan.yml` | Scan dependencies for CVE vulnerabilities | Push + PR to main |
| `gitleaks-scan.yml` | Detect secrets (API keys, tokens, passwords) | Push + PR to main |
| `docker-best-practices.yml` | Combined pipeline (Gitleaks + Trivy + CodeQL) | Push + PR to main |

---

## 🚀 Quick Start

These workflows run automatically when you push to `main` or open a PR.

No manual setup required — GitHub Actions picks up any `.yml` file in `.github/workflows/`.

---

## 📖 How Each Workflow Works

### Trivy Scan
```
Purpose:  Find known vulnerabilities in your dependencies
Tool:     Trivy (aquasecurity/trivy-action)
Output:   GitHub Security tab (SARIF format)
Filters:  Only CRITICAL and HIGH severity
```

### Gitleaks Scan
```
Purpose:  Stop secrets from being committed
Tool:     Gitleaks (gitleaks/gitleaks-action)
Mode:     detect (scans existing code in CI)
Blocks:   Push/PR if secrets found
```

### Combined Pipeline
```
Purpose:  Run all security scans in parallel
Tools:    Gitleaks + Trivy + CodeQL
Speed:    Faster than sequential (parallel execution)
Best for: Production projects
```

---

## 🔧 Customization

### Change severity filter (trivy-scan.yml)
```yaml
severity: 'CRITICAL,HIGH'  # Change to include MEDIUM
```

### Change scan directory (trivy-scan.yml)
```yaml
scan-ref: './src'  # Scan only src folder
```

### Disable a workflow
Rename file extension: `trivy-scan.yml` → `trivy-scan.yml.disabled`

---

## 📚 Related Documentation

See also:
- `exercises/01-recap-security-gates.md` — Full exercise with learning material
- `reference/cheatsheet.md` — CLI tool commands
- `roadmap.md` — Learning path