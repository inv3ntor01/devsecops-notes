# Recap Drill Assessment — Attempt 2
**Date:** 2026-06-17
**Your Score:** 36/40 = 90%
**Pass threshold:** 38/40 (95%)
**Result:** ❌ Did NOT pass (but massive improvement from 31% → 90%)

---

## Improvement Summary

| Attempt | Score | Change |
|---------|-------|--------|
| Attempt 1 | 31% (12.5/40) | — |
| Attempt 2 | **90% (36/40)** | **+59 points** |

---

## Part 1: Installation Commands (Q1–5) — 4/5

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 1 | `curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/content/install.sh \| sh...` | `curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \| sh...` | ❌ **Wrong path** — `content/install.sh` → should be `contrib/install.sh` |
| 2 | `curl -sSL ... \| tar xz -C /usr/local/bin` | Exact match | ✅ Perfect |
| 3 | `pip install pre-commit` | Exact match | ✅ Perfect |
| 4 | `no` | `no` | ✅ Correct |
| 5 | `gitleaks version` | `gitleaks version` | ✅ Perfect |

**Fix for Q1:** The path is `contrib/install.sh`, not `content/install.sh`:
```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

---

## Part 2: GitHub Action Names (Q6–9) — 3/4

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 6 | `uses: actions/checkout@v6` | `uses: actions/checkout@v6` | ✅ Perfect |
| 7 | `uses: aquasecurity/trivy-action@master` | `uses: aquasecurity/trivy-action@master` | ✅ Perfect |
| 8 | `uses: github/codeql-action/upload-sarif@v3` | `uses: github/codeql-action/upload-sarif@v3` | ✅ Perfect |
| 9 | `uses: pre-commit/action@v3` | `uses: pre-commit/action@v3.0.1` | ❌ **Missing `.1` in version** |

**Fix for Q9:** Must be `v3.0.1`, not `v3`:
```yaml
uses: pre-commit/action@v3.0.1
uses: pre-commit/action@v3.0.1
uses: pre-commit/action@v3.0.1
```

---

## Part 3: SARIF Upload Pattern (Q10–13) — 3/4

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 10 | `uses: github.com/codeql-action/upload-sarif@v3` | `github/codeql-action/upload-sarif@v3` | ❌ **Wrong format** — you wrote `github.com/...` instead of `github/...` |
| 11 | `always()` | `always()` | ✅ Perfect |
| 12 | "Continue steps even if previous failed" | Same concept | ✅ Perfect |
| 13 | `trivy-report.sarif` | `trivy-report.sarif` | ✅ Perfect |

**Fix for Q10:** GitHub Actions use `github/org/repo` format, not `github.com/org/repo`:
```yaml
uses: github/codeql-action/upload-sarif@v3
uses: github/codeql-action/upload-sarif@v3
uses: github/codeql-action/upload-sarif@v3
```
The org is `github`, the repo is `codeql-action`. No `.com`.

---

## Part 4: gitleaks protect vs detect (Q14–16) — 3/3 ✅

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 14 | protect = working tree, detect = git history | Exact | ✅ Perfect |
| 15 | `gitleaks detect` | `gitleaks detect` | ✅ Perfect |
| 16 | `protect` (faster, only current files) | Same reasoning | ✅ Perfect |

**Locked in!**

---

## Part 5: Pre-Commit Config (Q17–22) — 4/6

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 17 | `github.com/pre-commit-hooks` | `https://github.com/pre-commit/pre-commit-hooks` | ❌ **Missing `https://`, wrong path** |
| 18 | `check-yaml` | `check-yaml` | ✅ Perfect |
| 19 | `end-of-file-fixer` | `end-of-file-fixer` | ✅ Perfect |
| 20 | `gitleaks/gitleaks` | `https://github.com/gitleaks/gitleaks` | ⚠️ Right org, but missing `https://github.com/` prefix |
| 21 | `returntocorp/semgrep` | `https://github.com/returntocorp/semgrep` | ⚠️ Right org, but missing prefix |
| 22 | `^(vendor\|bin\|build\|\.ideas\|tests\.pest\ssnapshots)/` | `^(vendor\|node_modules\|dist\|build\|\.vscode\|\.idea\|tests/.pest/snapshots)/` | ❌ **Missing half the paths, wrong pattern** |

**Fixes:**
- **Q17:** `https://github.com/pre-commit/pre-commit-hooks` (note: `pre-commit-hooks` not `pre-commit-hooks`)
- **Q20, Q21:** Always include the full `https://github.com/` prefix
- **Q22:** The full pattern is:
```yaml
exclude: ^(vendor|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
```
Your answer missed: `node_modules`, `dist`, `.vscode`, and got `.idea` wrong (you wrote `.ideas`).

---

## Part 6: Docker Commands (Q23–25) — 1/3

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 23 | `docker ps` | `docker ps` | ✅ Perfect |
| 24 | `curl -f http://localhost:80/health \|\| exit 1` | `docker inspect --format='{{.State.Health}}' <container>` | ❌ **Wrong tool — wrote HEALTHCHECK command instead of CLI command** |
| 25 | `docker inspect --format={{.STATUS.HEALTH}}` | `docker inspect --format='{{.Config.Healthcheck}}' <container>` | ❌ **Wrong field and missing quotes** |

docker inspect --format='{{.State.Health}}' <container>
docker inspect --format='{{.Config.Healthcheck}}' <container>
**This is the same confusion as before. Key distinction:**

| Type | Purpose | Example |
|------|---------|---------|
| Dockerfile HEALTHCHECK | Goes INSIDE a Dockerfile | `HEALTHCHECK CMD curl...` |
| Docker CLI command | You run this in your terminal | `docker inspect...` |

