## Done

Same mechanism, `valueFrom`, wires both a ConfigMap and a Secret into a container's environment -- the difference is entirely about what belongs where: non-sensitive config in a ConfigMap, sensitive values in a Secret (base64 is encoding for transport, not encryption; RBAC is the real access boundary).

This is the KCNA **ConfigMaps and Secrets** competency under K8s Fundamentals.

**Next: Level 14, DaemonSets.**
