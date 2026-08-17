## Done

Two habits that pay off every day on real clusters:

1. **Context defaults** -- `kubectl config set-context --current --namespace=X` kills the constant `-n X` typing, and `-o jsonpath` pulls exact fields out of any object without eyeballing YAML.
2. **`kubectl explain`** -- the API schema travels with the client. No docs site needed to know a field's type, whether it's required, or what it nests under.

Both are named KCNA **K8s Fundamentals** competencies: kubectl usage and API object structure.

**Next: Level 9, Pods & Multi-container Patterns.**
