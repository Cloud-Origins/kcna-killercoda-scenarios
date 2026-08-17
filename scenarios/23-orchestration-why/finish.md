## Done

Same failure, same three replicas, two completely different outcomes. Manual scaling is a snapshot -- correct the moment you create it, silently wrong the moment anything changes. A controller is a standing reconcile loop -- continuously comparing desired state to actual state and closing the gap, forever, without anyone watching. That loop, not the YAML syntax, is what "orchestration" actually means.

This is the KCNA **why orchestration** competency under Architecture.

**Next: Level 24, Rolling Updates.**
