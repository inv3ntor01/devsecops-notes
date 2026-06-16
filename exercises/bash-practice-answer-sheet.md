# Bash CI/CD Practice Exercises — Answer Sheet

**Date:** _______________
**Score:** ___/30

---

## Day 1: Exit Codes and `set -e`

### Exercise 1
Write a script that:
1. Takes a filename as argument (`$1`)
2. Exits with code `1` if the file doesn't exist
3. Echoes "File exists" if it does

```bash
#!/usr/bin/env bash


```

**Expected:**
```bash
#!/usr/bin/env bash
set -euo pipefail

FILE="$1"

[[ -f "$FILE" ]] || { echo "File not found: $FILE"; exit 1; }

echo "File exists: $FILE"
```

---

## Day 2: Variable Quoting

### Exercise 2
Fix the bugs in this script:

```bash
#!/usr/bin/env bash
TOKEN="$GITHUB_TOKEN"
OUTPUT="scan report.txt"

curl -s -H "Bearer $TOKEN" https://api.github.com
echo $OUTPUT
rm $TOKEN
```

**What's broken?**

1. _____________________________________________________________________

2. _____________________________________________________________________

3. _____________________________________________________________________

**Fixed version:**

```bash
#!/usr/bin/env bash
TOKEN="$GITHUB_TOKEN"
OUTPUT="scan report.txt"

curl -s -H "Bearer $TOKEN" "https://api.github.com"
echo "$OUTPUT"


```

---

## Day 3: Conditionals — `[[ ]]` Test Operators

### Exercise 3
Write the missing parts:

```bash
#!/usr/bin/env bash

# 1. Exit if GITHUB_TOKEN is not set
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "GITHUB_TOKEN is required"
    exit 1
fi

# 2. Run composer install only if composer.json exists
# _______________________________________________________

# 3. Check if we're on the main branch, echo "On main" if yes
BRANCH=$(git rev-parse --abbrev-ref HEAD)
# _______________________________________________________

```

**Expected:**
```bash
# 2.
[[ -f "composer.json" ]] && composer install

# 3.
if [[ "$BRANCH" == "main" ]]; then
    echo "On main branch"
fi
```

---

## Day 4: Command Substitution `$( )`

### Exercise 4
Write the command substitutions:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Get current git branch
BRANCH=____________________________________

# 2. Get the latest tag (or "no-tag" if none)
TAG=____________________________________

# 3. Count workflow files in .github/workflows
WORKFLOW_COUNT=____________________________________

```

**Expected:**
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")
WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
```

---

## Day 5: `set -euo pipefail` + `&&` / `||`

### Exercise 5
Write the scripts:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Check if gitleaks is installed, echo "installed" or "missing"
# _______________________________________________________________

# 2. Run trivy, echo "passed" if success, "CVEs detected" if failed
# _______________________________________________________________

# 3. Full pattern: install trivy if not present, then run scan
# _______________________________________________________________

```

**Expected:**
```bash
# 1.
if command -v gitleaks > /dev/null 2>&1; then
    echo "installed"
else
    echo "missing"
fi

# 2.
trivy fs . --severity CRITICAL --exit-code 1 \
    && echo "passed" \
    || echo "CVEs detected"

# 3.
if ! command -v trivy > /dev/null 2>&1; then
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
        | sh -s -- -b /usr/local/bin
fi
trivy fs . --severity CRITICAL --exit-code 1
echo "No critical CVEs"
```

---

## Day 6: `for` Loops

### Exercise 6
Write a script that checks if these tools are installed: `trivy`, `gitleaks`, `pre-commit`

```bash
#!/usr/bin/env bash
set -euo pipefail

TOOLS="trivy gitleaks pre-commit"

# _______________________________________________________________
# _______________________________________________________________
# _______________________________________________________________
# _______________________________________________________________

```

**Expected:**
```bash
for tool in $TOOLS; do
    if command -v "$tool" > /dev/null 2>&1; then
        echo "Installed: $tool"
    else
        echo "Missing: $tool"
    fi
done
```

---

## CI/CD Pipeline Exercises

### Exercise 7: GitHub Actions `run:` Block
Write the `run:` block for a GitHub Actions workflow that:
1. Installs trivy if not present
2. Runs a filesystem scan
3. Fails the pipeline if CRITICAL CVEs are found

```yaml
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy scan
        run: |
          # _______________________________________________________
          # _______________________________________________________
          # _______________________________________________________
          # _______________________________________________________

```

**Expected:**
```yaml
      - name: Run Trivy scan
        run: |
          if ! command -v trivy > /dev/null 2>&1; then
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
              | sh -s -- -b /usr/local/bin
          fi
          trivy fs . --severity CRITICAL --exit-code 1
          echo "✅ No critical CVEs found"
