# Bash for CI/CD Security — 2-Week Learning Plan

**Goal:** Write and debug CI/CD pipeline `run:` blocks for LaraKube CLI security gates
**Prerequisite:** You already know what you need bash for — now learn just enough to do it

---

## Why this plan exists

You scored 3.5/23 on the bash test. Your CI/CD foundation is strong — but every pipeline step you run is a bash command. When Trivy fails, you read bash output. When gitleaks catches something, it's running bash under the hood.

You don't need to be a bash expert. You need to master the **8 bash patterns that appear in 80% of CI/CD scripts.**

---

## The 8 Patterns You Must Master

| # | Pattern | What it looks like |
|---|---|---|
| 1 | `set -euo pipefail` | Top of every script |
| 2 | Variable quoting | `"$VAR"` not `$VAR` |
| 3 | Exit codes + `&&` / `\|\|` | Control flow in every step |
| 4 | `[[ -f ]]`, `[[ -d ]]`, `[[ -z ]]` | Conditionals |
| 5 | `$( )` command substitution | Capture tool output |
| 6 | `for` loops | Run a tool on multiple targets |
| 7 | Functions + `local` | Reusable logic blocks |
| 8 | `bash -x` debugging | Find broken scripts |

That's the entire list. Everything else in bash CI scripts is a variation of these 8.

---

## Week 1 — Foundations (Days 1–5)

Each day: read the concept → run the examples → do the exercise → check yourself.

---

### Day 1: Exit Codes and `set -e`

**Concept:** Every command returns an exit code. `0` = success. `1+` = failure.
`set -e` makes your script stop on the first failure.

**Why it matters in CI:** Your pipeline must fail if a security scan finds something.

```bash
# Without set -e — script continues even if trivy finds CVEs
trivy fs . --exit-code 1
echo "Script finished"   # runs even if trivy failed

# With set -e — script stops immediately
set -e
trivy fs . --exit-code 1
echo "Script finished"   # NEVER runs if trivy failed
```

```bash
# Check exit codes manually
trivy fs .
echo "Exit code: $?"   # 0 if success, 1 if it found something

false
echo "Exit code: $?"   # 1
```

**Exercise 1:**
```bash
#!/usr/bin/env bash
# Fix this script: it should stop if the file doesn't exist

FILE="$1"

# Your code here — make it exit 1 if file doesn't exist
# Hint: use [[ -f ]] and || exit 1
```

**Answer:**
```bash
[[ -f "$FILE" ]] || { echo "File not found: $FILE"; exit 1; }
```

---

### Day 2: Variable Quoting

**Concept:** `"$VAR"` preserves spaces and special chars. `$VAR` does not.

**Why it matters in CI:** File paths have spaces. Usernames have spaces. Unquoted variables break on spaces.

```bash
# This breaks if the file has a space in the name
FILE="my report.txt"
rm $FILE          # expands to: rm my report.txt → tries to delete "my" and "report.txt"

# This is safe
FILE="my report.txt"
rm "$FILE"        # expands to: rm "my report.txt"

# Real CI example
BRANCH_NAME="feature/bug fix"    # branch with a space
echo $BRANCH_NAME                 # prints: feature bug fix — WRONG
echo "$BRANCH_NAME"               # prints: feature/bug fix — RIGHT
```

```bash
# Always quote variables that might contain spaces
GITHUB_TOKEN="abc 123"
curl -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com

# Quote everything as a habit — it costs nothing
echo "The branch is $BRANCH_NAME"
```

**Exercise 2:**
```bash
#!/usr/bin/env bash
# Fix the quoting bugs in this CI-style script

TOKEN="$GITHUB_TOKEN"
REPO=inv3ntor01/larakube-cli
OUTPUT="scan report.txt"

# Which of these are broken? Fix them.
curl -s -H "Bearer $TOKEN" https://api.github.com/repos/$REPO
echo $OUTPUT
rm $TOKEN
```

