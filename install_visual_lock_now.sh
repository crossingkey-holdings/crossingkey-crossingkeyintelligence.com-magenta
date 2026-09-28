#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
LOCK_DIR=".visual_lock"
BASELINE_DIR="$LOCK_DIR/baseline"
MANIFEST="$LOCK_DIR/manifest.sha256"
BACKUP_DIR=".ck_backups/visual_lock_install_$STAMP"

mkdir -p "$BASELINE_DIR" "$BACKUP_DIR" .ck_backups

echo "Installing CrossingKey visual lock tools..."
echo "Backup folder: $BACKUP_DIR"

find_visual_files() {
  find . \
    \( -path "./node_modules" -o -path "./node_modules/*" \
       -o -path "./dist" -o -path "./dist/*" \
       -o -path "./.git" -o -path "./.git/*" \
       -o -path "./.visual_lock" -o -path "./.visual_lock/*" \
       -o -path "./.ck_backups" -o -path "./.ck_backups/*" \) -prune \
    -o -type f \
    \( -name "index.html" \
       -o -path "./src/*" \
       -o -path "./public/*" \
       -o -path "./assets/*" \
       -o -name "*.css" \
       -o -name "*.js" \
       -o -name "*.mjs" \
       -o -name "*.jsx" \
       -o -name "*.ts" \
       -o -name "*.tsx" \
       -o -name "*.svg" \
       -o -name "*.png" \
       -o -name "*.webp" \
       -o -name "*.jpg" \
       -o -name "*.jpeg" \) \
    -print | sort
}

echo "Backing up current visual files..."
while IFS= read -r file; do
  rel="${file#./}"
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  cp -a "$file" "$BACKUP_DIR/$rel"
done < <(find_visual_files)

echo "Creating current approved visual baseline..."
rm -rf "$BASELINE_DIR"
mkdir -p "$BASELINE_DIR"

while IFS= read -r file; do
  rel="${file#./}"
  mkdir -p "$BASELINE_DIR/$(dirname "$rel")"
  cp -a "$file" "$BASELINE_DIR/$rel"
done < <(find_visual_files)

python3 - <<'PY'
from pathlib import Path
import hashlib

exclude = {"node_modules", "dist", ".git", ".visual_lock", ".ck_backups"}
visual_exts = {".css", ".js", ".mjs", ".jsx", ".ts", ".tsx", ".svg", ".png", ".webp", ".jpg", ".jpeg"}

files = []
for p in Path(".").rglob("*"):
    if not p.is_file():
        continue
    if set(p.parts) & exclude:
        continue
    s = p.as_posix()
    if (
        p.name == "index.html"
        or s.startswith("src/")
        or s.startswith("public/")
        or s.startswith("assets/")
        or p.suffix.lower() in visual_exts
    ):
        files.append(p)

rows = []
for p in sorted(files, key=lambda x: x.as_posix()):
    rows.append(f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.as_posix()}")

Path(".visual_lock/manifest.sha256").write_text("\n".join(rows) + "\n", encoding="utf-8")
PY

cat > CROSSINGKEY_VISUAL_LOCK.md <<'MD'
# CrossingKey Intelligence Visual Lock

Status: LOCKED

The current visual system is the approved CrossingKey Intelligence command-surface design.

Do not redesign, recolor, restructure, rename, restyle, or replace the visuals unless the founder explicitly requests a visual change.

Locked traits:
- Void black / black-glass foundation
- Cold silver typography
- Atomic magenta glow
- Vertical magenta signal-line background
- Starfield / particle atmosphere
- Large CrossingKey Intelligence hero
- Rounded command-surface navigation
- Right-side search module
- Trending search pills
- Magenta CTA buttons
- Fifteen mapped category cards
- Glowing crossed-key card icons
- Shopify as official checkout rail
- Real LCARS-inspired command-interface direction without copying LCARS

Allowed without visual approval:
- Fix broken links
- Correct typos
- Update Shopify URL
- Update contact email
- Update product/category text
- Fix functional bugs without changing appearance
MD

