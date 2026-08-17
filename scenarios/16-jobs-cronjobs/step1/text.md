## Create a Job that runs to completion

Create a Job named `counter`:
- image `busybox:1.36`
- command `sh -c "echo processing; sleep 2; echo done"`
- `restartPolicy: Never`

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: counter
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: counter
          image: busybox:1.36
          command: ["sh", "-c", "echo processing; sleep 2; echo done"]
```

Save as `/root/kcna-scratch/counter.yaml`, apply it, and wait for it to finish:

```bash
kubectl wait --for=condition=Complete job/counter --timeout=60s
kubectl get jobs
kubectl logs job/counter
```
