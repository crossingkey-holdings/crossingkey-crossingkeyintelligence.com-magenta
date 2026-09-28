#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/rollback_founder_newsletter_keep_5_cards_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

echo "Backing up current files..."
cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true
cp -a src/ck-founder-hard-banner.js "$BACKUP_DIR/ck-founder-hard-banner.js" 2>/dev/null || true
cp -a src/ck-founder-status-banner.js "$BACKUP_DIR/ck-founder-status-banner.js" 2>/dev/null || true
cp -a src/ck-founder-newsletter.js "$BACKUP_DIR/ck-founder-newsletter.js" 2>/dev/null || true

echo "Removing founder/newsletter/quote imports..."
for MAIN_FILE in src/main.js src/main.jsx src/main.ts src/main.tsx; do
  [ -f "$MAIN_FILE" ] || continue

  python3 - "$MAIN_FILE" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

remove_lines = {
    'import "./ck-founder-hard-banner.js";',
    'import "./ck-founder-status-banner.js";',
    'import "./ck-founder-newsletter.js";'
}

rows = [row for row in text.splitlines() if row.strip() not in remove_lines]
path.write_text("\n".join(rows).strip() + "\n", encoding="utf-8")
PY
done

echo "Disabling founder/newsletter/quote scripts..."
mkdir -p src/_disabled_founder_banner_$STAMP

for file in \
  src/ck-founder-hard-banner.js \
  src/ck-founder-status-banner.js \
  src/ck-founder-newsletter.js
do
  if [ -f "$file" ]; then
    mv "$file" "src/_disabled_founder_banner_$STAMP/$(basename "$file")"
  fi
done

STYLE_FILE=""
if [ -f "src/styles.css" ]; then
  STYLE_FILE="src/styles.css"
elif [ -f "src/style.css" ]; then
  STYLE_FILE="src/style.css"
else
  echo "Could not find src/styles.css or src/style.css"
  exit 1
fi

echo "Cleaning founder/newsletter CSS while preserving 5-card grid..."
python3 - "$STYLE_FILE" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

remove_blocks = [
    r"/\* CK HARD MOUNT FOUNDER BANNER START \*/.*?/\* CK HARD MOUNT FOUNDER BANNER END \*/",
    r"/\* CK FOUNDER STATUS REPLACEMENT START \*/.*?/\* CK FOUNDER STATUS REPLACEMENT END \*/",
    r"/\* CK FOUNDER NEWSLETTER BANNER START \*/.*?/\* CK FOUNDER NEWSLETTER BANNER END \*/",
    r"/\* CK CLEAN FOUNDER COPY START \*/.*?/\* CK CLEAN FOUNDER COPY END \*/",
]

for block in remove_blocks:
    text = re.sub(block, "", text, flags=re.S)

# Ensure anything hidden by the old banner script becomes visible again.
restore_block = """
/* CK RESTORE SYSTEM STATUS START */
[data-ck-hidden-system-status="1"] {
  display: revert !important;
}
/* CK RESTORE SYSTEM STATUS END */
"""

text = re.sub(
    r"/\* CK RESTORE SYSTEM STATUS START \*/.*?/\* CK RESTORE SYSTEM STATUS END \*/",
    "",
    text,
    flags=re.S
)

# Ensure 5-card row lock exists and is last enough to win.
five_card_block = """
/* CK 5 CARD ROW LOCK START */
/* Desktop: 15 categories = 5 cards x 3 rows */
.ck-grid,
.categories-grid,
.category-grid,
.product-grid,
.cards-grid,
[class*="category-grid"],
[class*="cards-grid"] {
  display: grid !important;
  grid-template-columns: repeat(5, minmax(0, 1fr)) !important;
  gap: 18px !important;
}

.ck-card,
.category-card,
.product-card,
.feature-card,
.system-card {
  width: 100% !important;
  min-width: 0 !important;
}

@media (max-width: 1200px) {
  .ck-grid,
  .categories-grid,
  .category-grid,
  .product-grid,
  .cards-grid,
  [class*="category-grid"],
  [class*="cards-grid"] {
    grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
  }
}

@media (max-width: 850px) {
  .ck-grid,
  .categories-grid,
  .category-grid,
  .product-grid,
  .cards-grid,
  [class*="category-grid"],
  [class*="cards-grid"] {
    grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
  }
}

@media (max-width: 560px) {
  .ck-grid,
  .categories-grid,
  .category-grid,
  .product-grid,
  .cards-grid,
  [class*="category-grid"],
  [class*="cards-grid"] {
    grid-template-columns: 1fr !important;
  }
}
/* CK 5 CARD ROW LOCK END */
"""

text = re.sub(
    r"/\* CK 5 CARD ROW LOCK START \*/.*?/\* CK 5 CARD ROW LOCK END \*/",
    "",
    text,
    flags=re.S
)

text = text.rstrip() + "\n\n" + restore_block.strip() + "\n\n" + five_card_block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo "Adding small runtime cleanup in case the banner was cached..."
cat > src/ck-rollback-cleanup.js <<'JS'
function cleanupFounderBannerRollback() {
  document.querySelectorAll(
    "#founder-signal, .ck-founder-hard-banner, .ck-founder-status-replacement, .ck-founder-banner"
  ).forEach((node) => node.remove());

  document.querySelectorAll("[data-ck-hidden-system-status='1']").forEach((node) => {
    node.style.display = "";
    node.removeAttribute("data-ck-hidden-system-status");
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", cleanupFounderBannerRollback, { once: true });
} else {
  cleanupFounderBannerRollback();
}
JS

for MAIN_FILE in src/main.js src/main.jsx src/main.ts src/main.tsx; do
  [ -f "$MAIN_FILE" ] || continue

  python3 - "$MAIN_FILE" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
line = 'import "./ck-rollback-cleanup.js";'

text = "\n".join(row for row in text.splitlines() if row.strip() != line)
text = line + "\n" + text.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

  break
done

echo
echo "Rollback complete."
echo "Removed Founder/Navigator newsletter + quote banner."
echo "Kept 15 cards locked to 5 per row."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
