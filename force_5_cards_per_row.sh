#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/force_5_cards_per_row_$STAMP"

mkdir -p "$BACKUP_DIR"

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

STYLE_FILE=""
if [ -f "src/styles.css" ]; then
  STYLE_FILE="src/styles.css"
elif [ -f "src/style.css" ]; then
  STYLE_FILE="src/style.css"
else
  echo "Could not find src/styles.css or src/style.css"
  exit 1
fi

cp -a "$STYLE_FILE" "$BACKUP_DIR/$(basename "$STYLE_FILE")"

python3 - "$STYLE_FILE" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

# Remove older CrossingKey grid overrides if present.
text = re.sub(
    r"/\* CK 5 CARD ROW LOCK START \*/.*?/\* CK 5 CARD ROW LOCK END \*/",
    "",
    text,
    flags=re.S
)

block = """
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

/* Keep cards balanced in the 5-column system */
.ck-card,
.category-card,
.product-card,
.feature-card,
.system-card {
  width: 100% !important;
  min-width: 0 !important;
}

/* Medium screens: 3 per row */
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

/* Tablet: 2 per row */
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

/* Phone: 1 per row */
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

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo
echo "Done. Category cards are now locked to 5 per row on desktop."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
