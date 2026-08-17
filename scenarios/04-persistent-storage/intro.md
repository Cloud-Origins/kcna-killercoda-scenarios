## Persistent Storage: PV/PVC

A `PersistentVolume` named `data-pv` (1Gi, hostPath-backed) is already provisioned. You claim it, write to it, then prove the data outlives the pod that wrote it.

**You will:**
1. Create a PVC that binds to `data-pv`, mount it in a pod, write a file
2. Delete that pod, mount the same PVC in a new pod, prove the file is still there

**Target time:** 50 minutes
