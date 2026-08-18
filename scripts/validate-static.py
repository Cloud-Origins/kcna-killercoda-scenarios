#!/usr/bin/env python3
"""Static structural validator for all scenarios -- no cluster required.

Quality gate run in CI (and locally) before any scenario is trusted to
actually work. Checks:
  - index.json is valid JSON and has every field Killercoda's schema needs
  - every file index.json references actually exists on disk
  - background.sh / foreground.sh / verify.sh are executable
  - background.sh touches the foreground-wait marker; foreground.sh polls it
    (regression guard for the race condition that shipped in every scenario
    before it was caught and fixed -- see git history)
  - every .sh file passes `bash -n` (syntax) and `shellcheck -S error`
  - every relative asset path referenced from text.md/background.sh resolves
  - every non-quiz step has a well-formed Solution dropdown: matched
    <details>/</details>, exactly one <summary>Tip|Solution</summary> per
    <details>, balanced code fences, and no {{exec}} tag on a multi-line
    code block (regression guard for the Solution/Tip rollout -- this does
    NOT verify the *content* inside a Solution block is factually correct,
    only that the markup is well-formed and every non-quiz step has one)

Exits non-zero (and prints every failure, not just the first) if any
scenario fails any check.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SCENARIOS_DIR = REPO / "scenarios"
MARKER = "kcna-background-done"

# Multiple-choice self-assessment scenarios -- a "Solution: B" dropdown
# would hand over the answer key, so the Solution-dropdown convention
# deliberately does not apply here.
QUIZ_SCENARIOS = {"11-fundamentals-quiz", "29-cncf-landscape"}

errors: list[str] = []
warnings: list[str] = []


def fail(scenario: str, msg: str) -> None:
    errors.append(f"[{scenario}] {msg}")


def warn(scenario: str, msg: str) -> None:
    warnings.append(f"[{scenario}] {msg}")


def check_shell_syntax(scenario: str, path: Path) -> None:
    result = subprocess.run(
        ["bash", "-n", str(path)], capture_output=True, text=True
    )
    if result.returncode != 0:
        fail(scenario, f"{path.name}: bash -n failed: {result.stderr.strip()}")

    if subprocess.run(["which", "shellcheck"], capture_output=True).returncode == 0:
        # -s bash: Killercoda's own reference foreground/background scripts
        # have no shebang (the platform decides the interpreter, not the
        # file), so tell shellcheck explicitly instead of flagging SC2148.
        result = subprocess.run(
            ["shellcheck", "-s", "bash", "-S", "error", str(path)], capture_output=True, text=True
        )
        if result.returncode != 0:
            fail(scenario, f"{path.name}: shellcheck error(s):\n{result.stdout.strip()}")


def check_executable(scenario: str, path: Path) -> None:
    if not path.stat().st_mode & 0o111:
        fail(scenario, f"{path.name} is not executable (chmod +x)")


def check_solution_dropdowns(scenario: str, scenario_dir: Path) -> None:
    quiz = scenario in QUIZ_SCENARIOS
    for text_md in sorted(scenario_dir.glob("step*/text.md")):
        rel = text_md.relative_to(scenario_dir)
        content = text_md.read_text()

        open_count = len(re.findall(r"<details>", content))
        close_count = len(re.findall(r"</details>", content))
        if open_count != close_count:
            fail(scenario, f"{rel}: {open_count} <details> vs {close_count} </details> -- unbalanced")

        summary_count = len(re.findall(r"<summary>(?:Tip|Solution)</summary>", content))
        if summary_count != open_count:
            fail(scenario, f"{rel}: {open_count} <details> block(s) but {summary_count} recognized "
                            f"<summary>Tip|Solution</summary> tag(s) -- every <details> needs exactly one")

        fence_count = content.count("```")
        if fence_count % 2 != 0:
            fail(scenario, f"{rel}: odd number of ``` code fences ({fence_count}) -- an unclosed block")

        for block in re.findall(r"```[a-z]*\n([^`]*?)\n```\{\{exec\}\}", content):
            if "\n" in block.strip():
                fail(scenario, f"{rel}: a ```{{{{exec}}}}-tagged code block spans multiple lines -- "
                                f"only single-line, side-effect-free commands should be click-to-run")

        if not quiz and summary_count > 0 and "<summary>Solution</summary>" not in content:
            fail(scenario, f"{rel}: has a Tip dropdown but no Solution dropdown")

        if not quiz and "<summary>Solution</summary>" not in content:
            fail(scenario, f"{rel}: missing a Solution dropdown (see CONTRIBUTING.md)")


def check_asset_references(scenario: str, scenario_dir: Path) -> None:
    for md_or_sh in list(scenario_dir.glob("*.sh")) + list(scenario_dir.glob("**/*.md")):
        text = md_or_sh.read_text(errors="ignore")
        for ref in re.findall(r"assets/[A-Za-z0-9_./-]+\.ya?ml", text):
            if not (scenario_dir / ref).exists():
                fail(scenario, f"{md_or_sh.relative_to(scenario_dir)} references '{ref}' which does not exist")


def validate_scenario(scenario_dir: Path) -> None:
    name = scenario_dir.name
    index_path = scenario_dir / "index.json"

    if not index_path.exists():
        fail(name, "missing index.json")
        return

    try:
        data = json.loads(index_path.read_text())
    except json.JSONDecodeError as e:
        fail(name, f"index.json is not valid JSON: {e}")
        return

    details = data.get("details", {})
    intro = details.get("intro", {})

    for field, val in [("title", data.get("title")), ("description", data.get("description"))]:
        if not val:
            fail(name, f"index.json missing top-level '{field}'")

    if not intro.get("text"):
        fail(name, "details.intro.text missing")
    if not intro.get("foreground"):
        fail(name, "details.intro.foreground missing -- background.sh will race the learner's terminal (see repo history)")
    if not intro.get("background"):
        fail(name, "details.intro.background missing")

    steps = details.get("steps", [])
    if not steps:
        fail(name, "details.steps is empty")
    for i, step in enumerate(steps, 1):
        for field in ("title", "text", "verify"):
            if not step.get(field):
                fail(name, f"step {i} missing '{field}'")

    if not details.get("finish", {}).get("text"):
        fail(name, "details.finish.text missing")
    if not data.get("backend", {}).get("imageid"):
        fail(name, "backend.imageid missing")

    # Every referenced file must exist.
    referenced = [intro.get("text"), intro.get("foreground"), intro.get("background"),
                  details.get("finish", {}).get("text")]
    for step in steps:
        referenced += [step.get("text"), step.get("verify")]
    for rel in filter(None, referenced):
        if not (scenario_dir / rel).exists():
            fail(name, f"index.json references '{rel}' which does not exist on disk")

    # Executability + syntax for every shell script.
    for sh in scenario_dir.glob("**/*.sh"):
        check_executable(name, sh)
        check_shell_syntax(name, sh)

    # Foreground-wait regression guard.
    bg_path = scenario_dir / "background.sh"
    fg_path = scenario_dir / "foreground.sh"
    if bg_path.exists():
        bg_text = bg_path.read_text()
        if MARKER not in bg_text:
            fail(name, f"background.sh never touches /tmp/{MARKER} -- foreground.sh will wait forever")
        if not re.search(r"\bset -e\b", bg_text):
            warn(name, "background.sh has no 'set -e' -- a failed step may go unnoticed")
    if fg_path.exists():
        fg_text = fg_path.read_text()
        if MARKER not in fg_text:
            fail(name, f"foreground.sh does not poll for /tmp/{MARKER} -- won't block the learner's terminal")

    check_asset_references(name, scenario_dir)
    check_solution_dropdowns(name, scenario_dir)


def check_structure_json(scenario_dirs: list[Path]) -> None:
    """scenarios/structure.json controls Killercoda's display order for the
    course tile -- Killercoda otherwise sorts alphabetically by title,
    ignoring the NN- prefix entirely (confirmed live). If a scenario
    directory exists but isn't listed here, it silently vanishes from the
    course listing instead of failing loudly, so this is a real guardrail,
    not cosmetic."""
    structure_path = SCENARIOS_DIR / "structure.json"
    if not structure_path.exists():
        warn("structure.json", "missing -- Killercoda will sort the course listing alphabetically by "
                                "title instead of the intended domain/level order")
        return

    try:
        data = json.loads(structure_path.read_text())
    except json.JSONDecodeError as e:
        fail("structure.json", f"not valid JSON: {e}")
        return

    listed = [item.get("path") for item in data.get("items", [])]
    on_disk = {d.name for d in scenario_dirs}

    for path in listed:
        if path not in on_disk:
            fail("structure.json", f"lists '{path}' but no such scenario directory exists")

    for name in sorted(on_disk - set(listed)):
        fail("structure.json", f"scenario directory '{name}' exists but is not listed -- "
                                f"it will be invisible in Killercoda's course listing")

    if len(listed) != len(set(listed)):
        fail("structure.json", "contains duplicate paths")


def main() -> int:
    scenario_dirs = sorted(p for p in SCENARIOS_DIR.iterdir() if p.is_dir())
    if not scenario_dirs:
        print(f"No scenario directories found under {SCENARIOS_DIR}")
        return 1

    check_structure_json(scenario_dirs)

    for d in scenario_dirs:
        validate_scenario(d)

    print(f"Validated {len(scenario_dirs)} scenarios.\n")

    if warnings:
        print(f"{len(warnings)} warning(s):")
        for w in warnings:
            print(f"  WARN  {w}")
        print()

    if errors:
        print(f"{len(errors)} error(s):")
        for e in errors:
            print(f"  FAIL  {e}")
        print(f"\n{len(errors)} error(s) across {len(set(e.split(']')[0][1:] for e in errors))} scenario(s).")
        return 1

    print("All scenarios pass static validation.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
