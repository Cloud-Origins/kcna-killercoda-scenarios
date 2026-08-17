## Orchestration Why: Manual vs Controller

"Why do I need an orchestrator, I can just run three copies myself" is a real question, not a strawman. This scenario answers it empirically instead of by assertion: run three copies by hand, break one, watch. Then run three copies through a controller, break one the exact same way, watch again.

**You will:**
1. Manually create 3 standalone Pods, kill one, and watch it stay dead
2. Create the same workload as a Deployment, kill a Pod the same way, and watch it come back

**Target time:** 25 minutes
