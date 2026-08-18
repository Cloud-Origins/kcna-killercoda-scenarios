## Prove a broken stage fails the whole run

A CI pipeline is only useful if it actually stops bad builds. Create a second `build` Task that writes the wrong artifact, wire it into a second Pipeline reusing the same `verify-build` Task, and run it:

```yaml
apiVersion: tekton.dev/v1
kind: Task
metadata:
  name: build-broken
spec:
  workspaces:
    - name: shared
  steps:
    - name: build-step
      image: busybox:1.36
      script: |
        #!/bin/sh
        echo "wrong-artifact-content" > $(workspaces.shared.path)/artifact.txt
---
apiVersion: tekton.dev/v1
kind: Pipeline
metadata:
  name: ci-pipeline-broken
spec:
  workspaces:
    - name: shared-workspace
  tasks:
    - name: build
      taskRef:
        name: build-broken
      workspaces:
        - name: shared
          workspace: shared-workspace
    - name: verify
      taskRef:
        name: verify-build
      runAfter: ["build"]
      workspaces:
        - name: shared
          workspace: shared-workspace
---
apiVersion: tekton.dev/v1
kind: PipelineRun
metadata:
  name: ci-run-2-broken
spec:
  pipelineRef:
    name: ci-pipeline-broken
  workspaces:
    - name: shared-workspace
      emptyDir: {}
```

Save as `/root/kcna-scratch/pipeline-broken.yaml`, apply, and watch it fail:

```bash
kubectl get pipelinerun ci-run-2-broken -w
```

<br>

<details><summary>Solution</summary>

`kubectl get pipelinerun ci-run-2-broken` should show `SUCCEEDED: False` -- the `verify` Task's `grep` fails to find `kcna-build-artifact-v1` in the wrong content, which fails the whole run. Confirm both runs' final state:

```bash
kubectl get pipelinerun ci-run-2-broken -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}{"\n"}'
```{{exec}}

```bash
kubectl get pipelinerun ci-run-1 -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}{"\n"}'
```{{exec}}

Expect `False` then `True` -- the broken run fails, and the original good run from Step 1 is untouched.

</details>
