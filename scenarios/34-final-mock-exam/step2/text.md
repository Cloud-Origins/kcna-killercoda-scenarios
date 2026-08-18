## Part B: Operate and observe

**B1. Roll and scale `exam-app`.** Ship a new image tag, then scale up:

```bash
kubectl set image deployment/exam-app exam-app=nginx:1.27-alpine
kubectl rollout status deployment/exam-app --timeout=60s
kubectl scale deployment exam-app --replicas=4
kubectl rollout status deployment/exam-app --timeout=60s
```

**B2. Diagnose `mock-crash`.** It already crashed once and restarted. Find out why, from the instance that actually died, not the one running now:

```bash
kubectl logs mock-crash
kubectl logs mock-crash --previous
```

Save the crash reason:

```bash
kubectl logs mock-crash --previous > /root/kcna-scratch/answer-crash-reason.txt
```

<br>

<details><summary>Solution</summary>

**B1.** After the image update and scale:

```bash
kubectl get deploy exam-app -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}{.status.readyReplicas}{"\n"}'
```{{exec}}

should print `nginx:1.27-alpine` then `4`.

**B2.** `/root/kcna-scratch/answer-crash-reason.txt` should contain exactly `crash-reason-connection-refused`. Plain `kubectl logs mock-crash` (no `--previous`) only shows the current steady-state instance and won't have this string -- only `--previous` reaches the terminated instance's logs.

</details>
