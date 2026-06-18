# 🚀 Skills Assessment — Can You Apply for Jobs?

**Purpose:** Honest self-assessment to determine your job readiness  
**Instructions:** Answer every question. Be REAL. "I don't know" is VALID.  
**Output:** Your job-ready score and recommended roles

---

## 📊 YOUR BACKGROUND SUMMARY

| Skill | Source | Level |
|-------|--------|-------|
| Ethical Hacking | Self-taught, bug bounties | Intermediate |
| Bug Bounty Hunting | Real-world experience | Active |
| Laravel Development | Project work | Intermediate |
| Linux/SysAdmin | Comfortable | Intermediate |
| Git/GitHub | Used in development | Good |
| Docker/Containers | Learning | Beginner |
| Kubernetes | Learning | New |
| CI/CD | Learning (LaraKube) | Beginner |
| DevSecOps | In training | Beginner |

---

## SECTION 1: LINUX & SYSTEM ADMIN (20 Questions)

**Difficulty: JUNIOR → MID LEVEL**

---

**Q1.** What does `set -euo pipefail` do? Explain each flag.

```
Answer:
-e: looks for exit code 1
-u: looks for unresponsive_
-pipefail: stops the pipeline _
```

---

**Q2.** How do you check which process is using port 443?

```bash
# Write the command:
ss -tulnp | grep 443
```

---

**Q3.** What does the following command do?

```bash
df -h | grep -E '^/dev/' | awk '{print $5 " " $1}'
```

```
Answer:
showing the storage of the folder dev
```

---

**Q4.** How do you find the PID of a process by name?

```bash
# Write 2 different ways:
ps aux | grep <name>
ps | grep <name>
```

---

**Q5.** What is the difference between `systemctl stop` and `systemctl kill`?

```
Answer:
stop = disables a process
kill = stops and removes a process
```

---

**Q6.** How do you check memory usage per process?

```bash
# Write the command:
top
```

---

**Q7.** What does `journalctl -u nginx --since "1 hour ago"` do?

```
Answer:
shows the process on nginx an ahour ago
```

---

**Q8.** What is the difference between a symlink and a hard link?

```
Answer:
symlink = links a file into a create link like mounting a disk into a folder
hard link = copies the folder link into a folder
```

---

**Q9.** How do you persist environment variables across reboots?

```
Answer:
adding them into the env path
```

---

**Q10.** What does this do?

```bash
chmod 600 ~/.ssh/id_rsa
```

```
Answer:
changes file ownership in user owner
```

---

**Q11.** How do you troubleshoot a server that won't boot?

```
Answer (list steps):
1. checking system logs
2. ping IP address
3. turning off and on again
```

---

**Q12.** What is the difference between `cron` and `systemd timers`?

```
Answer:
cron is a scheduler task and can run even after reboot while timers is a system task which has a fixed time
```

---

**Q13.** How do you find large files (>100MB) on a server?

```bash
# Write the command:
df -H -f > 100
```

---

**Q14.** What does `top` command show? Name 5 columns.

```
1. CPU_
2. Memory_________________________________________________________
3. PID_________________________________________________________
4. Name_________________________________________________________
5. Runtime_________________________________________________________
```

---

**Q15.** What is `/proc` directory? What does it contain?

```
Answer:
i dont know
```

---

**Q16.** How do you add a new user and give them sudo access?

```bash
# Write commands:
sudo useradd <name>
sudo usermod -aG sudo <name>
```

---

**Q17.** What is the difference between `iptables` and `ufw`?

```
Answer:
iptables are ip address whitelisting while ufw is firewall that blocks ports
```

---

**Q18.** How do you check if a service is running on startup?

```bash
# Write the command:
sudo service --status-all
```

---

**Q19.** What does this script do?

```bash
#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi
```

```
Answer:
checking the user id if is not equal  to 0 or root, it will output a message on what echo says.
```

---

**Q20.** How do you log everything a script does to a file?