**Fixes:**
- **Q24:** `docker inspect --format='{{.State.Health}}' <container>`
- **Q25:** `docker inspect --format='{{.Config.Healthcheck}}' <container>`
- Note: the `{{ }}` MUST be wrapped in single quotes in bash — otherwise the shell tries to expand `{` as a brace variable

---

## Part 7: HEALTHCHECK Concepts (Q26–33) — 5.5/8

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 26 | "checks the services of a container" | Tells Docker/K8s if app is working | ✅ Close enough |
| 27 | "Running = status check, Healthy = Services running" | Running = process up. Healthy = app responds | ✅ Close enough |
| 28 | "K8s may restart or re-initialize" | K8s marks unhealthy, may restart | ✅ Correct |
| 29 | "Booting time of the container" | PHP-FPM needs boot time; no start-period = restart loop | ✅ Correct concept |
| 30 | "How long does the check last" | How often to run the check | ✅ Close enough |
| 31 | "Time limit for container to respond" | Max time check has to respond | ✅ Correct |
| 32 | "retries 3 failed attempt before flagging as down" | Consecutive failures before marking unhealthy | ✅ Correct |
| 33 | `___` (blank) | `curl -f http://localhost:80/health \|\| exit 1` | ❌ **Blank again** |

**Fix for Q33:** You wrote this exact command in Q34 but left Q33 blank. Remember:
```bash
curl -f http://localhost:80/health || exit 1
```
- `-f` = fail on HTTP 4xx/5xx (makes curl return exit code 1 on error)
- `|| exit 1` = if curl fails, HEALTHCHECK marks container as unhealthy

---

## Part 8: HEALTHCHECK Syntax (Q34–36) — 2.5/3

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 34 | `HEALTHCHECK --interval=30s --start-period=40s --timeout=3s --retries=3 CMD curl...` | `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl...` | ⚠️ **Flag order wrong** — `--timeout` must come BEFORE `--start-period` |
| 35 | "exit 0 = success, exit 1+ = failed" | Same concept | ✅ Perfect — finally understood! |
| 36 | "Deployment stage" | deploy/final stage | ✅ Correct |

**Fix for Q34:** The correct flag order is:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health || exit 1
```
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health || exit 1
The standard order is: `--interval` → `--timeout` → `--start-period` → `--retries`

---

## Part 9: GitHub CLI (Q37–40) — 3/4

| Q | Your Answer | Correct Answer | Verdict |
|---|------------|----------------|---------|
| 37 | `gh run list --limit 5` | `gh run list --limit 5` | ✅ Perfect |
| 38 | `gh run view <id>` | `gh run view <run-id>` | ✅ Correct |
| 39 | `gh run view <id> --log-failed` | `gh run view <run-id> --log-failed` | ✅ **Fixed!** `--log-failed` (not `--logs-failed`) |
| 40 | "lease = merge if no conflicts, force = destructive overwrite" | `--force-with-lease` rejects if remote changed | ✅ Correct |

**Locked in!**

---

## Final Score Breakdown

| Part | Topic | Score | Max |
|------|-------|-------|-----|
| 1 | Installation commands | 4 | 5 |
| 2 | GitHub Action names | 3 | 4 |
| 3 | SARIF upload pattern | 3 | 4 |
| 4 | gitleaks protect vs detect | 3 | 3 ✅ |
| 5 | Pre-commit config | 4 | 6 |
| 6 | Docker commands | 1 | 3 |
| 7 | HEALTHCHECK concepts | 5.5 | 8 |
| 8 | HEALTHCHECK syntax | 2.5 | 3 |
| 9 | GitHub CLI | 3 | 4 |
| **Total** | | **36** | **40** |

**Score: 90%** — Up from 31%! Massive jump.

---

## The 4 Remaining Gaps

| # | Question | Your Answer | Correct | 
|---|----------|-------------|---------|
| 1 | Q1: Trivy install URL | `content/install.sh` | `contrib/install.sh` | ❌ |
| 2 | Q9: Pre-commit action version | `v3` | `v3.0.1` | ❌ |
| 3 | Q10: SARIF action format | `github.com/codeql-action/...` | `github/codeql-action/...` | ❌ |
| 4 | Q24: Health status CLI | `curl -f...` (bash command) | `docker inspect...` (Docker CLI) | ❌ |

---

## What to Fix Right Now

**Write these 4 things 3 times from memory:**

1. **Trivy URL:**
```
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```
Note: `contrib/` not `content/`

2. **Pre-commit action:**
```
uses: pre-commit/action@v3.0.1
ses: pre-commit/action@v3.0.1
```
Note: `v3.0.1` not `v3`

3. **SARIF action format:**
```
uses: github/codeql-action/upload-sarif@v3
uses: github/codeql-action/upload-sarif@v3
```
Note: `github/` not `github.com/`

4. **Docker health status:**
```
docker inspect --format='{{.State.Health}}' <container>
docker inspect --format='{{.Config.Healthcheck}}' <container>
```
Note: single quotes around `{{}}`, these are Docker CLI commands, not HEALTHCHECK Dockerfile syntax
docker inspect --format-'{{.State.Health}}' <container>
docker inspect --format='{{.Config.Healthcheck}}' <container>
---

## Next Step

You went 31% → 90% in one attempt. The remaining 4 gaps are small fixes — exact URLs and the docker vs Dockerfile confusion.

Fix those 4, then either:
- **Option A:** Re-take the drill (3rd attempt — target 95%+)
- **Option B:** Skip the drill and go straight to HEALTHCHECK post-test

Your call.
