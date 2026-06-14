# Recap Exercise — Security Gates

**Before you peek at the source files, fill in every `???` from memory.**

---

## Part 1: Trivy CI Workflow

Fill in the missing pieces of the Trivy filesystem scanning workflow.

```yaml
name: Container Security Scan

on:
  push:
    branches: ['**']
  pull_request:
    branches: [ main, develop ]

permissions:
  contents: read

jobs:
  trivy:
    runs-on: ubuntu-latest
    steps:
      - uses: ???

      # Scan 1: Block on CRITICAL
      - uses: ???
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: sarif
          severity: CRITICAL
          exit-code: 1

      # Scan 2: Upload SARIF for HIGH + CRITICAL (always runs)
      - uses: ???
        if: always()
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: sarif
          severity: CRITICAL,HIGH
          output: 

      # Upload SARIF to GitHub Security tab
      - uses: ???
        if: ???
        with:
          sarif_file: ???
```

### Concept questions:
1. Why are there TWO Trivy steps instead of one? the first one is for console test and stops the pipeline when it catches a severity CRITICAL and the other one is for github actions to display the output for sevirity HIGH. 
2. Why `scan-type: 'fs'` and not `scan-type: 'image'` for this project? fs stands for file-system while image scan is for docker images.
3. Why `if: always()` on the SARIF step? It keeps the scan even if it hits a severity HIGH
4. What's the difference between `exit-code: '1'` and not setting it? exit-code: 1 stops the code when it captures what you set above it.

---

## Part 2: gitleaks Secrets Scanning

Fill in the gitleaks workflow.

```yaml
name: Secrets Scan

on:
  push:
    branches: [ '**' ]
  pull_request:
    branches: [ main, develop ]

permissions:
  contents: read

jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: ???

      # Install gitleaks
      - name: Install gitleaks
        run: |
          curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar xz -C gitleaks

      # Scan (PR mode: protect)
      - name: Run gitleaks (PR)
        if: github.request.method == 'PR'
        run: |
          gitleaks protect --source . --report-format sarif-pr-gitleaks.sarif --report-path sarif-pr-gitleaks.sarif

      # Scan (Push mode: detect)
      - name: Run gitleaks (push)
        if: github.request.method == 'push'
        run: |
          gitleaks detect --source . --report-format sarif-gitleaks.sarif --report-path sarif-gitleaks.sarif

      # Upload SARIF
      - uses: ???
        if: ???
        with:
          sarif_file: ???
```

### Concept questions:
1. What's the difference between `protect` and `detect`? When is each used? protect stops the uploading of the code if it detects any vulnerability from the code and detect shows the vulnerability detected from the uploaded code.
2. Why did we install gitleaks from the release URL instead of using `gitleaks/gitleaks-action@v2`? dependency issues and outdated version.
3. Why is the download URL `linux_x64` and not `linux_amd64`? linux distros uses x64 while arm architecture devices uses amd64 like macos and raspberrypi
4. What happened when gitleaks ran against the upstream repo? (How many secrets? What did that teach us?) it captures 4 secrets from the history.

---

## Part 3: Pre-Commit Config

Fill in the `.pre-commit-config.yaml` structure.

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: ???
    hooks:
      - id: ???           # validates YAML syntax
      - id: ???           # validates JSON syntax
      - id: ???           # ensures files end with newline
      - id: ???           # removes trailing whitespace

  - repo: ???
    rev: ???
    hooks:
      - id: ???           # secrets detection

  - repo: ???
    rev: ???
    hooks:
      - id: ???           # SAST scanning
      args: ???

