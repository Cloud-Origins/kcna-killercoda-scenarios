## Services: ClusterIP to NodePort

A `backend` Deployment (2 replicas) is already running -- KCNA doesn't test whether you can write a Deployment, it tests whether you understand how Services route to pods. You write Services only.

**You will:**
1. Expose `backend` internally with a ClusterIP Service
2. Expose it externally with a NodePort Service

**Target time:** 45 minutes
