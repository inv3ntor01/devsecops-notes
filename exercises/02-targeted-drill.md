# Targeted Drill — The 5 Gaps (Attempt 3)

**No scaffolding. No multiple choice. Write each answer from memory, then check.**
**NO cheatsheet. NO session notes. Pure recall.**
**Passing score: 19/20 (95%).**

---

## 1. Installation Commands (5 questions)

Write the exact command for each:

1. Install Trivy into `/usr/local/bin` (one-liner):
   ```
   curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
   ___
   ```

2. Install gitleaks v8.30.1 from the release tarball into `/usr/local/bin`:
   ```
   curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar xz -C /usr/local/bin
   ___
   ```

3. Install pre-commit (package manager command):
   ```
   pip install pre-commit
   ___
   ```

4. What does `sudo apt install trivy` do? (yes or no — does it work?)
   ```
   no
   ___
   ```

5. After installing gitleaks via `curl | tar xz -C /usr/local/bin`, what command confirms it's installed and working?
   ```
   gitleaks version
   ___
   ```

---

## 2. GitHub Action Names (4 questions)

Write the full `uses:` value for each:

6. Checkout code in any GitHub Action workflow:
   ```yaml
   - uses: actions/checkout@v6
   ```

7. Run Trivy filesystem scan:
   ```yaml
   - uses: aquasecurity/trivy-action@master
   ```

8. Upload SARIF results to the GitHub Security tab (used in both Trivy and gitleaks):
   ```yaml
   - uses: actions/codeql-action/upload-sarif@v3
   ```

9. Run pre-commit hooks in CI:
   ```yaml
   - uses: pre-commit/action@v3.0.1
   ```

---

## 3. SARIF Upload Pattern (4 questions)

This is the exact same pattern in both workflows. Fill in:

```yaml
# Upload SARIF to GitHub Security tab
- uses: actions/codeql-action/upload-sarif@v3
  if: always()            # this one word
  with:
    sarif_file: trivy-report.sarif  # for Trivy
```

10. The action name:
    ```
    actions/codeql-action/upload-sarif@v3
    ___
    ```

11. The `if` condition (one word):
    ```
    always()
    ___
    ```

12. Why that `if` condition? (One sentence — what would happen without it?)
    ```
    it means to run the step regardless of the status (PASS, FAIL)
    ___
    ```

13. The `sarif_file` value for the Trivy workflow:
    ```
    trivy-report.sarif
    ___
    ```

---

## 4. protect vs detect — The One Line (1 question)

14. In one sentence: what does `gitleaks protect` scan, and what does `gitleaks detect` scan?
    ```
    protect = scans working tree directory
    detect  = scans all git commit history
    ```

---

## 5. Pre-Commit YAML Structure (6 questions)

15. What repo provides the basic syntax hooks (YAML, JSON, trailing-whitespace, end-of-file)?
    ```yaml
    - repo: https://github.com/pre-commit/pre-commit-hooks
    ```

16. The hook ID for YAML syntax validation:
    ```yaml
    - id: check-yaml
    ```

17. The hook ID that ensures files end with a newline:
    ```yaml
    - id: end-of-file-fixer
    ```

18. What repo provides the gitleaks pre-commit hook?
    ```yaml
    - repo: https://github.com/gitleaks/gitleaks
    ```

19. What repo provides the semgrep SAST hook?
    ```yaml
    - repo: https://github.com/returntocorp/semgrep
    ```

20. The full `exclude:` pattern line:
    ```yaml
    exclude: ^(vendor|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
    ```

---

## Check Your Answers

When done, compare against:
- `reference/cheatsheet.md` — installation commands, local testing commands
- `sessions/2026-06-13-security-gates.md` — action names, SARIF pattern, pre-commit config
- `exercises/01-recap-security-gates.md` — your previous attempt and the full assessment

---

# ASSESSMENT (2026-06-14, Attempt 3 — Closed Book)

**Score: 18.5/20 = 92.5% (Target: 95%)**

