# DEPENDABOT STUDY GUIDE

**What you'll learn:**
- What Dependabot does
- How to configure it
- Why it matters for security

---

## What is Dependabot?

Dependabot automatically checks if your dependencies have:
1. **Security vulnerabilities** (CVEs)
2. **Newer versions** available

When it finds issues, it **creates PRs** to update them.

```
Real-world example:
Day 1:  Your app uses illuminate/http ^12.17
Day 30: CVE-2024-1234 found in 12.17
Day 31: Dependabot detects it → creates PR "Bump illuminate/http to ^12.18"
Day 32: You review → merge → fixed!
```

---

## Two Types of Dependabot

### 1. Built-in (No Config Needed)

GitHub auto-enables this for **security vulnerabilities only**.

```
✅ Pro: Zero setup
❌ Con: Only security patches, no version updates
```

### 2. Config File (You Configure)

You create `.github/dependabot.yml` for **everything**.

```
✅ Pro: Full control, all updates
❌ Con: You have to write the config
```

---

## The Config File

### Where it lives

```
.github/dependabot.yml
```

### Basic Template

```yaml
version: 2
updates:
  # Composer = PHP dependencies
  - package-ecosystem: "composer"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    commit-message:
      prefix: "deps"
    
  # GitHub Actions = CI/CD workflows
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 3
    commit-message:
      prefix: "ci"
```

---

## Key Concepts

### package-ecosystem

Tells Dependabot WHAT to scan:

| Value | Scans |
|-------|-------|
| `composer` | PHP (composer.json) |
| `npm` | JavaScript (package.json) |
| `pip` | Python (requirements.txt) |
| `github-actions` | GitHub Actions workflows |
| `docker` | Dockerfile |

For LaraKube CLI: `composer` + `github-actions`

---

### directory

Where the dependency file lives:

| directory | File location |
|-----------|--------------|
| `/` | Root of repo |
| `/frontend` | frontend/package.json |
| `/backend` | backend/composer.json |

For LaraKube CLI: `directory: "/"` (both at root)

---

### schedule.interval

How often Dependabot checks:

| Value | When |
|-------|------|
| `daily` | Every day (~6am) |
| `weekly` | Once a week (Monday) |
| `monthly` | Once a month |

**Recommendation:** `weekly` — balances security vs noise

---

### open-pull-requests-limit

Max PRs open at once:

```yaml
open-pull-requests-limit: 5
```

If 10 updates available, only 5 PRs created. Others wait.

**Why?** Prevents PR flooding.

---

### commit-message.prefix

What appears in commit messages:

```yaml
commit-message:
  prefix: "deps"
```

```
Result:
"deps: bump illuminate/http from 12.17 to 12.18"
"deps: bump laravel/framework from 11.0 to 11.1"
```

Makes it clear these are dependency updates.

---

## Semantic Versioning (How PHP Packages Work)

```
composer.json: "illuminate/http": "^12.17"
                  │     │
                  │     └── Package name
                  └── Version constraint

Symbols:
^12.17 = "Allow 12.17 to 12.99.99" (safe updates only)
~12.17 = "Allow 12.17 to 12.99" (stricter)
12.17  = "Exactly 12.17" (no auto-updates - LOCKED)
```

Dependabot respects these constraints. It won't break your code.

---

## Why Dependabot Matters

### Without Dependabot

```
Day 1:   You ship v1.0 with symfony/yaml ^6.0
Day 90:  CVE-2024-9999 found in symfony/yaml ^6.0
Day 120: Your app gets hacked because you forgot to check
```

### With Dependabot

```
Day 1:   Dependabot configured
Day 8:   PR created: "Bump symfony/yaml to ^6.1"
Day 9:   CI passes, you merge
Day 10:  Vulnerability patched
```

---

## The Safe Process

```
1. Dependabot creates PR
2. CI runs tests automatically
3. You review the PR
4. If tests pass → merge
5. If tests fail → close PR, investigate manually
```

**Key point:** Dependabot CREATES PRs. You DECIDE to merge.

---

## What Dependabot Creates

### Security PR
```
Title: [security] Bump symfony/yaml from 6.0.0 to 6.0.1
Labels: security, dependencies
Body:  Detects CVE-2024-9999 in current version
```

### Version Update PR
```
Title: deps: Bump laravel/framework from 11.0.0 to 11.1.0
Labels: dependencies
Body:  Changelog shows bug fixes and improvements
```

---

## Security vs Version Updates

| Type | Built-in | dependabot.yml |
|------|----------|----------------|
| CVE patches | ✅ Auto | ✅ Yes |
| Minor version updates | ❌ No | ✅ Yes |
| Major version updates | ❌ No | ✅ Yes (if semver allows) |
| GitHub Actions updates | ❌ No | ✅ Yes |

---

## LaravelKube CLI Config

For your project (`/home/loki/luchWeb/larakube-cli`):

```yaml
version: 2
updates:
  # PHP dependencies
  - package-ecosystem: "composer"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    commit-message:
      prefix: "deps"
    
  # GitHub Actions (keep CI updated)
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 3
    commit-message:
      prefix: "ci"
```

---

## Memorization Checklist

Before the post-test, close this file and write:

- [ ] File path for dependabot.yml
- [ ] The 2 values for package-ecosystem (LaraKube)
- [ ] What directory "/" means
- [ ] Schedule interval options
- [ ] What open-pull-requests-limit does
- [ ] What commit-message.prefix does
- [ ] What Dependabot CREATES (2 things)
- [ ] SemVer: what ^ means
- [ ] Safe merge process

---

## Next Step

When ready, open `04-dependabot-post-test.md` and answer from memory.