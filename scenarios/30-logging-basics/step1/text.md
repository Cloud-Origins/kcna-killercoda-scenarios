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

<br>

<details><summary>Solution</summary>

`/root/kcna-scratch/answer-sidecar-log.txt` should contain exactly `SIDECAR-LOG-LINE`. If plain `kubectl logs multi-log` (no `-c`) had worked, or the file contains anything else, you read from the wrong container -- re-run with `-c sidecar`.

</details>
