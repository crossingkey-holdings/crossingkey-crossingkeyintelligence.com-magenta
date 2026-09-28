#!/usr/bin/env bash
set -euo pipefail

if [ ! -f ".visual_lock/manifest.sha256" ]; then
  echo "Visual lock manifest missing."
  exit 1
fi

python3 - <<'PY'
from pathlib import Path
import hashlib
import sys

expected = {}
for line in Path(".visual_lock/manifest.sha256").read_text(encoding="utf-8").splitlines():
    if not line.strip():
        continue
    digest, rel = line.split("  ", 1)
    expected[rel] = digest

changed = []
missing = []

for rel, old in expected.items():
    p = Path(rel)
    if not p.exists():
        missing.append(rel)
        continue
    new = hashlib.sha256(p.read_bytes()).hexdigest()
    if new != old:
        changed.append(rel)

if changed or missing:
    print("CROSSINGKEY VISUAL LOCK DRIFT DETECTED")
    print()
    if changed:
        print("Changed files:")
        for f in changed:
            print(f"  - {f}")
    if missing:
        print("Missing files:")
        for f in missing:
            print(f"  - {f}")
    print()
    print("Restore locked visuals with:")
    print("  ./ck_visual_restore.sh")
    print()
    print("Accept current visuals as new baseline with:")
    print("  ./ck_visual_accept_new_baseline.sh")
    sys.exit(1)

print("CROSSINGKEY VISUAL LOCK VERIFIED: no visual drift.")
PY
