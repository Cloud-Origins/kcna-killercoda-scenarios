## StatefulSets

Two PersistentVolumes are already staged, pinned to one labeled node (`kcna-storage=true`) so storage stays local across reschedules. No default StorageClass exists on this cluster, which is realistic -- most clusters need one explicitly provisioned or configured.

**You will:**
1. Create a headless Service and a 2-replica StatefulSet with per-pod storage
2. Delete a pod and prove its identity and data survive

**Target time:** 55 minutes
