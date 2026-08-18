## Chain two Tasks into a Pipeline

Two Tasks, a Pipeline wiring them together in order with a shared workspace, and a PipelineRun to actually execute it:

```yaml
apiVersion: tekton.dev/v1
kind: Task
metadata:
  name: build
spec:
  workspaces:
    - name: shared
  steps:
    - name: build-step
      image: busybox:1.36
      script: |
        #!/bin/sh
        echo "kcna-build-artifact-v1" > $(workspaces.shared.path)/artifact.txt
---
apiVersion: tekton.dev/v1
kind: Task
metadata:
  name: verify-build
spec:
  workspaces:
    - name: shared
  steps:
    - name: verify-step
      image: busybox:1.36
      script: |
        #!/bin/sh
        grep -q "kcna-build-artifact-v1" $(workspaces.shared.path)/artifact.txt
---
apiVersion: tekton.dev/v1
kind: Pipeline
metadata:
  name: ci-pipeline
spec:
  workspaces:
    - name: shared-workspace
  tasks:
    - name: build
      taskRef:
        name: build
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
  name: ci-run-1
spec:
  pipelineRef:
    name: ci-pipeline
  workspaces:
    - name: shared-workspace
      emptyDir: {}
```

Save as `/root/kcna-scratch/pipeline.yaml`, apply, and watch it run:

```bash
kubectl get pipelinerun ci-run-1 -w
```

<br>

<details><summary>Solution</summary>

`kubectl get pipelinerun ci-run-1` should eventually show `SUCCEEDED: True`. Confirm via the raw condition:

```bash
kubectl get pipelinerun ci-run-1 -o jsonpath='{.status.conditions[?(@.type=="Succeeded")].status}{"\n"}'
```{{exec}}

Expect `True`. If it's still empty, the run hasn't finished yet -- give it a few more seconds.

</details>
