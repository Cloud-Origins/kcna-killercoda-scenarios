## Intro to Containers: crictl & containerd

`kubectl` talks to the API server, which talks to the kubelet, which talks to the container runtime (`containerd` here) over the Container Runtime Interface (CRI). `kubectl` is not the only way to see what's running -- `crictl` talks to the CRI socket directly, the same layer the kubelet itself uses. A `runtime-demo` pod is already running.

**You will:**
1. Find `runtime-demo`'s container at the runtime layer, below kubelet
2. Read its logs and exec into it through `crictl` directly, bypassing `kubectl` entirely

**Target time:** 30 minutes
