# Recap Exercise — DevSecOps Foundations (2026-06-15)

**Warming up. No notes, no cheatsheet. Then → HEALTHCHECK study + post-test.**

---

## Part 1: The One Remaining Gap (From Attempt 3)

You got everything right except one thing. Fix it:

1. The SARIF upload action — write the full `uses:` line:
   ```yaml
   - uses: github/codeql-action/upload-sarif@v3
   ```

2. What's wrong with `actions/codeql-action/upload-sarif@v3`?
   ```
    wrong organization, upload-sarif belongs to github
   ```

---

## Part 2: Dockerfile Basics (Required for HEALTHCHECK)

Fill in the blanks:

3. In a multi-stage Dockerfile, what are the two stage names?
   ```
   BUILD (builds the app)
   DEPLOY (runs the app)
   ```

4. What does this line do?
   ```dockerfile
   USER www-data
   ```
   ```
   setting the user as the least privilege user
   ```

5. What is the purpose of `ARG USER_ID` and `ARG GROUP_ID` in a Dockerfile?
   ```
   using the user id and group id in a setup
   ```

6. Why is Alpine-based base image preferred for production Dockerfiles?
   ```
   lightweight and less installed dependencies, low dependency exploitation
   ```

---

## Part 3: HEALTHCHECK Concepts (Pre-Test Recall)

7. What is a Docker HEALTHCHECK? (One sentence)
   ```
   checking whether a container is alive or dead
   ```

8. What's the difference between a container that's **running** vs one that's **healthy**?
   ```
   there maybe some container which are running but the services are dead or having issues while healthy states that all the running services inside the container are working.
   ```

9. What happens when a container's health check keeps failing?
   ```
   it returns a crashloopbackerror that states the container is failing
   ```

10. Why is `--start-period` important for PHP/Laravel apps?
    ```
    setting the time to start before it returns error
    ```

11. What does `--interval=30s` mean?
    ```
    duration to keep the container running
    ```

12. What does `--timeout=3s` mean?
    ```
    grace period to run before it outputs running error after the 3 seconds
    ```

13. What does `--retries=3` mean?
    ```
    retries a number of times before giving up and returns an error
    ```

14. What command does HEALTHCHECK use to check a Laravel/PHP web app health?
    ```
    laravel health
    ```

15. In a multi-stage Dockerfile, which stage gets the HEALTHCHECK?
    ```
    after deployment
    ```

16. In the blade template (`resources/views/docker/php.blade.php`), where exactly does HEALTHCHECK go?
    ```
   after the build
   ```

17. Why is `|| exit 1` required at the end of the HEALTHCHECK CMD?
    ```
    it stops the container if returns an error
    ```

18. Write the complete HEALTHCHECK instruction with all flags:
    ```dockerfile
    USE HEALTHCHECK
    ```

---

## Part 4: Local Docker Commands

19. List running containers:
    ```
    docker ps
    ```

20. View a container's health check status:
    ```
    docker doctor
    ```

21. Inspect a container's Dockerfile HEALTHCHECK config:
    ```
    ???
    ```

---

## Part 5: gitleaks protect vs detect (Still Drill This)

22. In one sentence — what does each command scan?
    ```
    gitleaks protect:  scans current working tree
    gitleaks detect:   scans all commit history
    ```

23. Which command would catch a secret that was committed 3 months ago and then deleted?
    ```
    pre-commit
    ```

24. Which command is faster and why?
    ```
    pre-commit because it scans all before uploading into the github repo
    ```

---

## Part 6: CI Debug Commands

25. List recent workflow runs (show 5):
    ```
    gh run list
    ```

26. View a specific run's full logs:
    ```
    gh run view <id>
    ```

27. View only failed step logs:
    ```
    gh run view <id> --logs-failed
    ```

---

## Part 7: Installation Commands (Confirm Still Locked)

Write the exact commands:

28. Install Trivy:
    ```
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
    ```

