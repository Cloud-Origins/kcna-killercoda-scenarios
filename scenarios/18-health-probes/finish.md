## Done

Liveness answers "is this container broken enough to restart" -- get it wrong (too strict) and you get restart-loop churn on transient issues. Readiness answers "is this pod ready for traffic right now" -- get it wrong (missing) and broken pods keep receiving requests during startup or partial failure. They're independent controls with independent consequences, proven here by breaking one without touching the other.

This is the KCNA **Health probes and production readiness** competency under K8s Fundamentals.

**Next: Level 19, Helm Packaging.**
