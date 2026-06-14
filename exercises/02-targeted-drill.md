# Targeted Drill — The 5 Gaps

**No scaffolding. No multiple choice. Write each answer from memory, then check.**
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
   yes
   ___
   ```

5. After installing gitleaks via `curl | tar xz -C /usr/local/bin`, what command confirms it's installed and working?
   ```
   gitleaks
   ___
   ```

---

## 2. GitHub Action Names (4 questions)

Write the full `uses:` value for each:

6. Checkout code in any GitHub Action workflow:
   ```yaml
   - uses: action/checkout@v3
   ```

7. Run Trivy filesystem scan:
   ```yaml
   - uses: aquasecurity/trivy-action@master
   ```

8. Upload SARIF results to the GitHub Security tab (used in both Trivy and gitleaks):
   ```yaml
   - uses: action/codeql-action@v3
   ```

9. Run pre-commit hooks in CI:
   ```yaml
   - uses: ???
   ```

---

## 3. SARIF Upload Pattern (4 questions)

This is the exact same pattern in both workflows. Fill in:

```yaml
# Upload SARIF to GitHub Security tab
- uses: ???
  if: always()            # this one word
  with:
    sarif_file: trivy-report.sarif  # for Trivy
```

10. The action name:
    ```
    ???
    ___
    ```

11. The `if` condition (one word):
    ```
    always()
    ___
    ```

12. Why that `if` condition? (One sentence — what would happen without it?)
    ```
    it stops the pipeline and will not show any for the users to see.
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
    protect = it scans the current directory of the file.
    detect  = it scan all history commit.
    ```

---

## 5. Pre-Commit YAML Structure (6 questions)

15. What repo provides the basic syntax hooks (YAML, JSON, trailing-whitespace, end-of-file)?
    ```yaml
    - repo: ???
    ```

16. The hook ID for YAML syntax validation:
    ```yaml
    - id: ???
    ```

17. The hook ID that ensures files end with a newline:
    ```yaml
    - id: ???
    ```

18. What repo provides the gitleaks pre-commit hook?
    ```yaml
    - repo: pre-commit
    ```

19. What repo provides the semgrep SAST hook?
    ```yaml
    - repo: semgrep
    ```

20. The full `exclude:` pattern line:
    ```yaml
    exclude: vendor, app/, .git, .github, npm_modules, dist
    ```

---

## Check Your Answers

When done, compare against:
- `reference/cheatsheet.md` — installation commands, local testing commands
- `sessions/2026-06-13-security-gates.md` — action names, SARIF pattern, pre-commit config
- `exercises/01-recap-security-gates.md` — your previous attempt and the full assessment

---

*After 95% on this drill, proceed to Exercise 2: Dockerfile HEALTHCHECK.*

---

# ASSESSMENT (2026-06-14)

**Score: 7/20 = 35% (Target: 95%)**

---

## 1. Installation Commands — 3.5/5

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 1. Trivy install | `curl -sfL .../install.sh \| sh -s -- -b /usr/local/bin` | Exact match | ✅ Correct |
| 2. Gitleaks install | `curl -sSL ...gitleaks_8.30.1_linux_x64.tar.gz \| tar xz -C /usr/local/bin` | Exact match | ✅ Correct |
| 3. Pre-commit install | `pip install pre-commit` | Exact match | ✅ Correct |
| 4. apt install trivy? | `yes` | No, it does NOT work | ❌ Trivy is not in any apt repository. Only the install script works. |
| 5. Confirm gitleaks works | `gitleaks` | `gitleaks version` is better | ⚠️ Bare `gitleaks` prints usage (works), but `gitleaks version` is the proper confirmation command. |

**Improvement from recap:** Went from 0/5 (all `apt install` guesses) to 3.5/5. The study paid off.

---

## 2. GitHub Action Names — 1/4

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 6. Checkout | `action/checkout@v3` | `actions/checkout@v6` | ❌ Missing 's' in `actions`. Wrong version (v4, not v3). |
| 7. Trivy action | `aquasecurity/trivy-action@master` | Exact match | ✅ Correct |
| 8. Upload SARIF | `action/codeql-action@v3` | `github/codeql-action/upload-sarif@v3` | ❌ Wrong org (`github`, not `action`). Missing `/upload-sarif` path. |
| 9. Pre-commit CI | Left `???` | `pre-commit/action@v3.0.1` | ❌ Blank |

**Key:** The SARIF upload action path is `github/codeql-action/upload-sarif@v3` — it's under the `github` organization, in the `codeql-action` repo, the specific action is `upload-sarif`.

---

## 3. SARIF Upload Pattern — 2/4

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 10. Action name | Left `???` | `github/codeql-action/upload-sarif@v3` | ❌ Same as Q8 — blank |
| 11. `if` condition | `always()` | Exact match | ✅ Correct |
| 12. Why `always()`? | "it stops the pipeline and will not show any for the users to see" | Wrong | ❌ SAME ERROR as recap. `always()` does NOT stop the pipeline. It means: run this step EVEN IF the previous step failed. Without it → Trivy finds CRITICAL → exits code 1 → SARIF upload SKIPPED → no report in Security tab. We want the report uploaded REGARDLESS of pass/fail. |
| 13. sarif_file | `trivy-report.sarif` | Exact match | ✅ Correct |

**Critical:** Q12 was wrong in the recap AND wrong again here. This concept needs to be locked in: `always()` = "run even if prior step failed."

---

## 4. protect vs detect — 0.5/1

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 14. One line | "protect = scans current directory. detect = scans all history commit" | Working tree vs git history (including deleted files) | ⚠️ Direction is correct this time (was backwards in recap). But wording is imprecise. |

**Improvement:** In the recap, I said protect "stops uploading" and detect "shows vulnerabilities from uploaded code" — completely wrong. Now I correctly map protect→current, detect→history.

**Still needs work:** `protect` doesn't scan the "current directory" — it scans the **working tree** (current file contents). `detect` scans **all git commits, including deleted files** — the key point is it catches secrets that were committed then deleted (which happened 3 times in the upstream repo).

---

## 5. Pre-Commit YAML Structure — 0/6

| Q | My Answer | Correct | Notes |
|---|-----------|---------|-------|
| 15. Hooks repo | Left `???` | `https://github.com/pre-commit/pre-commit-hooks` | ❌ Blank |
| 16. YAML hook ID | Left `???` | `check-yaml` | ❌ Blank |
| 17. Newline hook ID | Left `???` | `end-of-file-fixer` | ❌ Blank |
| 18. Gitleaks repo | `pre-commit` | `https://github.com/gitleaks/gitleaks` | ❌ Wrong repo. Gitleaks hook comes from the gitleaks repo itself, not the pre-commit org. |
| 19. Semgrep repo | `semgrep` | `https://github.com/returntocorp/semgrep` | ⚠️ Shorthand incomplete |
| 20. Exclude pattern | `vendor, app/, .git, .github, npm_modules, dist` | `^(vendor\|node_modules\|dist\|build\|\.vscode\|\.idea\|tests/.pest/snapshots)/` | ❌ Multiple errors |

