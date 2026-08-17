## Done

`kubectl logs` reads from one container's stdout/stderr stream, buffered by the kubelet -- "one container" isn't optional once there's more than one, and "current instance" isn't the same as "why it died" once a restart has happened. `-c` and `--previous` aren't edge-case flags, they're the difference between debugging the right thing and debugging nothing.

This is the KCNA **Logging** competency under Cloud Native Observability.

**Next: Level 31, Grafana Dashboards.**
