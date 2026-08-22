#!/usr/bin/env python3
"""Validate change fragments without requiring a release or network access."""

from pathlib import Path
import json
import sys

ROOT = Path(__file__).resolve().parents[1]
FRAGMENT_DIR = ROOT / ".changes" / "unreleased"
CHANGE_TYPES = {"added", "changed", "deprecated", "fixed", "removed", "security"}


def main() -> int:
    errors: list[str] = []
    fragments = list(FRAGMENT_DIR.glob("*.json")) if FRAGMENT_DIR.exists() else []
    for path in fragments:
        try:
            fragment = json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            errors.append(f"{path.name}: invalid JSON ({exc})")
            continue
        if fragment.get("schema_version") != 1 or not fragment.get("topic"):
            errors.append(f"{path.name}: schema_version 1 and topic are required")
        changes = fragment.get("changes")
        if not isinstance(changes, list) or not changes:
            errors.append(f"{path.name}: changes must be a non-empty array")
            continue
        for change in changes:
            if change.get("type") not in CHANGE_TYPES:
                errors.append(f"{path.name}: invalid change type")
            if not change.get("id") or not change.get("zh"):
                errors.append(f"{path.name}: every change needs id and zh")
            if change.get("announce") and not change.get("changelog"):
                errors.append(f"{path.name}: announce requires changelog")
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Checked {len(fragments)} change fragment(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
