# DevSecOps Cheatsheet

---

## gitleaks

### Install from release
```bash
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.24.0/gitleaks_8.24.0_linux_x64.tar.gz | tar xz -C /usr/local/bin
```

### Scan modes
```bash
# Scan current file contents (for PRs)
gitleaks protect --source . --report-format sarif --report-path report.sarif

# Scan all git history (for pushes)
gitleaks detect --source . --report-format sarif --report-path report.sarif

# Only scan specific commits
gitleaks detect --source . --log-opts "main..HEAD"
```

### Key differences
| Flag | What it scans | Use case |
|---|---|---|
| `protect` | Current file contents only | PRs, fast |
| `detect` | All commits in git history | Pushes to main, thorough |
| `detect --log-opts "A..B"` | Commits between A and B | PRs without full history |

---

## Trivy

### Filesystem scan (dependencies)
```bash
trivy fs . --severity CRITICAL --exit-code 1   # block on CRITICAL
trivy fs . --severity CRITICAL,HIGH            # show both (no exit code)
```

### Container image scan
```bash
trivy image myapp:latest --severity CRITICAL --exit-code 1
```

### SARIF output (for GitHub Security tab)
```bash
trivy fs . --format sarif --output trivy-report.sarif
```

### GitHub Action
```yaml
- uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'       # or 'image'
    scan-ref: '.'         # for fs scans
    image-ref: myapp:v1   # for image scans
    format: 'sarif'
    output: 'trivy-report.sarif'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'        # makes the step fail on matches
```

---

## Pre-Commit

### Install locally
```bash
pip install pre-commit
pre-commit install          # installs hooks for this repo
pre-commit run --all-files  # run against all files (for testing)
```

### Common exclude pattern
```yaml
exclude: ^(vendor|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
```

### GitHub Action
```yaml
- uses: pre-commit/action@v3.0.1
  # No extra_args = scans changed files only on PRs
```

---

## Dockerfile Security

### Non-root user
```dockerfile
USER www-data   # never run as root in production
```

### HEALTHCHECK
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1
```

### Read-only filesystem
Set in Kubernetes pod spec, not Dockerfile:
```yaml
securityContext:
  readOnlyRootFilesystem: true
```

### Minimal base
```dockerfile
FROM serversideup/php:8.4-frankenphp-alpine  # Alpine = smaller = fewer CVEs
```

---

## Git

### Safe force push
```bash
git push --force-with-lease   # rejects if remote changed since last fetch
git push --force              # blindly overwrites (dangerous)
```

### When to use --force-with-lease
- After `git commit --amend`
- After `git rebase`
- On your own feature branch only

### Never force push to
- `main` or `develop`
- Branches others are working on

---

## GitHub CLI

```bash
# List workflow runs
gh run list --limit 5

# View run summary
gh run view <run-id>

# View failed step logs
gh run view <run-id> --log-failed

# Check PR status
gh pr checks

# Create PR
gh pr create --base main --head feature/branch --title "title" --body "body"

# Open PR in browser
gh pr view --web
```
