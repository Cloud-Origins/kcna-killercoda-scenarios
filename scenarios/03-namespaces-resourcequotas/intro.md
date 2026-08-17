## Namespaces & Resource Quotas

Namespace `team-a` already has 2 pods running and a `ResourceQuota` capping it at 2 pods total. You'll try to add a third, watch it get rejected, and fix it -- no quota-writing boilerplate, straight to diagnosis.

**You will:**
1. Try to create `pod-c`, see it fail, and diagnose why
2. Fix it and get `pod-c` running

**Target time:** 40 minutes
