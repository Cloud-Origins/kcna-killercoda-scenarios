## Done

One Ingress object, one controller, two backends -- routed entirely by path. This is the pattern that replaces running a separate LoadBalancer Service per app: a single entrypoint fans traffic out by host/path rules to whichever Service actually owns it.

**Why this matters for KCNA:** Ingress is the most commonly tested Networking object beyond Services -- know that it needs a controller to do anything (the object alone is inert), and that routing is rule-based, not automatic.

Next: Level 6, Network Policies.
