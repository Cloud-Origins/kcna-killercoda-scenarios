## Done

Zero-downtime isn't a default -- it's `maxUnavailable: 0` plus a readiness probe plus a `preStop` grace window, all three working together. Drop the readiness probe and traffic hits pods before they're ready. Drop `maxUnavailable: 0` and the rollout can dip below capacity. Drop the `preStop` sleep and there's a race between the pod actually stopping and kube-proxy removing its endpoint. You just measured all three doing their job at once.

This is the KCNA **Rolling updates** competency under K8s Fundamentals.

**Next: Level 25, Rollbacks.**
