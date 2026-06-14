# Exercise 2 — Dockerfile HEALTHCHECK

**Topic:** Adding HEALTHCHECK to the LaraKube generated Dockerfile

---

## Part A: Pre-Test (Before Studying)

**Answer honestly. "I don't know" is a valid answer. This establishes your baseline.**

### Concept Questions

1. What is a Docker HEALTHCHECK? (One sentence)
   ```
   it checks the status of an image
   ```

2. Why do containers need one? (What problem does it solve?)
   ```
   it solves dead containers which takes up memory
   ```

3. What's the difference between a container that's "running" and one that's "healthy"?
   ```
   some containers are dead while running, without checking their status you might have dead containers which are running and takes up memory and cpu power.
   ```

4. What happens in Docker (and Kubernetes) when a container's health check fails repeatedly?
   ```
   it returns crashloopbackerror
   ___
   ```

### Syntax Questions

5. Write a HEALTHCHECK instruction from scratch (make your best guess):
   ```dockerfile
   HEALTHCHECK status
   ```

6. What do these flags mean? (Guess or write "don't know")
   ```
   --interval=30s        duration to setup the container
   --timeout=3s          has a grace period of 3 seconds before having a status of error
   --start-period=40s    initialization period
   --retries=3           it retries 3 times before giving up if it stills run as error.
   ```

7. What command would you use to check if a Laravel/PHP web app is healthy?
   ```
   laravel doctor
   ```

8. In a multi-stage Dockerfile (build → deploy), which stage should the HEALTHCHECK go in?
   ```
   on the deployment stage
   ```

### Context Question

9. The LaraKube tool generates Dockerfiles from a blade template at:
   `resources/views/docker/php.blade.php`

   Where in that file would you add the HEALTHCHECK?
   ```
   on top of the file.
   ```

---

## Study Guide

After filling in the pre-test, study these concepts:

1. **What is HEALTHCHECK?**
   - Read: Docker docs on HEALTHCHECK instruction
   - Key: it tells Docker (and orchestrators) whether your app is actually working, not just whether the process is alive

2. **The flags:**
   - `--interval` — how often to run the check
   - `--timeout` — max time for the check to respond
   - `--start-period` — grace period for app startup (before failures count)
   - `--retries` — how many failures before marking unhealthy

3. **The check command:**
   - For a web app: `curl -f http://localhost:80/health || exit 1`
   - The `|| exit 1` is required — HEALTHCHECK expects exit code 0 = healthy, 1 = unhealthy

4. **The blade template:**
   - File: `resources/views/docker/php.blade.php`
   - Find the deploy/final stage (the one that runs the app)
   - Add HEALTHCHECK near the end, after CMD or before it

5. **Start-period:**
   - Why 40s? PHP-FPM needs time to boot, especially with warm caches
   - Without start-period, the first few checks fail during boot → container marked unhealthy → restarts → boot loop

---

## Part B: Post-Test (After Studying)

**No notes. No docs. Pure recall.**

### Concept Questions

1. What is a Docker HEALTHCHECK? (One sentence)
   ```
   ___
   ```

2. Why do containers need one? (What problem does it solve?)
   ```
   ___
   ```

3. What's the difference between a container that's "running" and one that's "healthy"?
   ```
   ___
   ```

4. What happens in Docker (and Kubernetes) when a container's health check fails repeatedly?
   ```
   ___
   ```

### Syntax Questions

5. Write a HEALTHCHECK instruction with all four flags and a curl command:
   ```dockerfile
   HEALTHCHECK ___
   ```

6. What do these flags mean?
   ```
   --interval=30s        ___
   --timeout=3s          ___
   --start-period=40s    ___
   --retries=3           ___
   ```

7. What command would you use to check if a Laravel/PHP web app is healthy?
   ```
   ___
   ```

8. In a multi-stage Dockerfile (build → deploy), which stage should the HEALTHCHECK go in?
   ```
   ___
   ```

### Context Question

9. Where in `resources/views/docker/php.blade.php` would you add the HEALTHCHECK?
   ```
   ___
   ```

### Practical Question

10. Write the full HEALTHCHECK line you would add to the LaraKube blade template:
    ```dockerfile
    HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
        ___
    ```

---

## Scoring

- **Pre-test:** Honest baseline. "I don't know" is expected for most answers.
- **Post-test:** 9/10 correct to pass. Concepts matter more than perfect syntax.
- **Then:** Actually add the HEALTHCHECK to the blade template.