**Q20 errors:**
- `app/` is IN there — that's source code, should NOT be excluded
- `.github/` is IN there — we WANT gitleaks to scan workflow files for secrets
- Missing `node_modules` (the biggest one to exclude)
- Missing `build`, `.vscode`, `.idea`, `tests/.pest/snapshots`
- The pattern uses regex with `^()` and `|` separator, not comma-space
- `npm_modules` should be `node_modules`

---

## Summary

### Improved from recap (good):
- Installation commands: 0→3.5/5. Studied the cheatsheet and it worked.
- Trivy action name: correct.
- protect vs detect direction: was backwards in recap, now correct (but imprecise wording).

### Still wrong (identical to recap):
- Action names: `actions/checkout@v6` (missing 's'), SARIF path wrong. Pure memorization.
- `always()` reasoning: SAME wrong answer as recap. Need to lock this in.
- Pre-commit YAML: entirely blank/wrong. Same gap.
- Exclude pattern: still including paths that should be scanned, missing paths that shouldn't.

### What to fix before moving on:
1. Memorize: `actions/checkout@v6`, `github/codeql-action/upload-sarif@v3`, `pre-commit/action@v3.0.1`
2. Lock in: `always()` = "run even if previous step failed" (NOT "stop the pipeline")
3. Lock in: protect = working tree, detect = git history including deleted files
4. Memorize: pre-commit hook repo URL, hook IDs (check-yaml, check-json, end-of-file-fixer, trailing-whitespace), exclude regex pattern
5. `sudo apt install trivy` does NOT work — Trivy is not in apt repos
