#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/crossingkey_hero_join_cta_$STAMP"

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

files = [
    Path("index.html"),
    Path("src/main.js"),
    Path("src/main.jsx"),
    Path("src/main.ts"),
    Path("src/main.tsx"),
]

for path in files:
    if not path.exists():
        continue

    text = path.read_text(encoding="utf-8", errors="ignore")

    # Force only the main hero h1 title to CrossingKey.
    text = re.sub(
        r'<h1([^>]*)class=(["\'][^"\']*ck-title[^"\']*["\'])([^>]*)>.*?</h1>',
        r'<h1\1class=\2\3>CrossingKey</h1>',
        text,
        count=1,
        flags=re.S | re.I
    )

    # Fallback replacements for common title variants.
    text = text.replace(
        "CrossingKey <span>Intelligence is the standard.</span>",
        "CrossingKey"
    )
    text = text.replace(
        "CrossingKey <span>Intelligence</span>",
        "CrossingKey"
    )
    text = text.replace(
        "CrossingKey <span>Systems</span>",
        "CrossingKey"
    )

    # Shopify CTA wording.
    text = text.replace("Open Shopify Store", "Join CrossingKey")
    text = text.replace("Open Store", "Join CrossingKey")

    # Storefront section heading and copy cleaned up.
    text = text.replace(
        "Checkout lives on Shopify.",
        "Join CrossingKey."
    )

    text = text.replace(
        "Current products, pricing, availability, order confirmation, checkout, and delivery details are handled through the official CrossingKey Intelligence Shopify storefront.",
        "Enter the official CrossingKey storefront for products, pricing, availability, checkout, order confirmation, and digital delivery."
    )

    text = text.replace(
        "Current products, pricing, availability, order confirmation, checkout, and delivery details are handled through the official CrossingKey Shopify storefront.",
        "Enter the official CrossingKey storefront for products, pricing, availability, checkout, order confirmation, and digital delivery."
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
    r"/\* CK CROSSINGKEY HERO ONLY START \*/.*?/\* CK CROSSINGKEY HERO ONLY END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK CROSSINGKEY HERO ONLY START */
.ck-title {
  max-width: 820px !important;
  font-size: clamp(84px, 9.5vw, 146px) !important;
  line-height: 0.82 !important;
  letter-spacing: -0.075em !important;
}

.ck-title span {
  display: none !important;
}

@media (max-width: 760px) {
  .ck-title {
    font-size: clamp(62px, 17vw, 92px) !important;
    line-height: 0.88 !important;
  }
}
/* CK CROSSINGKEY HERO ONLY END */
"""

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo
echo "Applied:"
echo "  Hero: CrossingKey"
echo "  Shopify CTA: Join CrossingKey"
echo "  Storefront heading: Join CrossingKey."
echo
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
