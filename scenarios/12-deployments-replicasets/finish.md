## Done

A Deployment doesn't run Pods directly -- it owns a ReplicaSet, and the ReplicaSet is the controller with the reconcile loop that notices "3 wanted, 2 exist" and closes the gap. Deleting a Pod by hand doesn't fight that loop, it just proves it exists. Scaling is the same mechanism with a different target number.

This is the KCNA **Deployments and self-healing** competency under K8s Fundamentals.

**Next: Level 13, ConfigMaps & Secrets.**
