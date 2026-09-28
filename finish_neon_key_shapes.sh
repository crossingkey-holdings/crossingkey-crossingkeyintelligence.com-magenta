#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
VERSION="finished-neon-keys-$STAMP"

if [ -x "./ck_visual_unlock.sh" ]; then
  echo "Unlocking visuals for founder-approved icon shape refinement..."
  ./ck_visual_unlock.sh
fi

mkdir -p public/assets .ck_backups

cp -a public/assets/crossingkey-keys.svg ".ck_backups/crossingkey-keys.svg.$STAMP" 2>/dev/null || true
cp -a src/ck-card-key-icons.js ".ck_backups/ck-card-key-icons.js.$STAMP" 2>/dev/null || true

cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120" role="img" aria-label="CrossingKey finished neon crossed keys">
  <defs>
    <filter id="pinkHaze" x="-120%" y="-120%" width="340%" height="340%">
      <feGaussianBlur stdDeviation="6.5" result="blur"/>
      <feColorMatrix in="blur" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 0.03
                0 0 0 0 0.52
                0 0 0 .95 0" result="magentaGlow"/>
      <feMerge>
        <feMergeNode in="magentaGlow"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>

    <linearGradient id="tubePink" x1="18" y1="18" x2="102" y2="102">
      <stop offset="0%" stop-color="#ffe9f8"/>
      <stop offset="25%" stop-color="#ffb3e6"/>
      <stop offset="55%" stop-color="#ff4fbc"/>
      <stop offset="78%" stop-color="#ff1493"/>
      <stop offset="100%" stop-color="#ff006e"/>
    </linearGradient>
  </defs>

  <!-- soft neon aura -->
  <g filter="url(#pinkHaze)" fill="none" stroke="#ff1493" stroke-linecap="round" stroke-linejoin="round" opacity=".42">
    <g stroke-width="11">
      <!-- key A aura -->
      <g transform="rotate(-45 60 60)">
        <circle cx="34" cy="60" r="12"/>
        <path d="M46 60 H81"/>
        <path d="M81 60 V72 H90 V60 H98 V68"/>
      </g>

      <!-- key B aura -->
      <g transform="rotate(45 60 60)">
        <circle cx="34" cy="60" r="12"/>
        <path d="M46 60 H81"/>
        <path d="M81 60 V72 H90 V60 H98 V68"/>
      </g>
    </g>
  </g>

  <!-- colored outline tube -->
  <g fill="none" stroke="url(#tubePink)" stroke-width="5.4" stroke-linecap="round" stroke-linejoin="round">
    <!-- key A -->
    <g transform="rotate(-45 60 60)">
      <!-- bow -->
      <circle cx="34" cy="60" r="12"/>
      <circle cx="34" cy="60" r="4.3"/>
      <!-- shaft -->
      <path d="M46 60 H81"/>
      <!-- shoulder -->
      <path d="M46 60 C42 57 39 55 36 54"/>
      <!-- teeth -->
      <path d="M81 60 V72 H90 V60 H98 V68"/>
    </g>

    <!-- key B -->
    <g transform="rotate(45 60 60)">
      <!-- bow -->
      <circle cx="34" cy="60" r="12"/>
      <circle cx="34" cy="60" r="4.3"/>
      <!-- shaft -->
      <path d="M46 60 H81"/>
      <!-- shoulder -->
      <path d="M46 60 C42 57 39 55 36 54"/>
      <!-- teeth -->
      <path d="M81 60 V72 H90 V60 H98 V68"/>
    </g>
  </g>

  <!-- hot white neon core -->
  <g fill="none" stroke="#fff7fd" stroke-width="1.65" stroke-linecap="round" stroke-linejoin="round" opacity=".95">
    <!-- key A core -->
    <g transform="rotate(-45 60 60)">
      <circle cx="34" cy="60" r="12"/>
      <circle cx="34" cy="60" r="4.3"/>
      <path d="M46 60 H81"/>
      <path d="M81 60 V72 H90 V60 H98 V68"/>
    </g>

    <!-- key B core -->
    <g transform="rotate(45 60 60)">
      <circle cx="34" cy="60" r="12"/>
      <circle cx="34" cy="60" r="4.3"/>
      <path d="M46 60 H81"/>
      <path d="M81 60 V72 H90 V60 H98 V68"/>
    </g>
  </g>
</svg>
SVG

if [ -f "src/ck-card-key-icons.js" ]; then
python3 - <<PY
from pathlib import Path
import re

path = Path("src/ck-card-key-icons.js")
text = path.read_text(encoding="utf-8")

pattern = r'const\\s+CK_ICON_SRC\\s*=\\s*["\\\'].*?["\\\'];'
replacement = 'const CK_ICON_SRC = "/assets/crossingkey-keys.svg?v=$VERSION";'

if re.search(pattern, text):
    text = re.sub(pattern, replacement, text, count=1)
else:
    text = replacement + "\\n" + text

path.write_text(text, encoding="utf-8")
PY
fi

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
/* CK FINISHED NEON KEYS START */
.ck-glowing-key-holder,
.ck-card-icon.ck-glowing-key-holder,
.ck-card-icon {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  min-height: 58px !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  padding: 0 !important;
  border: 1px solid rgba(255, 42, 163, 0.82) !important;
  border-radius: 16px !important;
  background:
    radial-gradient(circle at 50% 50%, rgba(255, 42, 163, 0.24), rgba(255, 42, 163, 0.08) 52%, rgba(7, 0, 6, 0.74) 100%) !important;
  box-shadow:
    0 0 10px rgba(255, 42, 163, 0.9),
    0 0 30px rgba(255, 42, 163, 0.44),
    inset 0 0 22px rgba(255, 42, 163, 0.12) !important;
  overflow: visible !important;
}

.ck-glowing-key-image,
.ck-card-key-image,
.ck-card-icon img {
  width: 52px !important;
  height: 52px !important;
  min-width: 52px !important;
  min-height: 52px !important;
  display: block !important;
  object-fit: contain !important;
  overflow: visible !important;
  pointer-events: none !important;
  user-select: none !important;
  filter:
    drop-shadow(0 0 4px rgba(255,255,255,.45))
    drop-shadow(0 0 8px rgba(255,42,163,.92))
    drop-shadow(0 0 18px rgba(255,42,163,.68)) !important;
}
/* CK FINISHED NEON KEYS END */
"""

text = re.sub(
    r"/\* CK FINISHED NEON KEYS START \*/.*?/\* CK FINISHED NEON KEYS END \*/",
    "",
    text,
    flags=re.S
)

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo
echo "Finished neon key shapes installed."
echo "Cache version: $VERSION"
echo
echo "Restart Vite and hard refresh:"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
echo "  Ctrl+Shift+R"
echo
echo "If approved, lock it in:"
echo "  ./ck_visual_accept_new_baseline.sh"