**Conditions:** NO cheatsheet. NO session notes. Pure recall.

---

## 1. Installation Commands — 5/5 ✅

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 1. Trivy install | `curl -sfL .../install.sh \| sh -s -- -b /usr/local/bin` | Exact match | ✅ Correct from recall |
| 2. Gitleaks install | `curl -sSL ...gitleaks_8.30.1_linux_x64.tar.gz \| tar xz -C /usr/local/bin` | Exact match | ✅ Correct from recall |
| 3. Pre-commit install | `pip install pre-commit` | Exact match | ✅ Correct from recall |
| 4. apt install trivy? | `no` | Correct | ✅ Fixed from attempt 1 |
| 5. Confirm gitleaks | `gitleaks version` | Correct | ✅ Fixed from attempt 2 |

---

## 2. GitHub Action Names — 3/4

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 6. Checkout | `actions/checkout@v6` | Exact match | ✅ Fixed! Plural 's' and v6 |
| 7. Trivy action | `aquasecurity/trivy-action@master` | Exact match | ✅ Correct |
| 8. Upload SARIF | `actions/codeql-action/upload-sarif@v3` | `github/codeql-action/upload-sarif@v3` | ❌ Wrong org (`github`, not `actions`) |
| 9. Pre-commit CI | `pre-commit/action@v3.0.1` | Exact match | ✅ Correct |

---

## 3. SARIF Upload Pattern — 3.5/4

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 10. Action name | `actions/codeql-action/upload-sarif@v3` | `github/codeql-action/upload-sarif@v3` | ❌ Same org error as Q8 |
| 11. `if` condition | `always()` | Exact match | ✅ Correct |
| 12. Why `always()`? | "it means to run the step regardless of the status (PASS, FAIL)" | Correct | ✅ **FINALLY CORRECT after 3 wrong attempts. Locked in.** |
| 13. sarif_file | `trivy-report.sarif` | Exact match | ✅ Correct |

---

## 4. protect vs detect — 1/1 ✅

| Q | My Answer | Notes |
|---|-----------|-------|
| 14. One line | "protect = scans working tree directory, detect = scans all git commit history" | ✅ Correct. "directory" slightly imprecise but conceptually solid. |

---

## 5. Pre-Commit YAML Structure — 6/6 ✅

| Q | My Answer | Notes |
|---|-----------|-------|
| 15. Hooks repo | `https://github.com/pre-commit/pre-commit-hooks` | ✅ |
| 16. YAML hook ID | `check-yaml` | ✅ |
| 17. Newline hook ID | `end-of-file-fixer` | ✅ Fixed from attempt 2 |
| 18. Gitleaks repo | `https://github.com/gitleaks/gitleaks` | ✅ |
| 19. Semgrep repo | `https://github.com/returntocorp/semgrep` | ✅ |
| 20. Exclude pattern | `^(vendor\|node_modules\|dist\|build\|\.vscode\|\.idea\|tests/.pest/snapshots)/` | ✅ Exact match |

---

## Summary

### What's now locked in from memory:
- All 3 installation commands
- `actions/checkout@v6` (plural, v6)
- `aquasecurity/trivy-action@master`
- `pre-commit/action@v3.0.1`
- `always()` = "run regardless of prior step pass/fail" (finally correct!)
- protect = working tree, detect = git history
- All pre-commit repos, hook IDs, and exclude pattern

### The one remaining gap:
- SARIF upload action org: `github/codeql-action/upload-sarif@v3` (not `actions/`). Only error in the entire drill.

### Progress across attempts:
| Attempt | Conditions | Score |
|---------|-----------|-------|
| Attempt 1 | Open book (peeked) | 35% (7/20) |
| Attempt 2 | Open book (cheatsheet + notes) | 80% (16/20) |
| Attempt 3 | Closed book (pure recall) | **92.5% (18.5/20)** ✅ |

**Ready to proceed to Exercise 2: Dockerfile HEALTHCHECK.**
