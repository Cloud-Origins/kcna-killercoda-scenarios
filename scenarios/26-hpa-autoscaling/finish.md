## Done

An HPA is a control loop on top of another control loop: `metrics-server` scrapes kubelets, the HPA controller polls the metrics API, compares against the target, and patches `spec.replicas` on the Deployment -- which then triggers the ReplicaSet's own reconcile loop. Every layer from earlier scenarios (self-healing, rolling updates) is still running underneath; autoscaling is just one more controller adjusting the desired count.

This is the KCNA **HPA autoscaling** competency under Cloud Native Architecture.

**Next: Level 27, VPA Autoscaling.**
