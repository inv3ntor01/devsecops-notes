# Recap Drill Assessment — All DevSecOps Foundations
**Date:** 2026-06-17
**Your Score:** 12.5/40 = 31%
**Pass threshold:** 38/40 (95%)
**Result:** ❌ Did NOT pass

---

## Part 1: Installation Commands (Q1–5) — 1.5/5

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 1 | `curl -sfL https://github.com/orgs/aquasecurity/packages/container/package/trivy \| sh -s -- -b /usr/local/bin` | `curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \| sh -s -- -b /usr/local/bin` | 0 |
| 2 | `curl -sfL ...gitleaks... \| tar -xz -C /usr/local/bin` | `curl -sSL ... \| tar xz -C /usr/local/bin` | 0 |
| 3 | `pip install pre-commit` | `pip install pre-commit` | 1 |
| 4 | `no` | `no` | 1 |
| 5 | `gitleaks --version` | `gitleaks version` | 0.5 |

### What went wrong:
- **Q1:** Wrong URL — that's a container registry URL, not the install script. Correct URL is `raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh`
- **Q2:** Wrong flags — should be `-sSL` (capital S), not `-sfL`. Also `tar -xz` works but `tar xz` is the standard form
- **Q5:** `gitleaks --version` → wrong syntax. It's `gitleaks version` (no double-dash)

### Memorize:
```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar xz -C /usr/local/bin
pip install pre-commit
gitleaks version
```

---

## Part 2: GitHub Action Names (Q6–9) — 0/4

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 6 | `uses: actions/checkout@v4` | `uses: actions/checkout@v6` | 0 |
| 7 | `trivy fs . --exit-code 1` | `uses: aquasecurity/trivy-action@master` | 0 |
| 8 | `uses: github/codeql-actions/upload-sarif@v3` | `uses: github/codeql-action/upload-sarif@v3` | 0 |
| 9 | `___` | `uses: pre-commit/action@v3.0.1` | 0 |

### What went wrong:
- **Q6:** `v4` → should be `v6`
- **Q7:** You wrote a **bash command** instead of a GitHub Action `uses:` line. These are different things
- **Q8:** `codeql-actions` → should be `codeql-action` (no 's')
- **Q9:** Blank

### Memorize:
```yaml
uses: actions/checkout@v6
uses: aquasecurity/trivy-action@master
uses: github/codeql-action/upload-sarif@v3
uses: pre-commit/action@v3.0.1
```

---

## Part 3: SARIF Upload Pattern (Q10–13) — 2/4

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 10 | `github/codeql-actions/upload-sarif@v3` | `github/codeql-action/upload-sarif@v3` | 0 |
| 11 | `always()` | `always()` | 1 |
| 12 | "runs the step regardless of the status report" | Runs step even if prior step failed (so failed scans still upload) | 1 |
| 13 | `trivy-report.sarif` | `trivy-report.sarif` | 1 |

### What went wrong:
- **Q10:** `codeql-actions` → `codeql-action` (no 's')

---

## Part 4: gitleaks protect vs detect (Q14–16) — 1/3

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 14 | protect = working tree, detect = all git commit history | Correct concept | 1 |
| 15 | `semgrep` | `gitleaks detect` | 0 |
| 16 | "gitleaks because it scans all the files" | `protect` is faster (only current files) vs `detect` (full history) | 0 |

### What went wrong:
- **Q15:** `semgrep` is for code analysis/SAST, NOT for detecting secrets. `gitleaks detect` scans git history
- **Q16:** `protect` is faster — it only scans current files. `detect` is slower because it scans full git history

### Memorize:
- `gitleaks detect` = scans git history (slower, catches deleted secrets)
- `gitleaks protect` = scans working tree (faster, PRs only)

---

## Part 5: Pre-Commit Config (Q17–22) — 2/6

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 17 | `https://github.com/pre-commit/pre-commit` | `https://github.com/pre-commit/pre-commit-hooks` | 0 |
| 18 | `check-ymal` | `check-yaml` | 0 |
| 19 | `end-of-file-fixer` | `end-of-file-fixer` | 1 |
| 20 | `https://github.com/gitleaks/gitleaks` | `https://github.com/gitleaks/gitleaks` | 1 |
| 21 | `https://github.com/semgrep/semgrep` | `https://github.com/returntocorp/semgrep` | 0 |
| 22 | `^vendor|bin|node_modules` | `^(vendor\|node_modules\|dist\|build\|\.vscode\|\.idea\|tests/.pest/snapshots)/` | 0 |