exclude: ???
```

### Concept questions:
1. Why do we NOT exclude `.github/` from the pre-commit checks? that is the location of the workflows
2. Why do we NOT exclude `.git/`? it stores the history of git
3. What paths DOES the exclude pattern cover? (Name at least 3) test, vendor, app
4. Why doesn't the pre-commit CI action need PHP/composer setup? it uses the builtin config from the hooks.

---

## Part 4: Local Testing Commands

Write the exact commands (from memory):

1. Install Trivy locally: `sudo apt install trivy`
2. Scan for CRITICAL CVEs (blocks): `trivy fs . --severity CRITICAL`
3. Scan for HIGH + CRITICAL (SARIF output): `trivy fs . --severity CRITICAL,HIGH`
4. Install gitleaks locally: `sudo apt install gitleaks`
5. Scan current files (what a PR sees): `gitleaks `
6. Scan all git history (what a push sees): `___`
7. Install pre-commit: `sudo apt install pre-commit`
8. Run pre-commit against all files: `___`
9. Run pre-commit against a specific file: `___`
10. Skip a hook during testing: `___`

---

## Part 5: Git Commands

1. Soft reset — keep file changes but undo commits: `git reset --soft`
2. Replace the last commit with current staged changes (no edit message): `git commit --amend --no-edits`
3. Force push with a safety net (rejects if remote changed): `git push --force-with-lease`
4. Force push that blindly overwrites (dangerous): `git push --force`
5. When should you use `--force-with-lease`? (2 scenarios) when you want to push your code without harming other devs progress and when you have the same file used on the other developer.
6. When should you NEVER force push? (2 scenarios) when you edit the same file with the other developer and on the main branch

---

## Part 6: CI Debugging

1. List recent workflow runs: `gh run list`
2. View a specific run's summary: `gh run view --logs `
3. View only failed step logs: `gh run view --logs-failed`

---

**When done, check your answers against:**
- `sessions/2026-06-13-security-gates.md`
- `sessions/2026-06-13-practice-testing.md`
- `reference/cheatsheet.md`
- The actual workflow files in the LaraKube repo

---

# ASSESSMENT (2026-06-14)

**Score: ~30–35% of blanks filled, ~50% of attempted answers were correct**

---

## Part 1: Trivy CI Workflow

| Item | My Answer | Correct Answer | Notes |
|------|-----------|----------------|-------|
| `push branches` | `['**']` | `['**']` | ✅ Correct |
| `pr branches` | `[main, develop]` | `[main, develop]` | ✅ Correct |
| `runs-on` | `ubuntu-latest` | `ubuntu-latest` | ✅ Correct |
| Checkout step | Left `???` | `actions/checkout@v4` | ❌ Must memorize this — it's the first step in every workflow |
| Trivy action | Left `???` | `aquasecurity/trivy-action@master` | ❌ Action name blank |
| `scan-type` / `scan-ref` | `'fs'` / `'.'` | `'fs'` / `'.'` | ✅ Correct |
| `exit-code` | `1` | `'1'` | ✅ Correct (quotes optional) |
| SARIF output filename | Left blank | `trivy-report.sarif` | ❌ Blank |
| Upload SARIF action | Left `???` | `github/codeql-action/upload-sarif@v3` | ❌ This same action is used in BOTH workflows |
| Upload `if` condition | Left `???` | `always()` | ❌ Blank |
| `sarif_file` value | Left `???` | `trivy-report.sarif` | ❌ Must match the `output:` field |

### Concept Q1 (two steps):
My answer: "first one is for console test and stops the pipeline when it catches a severity CRITICAL and the other one is for github actions to display the output for sevirity HIGH"
Verdict: ✅ Mostly correct. Minor fix: it's not "github actions display" — it's the **GitHub Security tab** (Code Scanning SARIF feed).

### Concept Q2 (fs vs image):
My answer: "fs stands for file-system while image scan is for docker images"
Verdict: ✅ Correct. We scan file-system dependencies (Composer/npm lockfiles), not built Docker images.

### Concept Q3 (always()):
My answer: "It keeps the scan even if it hits a severity HIGH"
Verdict: ❌ **WRONG.** `always()` means the step runs **even if the first Trivy step failed** (exited with code 1). Without it, when Trivy finds CRITICAL CVEs and fails, the SARIF upload gets skipped — and you get NO report in the Security tab. It's about step continuation, not severity filtering.

### Concept Q4 (exit-code):
My answer: "exit-code: 1 stops the code when it captures what you set above it"
Verdict: ✅ Correct. `exit-code: 1` makes the step fail (blocks pipeline) when matches are found. Without it, Trivy just prints results and exits 0.

---

## Part 2: gitleaks Secrets Scanning

| Item | My Answer | Correct Answer | Notes |
|------|-----------|----------------|-------|
| Checkout step | Left `???` | `actions/checkout@v4` | ❌ Same as Trivy — every workflow starts with checkout |
| Version | `v8.30.1` | `v8.24.0` | ⚠️ Wrong version. Version numbers are hard to memorize; focus on the URL pattern instead |
| `-C` target | `gitleaks` | `/usr/local/bin` | ⚠️ Wrong — extracting to `gitleaks` means it won't be in PATH. Must be `/usr/local/bin` |
| PR condition | `github.request.method == 'PR'` | `github.event_name == 'pull_request'` | ❌ **Wrong syntax.** GitHub Actions uses `github.event_name`, not `github.request.method` |
| Push condition | `github.request.method == 'push'` | `github.event_name == 'push'` | ❌ Same wrong syntax |
| Commands | `protect` / `detect` | `protect` / `detect` | ✅ Correct commands |
| Upload action | Left `???` | `github/codeql-action/upload-sarif@v3` | ❌ Same as Trivy workflow |
| Upload `if` | Left `???` | `always()` | ❌ Same as Trivy workflow |
| `sarif_file` | Left `???` | Must match the `--report-path` value | ❌ Must match |

### Concept Q1 (protect vs detect):
My answer: "protect stops the uploading of the code if it detects any vulnerability from the code and detect shows the vulnerability detected from the uploaded code"
Verdict: ❌ **WRONG.** Neither one controls "uploading" of code.
- **`protect`** scans the **working tree** — current file contents only (what the diff shows in a PR)
- **`detect`** scans **all git commit history** — including deleted files and old commits (catches secrets someone tried to hide by deleting)

### Concept Q2 (why not gitleaks-action):
My answer: "dependency issues and outdated version"
Verdict: ❌ **WRONG.** The real reason: `gitleaks/gitleaks-action@v2` **requires a paid organization license** for org repos on GitHub Actions. We install the CLI binary directly to bypass the license requirement.

### Concept Q3 (x64 vs amd64):
My answer: "linux distros uses x64 while arm architecture devices uses amd64 like macos and raspberrypi"
Verdict: ❌ **BACKWARDS.** `amd64` = `x86_64` (they're the same thing). `arm64` = ARM. Gitleaks just uses `x64` in their release naming for Linux x86_64 — it's a naming convention, not an architecture difference.

### Concept Q4 (secrets found):
My answer: "it captures 4 secrets from the history"
Verdict: ❌ It was **3** secrets, not 4. Found in commit `a8dbd23` (test file with secrets) and `6563fb1` (tried to clean up but secrets still in history).

---

## Part 3: Pre-Commit Config

**Every YAML blank was left as `???`** — repo URLs, rev tags, hook IDs, exclude pattern. All skipped.

### Concept Q1 (why not exclude .github/):
My answer: "that is the location of the workflows"
Verdict: ✅ Pointing in the right direction. Full answer: **we WANT gitleaks to scan workflow files** because they often contain secrets (API keys, tokens, deploy keys).

### Concept Q2 (why not exclude .git/):
My answer: "it stores the history of git"
Verdict: ❌ That's what .git/ *is*, not why we don't exclude it. Real answer: **pre-commit already skips .git/ internally** — there's no need to exclude it explicitly.

### Concept Q3 (exclude pattern covers what):
My answer: "test, vendor, app"
Verdict: ⚠️ `vendor` = correct. `test` ≈ close (`tests/`). `app` = **WRONG** — `app/` is your actual source code and SHOULD be scanned.
Real list: `vendor`, `node_modules`, `dist`, `build`, `.vscode`, `.idea`, `tests/.pest/snapshots`.

### Concept Q4 (no PHP/composer needed):
My answer: "it uses the builtin config from the hooks"
Verdict: ⚠️ Incomplete. Real answer: **pre-commit installs its own tools in isolated environments** (Python venvs, downloads semgrep, etc.). It doesn't need the host system to have PHP or composer.

---

## Part 4: Local Testing Commands

| # | My Answer | Correct Answer | Verdict |
|---|-----------|----------------|---------|
| 1. Install Trivy | `sudo apt install trivy` | `curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin` | ❌ Trivy is NOT in apt repos |
| 2. Trivy CRITICAL scan | `trivy fs . --severity CRITICAL` | `trivy fs . --severity CRITICAL --exit-code 1` | ⚠️ Missing `--exit-code 1` |
| 3. Trivy SARIF output | `trivy fs . --severity CRITICAL,HIGH` | `trivy fs . --format sarif --output trivy-report.sarif` | ⚠️ Missing `--format sarif --output` |
| 4. Install gitleaks | `sudo apt install gitleaks` | `curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.24.0/gitleaks_8.24.0_linux_x64.tar.gz | tar xz -C /usr/local/bin` | ❌ Gitleaks is NOT in apt repos |
| 5. gitleaks protect | Left blank | `gitleaks protect --source .` | ❌ Blank |
| 6. gitleaks detect | Left blank | `gitleaks detect --source .` | ❌ Blank |
| 7. Install pre-commit | `sudo apt install pre-commit` | `pip install pre-commit` | ❌ Pre-commit is a Python package, NOT in apt |
| 8. pre-commit all files | Left blank | `pre-commit run --all-files` | ❌ Blank |
| 9. pre-commit specific file | Left blank | `pre-commit run --files <path>` | ❌ Blank |
| 10. Skip hook | Left blank | `SKIP=<hook-name> pre-commit run --all-files` | ❌ Blank |

**7 out of 10 left blank. 3 attempted, all wrong or incomplete.**
Pattern: guessed `sudo apt install` for all three tools — none of them use apt. This is the biggest gap.

---

## Part 5: Git Commands

| # | My Answer | Correct Answer | Verdict |
|---|-----------|----------------|---------|
| 1. Soft reset | `git reset --soft` | `git reset --soft <target>` | ⚠️ Missing the target reference (e.g., `upstream/main`) |
| 2. Amend | `git commit --amend --no-edits` | `git commit --amend --no-edit` | ⚠️ Typo: `--no-edit` (no 's') |
| 3. Safe force push | `git push --force-with-lease` | `git push --force-with-lease` | ✅ Correct |
| 4. Unsafe force push | `git push --force` | `git push --force` | ✅ Correct |
| 5. When to use lease | "when you want to push your code without harming other devs progress and when you have the same file used on the other developer" | After `amend`, after `rebase`, on your own feature branch only | ⚠️ Conceptually right, but the specific scenarios are: after `git commit --amend` and after `git rebase` |
| 6. Never force push | "when you edit the same file with the other developer and on the main branch" | `main` or `develop`; branches others are working on | ✅ Correct |

---

## Part 6: CI Debugging

| # | My Answer | Correct Answer | Verdict |
|---|-----------|----------------|---------|
| 1. List runs | `gh run list` | `gh run list --limit 5` | ✅ (missing --limit 5 but correct command) |
| 2. View run summary | `gh run view --logs` | `gh run view <run-id>` | ❌ Wrong flag, missing run-id. `--logs` shows all logs, not summary |
| 3. Failed logs | `gh run view --logs-failed` | `gh run view <run-id> --log-failed` | ❌ Wrong flag name (`--log-failed` not `--logs-failed`), missing run-id |

---

## Summary: What's Solid vs What Needs Work

### ✅ Solid (keep this knowledge)
- Trivy workflow structure: `fs`, `CRITICAL`, two-step pattern
- `protect` = PRs, `detect` = pushes (command-to-context mapping)
- `--force-with-lease` vs `--force` distinction and rules
- `always()` exists as a CI pattern
- `github.event_name` for conditional steps

### ❌ Critical gaps (must fix before moving on)
1. **Installation commands** — all 3 tools guessed `apt install` (wrong for all). Trivy, gitleaks, and pre-commit are NOT in apt repos.
2. **Action names** — `actions/checkout@v4`, `aquasecurity/trivy-action@master`, `github/codeql-action/upload-sarif@v3` — all blank
3. **`protect` vs `detect` concept** — confused with "upload blocking" instead of "working tree vs git history"
4. **gitleaks license issue** — wrong reason for bypassing the action
5. **Pre-commit YAML structure** — entirely blank
6. **SARIF upload pattern** — blank in both workflows (same pattern!)

### The pattern: conceptual understanding is strong, execution from memory is weak
This matches Session 2B notes exactly. The fix is repetition — drill the specific gaps, not the stuff you already know.
