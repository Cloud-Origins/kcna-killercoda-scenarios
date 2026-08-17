## Done

`ResourceQuota` caps aggregate consumption (pod count, CPU, memory) per namespace, independent of what any single pod's manifest asks for. A perfectly valid pod manifest can still be rejected if the namespace is already at its cap -- that rejection is enforced at admission time, not scheduling time.

**Why this matters for KCNA:** multi-tenant clusters live and die by quotas. The exam expects you to know quotas exist at the namespace level and reason about *why* a valid-looking pod creation fails.

Next: Level 4, Persistent Storage.
