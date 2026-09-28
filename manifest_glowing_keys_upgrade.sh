#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/glowing_keys_manifest_$STAMP"
VERSION="glowing-keys-$STAMP"

mkdir -p "$BACKUP_DIR" public/assets docs/visuals src

echo "Backing up current icon/runtime/style files..."
cp -a public/assets/crossingkey-keys.svg "$BACKUP_DIR/crossingkey-keys.svg" 2>/dev/null || true
cp -a src/ck-card-key-icons.js "$BACKUP_DIR/ck-card-key-icons.js" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true

if [ -x "./ck_visual_unlock.sh" ]; then
  echo "Visual lock detected. Unlocking for approved glowing-keys upgrade..."
  ./ck_visual_unlock.sh
fi

cat > docs/visuals/GLOWING_KEYS_MANIFEST.md <<'MD'
# CrossingKey Glowing Keys Manifest

Status: Approved visual direction candidate

Purpose:
The CrossingKey card icon should read as two crossed neon keys, not rods, panels, generic controls, or abstract symbols.

Visual rules:
- The icon must look like neon tubing shaped into keys.
- The key bows must be visible circular rings.
- The shafts must cross cleanly.
- The teeth must be readable at small size.
- The glow must be magenta/pink with a hot silver-white core.
- The card icon holder remains black glass with atomic magenta border and glow.
- The asset must remain simple enough to render clearly at 40–56px.

Locked intent:
The crossed keys represent access, operator authority, system gates, protected execution, and CrossingKey Intelligence as a command-surface company.

Do not replace this with:
- Rod-like X shapes
- Generic squares
- Control-panel dots
- Random glyphs
- Multi-color icons
- Flat monochrome symbols
MD

cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120" role="img" aria-label="CrossingKey glowing crossed keys">
  <defs>
    <filter id="softGlow" x="-90%" y="-90%" width="280%" height="280%">
      <feGaussianBlur stdDeviation="6" result="blur"/>
      <feColorMatrix in="blur" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 .03
                0 0 0 0 .54
                0 0 0 .92 0" result="pinkGlow"/>
      <feMerge>
        <feMergeNode in="pinkGlow"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <filter id="hotCore" x="-80%" y="-80%" width="260%" height="260%">
      <feGaussianBlur stdDeviation="1.15" result="tinyBlur"/>
      <feMerge>
        <feMergeNode in="tinyBlur"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <linearGradient id="neonTube" x1="18" y1="18" x2="102" y2="102">
      <stop offset="0%" stop-color="#fff0fb"/>
      <stop offset="22%" stop-color="#ff9fe0"/>
      <stop offset="52%" stop-color="#ff35ad"/>
      <stop offset="78%" stop-color="#ff0f8b"/>
      <stop offset="100%" stop-color="#ff006e"/>
    </linearGradient>
  </defs>

  <!-- transparent canvas; holder supplies black-glass square -->

  <!-- outer neon haze -->
  <g filter="url(#softGlow)" fill="none" stroke="#ff1493" stroke-width="12" stroke-linecap="round" stroke-linejoin="round" opacity=".42">
    <g transform="rotate(-45 60 60)">
      <circle cx="31" cy="60" r="13"/>
      <path d="M44 60 H82"/>
      <path d="M82 60 V72 H91 V60 H98 V69"/>
    </g>

    <g transform="rotate(45 60 60)">
      <circle cx="31" cy="60" r="13"/>
      <path d="M44 60 H82"/>
      <path d="M82 60 V72 H91 V60 H98 V69"/>
    </g>
  </g>

  <!-- visible neon tubing -->
  <g filter="url(#hotCore)" fill="none" stroke="url(#neonTube)" stroke-width="6.4" stroke-linecap="round" stroke-linejoin="round">
    <!-- first key -->
    <g transform="rotate(-45 60 60)">
      <circle cx="31" cy="60" r="13"/>
      <circle cx="31" cy="60" r="4.7"/>
      <path d="M44 60 H82"/>
      <path d="M82 60 V72 H91 V60 H98 V69"/>
      <path d="M44 60 C40 56 37 54 34 53"/>
    </g>

    <!-- second key -->
    <g transform="rotate(45 60 60)">
      <circle cx="31" cy="60" r="13"/>
      <circle cx="31" cy="60" r="4.7"/>
      <path d="M44 60 H82"/>
      <path d="M82 60 V72 H91 V60 H98 V69"/>
      <path d="M44 60 C40 56 37 54 34 53"/>
    </g>
  </g>

  <!-- hot white highlights -->
  <g fill="#fff6fd" opacity=".98">
    <circle cx="60" cy="60" r="2"/>
    <circle cx="29" cy="29" r="1.8"/>
    <circle cx="91" cy="29" r="1.8"/>
    <circle cx="29" cy="91" r="1.3"/>
    <circle cx="91" cy="91" r="1.3"/>
  </g>
</svg>
SVG

cat > src/ck-card-key-icons.js <<JS
const CK_ICON_SRC = "/assets/crossingkey-keys.svg?v=$VERSION";

function createGlowingKeyImage() {
  const img = document.createElement("img");
  img.src = CK_ICON_SRC;
  img.alt = "";
  img.className = "ck-glowing-key-image";
  img.dataset.ckGlowingKey = "1";
  img.setAttribute("aria-hidden", "true");
  return img;
}