### What went wrong:
- **Q17:** Missing `-hooks` at the end
- **Q18:** Typo — `check-ymal` → `check-yaml`
- **Q19:** ✅ Correct
- **Q20:** ✅ Correct
- **Q21:** semgrep lives under `returntocorp`, not `semgrep`
- **Q22:** Incomplete and missing the `^` anchor and parentheses. The exclude pattern is a **single line** — must be exact

### Memorize:
```yaml
- repo: https://github.com/pre-commit/pre-commit-hooks
- repo: https://github.com/gitleaks/gitleaks
- repo: https://github.com/returntocorp/semgrep
exclude: ^(vendor|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
```

---

## Part 6: Docker Commands (Q23–25) — 0/3

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 23 | `kubectl get namespaces` | `docker ps` | 0 |
| 24 | `HEALTHCHECK --start-period=5s...` | `docker inspect --format='{{.State.Health}}' <container>` | 0 |
| 25 | `___` | `docker inspect --format='{{.Config.Healthcheck}}' <container>` | 0 |

### What went wrong:
- **Q23:** `kubectl` is for Kubernetes, NOT Docker. `kubectl get namespaces` lists K8s namespaces. Docker command is `docker ps`
- **Q24:** You wrote **Dockerfile HEALTHCHECK syntax** instead of a Docker CLI command. These are completely different things
- **Q25:** Blank

### Memorize:
```bash
docker ps                                    # list running containers
docker inspect --format='{{.State.Health}}' <container>   # check health status
docker inspect --format='{{.Config.Healthcheck}}' <container>  # view HEALTHCHECK config
```

---

## Part 7: HEALTHCHECK Concepts (Q26–33) — 3.5/8

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 26 | "Checks the services running status" | Tells K8s/Docker if app is working | 1 |
| 27 | "healthy ensures running services are running" | Running = process up. Healthy = app responds | 1 |
| 28 | "it returns an error" | K8s marks unhealthy, may restart | 0.5 |
| 29 | "boot up while not flagged as down" | PHP-FPM needs boot time; no start-period = restart loop | 1 |
| 30 | "duration the container to keep running" | How often to run the check | 0 |
| 31 | "waits 3 seconds before flagging as failed" | Max time check has to respond | 1 |
| 32 | "tries booting up 3 times" | Consecutive failures before marking unhealthy | 0.5 |
| 33 | "checks the image after building" | `curl -f http://localhost:80/health \|\| exit 1` | 0 |

### What went wrong:
- **Q30:** Wrong — interval is how **often** to check, not how long to run
- **Q32:** Slightly imprecise — it's about consecutive failed checks, not "booting up"
- **Q33:** Completely wrong — `|| exit 1` is not about building or deployment

### Memorize:
```bash
--interval=30s    # how OFTEN to run the check (every 30 seconds)
--timeout=3s     # max time the check has to respond
--start-period=40s # grace period during app boot (PHP-FPM needs this!)
--retries=3      # consecutive failures before marking unhealthy
curl -f http://localhost:80/health || exit 1
# 0 = healthy, 1 = unhealthy
```

---

## Part 8: HEALTHCHECK Syntax (Q34–36) — 0.5/3

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 34 | `___` | `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health \|\| exit 1` | 0 |
| 35 | "stops the building process before deployment to avoid CVEs" | 0 = healthy, 1 = unhealthy. HEALTHCHECK reads exit codes | 0 |
| 36 | "After the build stage" | deploy/final stage (not builder) | 0.5 |

### What went wrong:
- **Q34:** Blank — this was the main gap from the recap drill
- **Q35:** You described CI/CD `exit 1` (blocks pipeline). HEALTHCHECK `|| exit 1` is DIFFERENT — it tells the HEALTHCHECK mechanism whether the container is healthy (exit 0) or unhealthy (exit 1)

