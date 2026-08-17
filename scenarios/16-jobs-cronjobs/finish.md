## Done

A Job's success condition is completion, not "still running" -- that's the whole point of `restartPolicy: Never`/`OnFailure` instead of `Always`. A CronJob is just a Job factory on a timer; every tick it creates a fresh Job, which behaves exactly like the one you built by hand in step 1.

This is the KCNA **Jobs and CronJobs** competency under K8s Fundamentals.

**Next: Level 17, Scheduling: Affinity & Taints.**