```bash
# Write how to run a script with logging:
cat <script> > log.txt
```

---

## SECTION 2: DOCKER & CONTAINERS (15 Questions)

**Difficulty: JUNIOR → MID LEVEL**

---

**Q21.** What is the difference between a container and a VM?

```
Answer:
A container is a compact applicaton which has an operating OS, services installed while a VM is an operating system running in a virtualized machine and takes up computer resources
```

---

**Q22.** Write a Dockerfile for a simple PHP/Laravel app.

```dockerfile
# Your answer:
RUN as PHP/Laravel

DEPLOY
```

---

**Q23.** What is the difference between `COPY` and `ADD` in Dockerfile?

```
Answer:
```

---

**Q24.** What does this Dockerfile instruction do?

```dockerfile
USER www-data
```

```
Answer:
sets the user into least privilege access 
```

---

**Q25.** What is a multi-stage build? Why use it?

```
Answer:
when you have multiple services running
```

---

**Q26.** Write a HEALTHCHECK instruction for a web app.

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
CMD curl -f http://localhost:80/health || exit 1_
```

---

**Q27.** What does `docker ps -a` show vs `docker ps`?

```
Answer:
docker ps -a = shows all images
docker ps = shows running images
```

---

**Q28.** How do you debug a container that exits immediately after starting?

```
Answer (steps):
1. checking the events view_________________________________________________________
2. looking into its yaml file_________________________________________________________
3. checking the logs_________________________________________________________
```

---

**Q29.** What is the difference between `ENTRYPOINT` and `CMD`?

```
Answer:
```

---

**Q30.** How do you pass environment variables to a container?

```bash
# Write 2 ways:
```

---

**Q31.** What is a Docker volume? Why use it?

```
Answer:
docker volumes are non-persistent
```

---

**Q32.** How do you clean up unused Docker resources?

```bash
# Write commands:
docker prune 
```

---

**Q33.** What does `docker-compose.yml` do? Write a basic example.

```yaml
# Your answer:
```

---

**Q34.** What is Docker's COPY-on-Write mechanism?

```
Answer:
```

---

**Q35.** How do you run a command inside a running container?

```bash
# Write the command:
docker exec
```

---

## SECTION 3: GIT & VERSION CONTROL (10 Questions)

**Difficulty: JUNIOR LEVEL**

---

**Q36.** What is the difference between `git merge` and `git rebase`?

```
Answer:
git merge = merging a github repo into local branch
git rebase = checking if it conflicts before merging
```

---

**Q37.** How do you undo the last commit but keep the changes?

```bash
# Write the command:
```

---

**Q38.** What does `git stash` do?

```
Answer:
```

---

**Q39.** How do you create and switch to a new branch?

```bash
# Write commands:
git checkout -b <branch>
```

---

**Q40.** What is a pull request? Why use it?

```
Answer:
if you have a feature or changes from your local github repo into the owners github repo
```

---

**Q41.** How do you see the differences between your local changes and the remote?

```bash
# Write the command:
```

---

**Q42.** What does `git fetch` do vs `git pull`?

```
Answer:
fetch = getting the codes from a forked github repo into your local folder
pull = getting the code from your own github repository
```

---

**Q43.** How do you resolve a merge conflict?

```
Answer (steps):
1. overwrites local edit_________________________________________________________
2. ignores the conflict_________________________________________________________
3. _________________________________________________________
```

---

**Q44.** What is `.gitignore` and why do you need it?

```
Answer:
for git to not add into the github repository like secrets or api keys
```

---

**Q45.** How do you sign commits? (Conceptually)

```
Answer:
```

---

## SECTION 4: CI/CD WITH GITHUB ACTIONS (10 Questions)

**Difficulty: JUNIOR → MID LEVEL**

---

**Q46.** Write a basic GitHub Actions workflow that runs on push.

```yaml
# Your answer:
-name: push request
  on: push

