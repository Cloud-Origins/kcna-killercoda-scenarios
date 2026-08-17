## Done

VPA is three separate controllers cooperating: the recommender watches real usage and computes a target, the updater decides an existing pod is too far off that target and evicts it, and the admission-controller intercepts the replacement pod's creation and rewrites its resource requests on the way in -- which is why VPA resizes by recreating, not by patching a running pod in place (containers can't be live-resized without `InPlacePodVerticalScaling`, a newer, non-default feature).

This is the KCNA **VPA autoscaling** competency under Cloud Native Architecture.

**Next: Level 28, Serverless: Knative Scale-to-Zero.**
