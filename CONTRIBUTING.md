# Contributing

Thanks for considering a contribution. This project follows the
[Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md) -- participation
means agreeing to abide by it.

## Before you start

Read the README's [Compression Methodology](README.md#compression-methodology)
section first. Every scenario applies the same four techniques; a PR that
doesn't will likely get asked to rework before merge.

## Adding a new scenario

```bash
mkdir -p scenarios/NN-slug/{step1,step2}
```

1. Write `index.json`, `intro.md`, `background.sh`, and `finish.md`.
2. `background.sh` must `touch /tmp/kcna-background-done` as its final line,
   and `index.json`'s `details.intro` must declare both `foreground` and
   `background` (see any existing scenario for the pattern). Without this,
   the learner's terminal races the provisioning script instead of waiting
   for it -- this exact bug shipped once already; the static validator now
   catches it, but understand why before you touch it.
3. For each step, write `stepN/text.md` (learner-facing instructions) and
   `stepN/verify.sh` (an executable script that exits `0` on success,
   non-zero with a clear message on failure).
4. Where a step is genuinely diagnostic (the learner has to figure something
   out, not just paste boilerplate), don't put the answer in the main text.
   Put it behind a collapsible `<details><summary>Solution</summary>...
   </details>` block instead, following the pattern in
   [killercoda/scenario-examples](https://github.com/killercoda/scenario-examples/tree/main/solution-dropdown).
   A `<details><summary>Tip</summary>` block above it for a lighter nudge is
   welcome too. The main text should never state the exact value or output
   `verify.sh` is independently checking -- that turns a diagnostic exercise
   into copy-paste with no cognitive lift.
5. `chmod +x background.sh stepN/verify.sh`.
6. Add a row to the appropriate domain table in the README.

## Validating before you open a PR

```bash
python3 scripts/validate-static.py          # schema, files, shellcheck -- seconds, no cluster
scripts/test-scenario.sh NN-slug            # real kind cluster, runs background.sh as Killercoda would -- Linux + sudo only
```

`test-scenario.sh` needs a Linux host with passwordless `sudo` (it runs
`background.sh` as real root, matching Killercoda's execution environment
exactly -- there is no macOS-compatible version, because `/root` doesn't
exist on macOS at all). If you're on macOS, push a draft PR and let CI run
the dynamic gate for you.

CI (`.github/workflows/validate-scenarios.yml`) runs both automatically on
every PR: a static schema/lint pass, then one real kind-cluster run per
scenario in parallel. Both must pass before merge.

## Pull requests

- One scenario (or one coherent fix) per PR where practical.
- Explain *why*, not just *what*, in the description -- especially for any
  compression decision (what got cut from the source lab, and why the cut
  doesn't compromise the tested skill).
- If your change touches `background.sh` for an existing scenario, mention
  whether you re-ran `scripts/test-scenario.sh` locally, since CI will
  catch a regression either way but a heads-up saves review time.
