## HPA Autoscaling

`metrics-server` is already installed and serving real CPU metrics. An HPA is only as real as the metrics feeding it -- this scenario proves both halves: the metrics pipeline actually works, and the autoscaler actually acts on it.

**You will:**
1. Create a CPU-hungry Deployment and an HPA targeting it
2. Watch it genuinely scale out under real load, not a simulated one

**Target time:** 45 minutes
