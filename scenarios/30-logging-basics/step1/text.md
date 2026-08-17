## Read logs from one specific container

`multi-log` has two containers. Plain `kubectl logs multi-log` fails -- it doesn't know which one you mean:

```bash
kubectl logs multi-log
```

Pick the `sidecar` container specifically:

```bash
kubectl logs multi-log -c sidecar --tail=3
```

Save what you saw to prove you read the right one:

```bash
kubectl logs multi-log -c sidecar --tail=1 > /root/kcna-scratch/answer-sidecar-log.txt
cat /root/kcna-scratch/answer-sidecar-log.txt
```
