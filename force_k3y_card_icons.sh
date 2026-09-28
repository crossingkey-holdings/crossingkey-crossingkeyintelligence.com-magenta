#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
VERSION="k3y-card-icons-$STAMP"
BACKUP_DIR=".ck_backups/force_k3y_card_icons_$STAMP"

SOURCE="$HOME/Downloads/k3y.png"
TARGET="public/assets/k3y.png"

mkdir -p "$BACKUP_DIR" public/assets src .ck_backups

if [ ! -f "$SOURCE" ]; then
  echo "Missing source image:"
  echo "  $SOURCE"
  echo
  echo "Download k3y.png first, then rerun this script."
  exit 1
fi

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

find src public/assets -type f -exec chmod u+w {} \; 2>/dev/null || true

cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true
cp -a src/ck-card-key-icons.js "$BACKUP_DIR/ck-card-key-icons.js" 2>/dev/null || true
cp -a "$TARGET" "$BACKUP_DIR/k3y.png" 2>/dev/null || true

cp -a "$SOURCE" "$TARGET"

cat > src/ck-card-key-icons.js <<JS
const CK_KEY_ICON_SRC = "/assets/k3y.png?v=$VERSION";

function createK3yImage() {
  const img = document.createElement("img");
  img.src = CK_KEY_ICON_SRC;
  img.alt = "";
  img.className = "ck-k3y-card-icon-image";
  img.setAttribute("aria-hidden", "true");
  img.dataset.ckK3yIcon = "1";
  return img;
}

function isCard(card) {
  if (!card || card.nodeType !== 1) return false;

  const rect = card.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (card.closest("header, nav, footer, form, .ck-search")) return false;

  const text = (card.textContent || "").replace(/\\s+/g, " ").trim();
  return text.length >= 20;
}

function getIconSlot(card) {
  let slot =
    card.querySelector(".ck-card-icon") ||
    card.querySelector(".card-icon") ||
    card.querySelector(".ck-exact-key-holder") ||
    card.querySelector(".ck-real-key-holder") ||
    card.querySelector(".ck-final-key-holder") ||
    card.querySelector(".ck-glowing-key-holder") ||
    card.querySelector(".ck-card-key-holder") ||
    card.querySelector("[class*='icon']");

  if (!slot) {
    slot = document.createElement("span");
    slot.className = "ck-card-icon ck-k3y-card-icon-holder";

    const heading = card.querySelector("h1,h2,h3,h4");
    if (heading) card.insertBefore(slot, heading);
    else card.insertBefore(slot, card.firstChild);
  }

  return slot;
}

function applyK3yIcons() {
  const cards = document.querySelectorAll(
    ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
  );

  cards.forEach((card) => {
    if (!isCard(card)) return;

    const slot = getIconSlot(card);
    slot.classList.add("ck-card-icon", "ck-k3y-card-icon-holder");

    const existing = slot.querySelector("img[data-ck-k3y-icon='1']");
    if (existing && existing.src.includes("$VERSION")) return;

    slot.innerHTML = "";
    slot.appendChild(createK3yImage());
  });
}

function boot() {
  applyK3yIcons();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(applyK3yIcons);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", boot, { once: true });
} else {
  boot();
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

patterns = [
    r"/\* CK K3Y CARD ICON START \*/.*?/\* CK K3Y CARD ICON END \*/",
    r"/\* CK IMPOSED EXACT KEY IMAGE START \*/.*?/\* CK IMPOSED EXACT KEY IMAGE END \*/",
    r"/\* CK EXACT PNG KEY ICON START \*/.*?/\* CK EXACT PNG KEY ICON END \*/",
    r"/\* CK REAL NEON KEYS START \*/.*?/\* CK REAL NEON KEYS END \*/",
    r"/\* CK FINAL PRECISION NEON KEYS START \*/.*?/\* CK FINAL PRECISION NEON KEYS END \*/",
    r"/\* CK FINISHED NEON KEYS START \*/.*?/\* CK FINISHED NEON KEYS END \*/",
    r"/\* CK GLOWING KEYS MANIFEST START \*/.*?/\* CK GLOWING KEYS MANIFEST END \*/",
    r"/\* CrossingKey repaired crossed-keys card icon rendering \*/.*?(?=\n/\*|\Z)",
    r"/\* CrossingKey card icon lock \*/.*?(?=\n/\*|\Z)"
]

for pattern in patterns:
    text = re.sub(pattern, "", text, flags=re.S)

block = """
/* CK K3Y CARD ICON START */
.ck-card-icon,
.ck-k3y-card-icon-holder,
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
  overflow: hidden !important;
  border: 1px solid rgba(255, 42, 163, 0.78) !important;
  border-radius: 16px !important;
  background: transparent !important;
  box-shadow:
    0 0 8px rgba(255, 42, 163, 0.88),
    0 0 26px rgba(255, 42, 163, 0.42),
    inset 0 0 18px rgba(255, 42, 163, 0.13) !important;
}

.ck-k3y-card-icon-image,
.ck-card-icon img.ck-k3y-card-icon-image {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  min-height: 58px !important;
  display: block !important;
  object-fit: cover !important;
  object-position: center !important;
  image-rendering: auto !important;
  pointer-events: none !important;
  user-select: none !important;
}
/* CK K3Y CARD ICON END */
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
echo "k3y.png is now forced into every card icon spot."
echo "Project asset:"
echo "  $TARGET"
echo "Backup:"
echo "  $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
