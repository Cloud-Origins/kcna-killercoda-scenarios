## Rolling Updates

"Zero-downtime deploy" is a testable claim, not a marketing phrase. This scenario proves it: a monitor pod fires continuous requests at a Service while a rolling update happens underneath it, and the failure count has to actually be zero at the end.

**You will:**
1. Create a 4-replica Deployment tuned for a true zero-downtime rollout
2. Roll `nginx:1.26` to `nginx:1.27` while traffic keeps flowing, and prove nothing dropped

**Target time:** 35 minutes
