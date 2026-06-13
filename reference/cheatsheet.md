# DevSecOps Cheatsheet

---

## gitleaks

### Install from release
```bash
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.24.0/gitleaks_8.24.0_linux_x64.tar.gz | tar xz -C /usr/local/bin
```

### Manual Testing (Local)
```bash
# Install
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.24.0/gitleaks_8.24.0_linux_x64.tar.gz | tar xz -C /usr/local/bin

# Scan current files only (what the PR sees)
gitleaks protect --source .

# Scan all git history (what a push sees)
gitleaks detect --source .

# With SARIF output for upload
gitleaks detect --source . --report-format sarif --report-path gitleaks.sarif
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
| Command | What it scans | When to use |
|---|---|---|
| `protect` | Current file contents only | PRs — fast, catches what's in the diff |
| `detect` | All commits in git history | Pushes to main — thorough, catches deleted secrets |
| `detect --log-opts "A..B"` | Commits between A and B | PRs without full history |

### Gotcha: Organization repos require paid license
- `gitleaks/gitleaks-action@v2` on GitHub Actions requires paid license for orgs
- Solution: install the CLI binary directly (see Install above)

---

## Trivy

### Manual Testing (Local)
```bash
# Install
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Scan dependencies — blocks on CRITICAL
trivy fs . --severity CRITICAL --exit-code 1

# Scan dependencies — show HIGH too (won't fail)
trivy fs . --severity HIGH

# SARIF output for GitHub Security tab
trivy fs . --severity CRITICAL,HIGH --format sarif --output trivy-report.sarif
```

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

### Manual Testing (Local)
```bash
# Install
pip install pre-commit
pre-commit install          # installs hooks for this repo

# Run against ALL files (for testing)
pre-commit run --all-files

# Run against SPECIFIC files only
pre-commit run --files .github/workflows/trivy-scan.yml

# Skip a specific hook (for testing)
SKIP=semgrep pre-commit run --all-files
```

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

---

## Local Testing Workflow

The order to test before pushing to GitHub:

```bash
# 1. Pre-commit (runs automatically on commit, but test manually too)
pre-commit run --all-files

# 2. gitleaks (catches secrets before push)
gitleaks protect --source .

# 3. Trivy (catches CVEs before push)
trivy fs . --severity CRITICAL --exit-code 1

# If all three pass locally → they'll pass on GitHub (95% of the time)
```

### When to use each test

| When | What to run | Why |
|---|---|---|
| Before every commit | pre-commit (auto) | Catches formatting, secrets, bad YAML |
| Before every push | gitleaks + Trivy | Catches secrets + CVEs that pre-commit misses |
| Before opening PR | Push to test branch, check `gh run list` | Final verification on actual GitHub runners |
| When CI fails | `gh run view <id> --log-failed` | See exact error, fix locally, re-test |
