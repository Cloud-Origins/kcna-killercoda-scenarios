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
