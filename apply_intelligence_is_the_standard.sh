#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/intelligence_is_the_standard_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

cp -a index.html "$BACKUP_DIR/index.html" 2>/dev/null || true
cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true

python3 - <<'PY'
from pathlib import Path
import re

targets = [
    Path("index.html"),
    Path("src/main.js"),
    Path("src/main.jsx"),
    Path("src/main.ts"),
    Path("src/main.tsx"),
]

for path in targets:
    if not path.exists():
        continue

    text = path.read_text(encoding="utf-8", errors="ignore")

    # Replace common hero headline variants only.
    text = text.replace(
        "CrossingKey <span>Intelligence</span>",
        "CrossingKey <span>Intelligence is the standard.</span>"
    )

    text = text.replace(
        "CrossingKey <span>Systems</span>",
        "CrossingKey <span>Intelligence is the standard.</span>"
    )

    text = text.replace(
        "CrossingKey\nSystems",
        "CrossingKey\nIntelligence is the standard."
    )

    text = text.replace(
        "CrossingKey\nIntelligence",
        "CrossingKey\nIntelligence is the standard."
    )

    # If the hero is built with separate tags, normalize the visible title area.
    text = re.sub(
        r"<h1([^>]*)class=(['\"][^'\"]*ck-title[^'\"]*['\"])([^>]*)>.*?</h1>",
        r"<h1\1class=\2\3>CrossingKey <span>Intelligence is the standard.</span></h1>",
        text,
        count=1,
        flags=re.S | re.I
    )

    # Clean subtitle to match the new doctrine.
    text = text.replace(
        "AI-powered intelligence, operator systems, automation products, and advanced analytics that turn complex signals into decisive action.",
        "Operator systems, AI infrastructure, automation products, and digital tools built for controlled execution."
    )

    text = text.replace(
        "Operator systems, AI infrastructure, automation products, and digital tools built for controlled execution.",
        "Operator systems, AI infrastructure, automation products, and digital tools built for controlled execution."
    )

    # Page title can stay formal but public-facing tab can be cleaner.
    text = text.replace(
        "CrossingKey Systems | Operator Systems, AI Products, and Digital Infrastructure",
        "CrossingKey | Intelligence is the standard"
    )

    text = text.replace(
        "CrossingKey Intelligence | Operator Systems, AI Products, and Digital Infrastructure",
        "CrossingKey | Intelligence is the standard"
    )

    path.write_text(text, encoding="utf-8")
PY

STYLE_FILE=""
if [ -f "src/styles.css" ]; then
  STYLE_FILE="src/styles.css"
elif [ -f "src/style.css" ]; then
  STYLE_FILE="src/style.css"
else
  echo "Could not find src/styles.css or src/style.css"
  exit 1
fi

python3 - "$STYLE_FILE" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8", errors="ignore")

text = re.sub(
    r"/\* CK INTELLIGENCE STANDARD HERO START \*/.*?/\* CK INTELLIGENCE STANDARD HERO END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK INTELLIGENCE STANDARD HERO START */
.ck-title {
  max-width: 820px !important;
}

.ck-title span {
  display: block !important;
  max-width: 920px !important;
  font-size: clamp(54px, 6.9vw, 108px) !important;
  line-height: 0.88 !important;
  letter-spacing: -0.07em !important;
}

@media (max-width: 760px) {
  .ck-title span {
    font-size: clamp(42px, 13vw, 64px) !important;
    line-height: 0.92 !important;
  }
}
/* CK INTELLIGENCE STANDARD HERO END */
"""

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo
echo "Applied hero doctrine:"
echo "  CrossingKey"
echo "  Intelligence is the standard."
echo
echo "Formal top-left logo remains CrossingKey Intelligence."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
