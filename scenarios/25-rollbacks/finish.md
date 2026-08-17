## Done

`kubectl rollout undo` isn't a Ctrl-Z on your terminal history -- it's Kubernetes redeploying the exact PodSpec from a previous, numbered ReplicaSet it already kept around. That's why it works even if you closed your terminal, forgot the old image tag, or someone else made the broken change. The rolling-update guarantees from the last scenario apply here too -- the rollback itself is zero-downtime.

This is the KCNA **Rollbacks** competency under K8s Fundamentals.

**Next: Level 26, HPA Autoscaling.**
