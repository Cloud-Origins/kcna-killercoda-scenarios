## Done

You identified the control plane by what runs in `kube-system` (`etcd`, `kube-apiserver`, `kube-scheduler`, `kube-controller-manager`), and distinguished it from a worker node by labeling.

**Why this matters for KCNA:** the exam tests this distinction directly -- which components run where, and what each one does. If `kube-apiserver` is down, nothing can talk to the cluster. If `etcd` is down, no state is readable or writable. If `kube-scheduler` is down, new pods stay `Pending` forever. Knowing *where* these live is the first step to reasoning about *what breaks* when one fails.

Next: Level 2, Services.