```

---

### Exercise 8: Multi-Step Pipeline
Write a `run:` block that:
1. Checks for required env vars (`GITHUB_TOKEN`, `BRANCH_NAME`)
2. Runs gitleaks protect
3. Runs trivy fs scan
4. Only proceeds to next step if previous succeeded

```yaml
      - name: Security checks
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          BRANCH_NAME: ${{ github.ref_name }}
        run: |
          # _______________________________________________________
          # _______________________________________________________
          # _______________________________________________________
          # _______________________________________________________
          # _______________________________________________________

```

**Expected:**
```yaml
        run: |
          set -euo pipefail

          # Check required env vars
          [[ -z "$GITHUB_TOKEN" ]] && { echo "GITHUB_TOKEN required"; exit 1; }
          [[ -z "$BRANCH_NAME" ]] && { echo "BRANCH_NAME required"; exit 1; }

          # Run gitleaks
          echo "Running gitleaks..."
          gitleaks protect --source . --exit-code 1

          # Run trivy
          echo "Running trivy..."
          trivy fs . --severity CRITICAL --exit-code 1

          echo "✅ All security checks passed"
```

---

### Exercise 9: Loop Over Multiple Targets
Write a `run:` block that scans `src`, `tests`, and `vendor` directories with trivy.

```yaml
      - name: Scan all directories
        run: |
          # _______________________________________________________
          # _______________________________________________________
          # _______________________________________________________

```

**Expected:**
```yaml
        run: |
          set -euo pipefail

          for dir in src tests vendor; do
            if [[ -d "$dir" ]]; then
              echo "Scanning: $dir"
              trivy fs "$dir" --severity CRITICAL --exit-code 1
            fi
          done
          echo "✅ All directories scanned"
```

---

### Exercise 10: Function in CI/CD
Convert this to a reusable function in a shell script:

```bash
#!/usr/bin/env bash
# Reusable security scan function

# _______________________________________________________
# _______________________________________________________
# _______________________________________________________
# _______________________________________________________

# Usage examples:
# scan_directory "." "CRITICAL"
# scan_directory "./vendor" "HIGH"

```

**Expected:**
```bash
#!/usr/bin/env bash
set -euo pipefail

scan_directory() {
    local target="$1"
    local severity="${2:-CRITICAL}"

    if [[ ! -d "$target" ]]; then
        echo "⚠️  Skipping $target (not a directory)"
        return 0
    fi

    echo "Scanning: $target (severity: $severity)"

    if ! command -v trivy > /dev/null 2>&1; then
        echo "⚠️  Trivy not installed — skipping"
        return 1
    fi

    trivy fs "$target" --severity "$severity" --exit-code 1
    echo "✅ $target passed"
}

# Usage examples:
scan_directory "." "CRITICAL"
scan_directory "./vendor" "HIGH"
```

---

### Exercise 11: Debug Pipeline Failure
This script is failing. Use `bash -x` to find the bug:

```bash
#!/usr/bin/env bash
set -euo pipefail

TOOL="trivy"
VERSION=$TOOL --version

echo "Installed version: $VERSION"
```

**What does `bash -x` show?**

```
_____________________________________________________________________
_____________________________________________________________________
```

**What's the bug?**

```
_____________________________________________________________________
```

**Fix:**

```bash
#!/usr/bin/env bash
set -euo pipefail

TOOL="trivy"
VERSION=____________________________________

echo "Installed version: $VERSION"
```

**Expected:**
```bash
VERSION=$(trivy --version 2>/dev/null | head -1 || echo "not installed")
```

---

## Scoring Guide

| Exercise | Pattern | Max |
|----------|---------|-----|
| 1 | `[[ -f ]]` + `exit 1` | 3 pts |
| 2 | Variable quoting fixes | 3 pts |
| 3 | `&&` conditional + `==` | 3 pts |
| 4 | `$(command)` substitution | 3 pts |
| 5 | `command -v` + `&&`/`\|\|` | 3 pts |
| 6 | `for` loop | 3 pts |
| 7 | GitHub Actions run block | 3 pts |
| 8 | Multi-step pipeline | 3 pts |
| 9 | Loop over directories | 3 pts |
| 10 | Reusable function | 3 pts |
| 11 | Debug with `bash -x` | 3 pts |
| **Total** | | **30 pts** |

| Score | Level |
|-------|-------|
| 27-30 | Expert |
| 21-26 | Solid |
| 15-20 | Working knowledge |
| <15 | Review and retry |

---

## Notes

_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________