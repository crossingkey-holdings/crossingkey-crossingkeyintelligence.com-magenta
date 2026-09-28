#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/remove_ai_search_status_$STAMP"

mkdir -p "$BACKUP_DIR"

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

cp -a src/ck-ai-search.js "$BACKUP_DIR/ck-ai-search.js" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true

if [ -f src/ck-ai-search.js ]; then
python3 - <<'PY'
from pathlib import Path
import re

p = Path("src/ck-ai-search.js")
s = p.read_text(encoding="utf-8")

# Disable the visible status text function without breaking search.
s = re.sub(
    r"function\s+setSearchStatus\s*\([^)]*\)\s*\{.*?\n\}",
    "function setSearchStatus(text) {\n  return;\n}",
    s,
    flags=re.S
)

# Remove any already-created visible status node on load.
s += """

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-ck-ai-search-status], .ck-ai-search-status").forEach((node) => node.remove());
});
"""

p.write_text(s, encoding="utf-8")
PY
fi

STYLE_FILE=""
if [ -f src/styles.css ]; then
  STYLE_FILE="src/styles.css"
elif [ -f src/style.css ]; then
  STYLE_FILE="src/style.css"
fi

if [ -n "$STYLE_FILE" ]; then
cat >> "$STYLE_FILE" <<'CSS'

/* CK hide AI search status text */
.ck-ai-search-status,
[data-ck-ai-search-status] {
  display: none !important;
}
CSS
fi

echo "Removed visible AI-search status words."
echo "Backup saved to: $BACKUP_DIR"