```

---

**Q47.** What is the difference between `on: push` and `on: pull_request`?

```
Answer:
on: push is for uploading your code and the workflow will run while pull_request is for  PR and the workflow will run
```

---

**Q48.** How do you store secrets in GitHub Actions?

```
Answer:
gha
```

---

**Q49.** What is a matrix strategy? When would you use it?

```
Answer:
```

---

**Q50.** What does `needs:` keyword do in GitHub Actions?

```
Answer:
```

---

**Q51.** How do you cache dependencies in GitHub Actions?

```yaml
# Write the relevant step:
```

---

**Q52.** What is the difference between `actions/checkout@v4` and `@v3`?

```
Answer:
versioning, some bugs may be fixed on the newer version
```

---

**Q53.** How do you run jobs only on specific branches?

```yaml
# Write the conditional:
if {{ -b branch == <branch> }}; then
```

---

**Q54.** What does this do?

```yaml
- name: Run Trivy scanner
  run: trivy fs --severity HIGH,CRITICAL .
```

```
Answer:
it scans the filesystem for vulnerabilities with the severity of high and critical
```

---

**Q55.** What is a reusable workflow? When would you use it?

```
Answer:
```

---

## SECTION 5: SECURITY (15 Questions)

**Difficulty: JUNIOR → SENIOR (Hacker level!)**

---

**Q56.** What is the difference between SAST, DAST, and SCA?

```
SAST: _____________________________________________________
DAST: _____________________________________________________
SCA:  _____________________________________________________
```

---

**Q57.** What is gitleaks? What does it detect?

```
Answer:
secrets api keys on github
```

---

**Q58.** How do you scan a Docker image for vulnerabilities?

```bash
# Write the command:
trivy image 
```

---

**Q59.** What is an SBOM? Why is it important?

```
Answer:
```

---

**Q60.** What is Cosign? Why use it?

```
Answer:
```

---

**Q61.** What is the principle of least privilege?

```
Answer:
in order for the attack vector to have less attack access
```

---

**Q62.** How do you securely store secrets in Kubernetes?

```
Answer (mention 2-3 ways):
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
```

---

**Q63.** What is a supply chain attack? Give an example.

```
Answer:
dependency exploitation that leads to privilege escalation
```

---

**Q64.** What is Log4Shell (CVE-2021-44228)? Why was it dangerous?

```
Answer:
```

---

**Q65.** What is the difference between a vulnerability scan and a penetration test?

```
Answer:
vulnerability scans for possible attack but doesn't validate if its false positive while penetration testing validates the found vulnerabilities to ensure its really a vulnerability that can be exploited
```

---

**Q66.** How would you prevent SQL injection in a Laravel app?

```
Answer:
have input sanitization enforced
```

---

**Q67.** What is CORS? Why does it matter?

```
Answer:
Cross-Origin Request Security
```

---

**Q68.** What is XSS? How do you prevent it?

```
Answer:
Cross-Site-Scripting, to prevent xss you must enable @csrf and harden the DOM
```

---

**Q69.** What is the difference between authentication and authorization?

```
Answer:
authentication verifies access while authorization clasifies what you can access
```

---

**Q70.** What is OAuth 2.0? How does it work?

```
Answer:
```

---

## SECTION 6: KUBERNETES (10 Questions)

**Difficulty: JUNIOR → MID LEVEL**

---

**Q71.** What is a Pod? How is it different from a Container?

```
Answer:
A pod is a service within a namespace and a container is the full package that has the os,services,and packages
```

---

**Q72.** What is a Deployment? Why use it?

```
Answer:
```

---

**Q73.** What is the difference between ClusterIP, NodePort, and LoadBalancer services?

```
ClusterIP: ________________________________________________
NodePort:  ________________________________________________
LoadBalancer: _____________________________________________
```

---

**Q74.** What is a ConfigMap vs a Secret?

```
Answer:
```

---

**Q75.** How do you troubleshoot a Pod stuck in CrashLoopBackOff?

```
Answer (steps):
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
```

---

**Q76.** What is a Namespace in Kubernetes?

```
Answer:
```

---

**Q77.** What is RBAC? Why is it important?

```
Answer:
Role-based-access-control, so that the admin can give access control based on the level on a given cluster or namespace
```

---

**Q78.** What is a NetworkPolicy?

```
Answer:
```

---

**Q79.** How do you do a rolling update in Kubernetes?

```
Answer:
```

---

**Q80.** What is a PersistentVolume? When would you use it?

```
Answer:
```

---

## SECTION 7: NETWORKING (10 Questions)

**Difficulty: JUNIOR → MID LEVEL**

---

**Q81.** What is the difference between TCP and UDP?

```
Answer:
TCP is like house to house delivery that ensures the package is delivered while UDP does not care whether the package is delivered or not, like streaming videos, communicating on call
```

---

**Q82.** What happens when you type `curl https://google.com`? (Explain the steps)