29. Install gitleaks v8.30.1:
    ```
    curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar xz -C /usr/local/bin
    ```

30. Install pre-commit:
    ```
    pip install pre-commit
    ```

---

## Scoring

- **Part 1** (Q1-2): The SARIF fix — must nail this
- **Part 2** (Q3-6): Dockerfile fundamentals
- **Part 3** (Q7-18): HEALTHCHECK concepts (20 pts)
- **Part 4** (Q19-21): Docker commands
- **Part 5** (Q22-24): gitleaks concepts
- **Part 6** (Q25-27): GitHub CLI
- **Part 7** (Q28-30): Installation commands

**Pass: 28/30 (93%)** — you scored 92.5% last time, match or beat it.

---

## Then → HEALTHCHECK Study

After the recap drill, re-read Exercise 03's Study Guide, then complete the **post-test** (all blanks, no peeking). Then implement the HEALTHCHECK in the blade template.

---

## Assessment

| Q | Your Answer | Correct Answer | ✅/❌ |
|---|------------|----------------|------|
| 1 | github/codeql-action/upload-sarif@v3 | github/codeql-action/upload-sarif@v3 | ✅ |
| 2 | wrong org, upload-sarif belongs to github | The org is `github`, not `actions` | ✅ |
| 3 | BUILD / DEPLOY | builder / deploy | ⚠️ Concept right, names lowercase |
| 4 | least privilege user | Runs as www-data non-root user | ⚠️ Right concept, missing www-data specificity |
| 5 | using the user id and group id in a setup | Allows dynamically setting UID/GID at build time | ⚠️ Vague |
| 6 | lightweight, less deps, low exploitation | Smaller image = fewer packages = fewer CVEs | ✅ |
| 7 | alive or dead | Tells K8s if app is working, not just alive | ❌ Incomplete — misses K8s context |
| 8 | running vs services inside working | Running = process up. Healthy = app responds correctly | ✅ |
| 9 | crashloopbackerror | K8s marks unhealthy, may restart | ⚠️ Concept right, wrong term |
| 10 | time to start before error | PHP-FPM needs boot time; no start-period → restart loop | ⚠️ Close but missing boot loop concept |
| 11 | duration to keep running | How often to run the check | ❌ Wrong |
| 12 | grace period before 3s error | Max time check has to respond | ⚠️ Close |
| 13 | retries before giving up | Consecutive failures before marking unhealthy | ✅ |
| 14 | laravel health | curl -f http://localhost:80/health \|\| exit 1 | ❌ Wrong tool |
| 15 | after deployment | deploy (final stage) | ⚠️ Vague |
| 16 | after the build | Near the end, after CMD or just before it | ⚠️ Vague |
| 17 | stops container on error | 0 = healthy, 1 = unhealthy | ❌ Incomplete |
| 18 | USE HEALTHCHECK | HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health \|\| exit 1 | ❌ Wrong syntax entirely |
| 19 | docker ps | docker ps | ✅ |
| 20 | docker doctor | docker inspect --format='{{.State.Health}}' <container> | ❌ Wrong command |
| 21 | ??? | docker inspect --format='{{.Config.Healthcheck}}' <container> | ❌ Blank |
| 22 | working tree / commit history | protect = working tree / detect = git history | ✅ |
| 23 | pre-commit | gitleaks detect | ❌ Wrong tool |
| 24 | pre-commit faster | protect (only scans current files) | ❌ Wrong tool |
| 25 | gh run list | gh run list --limit 5 | ⚠️ Missing --limit 5 |
| 26 | gh run view <id> | gh run view <run-id> | ✅ |
| 27 | --logs-failed | --log-failed | ❌ Wrong flag (logs vs log) |
| 28 | curl -sfL … install.sh … | Exact | ✅ |
| 29 | curl -sSL … tar.gz … | Exact | ✅ |
| 30 | pip install pre-commit | Exact | ✅ |

---

## Score Breakdown

