#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
VERSION="ck-final-keys-$STAMP"
BACKUP_DIR=".ck_backups/emergency_finish_keys_$STAMP"

mkdir -p "$BACKUP_DIR" public/assets src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  echo "Unlocking visual lock for approved icon repair..."
  ./ck_visual_unlock.sh || true
fi

cp -a public/assets/crossingkey-keys.svg "$BACKUP_DIR/crossingkey-keys.svg" 2>/dev/null || true
cp -a src/ck-card-key-icons.js "$BACKUP_DIR/ck-card-key-icons.js" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true

cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" role="img" aria-label="CrossingKey crossed neon keys">
  <defs>
    <filter id="ckGlow" x="-90%" y="-90%" width="280%" height="280%">
      <feGaussianBlur stdDeviation="4.2" result="blur"/>
      <feColorMatrix in="blur" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 .04
                0 0 0 0 .55
                0 0 0 .95 0" result="pink"/>
      <feMerge>
        <feMergeNode in="pink"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <linearGradient id="tube" x1="12" y1="12" x2="88" y2="88">
      <stop offset="0%" stop-color="#fff4fd"/>
      <stop offset="28%" stop-color="#ff9bdf"/>
      <stop offset="62%" stop-color="#ff2aa3"/>
      <stop offset="100%" stop-color="#ff006e"/>
    </linearGradient>
  </defs>

  <!-- Glow layer -->
  <g filter="url(#ckGlow)" fill="none" stroke="#ff1493" stroke-width="7.2" stroke-linecap="round" stroke-linejoin="round" opacity=".62">
    <g transform="rotate(-45 50 50)">
      <circle cx="22" cy="50" r="11"/>
      <path d="M33 50 H77"/>
      <path d="M77 50 V61 H87"/>
      <path d="M70 50 V41"/>
    </g>

    <g transform="rotate(45 50 50)">
      <circle cx="22" cy="50" r="11"/>
      <path d="M33 50 H77"/>
      <path d="M77 50 V61 H87"/>
      <path d="M70 50 V41"/>
    </g>
  </g>

  <!-- Main neon outline -->
  <g fill="none" stroke="url(#tube)" stroke-width="4.3" stroke-linecap="round" stroke-linejoin="round">
    <g transform="rotate(-45 50 50)">
      <circle cx="22" cy="50" r="11"/>
      <circle cx="22" cy="50" r="4.4"/>
      <path d="M33 50 H77"/>
      <path d="M77 50 V61 H87"/>
      <path d="M70 50 V41"/>
    </g>

    <g transform="rotate(45 50 50)">
      <circle cx="22" cy="50" r="11"/>
      <circle cx="22" cy="50" r="4.4"/>
      <path d="M33 50 H77"/>
      <path d="M77 50 V61 H87"/>
      <path d="M70 50 V41"/>
    </g>
  </g>

  <!-- Hot white neon centerline -->
  <g fill="none" stroke="#fff8fd" stroke-width="1.25" stroke-linecap="round" stroke-linejoin="round" opacity=".92">
    <g transform="rotate(-45 50 50)">
      <circle cx="22" cy="50" r="11"/>
      <path d="M33 50 H77"/>
      <path d="M77 50 V61 H87"/>
      <path d="M70 50 V41"/>
    </g>

    <g transform="rotate(45 50 50)">
      <circle cx="22" cy="50" r="11"/>
      <path d="M33 50 H77"/>
      <path d="M77 50 V61 H87"/>
      <path d="M70 50 V41"/>
    </g>
  </g>
</svg>
SVG

cat > src/ck-card-key-icons.js <<JS
const CK_ICON_SRC = "/assets/crossingkey-keys.svg?v=$VERSION";

function createCrossingKeyIcon() {
  const img = document.createElement("img");
  img.src = CK_ICON_SRC;
  img.alt = "";
  img.className = "ck-final-key-image";
  img.setAttribute("aria-hidden", "true");
  img.dataset.ckFinalKey = "1";
  return img;
}

function isValidCard(card) {
  if (!card || card.nodeType !== 1) return false;

  const rect = card.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (card.closest("header, nav, footer, form, .ck-search")) return false;

  const text = (card.textContent || "").replace(/\\s+/g, " ").trim();
  if (text.length < 20) return false;

  return true;
}

function getIconSlot(card) {
  let slot =
    card.querySelector(".ck-card-icon") ||
    card.querySelector(".ck-final-key-holder") ||
    card.querySelector(".ck-glowing-key-holder") ||
    card.querySelector(".ck-card-key-holder") ||
    card.querySelector(".card-icon") ||
    card.querySelector("[class*='icon']");

  if (!slot) {
    slot = document.createElement("span");
    slot.className = "ck-card-icon ck-final-key-holder";

    const heading = card.querySelector("h1,h2,h3,h4");
    if (heading) {
      card.insertBefore(slot, heading);
    } else {
      card.insertBefore(slot, card.firstChild);
    }
  }

  return slot;
}

function applyCrossingKeyIcons() {
  const cards = document.querySelectorAll(
    ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
  );

  cards.forEach((card) => {
    if (!isValidCard(card)) return;

    const slot = getIconSlot(card);
    slot.classList.add("ck-card-icon", "ck-final-key-holder");

    const existing = slot.querySelector("img[data-ck-final-key='1']");
    if (existing && existing.src.includes("$VERSION")) return;

    slot.innerHTML = "";
    slot.appendChild(createCrossingKeyIcon());
  });
}

function boot() {
  applyCrossingKeyIcons();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(applyCrossingKeyIcons);
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

remove_patterns = [
    r"/\* CK GLOWING KEYS MANIFEST START \*/.*?/\* CK GLOWING KEYS MANIFEST END \*/",
    r"/\* CK FINISHED NEON KEYS START \*/.*?/\* CK FINISHED NEON KEYS END \*/",
    r"/\* CK FINAL PRECISION NEON KEYS START \*/.*?/\* CK FINAL PRECISION NEON KEYS END \*/",
    r"/\* CrossingKey repaired crossed-keys card icon rendering \*/.*?(?=\n/\*|\Z)",
    r"/\* CrossingKey card icon lock \*/.*?(?=\n/\*|\Z)"
]

for pattern in remove_patterns:
    text = re.sub(pattern, "", text, flags=re.S)

block = """
/* CK FINAL PRECISION NEON KEYS START */
.ck-card-icon,
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
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.20), rgba(255, 42, 163, 0.07) 54%, rgba(8, 0, 7, 0.72) 100%) !important;
  box-shadow:
    0 0 8px rgba(255, 42, 163, 0.84),
    0 0 24px rgba(255, 42, 163, 0.36),
    inset 0 0 18px rgba(255, 42, 163, 0.12) !important;
}

.ck-final-key-image,
.ck-card-icon img.ck-final-key-image {
  width: 56px !important;
  height: 56px !important;
  min-width: 56px !important;
  min-height: 56px !important;
  display: block !important;
  object-fit: contain !important;
  overflow: visible !important;
  pointer-events: none !important;
  user-select: none !important;
  filter:
    drop-shadow(0 0 4px rgba(255, 255, 255, 0.35))
    drop-shadow(0 0 7px rgba(255, 42, 163, 0.96))
    drop-shadow(0 0 16px rgba(255, 42, 163, 0.64)) !important;
}
/* CK FINAL PRECISION NEON KEYS END */
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
echo "Emergency final key repair complete."
echo "Backup saved to: $BACKUP_DIR"
echo "Cache version: $VERSION"
echo
echo "Restart Vite now:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
