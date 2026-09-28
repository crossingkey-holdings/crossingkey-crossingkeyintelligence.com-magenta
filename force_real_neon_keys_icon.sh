#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
VERSION="real-neon-keys-$STAMP"
BACKUP_DIR=".ck_backups/real_neon_keys_$STAMP"

mkdir -p "$BACKUP_DIR" public/assets src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  echo "Unlocking visual lock for approved key-icon correction..."
  ./ck_visual_unlock.sh || true
fi

find public/assets src -type f -exec chmod u+w {} \; 2>/dev/null || true

cp -a public/assets/crossingkey-keys.svg "$BACKUP_DIR/crossingkey-keys.svg" 2>/dev/null || true
cp -a src/ck-card-key-icons.js "$BACKUP_DIR/ck-card-key-icons.js" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true

cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" role="img" aria-label="CrossingKey neon crossed keys">
  <defs>
    <filter id="ckNeonGlow" x="-100%" y="-100%" width="300%" height="300%">
      <feGaussianBlur stdDeviation="4.8" result="blur"/>
      <feColorMatrix in="blur" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 .04
                0 0 0 0 .58
                0 0 0 .95 0" result="magentaGlow"/>
      <feMerge>
        <feMergeNode in="magentaGlow"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <linearGradient id="ckTube" x1="10" y1="10" x2="90" y2="90">
      <stop offset="0%" stop-color="#fff7fd"/>
      <stop offset="28%" stop-color="#ff9fe0"/>
      <stop offset="60%" stop-color="#ff2aa3"/>
      <stop offset="100%" stop-color="#ff006e"/>
    </linearGradient>
  </defs>

  <!-- Big readable key silhouettes. No tiny glyph clutter. -->

  <!-- Glow underlay -->
  <g filter="url(#ckNeonGlow)" fill="none" stroke="#ff1493" stroke-width="8.5" stroke-linecap="round" stroke-linejoin="round" opacity=".58">
    <!-- upper-left bow to lower-right teeth -->
    <circle cx="24" cy="25" r="11"/>
    <path d="M32 33 L72 73"/>
    <path d="M72 73 L84 85"/>
    <path d="M75 76 H88"/>
    <path d="M80 81 V92"/>

    <!-- lower-left bow to upper-right teeth -->
    <circle cx="24" cy="75" r="11"/>
    <path d="M32 67 L72 27"/>
    <path d="M72 27 L84 15"/>
    <path d="M75 24 H88"/>
    <path d="M80 19 V8"/>
  </g>

  <!-- Main neon tube -->
  <g fill="none" stroke="url(#ckTube)" stroke-width="4.8" stroke-linecap="round" stroke-linejoin="round">
    <!-- upper-left key -->
    <circle cx="24" cy="25" r="11"/>
    <path d="M32 33 L72 73"/>
    <path d="M72 73 L84 85"/>
    <path d="M75 76 H88"/>
    <path d="M80 81 V92"/>

    <!-- lower-left key -->
    <circle cx="24" cy="75" r="11"/>
    <path d="M32 67 L72 27"/>
    <path d="M72 27 L84 15"/>
    <path d="M75 24 H88"/>
    <path d="M80 19 V8"/>
  </g>

  <!-- White-hot neon core -->
  <g fill="none" stroke="#fff8fd" stroke-width="1.35" stroke-linecap="round" stroke-linejoin="round" opacity=".95">
    <circle cx="24" cy="25" r="11"/>
    <path d="M32 33 L72 73"/>
    <path d="M72 73 L84 85"/>
    <path d="M75 76 H88"/>
    <path d="M80 81 V92"/>

    <circle cx="24" cy="75" r="11"/>
    <path d="M32 67 L72 27"/>
    <path d="M72 27 L84 15"/>
    <path d="M75 24 H88"/>
    <path d="M80 19 V8"/>
  </g>
</svg>
SVG

cat > src/ck-card-key-icons.js <<JS
const CK_ICON_SRC = "/assets/crossingkey-keys.svg?v=$VERSION";

function createKeyIcon() {
  const img = document.createElement("img");
  img.src = CK_ICON_SRC;
  img.alt = "";
  img.className = "ck-real-key-image";
  img.setAttribute("aria-hidden", "true");
  img.dataset.ckRealKey = "1";
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

function getSlot(card) {
  let slot =
    card.querySelector(".ck-card-icon") ||
    card.querySelector(".ck-final-key-holder") ||
    card.querySelector(".ck-glowing-key-holder") ||
    card.querySelector(".ck-card-key-holder") ||
    card.querySelector(".card-icon") ||
    card.querySelector("[class*='icon']");

  if (!slot) {
    slot = document.createElement("span");
    slot.className = "ck-card-icon ck-real-key-holder";

    const heading = card.querySelector("h1,h2,h3,h4");
    if (heading) card.insertBefore(slot, heading);
    else card.insertBefore(slot, card.firstChild);
  }

  return slot;
}

function applyKeys() {
  const cards = document.querySelectorAll(
    ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
  );

  cards.forEach((card) => {
    if (!isCard(card)) return;

    const slot = getSlot(card);
    slot.classList.add("ck-card-icon", "ck-real-key-holder");

    const existing = slot.querySelector("img[data-ck-real-key='1']");
    if (existing && existing.src.includes("$VERSION")) return;

    slot.innerHTML = "";
    slot.appendChild(createKeyIcon());
  });
}

function boot() {
  applyKeys();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(applyKeys);
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

for pattern in [
    r"/\* CK GLOWING KEYS MANIFEST START \*/.*?/\* CK GLOWING KEYS MANIFEST END \*/",
    r"/\* CK FINISHED NEON KEYS START \*/.*?/\* CK FINISHED NEON KEYS END \*/",
    r"/\* CK FINAL PRECISION NEON KEYS START \*/.*?/\* CK FINAL PRECISION NEON KEYS END \*/",
    r"/\* CK REAL NEON KEYS START \*/.*?/\* CK REAL NEON KEYS END \*/",
    r"/\* CrossingKey repaired crossed-keys card icon rendering \*/.*?(?=\n/\*|\Z)",
    r"/\* CrossingKey card icon lock \*/.*?(?=\n/\*|\Z)"
]:
    text = re.sub(pattern, "", text, flags=re.S)

block = """
/* CK REAL NEON KEYS START */
.ck-card-icon,
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
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.22), rgba(255, 42, 163, 0.07) 54%, rgba(8, 0, 7, 0.72) 100%) !important;
  box-shadow:
    0 0 8px rgba(255, 42, 163, 0.88),
    0 0 26px rgba(255, 42, 163, 0.42),
    inset 0 0 18px rgba(255, 42, 163, 0.13) !important;
}

.ck-real-key-image,
.ck-card-icon img.ck-real-key-image {
  width: 57px !important;
  height: 57px !important;
  min-width: 57px !important;
  min-height: 57px !important;
  display: block !important;
  object-fit: contain !important;
  object-position: center !important;
  overflow: visible !important;
  pointer-events: none !important;
  user-select: none !important;
  filter:
    drop-shadow(0 0 4px rgba(255, 255, 255, 0.38))
    drop-shadow(0 0 8px rgba(255, 42, 163, 0.98))
    drop-shadow(0 0 18px rgba(255, 42, 163, 0.68)) !important;
}
/* CK REAL NEON KEYS END */
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
echo "Real neon crossed-key icon installed."
echo "Backup saved to: $BACKUP_DIR"
echo "Cache version: $VERSION"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
