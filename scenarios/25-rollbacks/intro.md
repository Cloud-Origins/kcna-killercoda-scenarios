## Rollbacks

A `web` Deployment is already running cleanly on `nginx:1.26`. Every rollout is a numbered revision Kubernetes keeps around -- that history is what makes "undo" a real operation, not a manual redo.

**You will:**
1. Ship a broken image and watch the rollout stall
2. Roll back to the last good revision without touching YAML

**Target time:** 30 minutes
