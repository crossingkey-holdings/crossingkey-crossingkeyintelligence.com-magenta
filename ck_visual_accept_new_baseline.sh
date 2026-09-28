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