cat > ck_visual_verify.sh <<'VERIFY'
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
VERIFY

cat > ck_visual_restore.sh <<'RESTORE'
#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ".visual_lock/baseline" ]; then
  echo "Missing .visual_lock/baseline"
  exit 1
fi

echo "Restoring approved visual baseline..."
find index.html src public assets -type f -exec chmod u+w {} \; 2>/dev/null || true
cp -a .visual_lock/baseline/. .
echo "Restored."
./ck_visual_verify.sh
RESTORE

cat > ck_visual_accept_new_baseline.sh <<'ACCEPT'
#!/usr/bin/env bash
set -euo pipefail

echo "Accepting current visuals as the new approved baseline..."

rm -rf .visual_lock/baseline
mkdir -p .visual_lock/baseline

find . \
  \( -path "./node_modules" -o -path "./node_modules/*" \
     -o -path "./dist" -o -path "./dist/*" \
     -o -path "./.git" -o -path "./.git/*" \
     -o -path "./.visual_lock" -o -path "./.visual_lock/*" \
     -o -path "./.ck_backups" -o -path "./.ck_backups/*" \) -prune \
  -o -type f \
  \( -name "index.html" \
     -o -path "./src/*" \
     -o -path "./public/*" \
     -o -path "./assets/*" \
     -o -name "*.css" \
     -o -name "*.js" \
     -o -name "*.mjs" \
     -o -name "*.jsx" \
     -o -name "*.ts" \
     -o -name "*.tsx" \
     -o -name "*.svg" \
     -o -name "*.png" \
     -o -name "*.webp" \
     -o -name "*.jpg" \
     -o -name "*.jpeg" \) \
  -print | sort | while read -r file; do
    rel="${file#./}"
    mkdir -p ".visual_lock/baseline/$(dirname "$rel")"
    cp -a "$file" ".visual_lock/baseline/$rel"
  done

python3 - <<'PY'
from pathlib import Path
import hashlib

exclude = {"node_modules", "dist", ".git", ".visual_lock", ".ck_backups"}
visual_exts = {".css", ".js", ".mjs", ".jsx", ".ts", ".tsx", ".svg", ".png", ".webp", ".jpg", ".jpeg"}

files = []
for p in Path(".").rglob("*"):
    if not p.is_file():
        continue
    if set(p.parts) & exclude:
        continue
    s = p.as_posix()
    if (
        p.name == "index.html"
        or s.startswith("src/")
        or s.startswith("public/")
        or s.startswith("assets/")
        or p.suffix.lower() in visual_exts
    ):
        files.append(p)

rows = []
for p in sorted(files, key=lambda x: x.as_posix()):
    rows.append(f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.as_posix()}")

Path(".visual_lock/manifest.sha256").write_text("\n".join(rows) + "\n", encoding="utf-8")
PY

echo "New approved visual baseline accepted."
./ck_visual_verify.sh
ACCEPT

cat > ck_visual_unlock.sh <<'UNLOCK'
#!/usr/bin/env bash
set -euo pipefail
find index.html src public assets -type f -exec chmod u+w {} \; 2>/dev/null || true
echo "Visual files unlocked for approved edits."
UNLOCK

chmod +x ck_visual_verify.sh ck_visual_restore.sh ck_visual_accept_new_baseline.sh ck_visual_unlock.sh

echo "Adding npm visual scripts..."
python3 - <<'PY'
from pathlib import Path
import json

p = Path("package.json")
if not p.exists():
    raise SystemExit(0)

data = json.loads(p.read_text(encoding="utf-8"))
scripts = data.setdefault("scripts", {})
scripts["visual:verify"] = "./ck_visual_verify.sh"
scripts["visual:restore"] = "./ck_visual_restore.sh"
scripts["visual:accept"] = "./ck_visual_accept_new_baseline.sh"
scripts["visual:unlock"] = "./ck_visual_unlock.sh"
p.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY

echo
echo "Visual lock installed."
echo "Run verify:"
echo "  ./ck_visual_verify.sh"
