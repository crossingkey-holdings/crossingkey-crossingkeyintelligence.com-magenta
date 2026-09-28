#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/clean_founder_banner_copy_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

cp -a src/ck-founder-hard-banner.js "$BACKUP_DIR/ck-founder-hard-banner.js" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true

if [ ! -f src/ck-founder-hard-banner.js ]; then
  echo "Missing src/ck-founder-hard-banner.js"
  echo "Run the founder banner installer first."
  exit 1
fi

python3 - <<'PY'
from pathlib import Path
import re

path = Path("src/ck-founder-hard-banner.js")
text = path.read_text(encoding="utf-8")

replacements = {
    "Founder Signal": "The Navigator",
    "Weekly intelligence from the operator seat.": "A weekly field note for builders, operators, and AI-era founders.",
    "Subscribe free for the CrossingKey weekly signal: AI systems, operator engineering, commercial infrastructure, documentation discipline, and founder-grade execution notes.": "Subscribe free to The Navigator: a weekly CrossingKey dispatch on AI systems, operator engineering, commercial infrastructure, documentation discipline, and founder-grade execution.",
    "Enter your email for the free weekly signal": "Enter your email for The Navigator",
    "Subscribe Free": "Subscribe Free",
    "After the free issue lands, readers can upgrade into the paid educational newsletter for deeper lessons, build systems, and implementation frameworks.": "Start with the free weekly dispatch. Upgrade later for deeper educational lessons, build systems, operator frameworks, and implementation guides.",
    "Paid Education Path": "Upgrade to Paid",
    "Navigator Quote": "Navigator Signal",
    "240s cycle · 120s pulse": "",
    "Captured locally. Connect the newsletter endpoint next for automatic weekly delivery.": "You’re on the list. Connect the newsletter endpoint next for automatic weekly delivery."
}

for old, new in replacements.items():
    text = text.replace(old, new)

# Clean the footer span completely so no timing label remains if spacing survives.
text = re.sub(
    r"<span>\s*</span>",
    "",
    text
)

# If the old timing text exists with whitespace or punctuation variants, remove it.
text = re.sub(
    r"\s*240s\s*cycle\s*[·•-]\s*120s\s*pulse\s*",
    "",
    text,
    flags=re.I
)

path.write_text(text, encoding="utf-8")
PY

STYLE_FILE=""
if [ -f "src/styles.css" ]; then
  STYLE_FILE="src/styles.css"
elif [ -f "src/style.css" ]; then
  STYLE_FILE="src/style.css"
else
  STYLE_FILE="src/styles.css"
  touch "$STYLE_FILE"
fi

python3 - "$STYLE_FILE" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

text = re.sub(
    r"/\* CK CLEAN FOUNDER COPY START \*/.*?/\* CK CLEAN FOUNDER COPY END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK CLEAN FOUNDER COPY START */
.ck-founder-hard-main h2 {
  max-width: 860px !important;
  font-size: clamp(36px, 4.2vw, 62px) !important;
  line-height: 0.98 !important;
}

.ck-founder-hard-main p {
  max-width: 820px !important;
}

.ck-founder-hard-count {
  justify-content: flex-start !important;
}

.ck-founder-hard-count span:empty {
  display: none !important;
}

.ck-founder-hard-quote blockquote {
  font-size: clamp(24px, 2vw, 30px) !important;
}
/* CK CLEAN FOUNDER COPY END */
"""

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo
echo "Founder banner copy cleaned."
echo "Newsletter renamed to: The Navigator"
echo "Quote timing text removed."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