**Answer:**
```bash
curl -s -H "Bearer $TOKEN" "https://api.github.com/repos/$REPO"
echo "$OUTPUT"
# TOKEN shouldn't be deleted, but if it were:
# rm "$TOKEN"
```

---

### Day 3: Conditionals — `[[ ]]` Test Operators

**Concept:** `[[ ]]` is the bash way to test conditions. It's safer than `[ ]`.

**Why it matters in CI:** Every `if this file exists, then scan it` is a conditional.

```bash
# File and directory tests
[[ -f "composer.json" ]]    # true if regular file exists
[[ -d "src" ]]              # true if directory exists
[[ -z "$TOKEN" ]]           # true if variable is empty
[[ -n "$TOKEN" ]]           # true if variable is NOT empty
[[ "$VAR" == "main" ]]      # string equality
[[ "$BRANCH" =~ ^feature/ ]] # regex match

# Real CI examples
[[ -f "composer.json" ]] && composer install
[[ -f "package.json" ]] && npm ci

# Combine conditions
if [[ -f "$FILE" ]] && [[ -s "$FILE" ]]; then
    echo "File exists and is not empty"
fi
```

**Exercise 3:**
```bash
#!/usr/bin/env bash
# Write the missing conditionals

# 1. Exit if GITHUB_TOKEN is not set
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "GITHUB_TOKEN is required"
    exit 1
fi

# 2. Run composer install only if composer.json exists
# Your code here

# 3. Check if we're on the main branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
# Your code here — echo "On main branch" if true
```

**Answers:**
```bash
# 2.
[[ -f "composer.json" ]] && composer install

# 3.
if [[ "$BRANCH" == "main" ]]; then
    echo "On main branch"
fi
```

---

### Day 4: Command Substitution `$( )`

**Concept:** `$(command)` runs the command and returns its output. You capture it into a variable.

**Why it matters in CI:** Every time you need a dynamic value — branch name, commit SHA, tool version — you use `$( )`.

```bash
# Capture tool output
BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT=$(git rev-parse HEAD)
TRIVY_VERSION=$(trivy --version 2>/dev/null | head -1)

# Use captured values in commands
echo "Scanning branch: $BRANCH"
gh run list --limit 5 --branch "$BRANCH"

# Nested command substitution
FILE_COUNT=$(find . -name "*.php" | wc -l)
echo "PHP files: $FILE_COUNT"
```

**Exercise 4:**
```bash
#!/usr/bin/env bash
# Write the command substitutions

# 1. Get the current git branch
BRANCH=???

# 2. Get the latest tag
TAG=???

# 3. Count how many workflow files exist
WORKFLOW_COUNT=???

# 4. Get only the exit code of trivy (don't let it stop the script)
# Hint: run trivy, capture $?, but don't exit on failure
set +e
trivy fs . --severity CRITICAL --exit-code 1 > /dev/null 2>&1
TRIVY_RESULT=$?
set -e
if [[ "$TRIVY_RESULT" -eq 0 ]]; then
    echo "No critical CVEs found"
else
    echo "Critical CVEs detected!"
fi
```

**Answers:**
```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")
WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
```

---

### Day 5: `set -euo pipefail` + `&&` / `||` in Real Scripts

**Concept:** Combine everything. This is the header of every CI script you write.

**Why it matters:** This is the pattern that appears in every single `run:` block in your pipelines.

```bash
#!/usr/bin/env bash
set -euo pipefail

# && runs next command only if previous succeeded
# || runs next command only if previous failed

# CI pattern: do X, then Y only if X succeeded
npm ci && npm run build

# CI pattern: do X, or exit with message if it fails
curl -sSL https://... | tar xz -C /usr/local/bin \
    || { echo "Failed to install gitleaks"; exit 1; }

# CI pattern: conditional based on exit code
gitleaks detect --source . --exit-code 1 \
    && echo "No secrets found" \
    || echo "Secrets detected!"
```

