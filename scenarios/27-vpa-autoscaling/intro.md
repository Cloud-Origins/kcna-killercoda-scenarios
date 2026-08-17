## VPA Autoscaling

HPA changes replica *count*. VPA changes a container's resource *requests* -- for workloads that can't be horizontally scaled cleanly, or that are simply mis-sized. `metrics-server` and the full VPA stack (recommender, updater, admission-controller) are already installed.

**You will:**
1. Create a Deployment deliberately starved of CPU, and a VPA watching it
2. Watch VPA's recommender measure real usage, and its updater actually evict and resize the pod

**Target time:** 45 minutes
