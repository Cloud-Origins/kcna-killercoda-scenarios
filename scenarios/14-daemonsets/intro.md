## DaemonSets

Log collectors and node agents need exactly one Pod per node, not a replica count someone picks. That's what a DaemonSet is for -- and it interacts with taints in a way that surprises people the first time.

**You will:**
1. Create a DaemonSet and confirm it's scheduled correctly
2. Add a toleration so it also runs on the tainted control-plane node

**Target time:** 35 minutes
