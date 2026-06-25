# DevSecOps Foundation — Full Review

**Date:** 2026-06-25
**Purpose:** Study all 20 topics before the post-test

---

## Section 1: CI/CD Security Gates

---

### Q1: The 3 Tools in Our Pipeline

**Question:** What are the **3 tools** we use in our combined GitHub Actions pipeline?

**Your Answer:** ✅ Gitleaks, Trivy, Semgrep

**Correct Answer:** ✅ **Gitleaks, Trivy, Semgrep**

**Explanation:**
Our combined pipeline in `docker-best-practices.yml` runs:
1. **Gitleaks** — Detects secrets/credentials in code
2. **Trivy** — Scans for vulnerabilities in OS packages and dependencies
3. **Semgrep** — Static Analysis (SAST) that finds code bugs and security issues

**Why Gitleaks ≠ Trivy:**
- Gitleaks finds things you typed (passwords, API keys)
- Trivy finds things others wrote (vulnerable libraries)
- Semgrep finds patterns in how you wrote code (insecure patterns)

---

### Q2: Gitleaks Protect vs Detect

**Question:** What's the difference between **Gitleaks protect** and **Gitleaks detect**?

**Your Answer:** ✅ Protect = working tree, Detect = git history

**Correct Answer:** ✅

**Explanation:**
- **`protect`** — Scans the **current working tree only** (staged files). Fails if secrets are found. Used in pre-commit/pre-push hooks.
- **`detect`** — Scans the **entire git history** (all commits). Used in CI to catch secrets that were committed in the past.

**Real-world use:**
- Protect: Local hook (before you push)
- Detect: CI pipeline (catches everything ever committed)

---

### Q3: Trivy Install Command

**Question:** What command installs **Trivy** on Linux?

**Your Answer:** `curl -sFL https://github.com/aquasecurity/trivy/contrib/install.sh | sh`

**Correct Answer:** `curl -sFL https://github.com/aquasecurity/trivy/releases/download/v0.50.4/contrib/install.sh | sh`

**Key mistakes in your answer:**
1. ❌ Wrong URL: `aquasecurity/trivy/contrib` should be `aquasecurity/trivy/releases/download/v0.50.4/contrib`
2. ❌ Missing version: Always pin the version (`v0.50.4`)

**The exact command:**
```bash
curl -sFL https://github.com/aquasecurity/trivy/releases/download/v0.50.4/contrib/install.sh | sh
```

**Breaking it down:**
- `curl -sF` = Follow redirects + send credentials if needed
- `L` = Follow HTTP redirects
- `https://github.com/aquasecurity/trivy/releases/download/v0.50.4/contrib/install.sh` = Direct download URL with version pinned
- `| sh` = Pipe to shell installer

---

### Q4: Pre-commit Install Command

**Question:** What command installs **pre-commit**?

**Your Answer:** `pip install pre-commit@v3.0.1` ⚠️

**Correct Answer:** `pip3 install pre-commit==3.0.1`

**Key mistakes:**
1. ❌ Used `@` instead of `==` (pip uses `==` for version pinning)
2. ⚠️ Used `pip` instead of `pip3` (safer to use `pip3` to ensure Python 3)

**The exact command:**
```bash
pip3 install pre-commit==3.0.1
```

---

### Q5: Semgrep vs Trivy (What SAST Means)

**Question:** What does **Semgrep** do that Trivy doesn't?

**Your Answer:** ❌ "checks bad code and its SAST" (incomplete)

**Correct Answer:**

**Semgrep** does **Static Application Security Testing (SAST)** — it analyzes your **source code** to find:
- Insecure coding patterns (e.g., `eval(user_input)`)
- SQL injection risks
- Hardcoded credentials in code
- Unsafe deserialization
- Auth bypass patterns

**Trivy** does **Vulnerability Scanning** — it checks:
- Known CVEs in OS packages
- Known CVEs in dependencies (npm, pip, gem, etc.)
- Misconfigurations in infrastructure (Dockerfile, Kubernetes)

**The key difference:**

| Tool | Analyzes | Finds |
|------|----------|-------|
| **Semgrep** | Source code patterns | How you wrote code (bugs, risks) |
| **Trivy** | Packages/dependencies | What others wrote that is vulnerable |

**Think of it this way:**
- Trivy: "Are there known vulnerabilities in my dependencies?"
- Semgrep: "Did I write my code in a secure way?"

---

## Section 2: GitHub Actions

---

### Q6: SARIF Category Format

**Question:** What is the **correct format** for uploading a SARIF result to GitHub?

**Your Answer:** `sarif-report.sarif`

**Correct Answer:** `github-dashboard/sarif-report.sarif` or `semgrep/sarif-report.sarif`

**Key mistake:** The `category` field should identify **which tool** produced the report, not just the filename.