```
Answer:
```

---

**Q83.** What is DNS? How does it work?

```
Answer:
Domain name System
```

---

**Q84.** What is the difference between a proxy and a reverse proxy?

```
Answer:
```

---

**Q85.** What is SSL/TLS handshake?

```
Answer:
```

---

**Q86.** What ports do these commonly use?
```
HTTP:    _______
HTTPS:   _______
SSH:     _______
MySQL:   _______
Postgres: _______
Redis:   _______
```

---

**Q87.** What is a firewall? What does UFW allow/deny mean?

```
Answer:
```

---

**Q88.** What is the difference between Ingress and IngressController?

```
Answer:
```

---

**Q89.** What is a load balancer? Layer 4 vs Layer 7?

```
Answer:
```

---

**Q90.** How do you expose a Kubernetes service externally?

```
Answer (mention 2 ways):
1. _________________________________________________________
2. _________________________________________________________
```

---

## SECTION 8: BUG BOUNTY / ETHICAL HACKING (10 Questions)

**Difficulty: YOUR DOMAIN**

---

**Q91.** What is the difference between black-box, white-box, and gray-box testing?

```
Answer:
```

---

**Q92.** What is Subdomain Enumeration? Name 3 techniques.

```
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
```

---

**Q93.** What is IDOR? How do you find it?

```
Answer:
```

---

**Q94.** What is SSRF? How dangerous can it be?

```
Answer:
```

---

**Q95.** What tools do you use for web application testing? (Name 5+)

```
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
4. _________________________________________________________
5. _________________________________________________________
```

---

**Q96.** What is the OWASP Top 10? Name at least 5.

```
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
4. _________________________________________________________
5. _________________________________________________________
```

---

**Q97.** What is Burp Suite used for? What features?

```
Answer:
```

---

**Q98.** How do you test for SQL injection manually?

```
Answer:
```

---

**Q99.** What is recon in bug bounty? Why is it important?

```
Answer:
```

---

**Q100.** How do you write a good bug report?

```
Answer (key elements):
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
4. _________________________________________________________
```

---

## SECTION 9: BEHAVIORAL & SCENARIOS (5 Questions)

---

**Q101.** Tell me about a time you debugged a production issue.

```
Situation: ________________________________________________
Task: _____________________________________________________
Action: ____________________________________________________
Result: ___________________________________________________
```

---

**Q102.** A pipeline is failing but only on the main branch. What do you do?

```
Answer (steps):
1. _________________________________________________________
2. _________________________________________________________
3. _________________________________________________________
```

---

**Q103.** Your team wants to skip security scanning to meet a deadline. What do you do?

```
Answer:
```

---

**Q104.** You found a critical vulnerability in production. What's your process?

```
Answer:
```

---

**Q105.** How do you explain a complex technical issue to a non-technical stakeholder?

```
Answer:
```

---

## 📊 SCORING SHEET

### How to Score

