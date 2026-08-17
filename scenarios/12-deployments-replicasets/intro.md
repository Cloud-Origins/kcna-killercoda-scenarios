## Deployments & ReplicaSets

A Deployment manages a ReplicaSet for you, which in turn keeps a target number of Pods alive. This scenario builds one, then breaks it on purpose to prove the self-healing actually happens -- not just that it's documented.

**You will:**
1. Create a 3-replica Deployment
2. Delete a Pod and watch the ReplicaSet replace it, then scale up

**Target time:** 55 minutes
