#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/hero_body_copy_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

cp -a index.html "$BACKUP_DIR/index.html" 2>/dev/null || true
cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true

python3 - <<'PY'
from pathlib import Path
import re

NEW_COPY = "Intelligence systems built to inspect, govern, automate, and deliver."

targets = [
    Path("index.html"),
    Path("src/main.js"),
    Path("src/main.jsx"),
    Path("src/main.ts"),
    Path("src/main.tsx"),
]

old_phrases = [
    "Operator systems, AI infrastructure, automation products, and digital tools built for controlled execution.",
    "AI-powered intelligence, operator systems, automation products, and advanced analytics that turn complex signals into decisive action.",
    "AI-powered intelligence, operator systems, automation products, and advanced analytics that turn complex signals into decisive action",
    "Operator systems, AI infrastructure, automation products, and digital tools built for controlled execution",
]

for path in targets:
    if not path.exists():
        continue

    text = path.read_text(encoding="utf-8", errors="ignore")

    for old in old_phrases:
        text = text.replace(old, NEW_COPY)

    # Fallback: target common subtitle element if old text was already changed.
    text = re.sub(
        r'(<p[^>]*class=["\'][^"\']*(?:ck-subtitle|hero-subtitle)[^"\']*["\'][^>]*>)(.*?)(</p>)',
        lambda m: m.group(1) + NEW_COPY + m.group(3),
        text,
        count=1,
        flags=re.S | re.I
    )

    path.write_text(text, encoding="utf-8")
PY

echo
echo "Applied hero body copy:"
echo "  Intelligence systems built to inspect, govern, automate, and deliver."
echo
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
