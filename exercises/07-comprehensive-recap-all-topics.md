# COMPREHENSIVE RECAP ASSESSMENT
## Day 1 to Day 7 — Full DevSecOps Foundations

**Date:** 2026-06-19
**Purpose:** Test retention of all topics learned
**Instructions:** Answer from memory. No peeking.

---

## SECTION 1: GITLEAKS (Day 1)

**Q1.** What does gitleaks detect?

```
Answer:
secrets, api keys on git commit history
```

**Q2.** What is the difference between `gitleaks protect` and `gitleaks detect`?

```
protect:
scans current working tree
detect:
scans all git commit history
```

**Q3.** Where does gitleaks config file live?

```
Answer:
.github/workflows
```

**Q4.** What permission level does gitleaks-action need for PR scans?

```
Answer:
write
```

---

## SECTION 2: TRIVY (Day 1)

**Q5.** What does Trivy scan for?

```
Answer:
scans for CVEs
```

**Q6.** What is the command to scan filesystem with Trivy?

```
Answer:
trivy fs . --exit-code 1
```

**Q7.** What does `--severity CRITICAL,HIGH` do?

```
Answer:
it scans for CRITICAL and HIGH vulnerabilities
```

**Q8.** What format does Trivy output for GitHub Security tab?

```
Answer:
sarif
```

**Q9.** What does `exit-code 1` mean in Trivy?

```
Answer:
it stops the scan if it detects failed
```

---

## SECTION 3: PRE-COMMIT HOOKS (Day 1)

**Q10.** What does pre-commit install do?

```
Answer:
it installs pre-commit into the system
```

**Q11.** Write the command to install pre-commit:

```
Answer:
pip install pre-commit
```

**Q12.** What is the command to run pre-commit on all files?

```
Answer:
pre-commit --all-files
```

**Q13.** What is the pre-commit config file called?

```
Answer:
pre-commit.yml
```

**Q14.** What version of pre-commit did we use?

```
Answer:
v3
```

---

## SECTION 4: DOCKER HEALTHCHECK (Day 3)

**Q15.** What does HEALTHCHECK do in Dockerfile?

```
Answer:
it checks a container whether the services are running and responding
```

**Q16.** Fill in the HEALTHCHECK syntax:

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD curl -f http://localhost:80/health || exit 1
```

**Q17.** What does `--start-period` do?

```
Answer:
booting time for the container
```

**Q18.** Why do we use `|| exit 1` in HEALTHCHECK?

```
Answer:
it shows that the container has failed and may restart the initialization
```

---

## SECTION 5: DEPENDABOT (Day 7)

**Q19.** What does Dependabot do?

```
Answer:
it checks for updates
```

**Q20.** Where does `dependabot.yml` live?

```
Answer:
.github/
```

**Q21.** What is `version: 2` and why use it?

```
Answer:
version 2 has updated syntax while the version 1 is deprecated
```

**Q22.** Fill in the Dependabot config:

```yaml
version: 2
updates:
  - package-ecosystem: "composer"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    commit-message:
      prefix: "deps"
```

**Q23.** What are the 3 package-ecosystem values for LaraKube CLI?

```
1. composer
2. npm
3. github-action
```

**Q24.** What does `open-pull-requests-limit: 5` mean?

```
Answer:
the max pr for the bot to submit
```

**Q25.** In composer.json, what does `^12.17` mean?

```
Answer:
Safe update or the patch update
```

**Q26.** Why is Dependabot SAFE even though updates can break code?

```
Answer:
because it only uses pull request and the human or the reviewer has the power to accept/reject the bot's pr request and dependabot never updates a major update unless configured.
```

---

## SECTION 6: GITHUB ACTIONS (Day 1-2)

**Q27.** What are the 2 required fields in a workflow file?

```
1. on
2. jobs
```

**Q28.** What does `on: push` trigger?

```
Answer:
when uploading a file form local to github via push
```

**Q29.** What does `on: pull_request` trigger?

```
Answer:
when submitting a pr into the github repo
```

**Q30.** What does `needs:` keyword do?

```
Answer:
???
```

**Q31.** What is the `permissions:` section for?

```
Answer:
for the github actions access control have on a workflow
```

**Q32.** What permission do you need to upload SARIF results?

```
Answer:
write
```

**Q33.** What permission do you need for gitleaks PR scans?

```
Answer:
read
```

**Q34.** Write a step that runs a command:

```yaml
- name: vulscan Trivy
  run: trivy fs . --exit-code 1
