# Exercise 03 — Dockerfile HEALTHCHECK
# Post-Test (After Studying)

**Date:** 2026-06-18
**Rules:** No notes. No docs. Pure recall.
**Pass threshold:** 9/10

---

## Concept Questions

**Q1.** What is a Docker HEALTHCHECK? (One sentence)
```
it checks the container if the services are responding and running
```

**Q2.** Why do containers need one? (What problem does it solve?)
```
it solves a dead containers which are running and the services inside are down
```

**Q3.** What's the difference between a container that's "running" and one that's "healthy"?
```
running = the container is up and running while healthy = services responds and ensures that the services inside are up and running
```

**Q4.** What happens in Docker (and Kubernetes) when a container's health check fails repeatedly?
```
it restarts the container or re-initialize
```

---

## Syntax Questions

**Q5.** Write a HEALTHCHECK instruction with all four flags and a curl command:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
CMD curl -f http://localhost:80/health | exit 1
```

**Q6.** What do these flags mean?
```
--interval=30s        how often the healthcheck run
--timeout=3s          max time for the container to respond
--start-period=40s    booting time for the container
--retries=3           tries 3 consecutive failure before flagging as down or failed
```

**Q7.** What command would you use to check if a Laravel/PHP web app is healthy?
```
docker inspect --format='{{.State.Health}}'
```

**Q8.** In a multi-stage Dockerfile (build → deploy), which stage should the HEALTHCHECK go in?
```
deploy
```

---

## Context Question

**Q9.** Where in `resources/views/docker/php.blade.php` would you add the HEALTHCHECK?
```
on the deployment stage
```

---

## Practical Question

**Q10.** Write the full HEALTHCHECK line you would add to the LaraKube blade template:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
CMD curl -f http://localhost:80/health | exit 1
```

---

## Score Sheet

| Q | Your Answer | Max | Notes |
|---|------------|-----|-------|
| 1  | /1 | | |
| 2  | /1 | | |
| 3  | /1 | | |
| 4  | /1 | | |
| 5  | /1 | | |
| 6  | /1 | | |
| 7  | /1 | | |
| 8  | /1 | | |
| 9  | /1 | | |
| 10 | /1 | | |
| **Total** | **/10** | **10** | **%** |

**Pass: 9/10 (90%)**
