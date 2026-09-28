#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$PWD"
STAMP="$(date +%Y%m%d_%H%M%S)"
VERSION="exact-imposed-keys-$STAMP"
BACKUP_DIR=".ck_backups/impose_exact_card_keys_$STAMP"

mkdir -p "$BACKUP_DIR" src public/assets .ck_backups

SOURCE_IMAGE=""

if [ -f "$HOME/Downloads/exact-card-keys.png" ]; then
  SOURCE_IMAGE="$HOME/Downloads/exact-card-keys.png"
elif [ -f "$HOME/Downloads/exact-card-keys (1).png" ]; then
  SOURCE_IMAGE="$HOME/Downloads/exact-card-keys (1).png"
else
  SOURCE_IMAGE="$(find "$HOME/Downloads" -maxdepth 1 -type f \( -iname '*exact*card*keys*.png' -o -iname '*card*keys*.png' -o -iname '*keys*.png' \) | head -1 || true)"
fi

if [ -z "$SOURCE_IMAGE" ] || [ ! -f "$SOURCE_IMAGE" ]; then
  echo "Could not find the keys image in ~/Downloads."
  echo
  echo "Download it as:"
  echo "  exact-card-keys.png"
  echo
  echo "Then run:"
  echo "  ./impose_exact_card_keys_image.sh"
  exit 1
fi

echo "Using image:"
echo "  $SOURCE_IMAGE"

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

find src public/assets -type f -exec chmod u+w {} \; 2>/dev/null || true

cp -a "$SOURCE_IMAGE" public/assets/exact-card-keys.png

cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true
cp -a src/ck-card-key-icons.js "$BACKUP_DIR/ck-card-key-icons.js" 2>/dev/null || true

cat > src/ck-card-key-icons.js <<JS
const CK_EXACT_KEY_SRC = "/assets/exact-card-keys.png?v=$VERSION";

function makeExactKeyImage() {
  const img = document.createElement("img");
  img.src = CK_EXACT_KEY_SRC;
  img.alt = "";
  img.className = "ck-imposed-key-image";
  img.setAttribute("aria-hidden", "true");
  img.dataset.ckImposedKey = "1";
  return img;
}

function isRealCard(card) {
  if (!card || card.nodeType !== 1) return false;

  const rect = card.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (card.closest("header, nav, footer, form, .ck-search")) return false;

  const text = (card.textContent || "").replace(/\\s+/g, " ").trim();
  return text.length >= 20;
}

function getIconSpot(card) {
  let spot =
    card.querySelector(".ck-card-icon") ||
    card.querySelector(".card-icon") ||
    card.querySelector(".ck-exact-key-holder") ||
    card.querySelector(".ck-real-key-holder") ||
    card.querySelector(".ck-final-key-holder") ||
    card.querySelector(".ck-glowing-key-holder") ||
    card.querySelector(".ck-card-key-holder") ||
    card.querySelector("[class*='icon']");

  if (!spot) {
    spot = document.createElement("span");
    spot.className = "ck-card-icon ck-exact-key-holder";

    const heading = card.querySelector("h1,h2,h3,h4");
    if (heading) card.insertBefore(spot, heading);
    else card.insertBefore(spot, card.firstChild);
  }

  return spot;
}

function imposeExactKeys() {
  const cards = document.querySelectorAll(
    ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
  );

  cards.forEach((card) => {
    if (!isRealCard(card)) return;

    const spot = getIconSpot(card);
    spot.classList.add("ck-card-icon", "ck-exact-key-holder");

    const existing = spot.querySelector("img[data-ck-imposed-key='1']");
    if (existing && existing.src.includes("$VERSION")) return;

    spot.innerHTML = "";
    spot.appendChild(makeExactKeyImage());
  });
}

function bootExactKeys() {
  imposeExactKeys();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(imposeExactKeys);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootExactKeys, { once: true });
} else {
  bootExactKeys();
}
JS

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

for pattern in [
    r"/\* CK IMPOSED EXACT KEY IMAGE START \*/.*?/\* CK IMPOSED EXACT KEY IMAGE END \*/",
    r"/\* CK EXACT PNG KEY ICON START \*/.*?/\* CK EXACT PNG KEY ICON END \*/",
    r"/\* CK REAL NEON KEYS START \*/.*?/\* CK REAL NEON KEYS END \*/",
    r"/\* CK FINAL PRECISION NEON KEYS START \*/.*?/\* CK FINAL PRECISION NEON KEYS END \*/",
    r"/\* CK FINISHED NEON KEYS START \*/.*?/\* CK FINISHED NEON KEYS END \*/",
    r"/\* CK GLOWING KEYS MANIFEST START \*/.*?/\* CK GLOWING KEYS MANIFEST END \*/",
    r"/\* CrossingKey repaired crossed-keys card icon rendering \*/.*?(?=\n/\*|\Z)",
    r"/\* CrossingKey card icon lock \*/.*?(?=\n/\*|\Z)"
]:
    text = re.sub(pattern, "", text, flags=re.S)

block = """
/* CK IMPOSED EXACT KEY IMAGE START */
.ck-card-icon,
.ck-exact-key-holder,
.ck-real-key-holder,
.ck-final-key-holder,
.ck-glowing-key-holder,
.ck-card-key-holder {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  min-height: 58px !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  padding: 0 !important;
  overflow: visible !important;
  border: 1px solid rgba(255, 42, 163, 0.78) !important;
  border-radius: 16px !important;
  background:
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.18), rgba(255, 42, 163, 0.06) 56%, rgba(8, 0, 7, 0.72) 100%) !important;
  box-shadow:
    0 0 8px rgba(255, 42, 163, 0.88),
    0 0 26px rgba(255, 42, 163, 0.42),
    inset 0 0 18px rgba(255, 42, 163, 0.13) !important;
}

.ck-imposed-key-image,
.ck-card-icon img.ck-imposed-key-image {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  min-height: 58px !important;
  display: block !important;
  object-fit: contain !important;
  object-position: center !important;
  image-rendering: auto !important;
  overflow: visible !important;
  pointer-events: none !important;
  user-select: none !important;
}
/* CK IMPOSED EXACT KEY IMAGE END */
"""

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

MAIN_FILE=""
for f in src/main.js src/main.jsx src/main.ts src/main.tsx; do
  if [ -f "$f" ]; then
    MAIN_FILE="$f"
    break
  fi
done

if [ -z "$MAIN_FILE" ]; then
  echo "Could not find Vite main entry file."
  exit 1
fi

python3 - "$MAIN_FILE" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
line = 'import "./ck-card-key-icons.js";'

text = "\n".join(row for row in text.splitlines() if row.strip() != line)
text = line + "\n" + text.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo
echo "Exact keys image imposed into every card icon spot."
echo "Project icon:"
echo "  public/assets/exact-card-keys.png"
echo "Backup:"
echo "  $BACKUP_DIR"
echo