**Why it matters:**
- GitHub shows results grouped by category in the Security tab
- Multiple tools can upload SARIF → need to distinguish them
- Format: `tool-name/report-category.sarif`

**The exact format from our workflow:**
```yaml
- name: Upload Semgrep results
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: semgrep.sarif
    category: "semgrep-rules/"
```

Note: In our combined pipeline, the category was `github-dashboard/semgrep/` to distinguish from CodeQL.

---

### Q7: Upload-SARIF Permissions

**Question:** What permission does the `upload-sarif` step need?

**Your Answer:** ⚠️ "write and read permission"

**Correct Answer:** `actions: read` (minimum required)

**Key mistake:** We don't need full `write` permission — just `actions: read`.

**The complete permissions block:**
```yaml
permissions:
  contents: read      # Required for checkout
  actions: read       # Required for upload-sarif
  security-events: write  # Required for GitHub Security tab
```

**Why this matters:**
- GitHub Actions runs with minimal permissions by default
- `upload-sarif` needs to read action metadata
- `security-events: write` lets GitHub display results in the Security tab

---

### Q8: Safe Force Push

**Question:** What is the **safe** way to force push?

**Your Answer:** ✅ `git push --force-with-lease`

**Correct Answer:** ✅ **Correct!**

**Why `--force-with-lease` is safe:**
- Regular `--force` overwrites remote even if someone else pushed
- `--force-with-lease` checks if anyone else pushed since you last fetched
- If someone else pushed → push fails (protects their work)

**Best practice:**
```bash
# Safe force push
git push --force-with-lease

# Even safer (specify branch)
git push --force-with-lease origin feature-branch
```

---

### Q9: Why Rebase Over Merge

**Question:** Why do we prefer **rebase** over merge when pulling?

**Your Answer:** ⚠️ "checks unconflicting codes before merging"

**Correct Answer:**

Rebase rewrites commit history to create a **linear, clean history** instead of merge commits.

**Visual comparison:**

```
MERGE (creates merge commit):
        A---B---C  (feature)
       /         \
main:  D---E---F---M  (merge commit)
                  
REBASE (rewrites history):
main:  D---E---F
              \
feature:        A'--B'--C' (rewritten commits)
```

**Why rebase is preferred in CI/CD:**
1. **Clean git log** — No merge commits cluttering history
2. **Clear linear progression** — Easy to trace when features were added
3. **Avoids merge conflicts later** — Conflicts resolved one commit at a time
4. **Better for bisect** — `git bisect` works better with linear history

**Your answer was close** — rebase does help avoid messy conflicts, but the main reason is **clean, linear history**.

---

## Section 3: Docker Hardening

---

### Q10: HEALTHCHECK Instruction

**Question:** Write the full **HEALTHCHECK** instruction.

**Your Answer:** ⚠️ `HEALTHCHECK --interval=30s --timeout=40s --retries=3 CMD curl -f http://localhost:80/up || exit-code 1`

**Correct Answer:**
```
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost/health || exit 1
```

**Your mistakes:**
1. ❌ `--timeout=40s` should be `--timeout=3s` (3 seconds, not 40!)
2. ❌ `--start-period=40s` is missing
3. ⚠️ Port is `/80/health` not `/up`
4. ⚠️ `exit-code` should be `exit` (no hyphen)

**The exact HEALTHCHECK:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost/health || exit 1
```

**What each flag means:**
- `--interval=30s` — Check every 30 seconds
- `--timeout=3s` — Fail if no response in 3 seconds
- `--start-period=40s` — Don't count failures during startup (give app time to boot)
- `--retries=3` — Mark container unhealthy after 3 consecutive failures

**Why `-f` in `curl -f`:**
- `curl -f` makes curl fail with exit code 22 if HTTP response is 4xx/5xx
- Without `-f`, curl would return 0 even if the app is broken

---

### Q11: Why curl -f

**Question:** Why do we use `curl -f` in HEALTHCHECK?

**Your Answer:** ✅ "returns failed if check didn't respond"

**Correct Answer:** ✅ **Correct!**

**The `-f` flag:**
- `-f` = Fail silently on HTTP errors (4xx, 5xx)
- Without `-f`: HTTP 500 returns exit code 0 (success) — WRONG
- With `-f`: HTTP 500 returns exit code 22 (failure) — CORRECT

**Real-world example:**
```bash
# Without -f (wrong)
curl http://localhost/health    # Returns 0 even if app is down