**Exercise 5:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Install gitleaks only if it's not already installed
# Your code here
# Hint: command -v gitleaks returns the path if installed, nothing if not

# 2. Run trivy and only echo success if it passes
# Your code here

# 3. Write the full install + scan pattern:
# - Install trivy if not present
# - Run trivy scan
# - Report result
```

**Answers:**
```bash
# 1.
if ! command -v gitleaks > /dev/null 2>&1; then
    curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/... | tar xz -C /usr/local/bin
fi

# 2.
trivy fs . --severity CRITICAL --exit-code 1 \
    && echo "Scan passed" \
    || echo "CVEs detected"

# 3.
if ! command -v trivy > /dev/null 2>&1; then
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh \
        | sh -s -- -b /usr/local/bin
fi
trivy fs . --severity CRITICAL --exit-code 1
echo "✅ No critical CVEs"
```

---

## Week 2 — Applied CI/CD Scripts (Days 6–10)

### Day 6: `for` Loops — Scan Multiple Targets

```bash
# Run trivy on each directory
for dir in src tests vendor; do
    trivy fs "$dir" --severity CRITICAL --exit-code 1
done

# Process each workflow file
for workflow in .github/workflows/*.yml; do
    echo "Validating: $workflow"
    # yaml validation here
done

# Iterate over a list from a variable
SCAN_TARGETS="src tests"
for target in $SCAN_TARGETS; do
    echo "Scanning: $target"
    trivy fs "$target"
done
```

**Exercise 6:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Write a script that:
# 1. Checks if each of these tools is installed: trivy, gitleaks, pre-commit
# 2. Echoes "Installed: <tool>" if found
# 3. Echoes "Missing: <tool>" if not found

TOOLS="trivy gitleaks pre-commit"

# Your code here
```

**Answer:**
```bash
TOOLS="trivy gitleaks pre-commit"
for tool in $TOOLS; do
    if command -v "$tool" > /dev/null 2>&1; then
        echo "Installed: $tool"
    else
        echo "Missing: $tool"
    fi
done
```

---

### Day 7: `while read` — Process Files Line by Line

```bash
# Read a list of repos from a file and scan each one
while read -r repo; do
    echo "Scanning: $repo"
    gitleaks detect --source "$repo"
done < repos.txt

# Read with IFS properly handled
while IFS= read -r line; do
    echo "Processing: $line"
done < input.txt

# Skip empty lines
while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    echo "Repo: $line"
done < repos.txt
```

**Exercise 7:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# repos.txt contains one repo per line: owner/repo
# Write a script that reads it and echoes each repo name

# Create the test file first:
# cat > repos.txt << 'EOF'
# inv3ntor01/larakube-cli
# inv3ntor01/devsecops-notes
# EOF

# Your code here
```

**Answer:**
```bash
while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    echo "Processing: $repo"
done < repos.txt
```

---

### Day 8: Functions + `local` — Clean Reusable Logic

```bash
# Without local — variable leaks out
set_var() {
    RESULT="something"
}
set_var
echo "$RESULT"   # "something" — leaked into outer scope

# With local — variable stays inside function
set_var() {
    local RESULT="something"
    echo "$RESULT"   # works inside, doesn't leak
}
set_var
# echo "$RESULT"   # would be empty here
```

**Real CI example — reusable scan function:**
```bash
run_scan() {
    local target="$1"
    local severity="${2:-CRITICAL}"

    echo "Scanning: $target (severity: $severity)"

    if ! command -v trivy > /dev/null 2>&1; then
        echo "Trivy not installed — skipping"
        return 1
    fi

    trivy fs "$target" --severity "$severity" --exit-code 1
}

# Use it
run_scan "." "CRITICAL"
run_scan "./vendor" "HIGH"
```

**Exercise 8:**
```bash
#!/usr/bin/env bash
set -euo pipefail

# Write a function that:
# 1. Takes a tool name as argument
# 2. Checks if it's installed
# 3. Returns 0 if installed, 1 if not
# 4. Uses `local` for the variable

check_tool() {
    local tool="$1"
    # Your code here
}

# Test it
check_tool "trivy" && echo "✅ trivy is installed" || echo "❌ trivy missing"
check_tool "nonexistent" && echo "✅ installed" || echo "❌ missing"
```

**Answer:**
```bash
check_tool() {
    local tool="$1"
    if command -v "$tool" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}
```

---

### Day 9: Debugging with `bash -x`

```bash
# Run a script with execution trace
bash -x script.sh
# Output shows each command with + prefix before running it
# + echo 'Starting scan'
# + trivy fs .
# + echo 'Done'

# Add debug mode inside a script
set -x   # turn on tracing
echo "Running scan"
trivy fs .
set +x   # turn off tracing

# Common debugging pattern — print variables
echo "DEBUG: BRANCH=$BRANCH TOKEN=${TOKEN:0:4}..."

# Find where a script is failing
set -x
source ./config.sh
./deploy.sh
set +x
```

**Exercise 9:**
Create a broken script, then use `bash -x` to find the bug:

```bash
#!/usr/bin/env bash
set -euo pipefail

# This script has a bug — find it with bash -x
TOOL="trivy"
VERSION=$TOOL --version

echo "Installed version: $VERSION"
```

Run it normally first, then run `bash -x script.sh`. What does the trace show?

---

### Day 10: Put It All Together — Write a Real CI Script

Write a script that mirrors what your GitHub Actions workflows do:

```bash
#!/usr/bin/env bash
# ci-check.sh — pre-push security check
# Run this before pushing to GitHub

set -euo pipefail

echo "=== CI Security Check ==="

# 1. Check required tools
check_tool() {
    local tool="$1"
    if ! command -v "$tool" > /dev/null 2>&1; then
        echo "❌ Missing: $tool"
        return 1
    fi
    echo "✅ $tool found"
}

# 2. Scan function
scan() {
    local target="$1"
    echo "--- Scanning: $target ---"
    trivy fs "$target" --severity CRITICAL --exit-code 1
    echo "✅ No critical CVEs in $target"
}

# 3. Main
echo ""
check_tool trivy
check_tool gitleaks
check_tool pre-commit
echo ""

echo "Running gitleaks..."
gitleaks protect --source .

echo ""
echo "Running Trivy..."
scan "."
scan "./vendor" 2>/dev/null || true

echo ""
echo "=== All checks passed ==="
```

**Exercise 10:**
Extend the script above to also:
- Check for `.env` files (they shouldn't be committed)
- Run semgrep if available
- Accept a `--skip-trivy` flag

---

## Daily Habit — Write Before You Read

For each day: try the exercise **cold first** (no peeking at the answer). You'll get it wrong — that's the point. The struggle is how you remember it.

The pattern from your HEALTHCHECK learning:
> Concepts strong → Execution weak → **Practice fixes execution**

Same here. The answers are in this guide. But the first time you see the exercise, try from memory. That's where the learning happens.

---

## Re-Take the Bash Test After Day 10

Go back to `exercises/05-bash-devops-test.md` and answer all 23 questions again. Target: **17/23 minimum**.

If you're below 17, focus on the sections where you dropped points and redo those days.

---

## TL;DR — The 8 Patterns to Memorize

```bash
# 1. Every script starts with this
set -euo pipefail

# 2. Always quote variables
echo "Branch: $BRANCH"

# 3. Test files and conditions
[[ -f "composer.json" ]] && composer install

# 4. Capture command output
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# 5. Control flow with exit codes
cmd && echo "success" || echo "failed"

# 6. Loop over targets
for dir in src tests vendor; do trivy fs "$dir"; done

# 7. Read lines from a file
while IFS= read -r line; do echo "$line"; done < file.txt

# 8. Debug with tracing
bash -x script.sh
```

---

*Re-take the bash test after Week 2. Target: 17/23 minimum.*