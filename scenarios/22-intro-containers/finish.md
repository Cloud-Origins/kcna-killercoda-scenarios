## Done

`kubectl` is a convenience layer, not the only truth. `kubectl logs`/`exec` go API server -> kubelet -> CRI -> containerd; `crictl` talks to that same CRI socket directly. Same container, same result, one fewer hop -- which is exactly the layer you're debugging when the API server itself is unreachable but the node is still up.

This is the KCNA **Container runtimes and CRI** competency under Architecture.

**Next: Level 23, Orchestration Why.**
