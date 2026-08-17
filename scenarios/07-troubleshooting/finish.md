## Done

Two independent, realistic failure classes fixed:

1. **ImagePullBackOff from a bad tag** -- caught by `kubectl describe pod` and its Events section, not by staring at the YAML.
2. **Service selector mismatch** -- zero endpoints even though the pod is healthy, caught by comparing `kubectl get svc -o yaml` against `kubectl get pod --show-labels`, not by assuming the Service "just works" once the pod is up.

This is the KCNA **Troubleshooting** sub-competency under Container Orchestration -- diagnosing broken state in an already-applied cluster, not building from scratch.

**Next: Level 8, kubectl Tooling & Contexts.**
