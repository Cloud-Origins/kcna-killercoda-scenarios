## Done

A StatefulSet gives you two things a Deployment can't: predictable ordinal names (`data-0`, `data-1`, not random suffixes) and a durable one-to-one binding between a Pod identity and its PVC. Delete `data-0` a hundred times, it always comes back as `data-0`, attached to the same volume -- that's what makes StatefulSets the right tool for databases and anything else that can't just be "any replaceable instance."

This is the KCNA **StatefulSets** competency under K8s Fundamentals.

**Next: Level 16, Jobs & CronJobs.**
