#!/usr/bin/env bash
set -euo pipefail

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh
fi

mkdir -p public/assets

VERSION="ck-keys-repair-$(date +%s)"

cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" role="img" aria-label="CrossingKey crossed keys">
  <defs>
    <filter id="outerGlow" x="-60%" y="-60%" width="220%" height="220%">
      <feGaussianBlur stdDeviation="3.5" result="blur"/>
      <feColorMatrix in="blur" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 0.04
                0 0 0 0 0.55
                0 0 0 1 0" result="glow"/>
      <feMerge>
        <feMergeNode in="glow"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <linearGradient id="tube" x1="15" y1="15" x2="85" y2="85">
      <stop offset="0%" stop-color="#ffe1f7"/>
      <stop offset="35%" stop-color="#ff66c7"/>
      <stop offset="70%" stop-color="#ff1493"/>
      <stop offset="100%" stop-color="#ff007a"/>
    </linearGradient>
  </defs>

  <rect x="3" y="3" width="94" height="94" rx="20" fill="#16000e"/>
  <rect x="5" y="5" width="90" height="90" rx="18" fill="none" stroke="#ff2aa3" stroke-width="2" opacity=".72"/>

  <!-- glow stroke underneath -->
  <g filter="url(#outerGlow)" fill="none" stroke="#ff1493" stroke-width="8.5" stroke-linecap="round" stroke-linejoin="round" opacity=".72">
    <path d="M23 23 L77 77"/>
    <path d="M77 23 L23 77"/>
    <circle cx="21" cy="21" r="9"/>
    <circle cx="79" cy="21" r="9"/>
    <path d="M66 66 L78 66"/>
    <path d="M72 72 L84 72"/>
    <path d="M66 34 L78 34"/>
    <path d="M72 28 L84 28"/>
  </g>

  <!-- clean neon tube -->
  <g filter="url(#outerGlow)" fill="none" stroke="url(#tube)" stroke-width="4.6" stroke-linecap="round" stroke-linejoin="round">
    <!-- left-top to right-bottom key -->
    <path d="M23 23 L77 77"/>
    <circle cx="21" cy="21" r="9"/>
    <circle cx="21" cy="21" r="3.2"/>
    <path d="M65 65 L78 65"/>
    <path d="M72 72 L84 72"/>
    <path d="M70 70 L70 59"/>

    <!-- right-top to left-bottom key -->
    <path d="M77 23 L23 77"/>
    <circle cx="79" cy="21" r="9"/>
    <circle cx="79" cy="21" r="3.2"/>
    <path d="M35 65 L22 65"/>
    <path d="M28 72 L16 72"/>
    <path d="M30 70 L30 59"/>
  </g>

  <!-- hot white neon core -->
  <g fill="#fff0fb" opacity=".96">
    <circle cx="21" cy="21" r="1.8"/>
    <circle cx="79" cy="21" r="1.8"/>
    <circle cx="50" cy="50" r="1.8"/>
  </g>
</svg>
SVG

STYLE_FILE="src/styles.css"
[ -f "$STYLE_FILE" ] || STYLE_FILE="src/style.css"
[ -f "$STYLE_FILE" ] || touch src/styles.css && STYLE_FILE="src/styles.css"

cat >> "$STYLE_FILE" <<'CSS'

/* CrossingKey repaired crossed-keys card icon rendering */
.ck-card-icon,
.ck-card-key-holder,
.ck-card-icon.ck-card-key-holder {
  width: 54px !important;
  height: 54px !important;
  min-width: 54px !important;
  min-height: 54px !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  padding: 0 !important;
  overflow: visible !important;
  border: 1px solid rgba(255, 42, 163, 0.76) !important;
  border-radius: 15px !important;
  background:
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.24), rgba(255, 42, 163, 0.06) 60%, rgba(0, 0, 0, 0.28) 100%) !important;
  box-shadow:
    0 0 24px rgba(255, 42, 163, 0.44),
    inset 0 0 18px rgba(255, 42, 163, 0.14) !important;
}

.ck-card-icon svg,
.ck-card-icon img,
.ck-card-key-image {
  width: 48px !important;
  height: 48px !important;
  min-width: 48px !important;
  min-height: 48px !important;
  display: block !important;
  object-fit: contain !important;
  overflow: visible !important;
  filter:
    drop-shadow(0 0 6px rgba(255, 42, 163, 1))
    drop-shadow(0 0 16px rgba(255, 42, 163, 0.62)) !important;
}
CSS

MAIN_FILE=""
for f in src/main.js src/main.jsx src/main.ts src/main.tsx; do
  if [ -f "$f" ]; then
    MAIN_FILE="$f"
    break
  fi
done

if [ -z "$MAIN_FILE" ]; then
  echo "Could not find src/main.js, src/main.jsx, src/main.ts, or src/main.tsx"
  exit 1
fi

cat > src/ck-card-key-icons.js <<JS
const CK_ICON_SRC = "/assets/crossingkey-keys.svg?v=$VERSION";

function buildKeyImage() {
  const img = document.createElement("img");
  img.src = CK_ICON_SRC;
  img.alt = "";
  img.className = "ck-card-key-image";
  img.setAttribute("aria-hidden", "true");
  img.dataset.ckCardKey = "1";
  return img;
}

function applyCrossingKeyIcons() {
  const cards = Array.from(document.querySelectorAll(
    ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
  ));

  for (const card of cards) {
    const rect = card.getBoundingClientRect();
    const text = (card.textContent || "").replace(/\\s+/g, " ").trim();

    if (rect.width < 120 || rect.height < 120) continue;
    if (text.length < 20) continue;
    if (card.closest("header, nav, footer, form, .ck-search")) continue;

    let slot =
      card.querySelector(".ck-card-icon") ||
      card.querySelector(".card-icon") ||
      card.querySelector("[class*='icon']");

    if (!slot) {
      slot = document.createElement("span");
      slot.className = "ck-card-icon ck-card-key-holder";
      const heading = card.querySelector("h2,h3,h4");
      if (heading) card.insertBefore(slot, heading);
      else card.insertBefore(slot, card.firstChild);
    }

    slot.classList.add("ck-card-key-holder");
    slot.innerHTML = "";
    slot.appendChild(buildKeyImage());
  }
}

function boot() {
  applyCrossingKeyIcons();
  new MutationObserver(applyCrossingKeyIcons).observe(document.documentElement, {
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

python3 - "$MAIN_FILE" <<'PY'
from pathlib import Path
import sys

p = Path(sys.argv[1])
s = p.read_text(encoding="utf-8")
line = 'import "./ck-card-key-icons.js";'

# Remove duplicate imports first.
s = "\n".join(x for x in s.splitlines() if x.strip() != line)

# Add once at top.
s = line + "\n" + s

p.write_text(s + "\n", encoding="utf-8")
PY

echo
echo "Done. Repaired card key rendering."
echo "New icon cache version: $VERSION"
echo
echo "Restart Vite:"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
echo
echo "Then hard refresh:"
echo "  Ctrl+Shift+R"
