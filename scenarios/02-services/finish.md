## Done

You routed traffic to the same backend two ways: `ClusterIP` (internal only, the default) and `NodePort` (reachable from outside the cluster on every node's IP). Same selector, same pods, different `spec.type`.

**Why this matters for KCNA:** Service type is one of the most directly-tested networking concepts on the exam -- knowing when traffic can and can't reach a Service from outside the cluster (ClusterIP vs NodePort vs LoadBalancer) is foundational, and it's exactly what you just did by hand.

Next: Level 3, Namespaces & Resource Quotas.
