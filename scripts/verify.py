#!/usr/bin/env python3
"""Compile the exact proof and specification checks, then audit axiom dependencies."""

import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / ".build"
ALLOWED_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
EXPECTED_CHECKS = {
    "Verification.seed_zero",
    "Verification.seed_one",
    "Verification.greedy_minimum",
    "Verification.claimed_result",
}
INPUTS = [
    "A057923.lean", "Verification.lean", "lean-toolchain", "TOOLCHAIN.json",
    "README.md", "PROVENANCE.md", "PRIOR_ART.md", "CITATION.cff",
    "PROMPT.md", "RESULTS.txt", "scripts/verify.py", ".github/workflows/verify.yml",
]


def run(args, **kwargs):
    return subprocess.run(args, cwd=ROOT, text=True, capture_output=True, **kwargs)


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def parse_axioms(messages):
    reports = {}
    for message in messages:
        data = message.get("data", "")
        match = re.fullmatch(r"'([^']+)' depends on axioms: \[(.*?)\]", data, re.S)
        empty = re.fullmatch(r"'([^']+)' does not depend on any axioms", data)
        if match:
            name = match.group(1)
            axioms = {x.strip() for x in match.group(2).split(",") if x.strip()}
        elif empty:
            name, axioms = empty.group(1), set()
        else:
            continue
        require(name not in reports, f"Duplicate axiom report: {name}")
        require(not (axioms - ALLOWED_AXIOMS),
                f"Unexpected axioms in {name}: {sorted(axioms - ALLOWED_AXIOMS)}")
        reports[name] = sorted(axioms)
    require(set(reports) == EXPECTED_CHECKS,
            f"Missing or unexpected statement checks: {sorted(reports)}")
    return reports


def main():
    BUILD.mkdir(exist_ok=True)
    for name in ["verification.json", "verification.log", "A057923.olean"]:
        (BUILD / name).unlink(missing_ok=True)

    config = json.loads((ROOT / "TOOLCHAIN.json").read_text())
    lean = os.environ.get("LEAN", "lean")
    version = run([lean, "--short-version"], check=True).stdout.strip()
    githash = run([lean, "--githash"], check=True).stdout.strip()
    require(version == config["lean_version"], f"Unexpected Lean version: {version}")
    require(githash == config["lean_githash"], f"Unexpected Lean revision: {githash}")
    require((ROOT / "lean-toolchain").read_text().strip() == f"leanprover/lean4:v{version}",
            "lean-toolchain and TOOLCHAIN.json disagree")

    environment = os.environ.copy()
    environment["LEAN_PATH"] = str(BUILD)
    commands = [
        [lean, "--json", "-o", str(BUILD / "A057923.olean"), "A057923.lean"],
        [lean, "--json", "Verification.lean"],
    ]
    checked_messages = []
    with (BUILD / "verification.log").open("w") as log:
        log.write(f"Lean {version}; compiler revision {githash}\n")
        for command in commands:
            result = run(command, env=environment)
            log.write(f"\nChecking {command[-1]}\n")
            log.write(result.stdout)
            log.write(result.stderr)
            log.flush()
            require(result.returncode == 0,
                    f"Lean failed on {command[-1]}:\n{result.stdout}{result.stderr}")
            require(not result.stderr.strip(), f"Unexpected compiler stderr: {result.stderr}")
            messages = [json.loads(line) for line in result.stdout.splitlines() if line.strip()]
            bad = [m for m in messages if m.get("severity") != "information"]
            require(not bad, f"Compiler warnings/errors: {json.dumps(bad)}")
            if command[-1] == "Verification.lean":
                checked_messages = messages

    axiom_reports = parse_axioms(checked_messages)
    commit_result = run(["git", "rev-parse", "HEAD"])
    commit = commit_result.stdout.strip() if commit_result.returncode == 0 else None
    dirty = run(["git", "diff", "--quiet", "HEAD", "--"]).returncode != 0 if commit else None
    if os.environ.get("GITHUB_ACTIONS") == "true":
        require(commit == os.environ.get("GITHUB_SHA"), "Checked commit differs from workflow SHA")
        require(dirty is False, "Tracked sources changed during verification")
    repository = os.environ.get("GITHUB_REPOSITORY")
    run_id = os.environ.get("GITHUB_RUN_ID")
    run_url = (f"https://github.com/{repository}/actions/runs/{run_id}"
               if repository and run_id else None)
    report = {
        "status": "verified",
        "checked_at_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "lean_version": version,
        "lean_githash": githash,
        "commit": commit,
        "tracked_worktree_dirty": dirty,
        "theorem": "forall n : Nat, A057923.a n < A057923.a (n + 2)",
        "axioms": axiom_reports,
        "source_sha256": {
            name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in INPUTS
        },
        "github_run_url": run_url,
        "github_event": os.environ.get("GITHUB_EVENT_NAME"),
        "repository_visibility": os.environ.get("REPOSITORY_VISIBILITY", "local"),
    }
    (BUILD / "verification.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"VERIFIED: Lean {version}; four statement checks; standard axioms only.")
    print("Reports: .build/verification.json and .build/verification.log")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"VERIFICATION FAILED: {error}", file=sys.stderr)
        sys.exit(1)
