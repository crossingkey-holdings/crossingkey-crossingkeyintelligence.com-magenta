#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$PWD"

if [ -x "./ck_visual_unlock.sh" ]; then
  echo "Visual lock detected. Unlocking for approved icon update..."
  ./ck_visual_unlock.sh
fi

mkdir -p public/assets src

echo "Writing crossed-keys icon asset..."
cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" role="img" aria-label="CrossingKey crossed keys">
  <defs>
    <radialGradient id="bg" cx="50%" cy="50%" r="70%">
      <stop offset="0%" stop-color="#33001f"/>
      <stop offset="60%" stop-color="#15000d"/>
      <stop offset="100%" stop-color="#080006"/>
    </radialGradient>

    <linearGradient id="magenta" x1="18" y1="18" x2="110" y2="110">
      <stop offset="0%" stop-color="#ffb3e8"/>
      <stop offset="35%" stop-color="#ff3db8"/>
      <stop offset="70%" stop-color="#ff1493"/>
      <stop offset="100%" stop-color="#ff006e"/>
    </linearGradient>

    <filter id="glow" x="-80%" y="-80%" width="260%" height="260%">
      <feGaussianBlur stdDeviation="3.2" result="blur"/>
      <feColorMatrix in="blur" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 .05
                0 0 0 0 .58
                0 0 0 .95 0" result="pink"/>
      <feMerge>
        <feMergeNode in="pink"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>

  <rect x="7" y="7" width="114" height="114" rx="24" fill="url(#bg)"/>
  <rect x="8.5" y="8.5" width="111" height="111" rx="22" fill="none" stroke="#ff2aa3" stroke-width="3" opacity=".72"/>

  <g filter="url(#glow)" fill="none" stroke="url(#magenta)" stroke-width="7.5" stroke-linecap="round" stroke-linejoin="round">
    <path d="M31 31 L97 97"/>
    <circle cx="29" cy="29" r="12"/>
    <path d="M84 84 L96 84"/>
    <path d="M91 91 L103 91"/>
    <path d="M74 74 L74 62"/>

    <path d="M97 31 L31 97"/>
    <circle cx="99" cy="29" r="12"/>
    <path d="M44 84 L32 84"/>
    <path d="M37 91 L25 91"/>
    <path d="M54 74 L54 62"/>
  </g>

  <g fill="#ffd7f3" opacity=".95">
    <circle cx="29" cy="29" r="3"/>
    <circle cx="99" cy="29" r="3"/>
    <circle cx="64" cy="64" r="2.5"/>
  </g>
</svg>
SVG

echo "Writing runtime patch..."
cat > src/ck-card-key-icons.js <<'JS'
const CK_ICON_SRC = "/assets/crossingkey-keys.svg?v=ck-card-key-1";

function isLikelyCard(node) {
  if (!node || node.nodeType !== 1) return false;

  const rect = node.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (node.closest("header, nav, footer, .ck-search, .search, form")) return false;

  const text = (node.textContent || "").replace(/\s+/g, " ").trim();
  if (text.length < 20) return false;

  const hasHeading = node.querySelector("h2, h3, h4, [class*='title'], [class*='heading']");
  const hasCardNumber = /\b0[1-9]\b|\b1[0-5]\b/.test(text.slice(0, 160));

  return Boolean(hasHeading || hasCardNumber);
}

function findCards() {
  const selectors = [
    ".ck-card",
    ".category-card",
    ".product-card",
    ".feature-card",
    ".service-card",
    ".solution-card",
    ".signal-card",
    ".system-card",
    "[class*='card']",
    "[class*='Card']"
  ];

  const found = new Set();

  selectors.forEach((selector) => {
    document.querySelectorAll(selector).forEach((node) => {
      if (isLikelyCard(node)) found.add(node);
    });
  });

  return [...found];
}

