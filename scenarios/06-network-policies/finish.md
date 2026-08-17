## Done

A NetworkPolicy that looks correct at a glance can still block everything if a single label value is off by one character. `podSelector` matches are exact string matches, not fuzzy -- `frontnd` != `frontend`, full stop.

**Why this matters for KCNA:** the exam tests whether you understand that NetworkPolicies are default-deny once any policy selects a pod, and that a policy silently failing to match is indistinguishable from "no policy" unless you check both sides -- the policy's selector and the pod's actual labels.

Next: Level 7, Troubleshooting Drill.