# With -f (correct)
curl -f http://localhost/health # Returns 22 if app returns 500
```

---

### Q12: Docker CLI vs Dockerfile

**Question:** What is the **difference** between Docker CLI and Dockerfile?

**Your Answer:** ✅ "CLI = terminal commands, Dockerfile = build instructions"

**Correct Answer:** ✅ **Perfect!**

**Docker CLI** — Commands you type in terminal:
```bash
docker run nginx
docker exec -it container bash
docker logs -f container
docker network create my-net
```

**Dockerfile** — Recipe for building images:
```dockerfile
FROM nginx:alpine
COPY ./html /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Think of it as:**
- CLI = Your voice commands to Docker
- Dockerfile = Written instructions for Docker to follow

---

### Q13: Docker Hardening Best Practices

**Question:** Name **3 Docker hardening best practices**.

**Your Answer:** ✅ Non-root, healthcheck, no vulnerabilities

**Correct Answer:** ✅ **All correct!**

**The 3 you mentioned:**
1. ✅ **Non-root user** — Don't run as root (security breach = full system access)
2. ✅ **HEALTHCHECK** — Know when your app is broken
3. ✅ **No vulnerabilities** — Scan with Trivy before deploying

**Complete Docker hardening checklist:**
```dockerfile
# 1. Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# 2. Read-only filesystem
docker run --read-only ...

# 3. HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost/health

# 4. Drop capabilities
docker run --cap-drop=ALL ...

# 5. No new privileges
docker run --security-opt=no-new-privileges:true ...

# 6. Scan for vulnerabilities
trivy image myapp:latest
```

---

## Section 4: Dependabot

---

### Q14: Dependabot Ecosystems

**Question:** What **two ecosystems** does our Dependabot config cover?

**Your Answer:** ❌ "Main and Develop branches" (wrong!)

**Correct Answer:** **Composer (PHP) and npm (JavaScript)**

**Your mistake:** You confused **ecosystems** with **branches**.

**Ecosystems** = Programming language/package managers:
- Composer (PHP)
- npm (JavaScript)
- pip (Python)
- bundler (Ruby)
- maven (Java)
- cargo (Rust)

**Branches** = Git branches (main, develop, feature-*)

**Our Dependabot config (`dependabot.yml`):**
```yaml
version: 2
updates:
  - package-ecosystem: "composer"  # PHP dependencies
    directory: "/"
    schedule:
      interval: "weekly"
    
  - package-ecosystem: "npm"       # JavaScript dependencies
    directory: "/"
    schedule:
      interval: "weekly"
```

---

### Q15: Renovatebot vs Dependabot

**Question:** What does **Renovatebot** do that Dependabot can't?

**Your Answer:** ❌ "I don't know"

**Correct Answer:**

**Renovatebot** has these advantages over Dependabot:

| Feature | Dependabot | Renovatebot |
|---------|------------|-------------|
| Auto-merge | Limited | ✅ Full control |
| Batch updates | ❌ One PR per dependency | ✅ Group multiple PRs |
| Custom scheduling | Weekly/daily | ✅ Any schedule |
| Monorepo support | Basic | ✅ Advanced |
| Post-create automations | ❌ | ✅ (rebase, comment, label) |
| Major version handling | Limited | ✅ Configurable grouped updates |
| Language support | Fewer | ✅ More ecosystems |
| Self-hosted option | ❌ | ✅ |

**The key difference most people cite:**
> Renovatebot can **auto-merge** minor/patch updates without any human approval, while Dependabot requires manual merging (or GitHub Actions automation).

**When to use which:**
- **Dependabot** — Simple projects, GitHub-native, no extra config needed
- **Renovatebot** — Complex projects, monorepos, need more control

---

### Q16: Security Update vs Regular Update

**Question:** What is a **security update** PR in Dependabot?

**Your Answer:** ✅ "detects vulnerability and requests update"

**Correct Answer:** ✅ **Correct!**

**Security update PR:**
- Triggered automatically when GitHub detects a CVE affecting your dependency
- Dependabot creates a PR immediately (not on schedule)
- Labeled with `security` tag
- GitHub can auto-merge if `open-pull-requests-limit: 0` is set

**Regular version update PR:**
- Created on your schedule (weekly, daily)
- Updates to latest version (may include breaking changes)
- Labeled with `dependencies` tag

**Visual:**
```
Security Update:     "Fix CVE-2024-1234 in lodash" → IMMEDIATE
Regular Update:      "Update lodash 4.17.15 → 4.17.21" → WEEKLY
```

---

## Section 5: Git Security

---

### Q17: Branch Protection Rules

**Question:** What **branch protection rule** does our repo have?

**Your Answer:** ⚠️ "Force push and you must PR for review"

**Correct Answer:** Our repo has:
1. ✅ **Require pull request reviews before merging** (at least 1 approval)
2. ✅ **Require status checks to pass before merging** (CI must pass)
3. ✅ **Include administrators** (even admins must follow rules)
4. ✅ **Do NOT allow force pushes** to main

