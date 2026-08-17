## Scheduling: Affinity & Taints

One node is already tainted `dedicated=labs:NoSchedule`. Its name is saved at `/root/kcna-scratch/tainted-node.txt`.

**You will:**
1. Try to land a Pod on that node without a toleration, and diagnose why it stays Pending
2. Build a Pod with node affinity and a matching toleration that actually gets scheduled there

**Target time:** 55 minutes
