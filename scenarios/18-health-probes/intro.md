## Health Probes

Liveness and readiness answer different questions -- "should this container be restarted?" versus "should this pod receive traffic?" -- and mixing them up is a common real-world mistake. This scenario builds both, then breaks only one to prove they're not the same thing.

**You will:**
1. Create a Deployment with a liveness probe and a readiness probe
2. Break readiness on one pod and prove it stays Running but drops out of the Service

**Target time:** 45 minutes
