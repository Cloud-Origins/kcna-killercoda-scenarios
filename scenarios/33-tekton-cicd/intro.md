## Tekton CI/CD

Tekton Pipelines is already installed. Tekton's model is Kubernetes-native CI: `Task` (one unit of work), `Pipeline` (an ordered graph of Tasks), `PipelineRun` (one actual execution) -- each `Task` runs as a Pod, each `step` inside it as a container, and `workspaces` are how one stage hands data to the next.

**You will:**
1. Chain a `build` Task into a `verify` Task through a shared workspace, and watch the PipelineRun succeed
2. Break the build stage on purpose and prove the whole run fails, loudly, instead of silently passing

**Target time:** 50 minutes