function findIconSpot(card) {
  const selectors = [
    ".ck-card-icon",
    ".card-icon",
    ".icon-box",
    ".icon-wrap",
    ".icon-slot",
    ".icon-holder",
    ".card__icon",
    "[class*='card-icon']",
    "[class*='iconBox']",
    "[class*='iconWrap']",
    "[class*='iconSlot']",
    "[class*='iconHolder']",
    "[class*='icon']"
  ];

  for (const selector of selectors) {
    const nodes = card.querySelectorAll(selector);
    for (const node of nodes) {
      if (!node || node.closest("button, a[href^='http']")) continue;
      const rect = node.getBoundingClientRect();
      if (rect.width > 96 || rect.height > 96) continue;
      if (rect.top > card.getBoundingClientRect().top + 130) continue;
      return node;
    }
  }

  return null;
}

function buildImage() {
  const img = document.createElement("img");
  img.src = CK_ICON_SRC;
  img.alt = "";
  img.setAttribute("aria-hidden", "true");
  img.className = "ck-card-key-image";
  img.dataset.ckCardKey = "1";
  return img;
}

function applyKeysToCards() {
  const cards = findCards();

  cards.forEach((card) => {
    if (card.dataset.ckKeysApplied === "1") return;

    let slot = findIconSpot(card);

    if (!slot) {
      slot = document.createElement("div");
      slot.className = "ck-card-icon ck-card-key-holder";
      const heading = card.querySelector("h2, h3, h4");
      if (heading) {
        card.insertBefore(slot, heading);
      } else {
        card.insertBefore(slot, card.firstChild);
      }
    }

    slot.classList.add("ck-card-key-holder");

    const existing = slot.querySelector("img[data-ck-card-key='1']");
    if (!existing) {
      slot.innerHTML = "";
      slot.appendChild(buildImage());
    }

    card.dataset.ckKeysApplied = "1";
  });
}

function boot() {
  applyKeysToCards();

  const observer = new MutationObserver(() => {
    applyKeysToCards();
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

echo "Patching CSS: $STYLE_FILE"
if ! grep -q "ck-card-key-holder" "$STYLE_FILE"; then
cat >> "$STYLE_FILE" <<'CSS'

/* CrossingKey card icon lock */
.ck-card-key-holder,
.ck-card-icon.ck-card-key-holder,
.ck-card-icon {
  width: 50px;
  height: 50px;
  min-width: 50px;
  min-height: 50px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 42, 163, 0.68);
  border-radius: 14px;
  background:
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.22), rgba(255, 42, 163, 0.05) 64%, rgba(0, 0, 0, 0.22) 100%);
  box-shadow:
    0 0 20px rgba(255, 42, 163, 0.36),
    inset 0 0 18px rgba(255, 42, 163, 0.12);
  overflow: hidden;
}

.ck-card-key-image {
  width: 42px;
  height: 42px;
  display: block;
  object-fit: contain;
  pointer-events: none;
  user-select: none;
  filter:
    drop-shadow(0 0 5px rgba(255, 42, 163, 1))
    drop-shadow(0 0 16px rgba(255, 42, 163, 0.55));
}
CSS
fi

MAIN_FILE=""
if [ -f "src/main.js" ]; then
  MAIN_FILE="src/main.js"
elif [ -f "src/main.jsx" ]; then
  MAIN_FILE="src/main.jsx"
elif [ -f "src/main.ts" ]; then
  MAIN_FILE="src/main.ts"
elif [ -f "src/main.tsx" ]; then
  MAIN_FILE="src/main.tsx"
else
  echo "Could not find a main Vite entry file in src/"
  exit 1
fi

echo "Patching runtime import: $MAIN_FILE"
python3 - "$MAIN_FILE" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

snippet = 'import "./ck-card-key-icons.js";'
if snippet not in text:
    text = snippet + "\n" + text

path.write_text(text, encoding="utf-8")
PY

echo
echo "Done."
echo "Card icon spots now use the crossed-keys image."
echo
echo "Next:"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
echo
echo "After you confirm it looks right:"
echo "  ./ck_visual_accept_new_baseline.sh"
