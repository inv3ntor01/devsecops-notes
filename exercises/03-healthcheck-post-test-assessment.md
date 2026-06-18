# Exercise 03 — HEALTHCHECK Post-Test Assessment

**Date:** 2026-06-18
**Your Score:** 8/10 = 80%
**Pre-test baseline:** 44%
**Pass threshold:** 9/10 (90%)

---

## Results Summary

| Attempt | Score | Change |
|---------|-------|--------|
| Pre-test | 44% (4/9) | — |
| **Post-test** | **80% (8/10)** | **+36 points** |

**Result:** ❌ Just missed the pass mark (9/10). 3 small corrections needed.

---

## Q1 — What is a Docker HEALTHCHECK?

| | Answer |
|---|--------|
| **Your answer** | "it checks the container if the services are responding and running" |
| **Correct** | Docker/K8s instruction that tells the orchestrator if the app is actually working, not just alive |
| **Verdict** | ✅ Correct concept |

---

## Q2 — Why do containers need one?

| | Answer |
|---|--------|
| **Your answer** | "it solves dead containers which are running and the services inside are down" |
| **Correct** | A container can be "running" (process alive) but the app inside can be dead/broken |
| **Verdict** | ✅ Correct — you nailed the core problem |

---

## Q3 — Running vs Healthy

| | Answer |
|---|--------|
| **Your answer** | "running = container is up, healthy = services respond" |
| **Correct** | Same concept |
| **Verdict** | ✅ Perfect |

---

## Q4 — What happens when health checks fail repeatedly?

| | Answer |
|---|--------|
| **Your answer** | "it restarts the container or re-initialize" |
| **Correct** | Docker marks unhealthy, may restart. K8s marks as CrashLoopBackOff or terminates pod |
| **Verdict** | ✅ Correct concept |

---

## Q5 — HEALTHCHECK syntax

| | Answer |
|---|--------|
| **Your answer** | `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health | exit 1` |
| **Correct** | `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health || exit 1` |
| **Verdict** | ❌ **Wrong operator — `|` should be `||`** |

### Fix:
```diff
- CMD curl -f http://localhost:80/health | exit 1
+ CMD curl -f http://localhost:80/health || exit 1
```

**Why `||` not `|`:** `||` is a bash "OR" operator — if the left command fails (curl gets a non-zero exit code), run the right command (exit 1). `|` is a pipe that feeds output to another command — that's wrong here.

---

## Q6 — Flag meanings

| Flag | Your Answer | Correct | Verdict |
|------|-------------|---------|---------|
| `--interval=30s` | how often the healthcheck run | how often to run the check | ✅ Correct |
| `--timeout=3s` | max time for container to respond | max time the check has to respond | ✅ Correct |
| `--start-period=40s` | booting time for container | grace period before failures count | ✅ Correct |
| `--retries=3` | tries 3 failures before flagging down | consecutive failures before unhealthy | ✅ Perfect |

**All 4 flags locked!**

---

## Q7 — Command to check Laravel/PHP health

| | Answer |
|---|--------|
| **Your answer** | `docker inspect --format='{{.State.Health}}'` |
| **Correct** | `curl -f http://localhost:80/health || exit 1` |
| **Verdict** | ❌ **Wrong — this is the Docker CLI command, not the HEALTHCHECK command** |

### The distinction again:

| Type | Purpose | Example |
|------|---------|---------|
| HEALTHCHECK CMD | The command Docker runs inside the container | `curl -f http://localhost:80/health || exit 1` |
| Docker CLI | You type this in your terminal | `docker inspect --format='{{.State.Health}}'` |

Q7 asks: *"what command would HEALTHCHECK use to check if a Laravel/PHP web app is healthy?"*

That's the **inside-the-container** command: `curl -f http://localhost:80/health || exit 1`

The `docker inspect` command is what **you** run to see the HEALTHCHECK result — it's not what HEALTHCHECK runs.

---

## Q8 — Which stage gets HEALTHCHECK?

| | Answer |
|---|--------|
| **Your answer** | "deploy" |
| **Correct** | deploy / final stage (where the app runs, not the build stage) |
| **Verdict** | ✅ Correct |

---

## Q9 — Where in php.blade.php?

| | Answer |
|---|--------|
| **Your answer** | "on the deployment stage" |
| **Correct** | In the deploy stage, before or after CMD |
| **Verdict** | ✅ Correct |

---

## Q10 — Full HEALTHCHECK line

| | Answer |
|---|--------|
| **Your answer** | `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health | exit 1` |
| **Correct** | `HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health || exit 1` |
| **Verdict** | ❌ **Same pipe error — `|` should be `||`** |

---

## Final Score Breakdown

| Q | Topic | Score | Notes |
|---|-------|-------|-------|
| 1  | What is HEALTHCHECK | 1 | ✅ |
| 2  | Why containers need it | 1 | ✅ |
| 3  | Running vs healthy | 1 | ✅ |
| 4  | Repeated failures | 1 | ✅ |
| 5  | HEALTHCHECK syntax | 0 | ❌ `\|` vs `\|\|` |
| 6  | Flag meanings | 1 | ✅ all 4 correct |
| 7  | Health check command | 0 | ❌ Docker CLI vs HEALTHCHECK CMD |
| 8  | Stage placement | 1 | ✅ |
| 9  | Where in blade template | 1 | ✅ |
| 10 | Full HEALTHCHECK line | 0 | ❌ `\|` vs `\|\|` |
| **Total** | | **8/10** | **80%** |

---

## The 3 Things to Fix

### 1. `||` not `|` — Q5 & Q10
```bash
curl -f http://localhost:80/health || exit 1
```
`||` = bash OR operator. If curl fails, run `exit 1`. Never `|`.

### 2. Q7 — HEALTHCHECK uses `curl`, not `docker inspect`
The question asks what command HEALTHCHECK **uses** to check the app:
```bash
curl -f http://localhost:80/health || exit 1
```
`docker inspect --format='{{.State.Health}}'` is what **you** run to see the result — it's not what HEALTHCHECK runs.

### 3. Mental model — Docker CLI vs Dockerfile HEALTHCHECK CMD

| You type in terminal | Goes inside Dockerfile |
|---|---|
| `docker ps` | HEALTHCHECK is NOT `docker ps` |
| `docker logs` | HEALTHCHECK is NOT `docker logs` |
| `docker inspect` | HEALTHCHECK is NOT `docker inspect` |
| `curl` (inside container) | **HEALTHCHECK uses `curl`** |

---

## Improvement: 44% → 80%

**Pre-test (honest baseline):** 44%
**Post-test (after studying):** 80%
**Improvement:** +36 points

You're **+36 points** above your pre-test baseline. The syntax is almost locked — just the `||` operator needs consolidation.

---

## Next Step

Fix these 3 items, then:
1. Find the `php.blade.php` blade template in the LaraKube project
2. Add the HEALTHCHECK instruction to the deploy stage
3. Push to your PR
