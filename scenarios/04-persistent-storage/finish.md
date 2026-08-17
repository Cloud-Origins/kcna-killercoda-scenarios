## Done

You proved the core PV/PVC guarantee by hand: storage lifecycle is decoupled from pod lifecycle. The pod that wrote the data can die completely, and a totally different pod can claim the same underlying volume and see the same bytes.

**Why this matters for KCNA:** this is the single fact the exam is checking when it tests storage -- pods are ephemeral, PVs are not, and a PVC is the binding contract between them.

Next: Level 5, Ingress & Gateway API.
