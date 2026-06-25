# DevSecOps Foundation Pre-Test

**Date:** 2026-06-25
**Instructions:** Write your answer from memory. No peeking. Rate your confidence (✅ sure / ⚠️ partial / ❌ blank).

---

## Section 1: CI/CD Security Gates

**1.** What are the **3 tools** we use in our combined GitHub Actions pipeline?
(Hint: one detects secrets, one finds vulnerabilities, one does SAST)

> **Answer:** Gitleaks, Trivy, Semgrep
> **Confidence:** ✅

---

**2.** What's the difference between **Gitleaks protect** and **Gitleaks detect**?

> **Answer:** Protect = Scans Current Working tree, Detect = Scans all git commit history
> **Confidence:** ✅

---

**3.** What command installs **Trivy** on Linux? (The exact one from our workflow)

> **Answer:** curl -sFL https://github.com/aquasecurity/trivy/contrib/install.sh | sh -- -b /usr/local/bin
> **Confidence:** ✅

---

**4.** What command installs **pre-commit**? (Version too — be specific)

> **Answer:** pip install pre-commit@v3.0.1
> **Confidence:** ⚠️

---

**5.** What does **Semgrep** do that Trivy doesn't? (What type of analysis?)

> **Answer:** It checks bad code and its SAST (Static Application Software Testing)
> **Confidence:**  ❌

---

## Section 2: GitHub Actions

**6.** What is the **correct format** for uploading a SARIF result to GitHub?
(The `category` field format we use)

> **Answer:** sarif-report.sarif
> **Confidence:** ✅

---

**7.** What permission does the `upload-sarif` step need from the workflow?
(The one we forgot and caused a failure)

> **Answer:** write and read permission
> **Confidence:** ✅

---

**8.** What is the **safe** way to force push to GitHub?
(The flag that protects against overwriting others' work)

> **Answer:** git push --force-with-lease
> **Confidence:** ✅

---

**9.** Why do we prefer **rebase** over merge when pulling?

> **Answer:** it checks unconflicting codes before merging
> **Confidence:** ✅

---

## Section 3: Docker Hardening

**10.** Write the full **HEALTHCHECK** instruction we added to the LaraKube Dockerfile:

> **Answer:** HEALTHCHECK --interval=30s --timeout=40s --retries=3 \ CMD curl -f http://localhost:80/up || exit-code 1
> **Confidence:** ⚠️

---

**11.** Why do we use `curl -f` in the HEALTHCHECK?

> **Answer:** it returns failed if the check did not respond.
> **Confidence:** ✅

---

**12.** What is the **difference** between the Docker **CLI** and a **Dockerfile**?

> **Answer:** CLI stands for Command Line Interface, meaning you write commands in the terminal while Dockerfile are a set of instructions for docker to follow during build command.
> **Confidence:** ✅

---

**13.** Name **3 Docker hardening best practices** for production images:

> **Answer:**
> 1. No root access after deployment
> 2. healthcheck implementation
> 3. dont deploy if it detects vulnerabilities in the packages or the OS
> **Confidence:** ⚠️ 

---

## Section 4: Dependabot

**14.** What **two ecosystems** does our Dependabot config cover?

> **Answer:** Main and Develop branches
> **Confidence:** ⚠️

---

**15.** What does **Renovatebot** do that Dependabot can't? (One key difference)

> **Answer:** I dont know
> **Confidence:** ❌

---

**16.** What is a **security update** PR in Dependabot vs a regular version update?

> **Answer:** It means it detects a vulnerability and requests an update from the github owner
> **Confidence:** ✅

---

## Section 5: Git Security

**17.** What **branch protection rule** does our repo have enabled?

> **Answer:** Force push and you must PR for review
> **Confidence:** ⚠️

---

**18.** Why should you **never force push to main**?

> **Answer:** It may BREAK or Fix a bug in the main github repo
> **Confidence:** ✅

---

## Section 6: Miscellaneous

**19.** What does `set -euo pipefail` do in a bash script?
(Explain each flag)

> **Answer:** -e = Checks for errors -u = Checks for uncertainty -o = Stops the pipeline if it detects an error
> **Confidence:** ✅

---

**20.** What is the `.semgrepignore` file for?

> **Answer:** it ignores the SAST scanning on what content on that file just like .gitignore
> **Confidence:** ✅

---

## Scoring Summary

Count your answers by confidence level:

| Confidence | Count |
|------------|-------|
| ✅ Sure | ___ |
| ⚠️ Partial | ___ |
| ❌ Blank | ___ |

**Total ✅ / 20**

| Score | Level |
|-------|-------|
| 18–20 | 🔥 On fire — still sharp |
| 14–17 | ✅ Solid — minor gaps |
| 10–13 | ⚠️ Rusty — needs review |
| 0–9 | ❌ Blank — re-study |

---

## Topics to Review

(List any ❌ or ⚠️ questions here for focused review)

| Question | Topic | Review Priority |
|----------|-------|-----------------|
| ___ | ___ | ___ |
| ___ | ___ | ___ |
| ___ | ___ | ___ |

---

**Note:** When done, share your score and which questions were ❌/⚠️ — I'll create a targeted post-test for your weak areas.