```

**Q35.** What is the difference between `actions/checkout@v4` and `@v7`?

```
Answer:
the updated version is v7 and has more updated features like deprecated node version on v4
```

---

## SECTION 7: SEMGREP (Day 7)

**Q36.** What does Semgrep scan for?

```
Answer:
code-analysis so that no bad code can be uploaded on the github repo
```

**Q37.** What is Semgrep also known as (full name)?

```
Answer:
Static Application Security Testing (SAST)
```

**Q38.** What does `config: 'auto'` do?

```
Answer:
all configuration analysis
```

**Q39.** What does `upload: 'on'` do in semgrep-action?

```
Answer:
it uploads into github security
```

**Q40.** Name 2 config values for Semgrep (not 'auto'):

```
1. p
2. /php
```

---

## SECTION 8: GIT WORKFLOW (Day 1-7)

**Q41.** What does `git pull --rebase` do?

```
Answer:
merge if it does not have any conflicting commits
```

**Q42.** What is the difference between `--force` and `--force-with-lease`?

```
Answer:
--force-with-lease pushes the code if it does not have any merge conflict and --force is destructive, it ignores the past commit and overwrites it
```

**Q43.** What does "branch protection" mean?

```
Answer:
it protects a branch for force push
```

**Q44.** Why can't you push directly to main when branch protection is enabled?

```
Answer:
the force protection or there is a restriction on who are allowed to push in a github repo
```

**Q45.** What command creates and switches to a new branch?

```
Answer:
git checkout -b
```

---

## SECTION 9: SARIF FORMAT (Day 2)

**Q46.** What is SARIF?

```
Answer:
upload format
```

**Q47.** What GitHub feature displays SARIF results?

```
Answer:
upload sarif
```

**Q48.** What action uploads SARIF to GitHub?

```
Answer:
github/codeql-action/upload-sarif@v4
```

---

## SECTION 10: INSTALLATION COMMANDS (Day 1)

**Q49.** Write the Trivy installation command:

```
Answer:
curl -sfL https://raw.githubusercontent.com/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

**Q50.** Write the pre-commit installation command:

```
Answer:
pip install pre-commit
```

---

## SCORING

| Section | Questions | Your Score |
|---------|-----------|------------|
| Gitleaks | Q1-Q4 | ___ / 4 |
| Trivy | Q5-Q9 | ___ / 5 |
| Pre-commit | Q10-Q14 | ___ / 5 |
| HEALTHCHECK | Q15-Q18 | ___ / 4 |
| Dependabot | Q19-Q26 | ___ / 8 |
| GitHub Actions | Q27-Q35 | ___ / 9 |
| Semgrep | Q36-Q40 | ___ / 5 |
| Git Workflow | Q41-Q45 | ___ / 5 |
| SARIF | Q46-Q48 | ___ / 3 |
| Installation | Q49-Q50 | ___ / 2 |

**TOTAL: ___ / 50**

---

## GRADE SCALE

| Score | Percentage | Grade |
|-------|------------|-------|
| 45-50 | 90-100% | 🎉 MASTERED |
| 40-44 | 80-89% | ✅ EXCELLENT |
| 35-39 | 70-79% | 🟡 GOOD |
| 30-34 | 60-69% | 🟡 NEEDS REVIEW |
| 25-29 | 50-59% | 🔴 STUDY AGAIN |
| 0-24 | 0-49% | ❌ RETAKE SECTION |

---

## WHAT TO DO NEXT

After completing:
1. Count your score
2. Identify weak sections
3. Review those sections specifically
4. Re-answer weak questions 3x to lock syntax

**Remember:** Attempt 1 = 35%, Attempt 2 = 80%, Attempt 3 = 92.5%
Repetition is how syntax locks in.