| Section | Questions | Your Score | Max |
|---------|-----------|------------|-----|
| Linux/SysAdmin | Q1-Q20 | ___ / 20 | 20 |
| Docker | Q21-Q35 | ___ / 15 | 15 |
| Git | Q36-Q45 | ___ / 10 | 10 |
| CI/CD | Q46-Q55 | ___ / 10 | 10 |
| Security | Q56-Q70 | ___ / 15 | 15 |
| Kubernetes | Q71-Q80 | ___ / 10 | 10 |
| Networking | Q81-Q90 | ___ / 10 | 10 |
| Bug Bounty | Q91-Q100 | ___ / 10 | 10 |
| Behavioral | Q101-Q105 | N/A | N/A |

---

### Total Score: ___ / 100

---

## 🎯 JOB RECOMMENDATIONS BY SCORE

### Score 80-100: SENIOR READY
**Jobs you can apply for:**
- Senior DevOps Engineer
- Senior Platform Engineer
- DevSecOps Lead
- Security Automation Engineer
- SRE (Site Reliability Engineer)

**You're OVERQUALIFIED for junior roles.**

---

### Score 60-79: MID-LEVEL READY
**Jobs you can apply for:**
- DevOps Engineer
- Platform Engineer
- Cloud Engineer
- Security Engineer
- SRE

**You're READY. Apply confidently.**

---

### Score 40-59: JUNIOR/ENTRY READY
**Jobs you can apply for:**
- Junior DevOps Engineer
- Junior SRE
- IT Support / Systems Administrator
- DevOps Intern (if available)
- Site Reliability Engineer (Intern)

**You're READY. These are stepping stones.**

---

### Score 25-39: GETTING THERE
**What to do:**
- Finish this assessment
- Study weak areas
- Apply to: IT help desk, junior sysadmin, freelance
- Focus on getting PAID experience

---

### Score 0-24: KEEP LEARNING
**What to do:**
- Complete LaraKube exercises
- Practice on your cloud server
- Land freelance gigs for experience
- Apply to IT support roles

---

## 📋 YOUR PERSONALIZED STUDY PLAN

Based on your scores, identify:

**STRONGEST AREAS (Score 70%+):**
```
1. _________________________________________________________
2. _________________________________________________________
```

**WEAKEST AREAS (Score <40%):**
```
1. _________________________________________________________
2. _________________________________________________________
```

**Priority to study:**
```
Week 1-2: _________________________________________________
Week 3-4: _________________________________________________
Week 5-6: _________________________________________________
```

---

## 📝 COVER LETTER HOOK (Based on Your Story)

Fill in the blanks:

```
"My journey into DevSecOps started with [1] ______________
and [2] ______________. I found real vulnerabilities in 
production systems through bug bounty hunting.

When I started building [3] ______________ with my team, 
I realized that the most secure code can be deployed through 
an insecure pipeline. That's when I understood: I need to 
secure the PIPE, not just the APP.

I bring:
- Attacker's mindset (I know how hackers think)
- Developer's skills (I build with [4] ______________)
- DevOps knowledge (I secure CI/CD pipelines)
- Real-world experience (I've [5] ______________)

I don't just implement security tools. I think like an 
attacker and build defenses where they would strike."
```

---

## 📄 ATTACH THIS TO YOUR RESUME

After completing this assessment, add to your resume:

### Skills Assessment Results
```
Completed: 100-question DevSecOps self-assessment
Score: ___/100
Strongest: Linux, Docker, GitHub Actions, Security Scanning
Focus Areas: Kubernetes, Advanced CI/CD
```

---

## ✅ NEXT STEPS

1. **Complete this assessment** (Don't cheat. Be honest.)
2. **Calculate your score**
3. **Identify your job tier**
4. **Apply to recommended jobs**
5. **Keep studying weak areas**
6. **Land a job!**

---

*Assessment created: 2026-06-18*
*Good luck! You've got this. 💪*
