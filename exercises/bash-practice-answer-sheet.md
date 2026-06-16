# Bash CI/CD Practice Exercises — Answer Sheet

**Date:** 06/16/26
**Score:** 14/30 (47%) — WORKING KNOWLEDGE

---

## Day 1: Exit Codes and `set -e`

### Exercise 1
Write a script that:
1. Takes a filename as argument (`$1`)
2. Exits with code `1` if the file doesn't exist
3. Echoes "File exists" if it does

```bash
#!/usr/bin/env bash

FILE="$1"

[[ -f "$FILE" ]] || { echo "File not found: $FILE"; exit 1; }

echo "File exists: $FILE"

```

**Your score: 2/3** ⚠️
> Logic is correct! But missing `set -euo pipefail` at the top. Add this to EVERY script from now on.

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

1. The url link has no ("")
2. The echoed output separates all words
3. Token has no ("")

**Your score: 3/3** ✅
> Perfect! You identified all 3 bugs.

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
[[ -f "composer.json" ]] && composer install

# 3. Check if we're on the main branch, echo "On main" if yes
BRANCH=$(git rev-parse --abbrev-ref HEAD)
[[ -f $BRANCH == "main" ]] || echo "On main"

```

**Your score: 1.5/3** ❌
> #2 is correct. But #3 has wrong syntax. You mixed up `[[ -f ]]` (file test) with string comparison.

**Your mistake:**
```bash
[[ -f $BRANCH == "main" ]]  # ❌ WRONG
# -f checks if something is a FILE, not for string comparison
# Also missing quotes around $BRANCH
```

**Correct answer:**
```bash
# 2.
[[ -f "composer.json" ]] && composer install

# 3.
if [[ "$BRANCH" == "main" ]]; then
    echo "On main branch"
fi
```

**Quick reference:**
- `[[ -f "file" ]]` → Is it a file? (yes/no)
- `[[ "$VAR" == "value" ]]` → Does string match? (yes/no)
- `[[ -z "$VAR" ]]` → Is string empty? (yes/no)
- `[[ "$VAR" =~ ^pattern$ ]]` → Does it match regex? (yes/no)

---

## Day 4: Command Substitution `$( )`

### Exercise 4
Write the command substitutions:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Get current git branch
BRANCH=$(git checkout)

# 2. Get the latest tag (or "no-tag" if none)
TAG=$(git tag)

# 3. Count workflow files in .github/workflows
WORKFLOW_COUNT=$()

```

**Your score: 0/3** 🔴
> All 3 are wrong commands. No partial credit here — the commands matter.

**Your mistakes:**
```bash
BRANCH=$(git checkout)        # ❌ git checkout SWITCHES branches
TAG=$(git tag)               # ❌ git tag LISTS all tags, not latest
WORKFLOW_COUNT=$()           # ❌ Empty — needs a command inside ()
```

**Correct answers:**
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
# - rev-parse = resolve git reference to hash
# - --abbrev-ref = give human-readable branch name instead of hash

TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")
# - describe --tags = finds the closest tag to current commit
# - --abbrev=0 = no hash suffix
# - 2>/dev/null = suppress error if no tags
# - || echo "no-tag" = fallback if command fails

WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
# - find = search for files
# - -name "*.yml" -o -name "*.yaml" = OR pattern
# - | wc -l = count lines (how many files found)
```

**Memorize these:**
```bash
# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Get latest tag
TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")

# Count files
COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
```

---

## Day 5: `set -euo pipefail` + `&&` / `||`

### Exercise 5
Write the scripts:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Check if gitleaks is installed, echo "installed" or "missing"
[[ -f gitleaks version ]] || { echo "installed"; exit 1; }
echo "missing"

# 2. Run trivy, echo "passed" if success, "CVEs detected" if failed
# _______________________________________________________________

# 3. Full pattern: install trivy if not present, then run scan
# _______________________________________________________________

```

**Your score: 0.5/3** 🔴
> You tried! But `[[ -f ]]` is for FILES, not for checking if a command is installed. Use `command -v` instead.

**Your mistake:**
```bash
[[ -f gitleaks version ]]  # ❌ WRONG
# -f checks if a FILE exists
# - "gitleaks version" is not a valid file path
# - Use `command -v` to check if a command is installed
```

**Correct answers:**
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

**Quick reference:**
```bash
# Check if command is installed
command -v gitleaks        # Returns path if installed, empty if not

# In an if statement
if command -v gitleaks > /dev/null 2>&1; then
    echo "installed"
fi

# Negate with !
if ! command -v trivy > /dev/null 2>&1; then
    echo "not installed, install it"
fi

# && and || together
trivy fs . --exit-code 1 \
    && echo "passed" \
    || echo "failed"
```

---

## Day 6: `for` Loops

### Exercise 6
Write a script that checks if these tools are installed: `trivy`, `gitleaks`, `pre-commit`

```bash
#!/usr/bin/env bash
set -euo pipefail

TOOLS="trivy gitleaks pre-commit"

for tool in $TOOLS; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "Installed: $tool"
  else
    echo "Missing: $tool"
  fi
done

```

**Your score: 3/3** ✅
> Perfect! Syntax is correct. Just minor spacing difference (`>/dev/null` vs `> /dev/null`) but functionally identical.

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
          if ! command -v trivy 2>/dev/null 2>&1; then
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
          fi
          trivy fs . --severity CRITICAL --exit-code 1
          echo "No critical CVEs found"

