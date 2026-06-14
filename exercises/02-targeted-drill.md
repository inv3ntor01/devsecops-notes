# Targeted Drill — The 5 Gaps

**No scaffolding. No multiple choice. Write each answer from memory, then check.**
**Passing score: 19/20 (95%).**

---

## 1. Installation Commands (5 questions)

Write the exact command for each:

1. Install Trivy into `/usr/local/bin` (one-liner):
   ```
   ___
   ```

2. Install gitleaks v8.24.0 from the release tarball into `/usr/local/bin`:
   ```
   ___
   ```

3. Install pre-commit (package manager command):
   ```
   ___
   ```

4. What does `sudo apt install trivy` do? (yes or no — does it work?)
   ```
   ___
   ```

5. After installing gitleaks via `curl | tar xz -C /usr/local/bin`, what command confirms it's installed and working?
   ```
   ___
   ```

---

## 2. GitHub Action Names (4 questions)

Write the full `uses:` value for each:

6. Checkout code in any GitHub Action workflow:
   ```yaml
   - uses: ???
   ```

7. Run Trivy filesystem scan:
   ```yaml
   - uses: ???
   ```

8. Upload SARIF results to the GitHub Security tab (used in both Trivy and gitleaks):
   ```yaml
   - uses: ???
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
  if: ???            # this one word
  with:
    sarif_file: ???  # for Trivy
```

10. The action name:
    ```
    ___
    ```

11. The `if` condition (one word):
    ```
    ___
    ```

12. Why that `if` condition? (One sentence — what would happen without it?)
    ```
    ___
    ```

13. The `sarif_file` value for the Trivy workflow:
    ```
    ___
    ```

---

## 4. protect vs detect — The One Line (1 question)

14. In one sentence: what does `gitleaks protect` scan, and what does `gitleaks detect` scan?
    ```
    protect = ___
    detect  = ___
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
    - repo: ???
    ```

19. What repo provides the semgrep SAST hook?
    ```yaml
    - repo: ???
    ```

20. The full `exclude:` pattern line:
    ```yaml
    exclude: ???
    ```

---

## Check Your Answers

When done, compare against:
- `reference/cheatsheet.md` — installation commands, local testing commands
- `sessions/2026-06-13-security-gates.md` — action names, SARIF pattern, pre-commit config
- `exercises/01-recap-security-gates.md` — your previous attempt and the full assessment

---

*After 95% on this drill, proceed to Exercise 2: Dockerfile HEALTHCHECK.*
