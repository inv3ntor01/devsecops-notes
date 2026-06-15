# Bash DevOps Knowledge Test

**Date:** 2026-06-15
**Rules:** No docs, no Google. Answer what you know, leave `???` or `___` where you don't.

---

## Section 1 — Variables & Exit Codes

1. What does `set -euo pipefail` do? (Line by line)

2. What's the difference between `$VAR` and `"$VAR"`?

3. What does `$?` capture?

4. Write a script that exits with code 1 if a file doesn't exist:
   ```bash
   ???
   ```

---

## Section 2 — Conditionals & Logic

5. Write the syntax to check if a directory exists:
   ```bash
   ???
   ```

6. What does this return?
   ```bash
   [[ "https://github.com" =~ ^https:// ]]
   echo $?
   ```
   ```
   ???
   ```

7. True or false: `&&` runs the next command only if the previous one succeeded.
   ```
   ???
   ```

8. What's the output?
   ```bash
   false || echo "ran"
   ```
   ```
   ???
   ```

---

## Section 3 — Loops

9. Write a loop that runs `trivy fs .` on each directory in a list:
   ```bash
   DIRS="src tests vendor"
   ???
   ```

10. What does this output?
    ```bash
    for i in {1..3}; do echo "$i"; done
    ```
    ```
    ???
    ```

11. Process each line of a file called `repos.txt`:
    ```bash
    while read -r line; do
        ???
    done < repos.txt
    ```

---

## Section 4 — Command Substitution & Pipes

12. Capture the current git branch into a variable:
    ```bash
    ???
    ```

13. What does `set -o pipefail` specifically prevent?

14. What's wrong with this?
    ```bash
    output = $(curl -s https://api.github.com/repos/inv3ntor01/larakube-cli)
    ```

---

## Section 5 — Functions

15. Write a function that exits 1 if a required env var is missing:
    ```bash
    require_env() {
        ???
    }
    ```

16. What does `local` do inside a function?

---

## Section 6 — Real DevOps Scenarios

17. Write a one-liner to find all `.env` files and delete them:
    ```bash
    ???
    ```

18. Diff two JSON files without installing jq:
    ```bash
    ???
    ```

19. Check if a port is open on localhost:
    ```bash
    ???
    ```

20. Download a file only if it doesn't exist:
    ```bash
    ???
    ```

21. Suppress stderr but keep stdout:
    ```bash
    ???
    ```

---

## Section 7 — Debugging

22. What does `bash -x script.sh` do?

23. What's the difference between `echo` and `printf`?

---

## Scoring Guide

| Score | Level | What it means |
|---|---|---|
| 21/23 | Expert | You can write production bash |
| 17–20 | Solid | Good enough for DevOps day-to-day |
| 13–16 | Working knowledge | Enough to read/write scripts, need practice |
| 9–12 | Beginner | Learn the gaps, practice daily |
| <9 | Start from scratch | Focus on Sections 1–3 first |

---

## Answers — fill in above first, then check

### Section 1

1. `set -e` = exit immediately if any command fails (non-zero exit code)
   `set -u` = exit if a variable is undefined (prevents empty var bugs)
   `set -o pipefail` = a pipeline fails if any part of it fails (not just the last command)

2. `$VAR` → splits on whitespace, glob-expands → dangerous with spaces/glob chars
   `"$VAR"` → preserves whitespace and special chars → safe

3. `$?` captures the exit code of the **last command** (0 = success, 1+ = failure)

4. ```bash
   #!/usr/bin/env bash
   set -euo pipefail

   [[ -f "$1" ]] || { echo "File not found: $1"; exit 1; }
   ```

---

### Section 2

5. ```bash
   if [[ -d "/path/to/dir" ]]; then
       echo "exists"
   fi
   ```

6. Returns `0` (true) — regex matched

7. True. `cmd1 && cmd2` → cmd2 only runs if cmd1 exited with 0.

8. Output: `ran` — `||` runs the next command if the previous one **failed** (non-zero)

---

### Section 3

9. ```bash
   for dir in $DIRS; do
       trivy fs "$dir"
   done
   ```

10. ```
    1
    2
    3
    ```

11. ```bash
    while read -r line; do
        echo "Processing: $line"
    done < repos.txt
    ```

---

### Section 4

12. ```bash
    branch=$(git rev-parse --abbrev-ref HEAD)
    ```

13. `set -o pipefail` makes a pipeline return the exit code of the **first non-zero command**, not just the last one. Without it, `cmd1 | cmd2 | cmd3` returns exit code of `cmd3` even if `cmd1` failed.

14. **Spaces around `=`** — bash variables can't have spaces around `=`.
    Correct: `output=$(curl ...)` — no spaces.

---

### Section 5

15. ```bash
    require_env() {
        local var_name="$1"
        [[ -z "${!var_name}" ]] && { echo "Missing required env: $var_name"; exit 1; }
    }
    # Usage: require_env GITHUB_TOKEN
    ```

16. `local` restricts a variable's scope to that function — it won't leak into the outer scope. Without it, setting a variable inside a function changes it globally.

---

### Section 6

17. ```bash
    find . -name ".env" -type f -delete
    ```

18. ```bash
    diff <(jq -S sort "$file1") <(jq -S sort "$file2")
    # Or without jq at all:
    diff <(cat "$file1") <(cat "$file2")
    ```

19. ```bash
    nc -z localhost 80 && echo "port open" || echo "port closed"
    # Or:
    timeout 1 bash -c 'echo >/dev/tcp/localhost/80' && echo "open"
    ```

20. ```bash
    [[ -f "file.tar.gz" ]] || curl -LO https://example.com/file.tar.gz
    ```

21. ```bash
    command 2>/dev/null
    ```

---

### Section 7

22. `bash -x script.sh` runs the script with **execution trace** — prints each command before it runs (prefixed with `+`). Used for debugging.

23. `echo` — simple, adds newline, limited formatting, not portable
    `printf` — formatted output, no auto-newline, more control (`printf "%s\n" "$var"`), POSIX portable

---

## Your Score

Count your answers. Fill in below after completing the test.

| Section | Your Score | Max |
|---|---|---|
| Section 1: Variables & Exit Codes | /4 | 4 |
| Section 2: Conditionals & Logic | /4 | 4 |
| Section 3: Loops | /3 | 3 |
| Section 4: Command Substitution & Pipes | /3 | 3 |
| Section 5: Functions | /2 | 2 |
| Section 6: Real DevOps Scenarios | /5 | 5 |
| Section 7: Debugging | /2 | 2 |
| **Total** | **/23** | **23** |

---

## Diagnosis

Fill in after scoring:

| Weak area | Action |
|---|---|
| `set -euo pipefail` | Practice in every script you write |
| Globbing / quoting | Read `shellcheck` warnings — fix them |
| `[[ ]]` vs `[ ]` vs `test` | Always use `[[ ]]` for bash |
| `set -o pipefail` | Add to every bash script from now on |
| Spaces around `=` | Common typo — just know it |
| `local` keyword | Use it every time in functions |
| `bash -x` | Use it when scripts misbehave |

---

*Fill in your answers above the answers section. Re-take this test weekly.*