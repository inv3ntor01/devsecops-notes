# Recap Drill — All DevSecOps Foundations
**Date:** 2026-06-17
**Pass threshold:** 95% (38/40)
**Rules:** No cheatsheet. No notes. Pure recall.

---

## Part 1: Installation Commands (Q1–5)

Write the exact command for each:

1. Install Trivy into `/usr/local/bin` (one-liner):
   ```
   curl -sfL https://raw.githubusecontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
   ```

2. Install gitleaks v8.30.1 from the release tarball into `/usr/local/bin`:
   ```
   curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar xz -C /usr/local/bin
   ```

3. Install pre-commit (package manager command):
   ```
   pip install pre-commit
   ```

4. What does `sudo apt install trivy` do? (yes or no — does it work?)
   ```
   no
   ```

5. After installing gitleaks via `curl | tar xz -C /usr/local/bin`, what command confirms it's installed and working?
   ```
   gitleaks version
   ```

---

## Part 2: GitHub Action Names (Q6–9)

Write the full `uses:` value for each:

6. Checkout code in any GitHub Action workflow:
   ```yaml
   uses: actions/checkout@v6 
   ```

7. Run Trivy filesystem scan:
   ```yaml
   uses: aquasecurity/trivy-action@master
   ```

8. Upload SARIF results to the GitHub Security tab:
   ```yaml
   - uses: github/codeql-action/upload-sarif@v3
   ```

9. Run pre-commit hooks in CI:
   ```yaml
   uses: pre-commit@v3.0.1
   ```

---

## Part 3: SARIF Upload Pattern (Q10–13)

Fill in the blank lines of this pattern:

```yaml
# Upload SARIF to GitHub Security tab
- uses: github/codeql-action/upload-sarif@v3
  if: always()
  with:
    sarif_file: sarif-result.sarif
```

10. The action name:
    ```
    github/codeql-action/upload-sarif@v3
    ```

11. The `if` condition (one word):
    ```
    always()
    ```

12. Why that `if` condition? (One sentence — what would happen without it?)
    ```
    runs the step regardless of the status report
    ```

13. The `sarif_file` value for the Trivy workflow:
    ```
    trivy-report.sarif
    ```

---

## Part 4: gitleaks protect vs detect (Q14–16)

14. In one sentence: what does `gitleaks protect` scan, and what does `gitleaks detect` scan?
    ```
    protect = scans working tree
    detect  = scans all git commit history
    ```

15. Which command would catch a secret committed 3 months ago and then deleted?
    ```
    gitleaks
    ```

16. Which command is faster and why?
    ```
    protect because it only scans the current working tree
    ```

---

## Part 5: Pre-Commit Config Structure (Q17–22)

Fill in the `.pre-commit-config.yaml` structure:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5
    hooks:
      - id: check-yaml
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: check-json

  - repo: https://github.com/gitleaks/gitleaks
    rev: v8
    hooks:
      - id: gitleaks

  - repo: https://github.com/semgrep/semgrep
    rev: v1
    hooks:
      - id: semgrep
        args: ['--config=p/security-audit', '--error']

exclude: ^(vendor|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
```

17. Repo URL for basic syntax hooks (YAML, JSON, trailing-whitespace, end-of-file):
    ```
    https://github.com/pre-commit/pre-commit
    ```

18. The hook ID for YAML syntax validation:
    ```
    check-yaml
    ```

19. The hook ID that ensures files end with a newline:
    ```
    enf-of-file-fixer
    ```

20. The repo URL for gitleaks:
    ```
    https://github.com/gitleaks/gitleaks
    ```

21. The repo URL for semgrep:
    ```
    https://github.com/semgrep/semgrep
    ```

22. The full `exclude:` pattern line:
    ```
    ^(vendor|bin|node_modules|dist|build|\.vscode|\.idea|tests/.pest/snapshots)/
    ```

---

## Part 6: Docker Commands (Q23–25)

23. List running containers:
    ```
    docker ps
    ```

24. View a container's health check status:
    ```
    curl -f http://localhost:80/health || exit 1
    ```

25. Inspect a container's Dockerfile HEALTHCHECK config:
    ```
    docker inspect --format='{{.State.Health}}'
    ```

---

## Part 7: HEALTHCHECK (Q26–33)

26. What is a Docker HEALTHCHECK? (One sentence)
    ```
    Checks the services running status
    ```

27. What's the difference between a container that's **running** vs one that's **healthy**?
    ```
    a healthy container ensures that running services are running while running is not clear whether the services are running or dead.
    ```

28. What happens when a container's health check keeps failing?
    ```
    it returns an error
    ```

29. Why is `--start-period` important for PHP/Laravel apps?
    ```
    It initializes the services to boot up while not get flagged as down
    ```

30. What does `--interval=30s` mean?
    ```
    the duration the container to keep running
    ```

31. What does `--timeout=3s` mean?
    ```
    waits for 3 seconds before flagging a status as failed or down
    ```

32. What does `--retries=3` mean?
    ```
    it tries booting up 3 times before flagging it as down if it keeps failing
    ```

33. What command does HEALTHCHECK use to check a Laravel/PHP web app health?
    ```
    it checks the image after building
    ```

---

## Part 8: HEALTHCHECK Syntax (Q34–36)

34. Write the complete HEALTHCHECK instruction with all flags and the curl command:
    ```dockerfile
    ___
    ```

35. Why is `|| exit 1` required at the end of the HEALTHCHECK CMD?
    ```
    it stops the building process before proceeding to deployment to avoid CVEs
    ```

36. In a multi-stage Dockerfile, which stage gets the HEALTHCHECK?
    ```
    After the build stage
    ```

---

## Part 9: GitHub CLI (Q37–40)

37. List recent workflow runs (show 5):
    ```
    gh run view --limit-5
    ```

38. View a specific run's full logs:
    ```
    gh run view <id> logs
    ```

39. View only failed step logs:
    ```
    gh run view <id> --logs-failed
    ```

40. What flag distinguishes `--force-with-lease` from `--force`?
    ```
    force-with-lease pushes the code if no conflicting merge and force is destructive because it overwrites other dev work on a repository
    ```

---

## Score Sheet

| Q | Your Answer | Max | Notes |
|---|------------|-----|-------|
| 1 | | 1 | |
| 2 | | 1 | |
| 3 | | 1 | |
| 4 | | 1 | |
| 5 | | 1 | |
| 6 | | 1 | |
| 7 | | 1 | |
| 8 | | 1 | |
| 9 | | 1 | |
| 10 | | 1 | |
| 11 | | 1 | |
| 12 | | 1 | |
| 13 | | 1 | |
| 14 | | 1 | |
| 15 | | 1 | |
| 16 | | 1 | |
| 17 | | 1 | |
| 18 | | 1 | |
| 19 | | 1 | |
| 20 | | 1 | |
| 21 | | 1 | |
| 22 | | 1 | |
| 23 | | 1 | |
| 24 | | 1 | |
| 25 | | 1 | |
| 26 | | 1 | |
| 27 | | 1 | |
| 28 | | 1 | |
| 29 | | 1 | |
| 30 | | 1 | |
| 31 | | 1 | |
| 32 | | 1 | |
| 33 | | 1 | |
| 34 | | 1 | |
| 35 | | 1 | |
| 36 | | 1 | |
| 37 | | 1 | |
| 38 | | 1 | |
| 39 | | 1 | |
| 40 | | 1 | |
| **Total** | **/40** | **40** | **%** |

**Pass: 38/40 (95%)**