**Your answer was partially correct** — yes to PR review, but the key rule is **no force pushes to main**.

**Why no force pushes to main:**
- Main branch = source of truth
- Force push rewrites history
- Could delete everyone's work
- CI history becomes invalid

---

### Q18: Why Never Force Push Main

**Question:** Why should you **never force push to main**?

**Your Answer:** ⚠️ "It may BREAK or Fix a bug"

**Correct Answer:**

**Never force push to main because:**

1. **Rewrites history** — Changes commit hashes of ALL subsequent commits
2. **Breaks other people's clones** — Their local history doesn't match remote
3. **Invalidates CI/CD** — GitHub Actions commits don't match anymore
4. **Can delete work** — Force push can overwrite others' commits
5. **Violates audit trail** — You lose the true history of changes

**The damage:**
```bash
# You force push to main
git push --force origin main

# Now:
# - Your colleague pulls → their history is broken
# - CI pipelines fail → commit hashes changed
# - PR merge commits are orphaned → broken history
# - You CANNOT recover if something went wrong
```

**Your answer mentioned "BREAK"** which is partially right — it can break CI/CD and collaborators' local repos.

---

## Section 6: Miscellaneous

---

### Q19: set -euo pipefail

**Question:** What does `set -euo pipefail` do?

**Your Answer:** ⚠️ Partial explanation

**Correct Answer:**

```bash
set -euo pipefail
```

| Flag | Name | What it does |
|------|------|--------------|
| `-e` | Exit on error | Script exits immediately if ANY command fails (non-zero exit) |
| `-u` | Unset variable error | Script exits if you use an undefined variable (e.g., `$UNDEFINED`) |
| `-o pipefail` | Pipefail | Script fails if ANY command in a pipeline fails (not just the last one) |

**Examples:**

```bash
# Without -e: continues even if command fails
false
echo "This still runs"

# With -e: exits immediately
set -e
false
echo "This does NOT run"

# Without -u: silent empty variable
echo "Hello $UNDEFINED_VAR"  # Prints: "Hello "

# With -u: crashes on undefined
set -u
echo "Hello $UNDEFINED_VAR"  # Error: UNDEFINED_VAR: unbound variable

# Without -o pipefail: ignores failed commands in pipe
false | true | echo "success"  # Prints "success"

# With -o pipefail: fails if ANY command fails
set -o pipefail
false | true | echo "success"  # Exits with error
```

**Why all three together:**
- `-e` catches command failures
- `-u` catches typo variables
- `-o pipefail` catches failures buried in pipes

**Best practice for DevOps scripts:**
```bash
#!/bin/bash
set -euo pipefail
```

---

### Q20: .semgrepignore

**Question:** What is the `.semgrepignore` file for?

**Your Answer:** ✅ "ignores SAST scanning like .gitignore"

**Correct Answer:** ✅ **Perfect!**

**`.semgrepignore`** tells Semgrep to skip certain files/directories during scanning — just like `.gitignore`.

**Common entries:**
```
# Skip generated code
vendor/
node_modules/
dist/
build/

# Skip test files (sometimes)
*_test.go
*.test.ts
tests/

# Skip documentation
*.md
docs/
```

**Why it matters:**
- Speeds up scans (skip large vendor folders)
- Reduces false positives (generated code has known patterns)
- Focuses on YOUR code, not dependencies

---

## Summary: Key Corrections

| Q# | Topic | Your Mistake | Correct Answer |
|----|-------|--------------|----------------|
| 3 | Trivy install | Wrong URL | `.../trivy/releases/download/v0.50.4/contrib/install.sh` |
| 4 | Pre-commit install | `@` instead of `==` | `pip3 install pre-commit==3.0.1` |
| 5 | Semgrep purpose | Incomplete | Analyzes code patterns for bugs (SAST), not package vulnerabilities |
| 6 | SARIF format | Missing prefix | `github-dashboard/sarif-report.sarif` |
| 7 | SARIF permissions | "write and read" | `actions: read` (minimum) |
| 9 | Rebase reason | Incomplete | Creates linear, clean history (not just conflict handling) |
| 10 | HEALTHCHECK | Wrong flags | `--interval=30s --timeout=3s --start-period=40s --retries=3` |
| 14 | Dependabot ecosystems | Confused with branches | Composer + npm (package managers) |
| 15 | Renovatebot | Didn't know | Auto-merge, batching, monorepo support |
| 17 | Branch protection | Incomplete | No force pushes + require PR reviews + require CI passing |
| 18 | Force push danger | Incomplete | Rewrites history, breaks clones, invalidates CI |
| 19 | set -euo pipefail | Partial | `-e` = exit on error, `-u` = exit on undefined var, `-o pipefail` = pipe failures |

---

**When ready, let me know and I'll create the Post-Test (Exercise 10)!**
