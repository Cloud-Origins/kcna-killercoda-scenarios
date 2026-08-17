## Done

A comma in a label selector is AND, not OR. Set-based selectors (`in`, `notin`, `exists`) cover cases equality selectors can't -- like "anything except this one env." Every controller in the cluster (Services, Deployments, ReplicaSets, NetworkPolicies) uses exactly this mechanism to find its Pods.

This is the KCNA **Labels and selectors** competency under K8s Fundamentals.

**Next: Level 11, Fundamentals Quiz Bank.**
