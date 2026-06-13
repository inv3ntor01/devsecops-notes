# Session 2B — Practice & Manual Testing
**Date:** 2026-06-13 (afternoon)
**Focus:** Memory exercises, manual tool testing, cheatsheet update

---

## Practice Exercises

### Trivy Workflow — From Memory
- First attempt: 1 line only (couldn't remember structure)
- Second attempt: Wrote conceptual explanation correctly
- Third attempt: Wrote full YAML using VS Code autocomplete
  - **Problem:** AI generated wrong patterns (`fetch-contents: true`, wrong action versions, wrong scan-type)
  - **Lesson:** Autocomplete while learning produces confidence-wrong code

**Final result:** Able to write correct Trivy workflow with correct values:
- `scan-type: 'fs'` (not `filesystem`)
- `exit-code: '1'`
- Two Trivy steps: table (blocks) + SARIF (tracks)

### Gitleaks Workflow — From Memory
- First attempt: Stopped at `permissions:` — forgot the rest
- Identified specific gaps: install URL, protect vs detect commands, SARIF upload
- Second attempt: Filled in from memory with `???` for gaps
- **Final result:** Complete working gitleaks workflow:
  - Correct URL: `gitleaks_8.24.0_linux_x64.tar.gz`
  - `gitleaks protect` for PRs
  - `gitleaks detect` for pushes
  - Matching SARIF filename in upload step

---

## Manual Tool Testing (Local Verification)

Instead of relying on CI every time, test the actual tools locally.

### gitleaks — Local Testing
```bash
# Install
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.24.0/gitleaks_8.24.0_linux_x64.tar.gz | tar xz -C /usr/local/bin

# Scan current files only (like PR check)
gitleaks protect --source .

# Scan all git history (like push check)
gitleaks detect --source .

# With SARIF output
gitleaks detect --source . --report-format sarif --report-path gitleaks.sarif
```

### Trivy — Local Testing
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

### pre-commit — Local Testing
```bash
# Install
pip install pre-commit
pre-commit install

# Run against all files
pre-commit run --all-files

# Run against specific files
pre-commit run --files .github/workflows/trivy-scan.yml

# Skip a specific hook (for testing)
SKIP=semgrep pre-commit run --all-files
```

### The Testing Workflow
```
Before commit:     pre-commit runs automatically (catches 80%)
Before push:       Run gitleaks + Trivy manually (catches 95%)
Before PR:         Push to test branch, verify on GitHub (final check)
```

---

## Key Concept: protect vs detect

| Command | What it scans | When to use |
|---|---|---|
| `gitleaks protect` | Current file contents only | PRs — fast, catches what's in the diff |
| `gitleaks detect` | All commits in git history | Pushes to main — thorough, catches deleted secrets |

**Critical insight:** Deleting a file does NOT remove it from git history. `gitleaks detect` found 3 secrets in commits that someone tried to clean up.

---

## What I Learned About Myself

- **Concept understanding:** Strong — I know what each tool does and why
- **Execution from memory:** Weak at first, improving with practice
- **AI autocomplete trap:** VS Code produced wrong code that looked right — don't use it while learning
- **Practice method that works:** Write blanks (`???`), fill from memory, then check source
- **Biggest gap:** Exact syntax/versions (scan-type, action versions, URL filenames)