| Part | Your Raw | Max | Notes |
|------|----------|-----|-------|
| Part 1 (Q1-2) | 2/2 | 2 | ✅ SARIF gap FIXED |
| Part 2 (Q3-6) | 2/4 | 4 | ⚠️ Concepts right, precision weak |
| Part 3 (Q7-18) | 3/12 | 12 | ❌ HEALTHCHECK syntax = 0, flags = 2.5 |
| Part 4 (Q19-21) | 1/3 | 3 | ❌ docker doctor wrong, Q21 blank |
| Part 5 (Q22-24) | 1/3 | 3 | ❌ Q23 & Q24: named wrong tool |
| Part 6 (Q25-27) | 1/3 | 3 | ❌ --logs-failed wrong, --limit missing |
| Part 7 (Q28-30) | 3/3 | 3 | ✅ All 3 installation commands LOCKED IN |

**Total: 13/30 = 43.3%**

---

## Diagnosis

### ✅ Locked In (keep doing what you're doing)
- SARIF upload org: `github/codeql-action` — finally correct
- All 3 installation commands (Trivy, gitleaks, pre-commit)
- gitleaks protect vs detect concept
- Docker basics: `docker ps`
- GH CLI: `gh run view <id>`

### ⚠️ Imprecise but directionally right (needs sharper recall)
- Stage names: `builder` / `deploy` (not "BUILD / DEPLOY")
- `USER www-data`: correct concept, should name `www-data`
- `--timeout`, `--interval`, `--start-period`: all in the right ballpark but off by framing
- GH CLI `--limit 5`: you know the command but forgot the flag

### ❌ Critical Gaps

**1. HEALTHCHECK syntax — completely blank (Q18)**
   - You wrote `USE HEALTHCHECK` — that doesn't exist
   - Correct: `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health || exit 1`
   - **The word is `HEALTHCHECK`, not `USE HEALTHCHECK`**

**2. HEALTHCHECK command for Laravel/PHP (Q14)**
   - You wrote `laravel health` — HEALTHCHECK doesn't use `laravel` CLI
   - It uses: `curl -f http://localhost:80/health || exit 1`
   - The `-f` flag makes curl fail on HTTP 4xx/5xx → triggers exit 1 → marks unhealthy

**3. Q20 — Wrong Docker command**
   - `docker doctor` — doesn't exist
   - Correct: `docker inspect --format='{{.State.Health}}' <container>`

**4. Q21 — Left blank**
   - Same family: `docker inspect --format='{{.Config.Healthcheck}}' <container>`

**5. Q23 & Q24 — Named wrong tool**
   - You said `pre-commit` for both
   - These are about **gitleaks**: `protect` vs `detect`
   - gitleaks detect = scans history (catches old secrets)
   - gitleaks protect = scans working tree only (faster)

**6. Q27 — Wrong flag name**
   - `--logs-failed` → should be `--log-failed` (singular "log")

---

## The Pattern

| Category | Score | Trend |
|----------|-------|-------|
| Installation commands | 3/3 | ✅ Solid |
| CI concepts (protect/detect) | 1/2 | ⚠️ Wavering |
| HEALTHCHECK syntax | 0/1 | ❌ Blank |
| HEALTHCHECK flags | 2.5/5 | ❌ Vague |
| Docker commands | 1/3 | ❌ Slipping |
| GH CLI flags | 1/3 | ❌ Details missing |

**This is exactly what happened in Session 2B:** concepts are strong, execution/syntax is weak. But this time the weakness is concentrated in **Docker** (new material) rather than CI tools (which you've drilled).

---

## The Fix

The 43.3% score is NOT a failure — it's honest data. Here's what to do right now:

**Study the HEALTHCHECK section of the cheatsheet** (30 seconds), then fill in Exercise 03's post-test from memory. That post-test is the same content as Q7-Q18. Then we'll implement it in the blade template.

The installation commands? 3/3. Don't touch those. Keep them locked.

Ready? Let's move to the post-test.
