## Done

A DaemonSet targets "one per node," but taints still apply -- it doesn't get a free pass onto the control-plane node unless it explicitly tolerates that taint, exactly like `kube-proxy` and CNI plugins do in `kube-system`. Desired count isn't "total nodes," it's "nodes this workload is allowed to land on."

This is the KCNA **DaemonSets and taints/tolerations** competency under K8s Fundamentals.

**Next: Level 15, StatefulSets.**