```

**Your score: 2.5/3** ✅
> Almost perfect! Logic is correct. Minor fix: `command -v` should redirect to `> /dev/null 2>&1` not `2>/dev/null 2>&1`.

**Your mistake:**
```yaml
if ! command -v trivy 2>/dev/null 2>&1; then  # ❌ Minor
# The 2>/dev/null should be > /dev/null
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

**Your score: 0/3** ⬜
> Left blank. Need to practice.

**Expected answer:**
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

**Key pattern:**
```bash
# Check if env var is empty → exit with error
[[ -z "$VAR" ]] && { echo "VAR is required"; exit 1; }

# Run command, fail pipeline on error (via set -e)
command --exit-code 1
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

**Your score: 0/3** ⬜
> Left blank. Need to practice.

**Expected answer:**
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

**Key pattern:**
```bash
# Check if directory exists before scanning
for dir in src tests vendor; do
    if [[ -d "$dir" ]]; then
        echo "Scanning: $dir"
        trivy fs "$dir"
    fi
done
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

**Your score: 0/3** ⬜
> Left blank. Need to practice.

**Expected answer:**
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

**Key patterns:**
```bash
# Function with parameters
function_name() {
    local param1="$1"                    # First argument
    local param2="${2:-default}"        # Second argument with default
}

# Check directory exists
if [[ ! -d "$target" ]]; then
    echo "Not a directory"
    return 1
fi

# Check tool installed
if ! command -v trivy > /dev/null 2>&1; then
    echo "Tool missing"
    return 1
fi
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
it executes a bash script
```

**What's the bug?**

```
No quotation on the version value
```

**Your score: 1.5/3** ⚠️
> You understood that quotes are the issue, but your fix is wrong. You need `$( )` for command substitution, not just quotes.

**Your mistake:**
```bash
VERSION="$TOOL --version"  # ❌ This is just a STRING, not running a command
# It will output: "Installed version: trivy --version"
# NOT the actual version number
```

**Correct answer:**
```bash
VERSION=$(trivy --version 2>/dev/null | head -1 || echo "not installed")
# - $( ) = run command and capture output
# - | head -1 = get first line only
# - 2>/dev/null = suppress errors
# - || echo = fallback if command fails
```

**bash -x actually shows:**
```
+ TOOL=trivy
+ VERSION=trivy
+ --version
+ echo 'Installed version: trivy'
Installed version: trivy
```
The `+ --version` on its own line is the bug — it's being treated as a separate command.

---

## 📊 Final Score Breakdown

| Exercise | Pattern | Your Score | Max | Status |
|----------|---------|------------|-----|--------|
| 1 | `[[ -f ]]` + `exit 1` | 2 | 3 | ⚠️ Missing set -euo pipefail |
| 2 | Variable quoting | 3 | 3 | ✅ Perfect |
| 3 | `&&` conditional + `==` | 1.5 | 3 | ❌ Wrong syntax |
| 4 | `$(command)` substitution | 0 | 3 | 🔴 Wrong commands |
| 5 | `command -v` + `&&`/`\|\|` | 0.5 | 3 | 🔴 Wrong approach |
| 6 | `for` loop | 3 | 3 | ✅ Perfect |
| 7 | GitHub Actions run block | 2.5 | 3 | ✅ Minor fix needed |
| 8 | Multi-step pipeline | 0 | 3 | ⬜ Need practice |
| 9 | Loop over directories | 0 | 3 | ⬜ Need practice |
| 10 | Reusable function | 0 | 3 | ⬜ Need practice |
| 11 | Debug with `bash -x` | 1.5 | 3 | ⚠️ Partial understanding |
| **Total** | | **14** | **30** | **47%** |

---

## 🎯 Priority Review Order

Based on your score, review in this order:

### 🔴 HIGH PRIORITY (Score: 0/3)
1. **Exercise 4** — Git commands: `rev-parse`, `describe --tags`, `find | wc -l`
2. **Exercise 5** — `command -v` vs `[[ -f ]]`
3. **Exercise 8** — Multi-step pipeline pattern
4. **Exercise 9** — Loop over directories
5. **Exercise 10** — Function syntax

### ⚠️ MEDIUM PRIORITY (Score: 1.5-2.5/3)
6. **Exercise 1** — Add `set -euo pipefail` everywhere
7. **Exercise 3** — String comparison `[[ ]]` vs file test `[[ -f ]]`
8. **Exercise 11** — Command substitution `$( )` for getting output

---

## 📝 Patterns to Memorize

### Git Commands for CI/CD
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)           # Current branch
COMMIT=$(git rev-parse HEAD)                        # Full SHA
TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "none")
```

### Check If Command Installed
```bash
if command -v gitleaks > /dev/null 2>&1; then
    echo "installed"
fi

if ! command -v trivy > /dev/null 2>&1; then
    echo "not installed"
fi
```

### File/Directory Tests
```bash
[[ -f "file.txt" ]]     # File exists
[[ -d "folder" ]]       # Directory exists
[[ -z "$VAR" ]]         # Variable is empty
[[ "$A" == "$B" ]]      # Strings equal
```

### Install + Run Pattern
```bash
if ! command -v tool > /dev/null 2>&1; then
    curl -sfL https://install.url | sh -s -- -b /usr/local/bin
fi
tool run --flags
```

---

## Notes

_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________