function isCardCandidate(card) {
  if (!card || card.nodeType !== 1) return false;

  const rect = card.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (card.closest("header, nav, footer, form, .ck-search")) return false;

  const text = (card.textContent || "").replace(/\\s+/g, " ").trim();
  if (text.length < 20) return false;

  return Boolean(
    card.matches(".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']")
  );
}

function findIconSlot(card) {
  const selectors = [
    ".ck-card-icon",
    ".ck-card-key-holder",
    ".card-icon",
    ".icon-box",
    ".icon-wrap",
    ".icon-slot",
    "[class*='card-icon']",
    "[class*='iconBox']",
    "[class*='iconWrap']",
    "[class*='iconSlot']",
    "[class*='icon']"
  ];

  for (const selector of selectors) {
    const node = card.querySelector(selector);
    if (!node) continue;

    const rect = node.getBoundingClientRect();
    const cardRect = card.getBoundingClientRect();

    if (rect.width > 100 || rect.height > 100) continue;
    if (rect.top > cardRect.top + 150) continue;
    if (node.closest("button, nav, header, footer")) continue;

    return node;
  }

  const slot = document.createElement("span");
  slot.className = "ck-card-icon ck-glowing-key-holder";

  const number = card.querySelector(".ck-card-number");
  const heading = card.querySelector("h1,h2,h3,h4");

  if (number && number.nextSibling) {
    card.insertBefore(slot, number.nextSibling);
  } else if (heading) {
    card.insertBefore(slot, heading);
  } else {
    card.insertBefore(slot, card.firstChild);
  }

  return slot;
}

function applyGlowingKeys() {
  const cards = Array.from(document.querySelectorAll(".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"));

  for (const card of cards) {
    if (!isCardCandidate(card)) continue;

    const slot = findIconSlot(card);
    slot.classList.add("ck-glowing-key-holder", "ck-card-icon");

    const current = slot.querySelector("img[data-ck-glowing-key='1']");
    if (current && current.src.includes("$VERSION")) continue;

    slot.innerHTML = "";
    slot.appendChild(createGlowingKeyImage());
    card.dataset.ckGlowingKeysApplied = "1";
  }
}

function bootGlowingKeys() {
  applyGlowingKeys();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(applyGlowingKeys);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootGlowingKeys, { once: true });
} else {
  bootGlowingKeys();
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

block = r"""
/* CK GLOWING KEYS MANIFEST START */
.ck-glowing-key-holder,
.ck-card-icon.ck-glowing-key-holder,
.ck-card-icon.ck-card-key-holder,
.ck-card-icon {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  min-height: 58px !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  padding: 0 !important;
  overflow: visible !important;
  border: 1px solid rgba(255, 42, 163, 0.82) !important;
  border-radius: 16px !important;
  background:
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.32), rgba(255, 42, 163, 0.09) 48%, rgba(9, 0, 7, 0.62) 100%) !important;
  box-shadow:
    0 0 8px rgba(255, 42, 163, 0.82),
    0 0 28px rgba(255, 42, 163, 0.42),
    inset 0 0 24px rgba(255, 42, 163, 0.16) !important;
  animation: ckKeyAura 2.8s ease-in-out infinite !important;
}

.ck-glowing-key-image,
.ck-card-icon img.ck-glowing-key-image {
  width: 54px !important;
  height: 54px !important;
  min-width: 54px !important;
  min-height: 54px !important;
  display: block !important;
  object-fit: contain !important;
  overflow: visible !important;
  pointer-events: none !important;
  user-select: none !important;
  filter:
    drop-shadow(0 0 4px rgba(255, 255, 255, 0.62))
    drop-shadow(0 0 8px rgba(255, 42, 163, 1))
    drop-shadow(0 0 22px rgba(255, 42, 163, 0.82)) !important;
  animation: ckKeyPulse 2.8s ease-in-out infinite !important;
}

@keyframes ckKeyPulse {
  0%, 100% {
    transform: scale(1);
    opacity: .92;
  }
  50% {
    transform: scale(1.045);
    opacity: 1;
  }
}

@keyframes ckKeyAura {
  0%, 100% {
    box-shadow:
      0 0 8px rgba(255, 42, 163, 0.72),
      0 0 24px rgba(255, 42, 163, 0.34),
      inset 0 0 22px rgba(255, 42, 163, 0.13);
  }
  50% {
    box-shadow:
      0 0 13px rgba(255, 42, 163, 1),
      0 0 38px rgba(255, 42, 163, 0.62),
      inset 0 0 28px rgba(255, 42, 163, 0.22);
  }
}
/* CK GLOWING KEYS MANIFEST END */
"""

text = re.sub(
    r"/\* CK GLOWING KEYS MANIFEST START \*/.*?/\* CK GLOWING KEYS MANIFEST END \*/",
    "",
    text,
    flags=re.S
)

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
  echo "Could not find Vite entry file in src/"
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
echo "Glowing keys manifest upgrade installed."
echo "Backup saved to: $BACKUP_DIR"
echo "Cache version: $VERSION"
echo
echo "Start/restart the dynamic server with:"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
echo
echo "Then hard refresh Firefox:"
echo "  Ctrl+Shift+R"
echo
echo "If approved, lock it as the new visual baseline:"
echo "  ./ck_visual_accept_new_baseline.sh"
