## Create a sidecar Pod sharing a volume

Create a Pod named `sidecar-demo` with two containers sharing an `emptyDir` volume named `logs`:
- container `app`: image `nginx:1.27`, mounts `logs` at `/var/log/shared`
- container `logger`: image `busybox:1.36`, mounts `logs` at `/var/log/shared`, command `sh -c "tail -f /dev/null"` (keeps it alive)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-demo
spec:
  volumes:
    - name: logs
      emptyDir: {}
  containers:
    - name: app
      image: nginx:1.27
      volumeMounts:
        - name: logs
          mountPath: /var/log/shared
    - name: logger
      image: busybox:1.36
      command: ["sh", "-c", "tail -f /dev/null"]
      volumeMounts:
        - name: logs
          mountPath: /var/log/shared
```

Save that as `/root/kcna-scratch/sidecar-demo.yaml` and apply it. Prove the volume is actually shared -- write a file from `app`, read it from `logger`:

```bash
kubectl exec sidecar-demo -c app -- sh -c "echo hello-from-app > /var/log/shared/proof.txt"
kubectl exec sidecar-demo -c logger -- cat /var/log/shared/proof.txt
```

<br>

<details><summary>Solution</summary>

`sidecar-demo` should be `Running` with exactly two containers, `app` then `logger` (in that order), and `logger` should be able to `cat` back whatever `app` wrote to `/var/log/shared/proof.txt` -- proof the `emptyDir` volume is shared, not container-local.

```bash
kubectl get pod sidecar-demo -o jsonpath='{.status.phase} {.spec.containers[*].name}{"\n"}'
```{{exec}}

</details>
