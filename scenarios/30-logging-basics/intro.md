## Logging Basics

`kubectl logs` has more to it than the bare command once a pod has more than one container, or has already crashed once. Both are already set up: `multi-log` (two containers, different output each) and `crasher` (already crashed once and restarted).

**You will:**
1. Read logs from one specific container in a multi-container pod
2. Read a crashed container's last logs before it died, not its current ones

**Target time:** 25 minutes
