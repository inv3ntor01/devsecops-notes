# Recap Drill — All DevSecOps Foundations
**Date:** 2026-06-17 — Attempt 2
**Pass threshold:** 95% (38/40)
**Rules:** No cheatsheet. No notes. Pure recall.

---

## Part 1: Installation Commands (Q1–5)

1. Install Trivy into `/usr/local/bin`:
   ```
   curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/content/install.sh | sh -s -- -b /usr/local/bin
   ```

2. Install gitleaks v8.30.1 into `/usr/local/bin`:
   ```
   curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | tar xz -C /usr/local/bin
   ```

3. Install pre-commit:
   ```
   pip install pre-commit
   ```

4. Does `sudo apt install trivy` work?
   ```
   no
   ```

5. Confirm gitleaks is installed:
   ```
   gitleaks version
   ```

---

## Part 2: GitHub Action Names (Q6–9)

6. Checkout code:
   ```yaml
   uses: actions/checkout@v6
   ```

7. Run Trivy scan:
   ```yaml
   uses: aquasecurity/trivy-action@master
   ```

8. Upload SARIF:
   ```yaml
   uses: github/codeql-action/upload-sarif@v3
   ```

9. Run pre-commit in CI:
   ```yaml
   uses: pre-commit/action@v3
   ```

---

## Part 3: SARIF Upload Pattern (Q10–13)

```yaml
# Upload SARIF to GitHub Security tab
- uses: github/codeql-action/upload-sarif@v3
  if: always()
  with:
    sarif_file: sarif-report.sarif
```

10. Action name:
    ```
    uses: github.com/codeql-action/upload-sarif@v3
    ```

11. `if` condition:
    ```
    always()
    ```

12. Why that `if` condition?
    ```
    Continue the steps even if the previous failed
    ```

13. sarif_file for Trivy:
    ```
    trivy-report.sarif
    ```

---

## Part 4: gitleaks protect vs detect (Q14–16)

14. What does each scan?
    ```
    protect = scans current working tree
    detect  = scans all git commit history
    ```

15. Catch deleted secret?
    ```
    yes
    ```

16. Which is faster and why?
    ```
    protect
    ```

---

## Part 5: Pre-Commit Config (Q17–22)

```yaml
repos:
  - repo: github.com/pre-commit-hooks
    rev: v2
    hooks:
      - id: check-yaml
      - id: end-of-file-fixer
      - id: check-json
      - id: trailing-whitespaces

  - repo: returntocorp/semgrep
    rev: v2
    hooks:
      - id: semgrep

  - repo: gitleaks/gitleaks
    rev: v2
    hooks:
      - id: gitleaks
        args: always()

exclude: ^(vendor|bin|build|\.ideas|tests\.pest\snapshots)/
```

17. Hooks repo URL:
    ```
    github.com/pre-commit-hooks
    ```

18. YAML hook ID:
    ```
    check-yaml
    ```

19. Newline hook ID:
    ```
    end-of-file-fixer
    ```

20. Gitleaks repo URL:
    ```
    gitleaks/gitleaks
    ```

21. Semgrep repo URL:
    ```
    returntocorp/semgrep
    ```

22. Exclude pattern:
    ```
    ^(vendor|bin|build|\.ideas|tests\.pest\snapshots)/
    ```

---

## Part 6: Docker Commands (Q23–25)

23. List running containers:
    ```
    docker ps
    ```

24. View container health status:
    ```
    curl -f http://localhost:80/health || exit 1
    ```

25. Inspect HEALTHCHECK config:
    ```
    docker inspect --format={{.STATUS.HEALTH}}
    ```

---

## Part 7: HEALTHCHECK Concepts (Q26–33)

26. What is a Docker HEALTHCHECK?
    ```
    checks the services of a container
    ```

27. Running vs healthy:
    ```
    Running = status check Healthy = Services running
    ```

28. Health check keeps failing:
    ```
    Kubernetes may restart or re initialize the container
    ```

29. Why --start-period for PHP/Laravel?
    ```
    Booting time of the container
    ```

30. What does --interval=30s mean?
    ```
    How long does the check last
    ```

31. What does --timeout=3s mean?
    ```
    Time limit for the container to respond
    ```

32. What does --retries=3 mean?
    ```
    reties 3 failed attempt before flagging as down
    ```

33. HEALTHCHECK command for PHP/Laravel app?
    ```
    ___
    ```

---

## Part 8: HEALTHCHECK Syntax (Q34–36)

34. Full HEALTHCHECK instruction:
    ```dockerfile
    HEALTHCHECK --interval=30s --start-period=40s --timeout=3s --retries=3 CMD curl -f http://localhost:80/health || exit 1
    ```

35. Why `|| exit 1`?
    ```
    it reads the output status exit 0 = success and exit 1+ = failed
    ```

36. Which stage in multi-stage Dockerfile?
    ```
    Deployment stage
    ```

---

## Part 9: GitHub CLI (Q37–40)

37. List recent workflow runs:
    ```
    gh run list --limit 5
    ```

38. View run logs:
    ```
    gh run view <id>
    ```

39. View failed logs:
    ```
    gh run view <id> --log-failed
    ```

40. --force-with-lease vs --force:
    ```
    --force-with-lase = merge if not conflicts with the previous pull and --force is destructive, it ignores the previous commit and overwrites the file
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
