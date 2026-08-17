## Troubleshooting Drill

A `webapp` Deployment and `webapp-svc` Service are already applied. Neither works. There is no building in this scenario -- only diagnosis and repair, using nothing but `kubectl describe`, `kubectl get events`, and reading what's actually deployed against what's actually labeled.

**You will:**
1. Get the `webapp` pod running
2. Get `webapp-svc` actually routing to it

**Target time:** 55 minutes
