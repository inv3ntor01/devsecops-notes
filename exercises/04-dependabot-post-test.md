# EXERCISE 04: DEPENDABOT — POST-TEST

**Instructions:** Answer from memory. No peeking at the study guide.

---

## Q1. What does Dependabot do? (1 sentence)

```
Answer:
it checks for dependency updates and pr for review
```

---

## Q2. Where does dependabot.yml live? (full path)

```
Answer:
.github/dependabot.yml
```

---

## Q3. What are the 2 package-ecosystem values for LaraKube CLI?

```
1. composer
2. github-actions
```

---

## Q4. Fill in this config:

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

---

## Q5. What does `directory: "/"` mean?

```
Answer:
root directory
```

---

## Q6. What does `open-pull-requests-limit: 5` mean?

```
Answer:
the maximum pr for the bot to do
```

---

## Q7. What does `schedule.interval: "weekly"` mean?

```
Answer:
it checks for updates every monday 
```

---

## Q8. What does `commit-message.prefix: "deps"` do?

```
Answer:
it add the subject deps so that a reviewer will know that it belongs to dependency updates
```

---

## Q9. What does Dependabot CREATE when it finds updates?

```
Answer:
Pull requests
```

---

## Q10. In composer.json, what does `^12.17` mean?

```
Answer:
it updates a safe update
```

---

## Q11. What's the difference between built-in Dependabot and dependabot.yml?

```
Answer:
built-in = it only reports an update while dependabot.yml requests a pr to update and for you to review and decide to accept or not
```

---

## Q12. Why is Dependabot SAFE even though updates can break code?

```
Answer:
you can set safe update in order to not break the code and to avoid unpatched cves
```

---

## SCORING: ___ / 12

**Grade:**
- 10-12: ✅ Mastered
- 7-9: 🟡 Good, review gaps
- 4-6: 🔴 Needs more study
- 0-3: ❌ Read study guide again