### Memorize:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:80/health || exit 1
# Goes in the DEPLOY stage, near the end
```

---

## Part 9: GitHub CLI (Q37–40) — 1/4

| Q | Your Answer | Correct Answer | Score |
|---|------------|----------------|-------|
| 37 | `gh run view --limit-5` | `gh run list --limit 5` | 0 |
| 38 | `gh run view <id> logs` | `gh run view <run-id>` | 0 |
| 39 | `gh run view <id> --logs-failed` | `gh run view <run-id> --log-failed` | 0 |
| 40 | "force-with-lease pushes if no conflicting merge" | `--force-with-lease` rejects if remote changed | 1 |

### What went wrong:
- **Q37:** `gh run view` shows ONE run. `gh run list` LISTS runs. Wrong command
- **Q38:** `gh run view <id> logs` — wrong syntax. It's just `gh run view <run-id>`
- **Q39:** `--logs-failed` → should be `--log-failed` (singular "log")

### Memorize:
```bash
gh run list --limit 5              # list recent runs
gh run view <run-id>               # view a specific run
gh run view <run-id> --log-failed  # view only failed steps
```

---

## Summary

| Part | Topic | Your Score | Max |
|------|-------|-----------|-----|
| 1 | Installation commands | 1.5 | 5 |
| 2 | GitHub Action names | 0 | 4 |
| 3 | SARIF upload pattern | 2 | 4 |
| 4 | gitleaks protect vs detect | 1 | 3 |
| 5 | Pre-commit config | 2 | 6 |
| 6 | Docker commands | 0 | 3 |
| 7 | HEALTHCHECK concepts | 3.5 | 8 |
| 8 | HEALTHCHECK syntax | 0.5 | 3 |
| 9 | GitHub CLI | 1 | 4 |
| **Total** | | **12.5** | **40** |

**Score: 31%** — Down significantly from previous attempts.

---

## What Dropped the Most

| Category | This Attempt | Previous Best | Trend |
|----------|-------------|---------------|-------|
| Installation commands | 1.5/5 | 3/3 | ❌ Regressed |
| GitHub Action names | 0/4 | 3/4 | ❌ Regressed |
| Docker commands | 0/3 | 1/3 | ❌ Regressed |
| GitHub CLI | 1/4 | 1/3 | ❌ Regressed |
| HEALTHCHECK concepts | 3.5/8 | 5.5/12 | ⚠️ Similar |
| Pre-commit config | 2/6 | 6/6 | ❌ Regressed |

---

## The Critical Gaps

### 🔴 Zero / Completely Wrong
1. **Docker commands** — confused kubectl with docker, wrote Dockerfile syntax instead of CLI commands
2. **HEALTHCHECK syntax** — completely blank (Q34)
3. **GitHub Action names** — wrong URLs, wrong versions, wrote bash instead of `uses:` lines
4. **Q33** — What command does HEALTHCHECK use? Completely wrong

### ⚠️ Imprecise / Slightly Off
5. **Q5** — `gitleaks --version` → should be `gitleaks version` (no double-dash)
6. **Q28** — "returns an error" — should mention K8s restart behavior
7. **Q30** — `--interval` — wrong meaning
8. **Q35** — Confused CI `exit 1` with HEALTHCHECK `|| exit 1`

---

## Diagnosis

You regressed on almost everything. Previous attempts had installation commands (3/3), pre-commit config (6/6), and GH CLI commands partially correct. Today those dropped.

**Possible causes:**
- The exercise was too long (40 questions) — fatigue?
- HEALTHCHECK was the main focus but the rest drifted
- Some concepts got overwritten by new learning

---

## The Fix

1. **Re-memorize the 4 installation commands** — this was 3/3 before, now 1.5/5
2. **Re-memorize the 4 GitHub Action `uses:` lines**
3. **Re-memorize Docker commands** — `docker ps`, `docker inspect` (Q23-25 are all new gaps)
4. **Write the HEALTHCHECK syntax 3 times from memory** — Q34 was blank

Then re-take the drill. This is the same pattern as Exercise 02: regression is normal, the fix is repetition.

---

## Next Step

Re-do the installation commands and action names sections right now (no peeking). Once those are 5/5 and 4/4, we'll try the full drill again.

Or — since the main goal today is HEALTHCHECK — let's do this instead:

**Skip the full drill. Go straight to the HEALTHCHECK post-test.**
- You've already studied the HEALTHCHECK concepts
- The drill showed you the exact gaps (Q34 is blank, Q33 is wrong, Q30 is wrong)
- Fix those 3 specifically, then do the post-test
- If post-test passes 9/10 → implement the blade template

What do you want to do?
