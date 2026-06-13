# Session 2 — Security Gates Built
**Date:** 2026-06-13
**Branch:** `feature/devsecops-pipeline`

---

## What We Built

### 1. Trivy Container Scanning CI

**File:** `.github/workflows/trivy-scan.yml`

**What it does:**
- Scans the LaraKube CLI tool's own dependencies (Composer + npm lockfiles)
- Blocks pipeline on CRITICAL CVEs
- Tracks HIGH CVEs in GitHub Security tab (SARIF upload)
- Runs on all branches (push) and main/develop (PR)

**Key config:**
```yaml
scan-type: 'fs'
scan-ref: '.'
severity: 'CRITICAL'        # blocks
# SARIF scan uses 'CRITICAL,HIGH'  # tracks
```

**Lessons:**
- Don't scan base images — scan the tool's own dependencies
- Trivy severity uses `CRITICAL,HIGH` (no space after comma)
- `if: always()` on SARIF upload so reports upload even on failure
- Use `scan-ref` for filesystem scans, not `image-ref`

### 2. gitleaks Secrets Scanning

**File:** `.github/workflows/secrets-scan.yml`

**What it does:**
- Installs gitleaks from release (v8.24.0, linux x64)
- PRs: `gitleaks protect` — scans current file contents
- Pushes: `gitleaks detect` — scans all git history
- Both upload SARIF to GitHub Security tab

**Why protect vs detect:**
- `protect` = scan the working tree (what files look like now)
- `detect` = scan all commits in history (including deleted files)
- Upstream had 3 real secrets in old commits — detect catches them on push

**gitleaks install URL:**
```
https://github.com/gitleaks/gitleaks/releases/download/v8.24.0/gitleaks_8.24.0_linux_x64.tar.gz
```
- Not `amd64` — gitleaks uses `x64` for Linux
- Not `latest` — pin the version

**Organization license:**
- gitleaks GitHub Action (`gitleaks/gitleaks-action@v2`) requires paid license for org repos
- Solution: install the CLI binary directly instead

### 3. Pre-Commit Hooks

**File:** `.pre-commit-config.yaml`

**Hooks configured:**
1. YAML validation
2. JSON validation
3. End-of-file fixer (ensures files end with newline)
4. Trailing whitespace stripper
5. gitleaks (secrets detection)
6. semgrep SAST (OWASP Top 10)

**Exclude pattern:**
```yaml
exclude: ^(vendor|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
```
- Don't exclude `.github/` — you WANT gitleaks to scan workflow files
- Don't exclude `.git/` — pre-commit already skips it internally

**pre-commit-ci.yml:**
- No PHP setup needed — pre-commit installs its own tools
- PHP/composer steps were dead weight

### 4. Drive-by Fixes

Fixed pre-existing upstream issues that pre-commit caught:
- `resources/views/docker/php.blade.php` — trailing whitespace
- `resources/views/k8s/viteserver.blade.php` — missing newline at EOF
- `storage/app/.gitignore` — missing newline at EOF
- `storage/framework/views/.gitignore` — missing newline at EOF

Commands used:
```bash
sed -i 's/[[:space:]]*$//' file.blade.php   # strip trailing whitespace
echo "" >> file                              # add missing newline
```

---

## Real Secrets Found

gitleaks detected **3 real secrets** in upstream git history:
- Commit `a8dbd23`: "test: add config file with secrets (should be caught by gitleaks)"
- Commit `6563fb1`: "remove test secrets file" (tried to clean up, but secrets still in history)

**Lesson:** Deleting a file in git doesn't erase its history. Anyone who clones can still find the secrets.

---

## CI Debugging Commands

```bash
# List recent workflow runs
gh run list --limit 5

# List runs for a specific repo
gh run list --repo owner/repo --limit 5

# View a specific run's summary
gh run view <run-id>

# View only failed step logs
gh run view <run-id> --log-failed

# Download full logs (via API)
curl -s -L -H "Authorization: token $(gh auth token)" \
  "https://api.github.com/repos/owner/repo/actions/runs/<run-id>/logs" \
  -o logs.zip && unzip logs.zip
```

---

## Git Commands Used Today

```bash
# Soft reset — keeps file changes, unstages commits
git reset --soft upstream/main

# Amend — replace the last commit with current staged changes
git commit --amend --no-edit

# Force push with safety net
git push --force-with-lease

# Why --force-with-lease and not --force?
# --force-with-lease checks the remote hasn't changed since your last fetch
# If someone pushed while you were working, it REJECTS instead of overwriting
```

---

## PR Submitted

- All 4 CI checks passing:
  - ✅ Secrets Scan (gitleaks)
  - ✅ Container Security Scan (Trivy)
  - ✅ CI (existing tests)
  - ✅ Pre-Commit Checks
