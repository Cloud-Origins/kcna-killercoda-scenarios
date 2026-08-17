## Label the worker

Find the node that is **not** the control plane -- that's your worker.

Label it:

```bash
kubectl label node <worker-node-name> role=worker-demo
```
