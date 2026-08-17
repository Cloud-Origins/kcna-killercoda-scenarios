## Done

Every Tekton `Task` is just a Pod, every `step` inside it just a container -- CI/CD on Kubernetes means the build system is subject to the exact same scheduling, RBAC, and resource controls as everything else in this track, not a separate system bolted on. `workspaces` are how stages pass data forward, and a non-zero exit code in any step is what makes a Pipeline fail loudly instead of quietly shipping a broken artifact -- which is the entire reason a `verify` stage exists.

This is the KCNA **CI/CD** competency under Cloud Native Application Delivery.

**Next: Level 34, Final Mock Exam.**
