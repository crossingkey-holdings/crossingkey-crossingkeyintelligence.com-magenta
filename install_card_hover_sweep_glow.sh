#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/card_hover_sweep_glow_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true
cp -a src/ck-card-sweep-glow.js "$BACKUP_DIR/ck-card-sweep-glow.js" 2>/dev/null || true

cat > src/ck-card-sweep-glow.js <<'JS'
function isCrossingKeyCard(card) {
  if (!card || card.nodeType !== 1) return false;

  const rect = card.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (card.closest("header, nav, footer, form, .ck-search")) return false;

  const text = String(card.textContent || "").replace(/\s+/g, " ").trim();
  return text.length >= 20;
}

function getCards() {
  return Array.from(
    document.querySelectorAll(
      ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
    )
  ).filter(isCrossingKeyCard);
}

function installSweepGlow() {
  const cards = getCards();

  cards.forEach((card) => {
    if (card.dataset.ckSweepGlowInstalled === "1") return;

    card.dataset.ckSweepGlowInstalled = "1";
    card.classList.add("ck-sweep-card");

    card.addEventListener("pointermove", (event) => {
      const rect = card.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width) * 100;
      const y = ((event.clientY - rect.top) / rect.height) * 100;

      card.style.setProperty("--ck-mouse-x", `${x}%`);
      card.style.setProperty("--ck-mouse-y", `${y}%`);
    });

    card.addEventListener("pointerenter", (event) => {
      const rect = card.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width) * 100;
      const y = ((event.clientY - rect.top) / rect.height) * 100;

      card.style.setProperty("--ck-mouse-x", `${x}%`);
      card.style.setProperty("--ck-mouse-y", `${y}%`);
      card.classList.add("ck-sweep-active");
    });

    card.addEventListener("pointerleave", () => {
      card.classList.remove("ck-sweep-active");
      card.style.setProperty("--ck-mouse-x", "50%");
      card.style.setProperty("--ck-mouse-y", "50%");
    });
  });
}

function bootSweepGlow() {
  installSweepGlow();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(installSweepGlow);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootSweepGlow, { once: true });
} else {
  bootSweepGlow();
}
JS

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
    r"/\* CK CARD HOVER SWEEP GLOW START \*/.*?/\* CK CARD HOVER SWEEP GLOW END \*/",
    "",
    text,
    flags=re.S
)

block = r"""
/* CK CARD HOVER SWEEP GLOW START */
.ck-sweep-card,
.ck-card,
.category-card,
.product-card,
.feature-card,
.system-card {
  --ck-mouse-x: 50%;
  --ck-mouse-y: 50%;
  position: relative !important;
  overflow: hidden !important;
  isolation: isolate !important;
  transition:
    transform 240ms ease,
    border-color 240ms ease,
    box-shadow 240ms ease,
    filter 240ms ease,
    background 240ms ease !important;
}

/* Moving magenta sweep glow */
.ck-sweep-card::before,
.ck-card::before,
.category-card::before,
.product-card::before,
.feature-card::before,
.system-card::before {
  content: "";
  position: absolute;
  inset: -2px;
  z-index: 0;
  pointer-events: none;
  opacity: 0;
  transition: opacity 240ms ease;
  background:
    radial-gradient(
      circle at var(--ck-mouse-x) var(--ck-mouse-y),
      rgba(255, 255, 255, 0.22) 0%,
      rgba(255, 42, 163, 0.38) 10%,
      rgba(255, 42, 163, 0.18) 22%,
      rgba(255, 42, 163, 0.05) 38%,
      transparent 62%
    ),
    linear-gradient(
      115deg,
      transparent 0%,
      transparent 32%,
      rgba(255, 42, 163, 0.12) 43%,
      rgba(245, 245, 255, 0.16) 50%,
      rgba(255, 42, 163, 0.12) 57%,
      transparent 68%,
      transparent 100%
    );
  mix-blend-mode: screen;
}

/* Keep card content above sweep */
.ck-sweep-card > *,
.ck-card > *,
.category-card > *,
.product-card > *,
.feature-card > *,
.system-card > * {
  position: relative;
  z-index: 1;
}

/* White/cold-silver outline glow on hover */
.ck-sweep-card:hover,
.ck-card:hover,
.category-card:hover,
.product-card:hover,
.feature-card:hover,
.system-card:hover {
  transform: translateY(-7px) scale(1.012) !important;
  border-color: rgba(245, 245, 255, 0.78) !important;
  box-shadow:
    0 0 0 1px rgba(245, 245, 255, 0.46),
    0 0 16px rgba(245, 245, 255, 0.42),
    0 0 36px rgba(215, 215, 223, 0.22),
    0 0 58px rgba(255, 42, 163, 0.42),
    0 34px 88px rgba(0, 0, 0, 0.58),
    inset 0 0 30px rgba(255, 42, 163, 0.13) !important;
  filter: saturate(1.08) brightness(1.04) !important;
}

.ck-sweep-card:hover::before,
.ck-sweep-card.ck-sweep-active::before,
.ck-card:hover::before,
.category-card:hover::before,
.product-card:hover::before,
.feature-card:hover::before,
.system-card:hover::before {
  opacity: 1;
}

/* Extra cold-silver edge line */
.ck-sweep-card::after,
.ck-card::after,
.category-card::after,
.product-card::after,
.feature-card::after,
.system-card::after {
  content: "";
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  border-radius: inherit;
  opacity: 0;
  transition: opacity 240ms ease;
  box-shadow:
    inset 0 0 0 1px rgba(245, 245, 255, 0.34),
    inset 0 0 22px rgba(245, 245, 255, 0.08);
}

.ck-sweep-card:hover::after,
.ck-card:hover::after,
.category-card:hover::after,
.product-card:hover::after,
.feature-card:hover::after,
.system-card:hover::after {
  opacity: 1;
}

/* Icon lights harder on card hover */
.ck-sweep-card:hover .ck-card-icon,
.ck-card:hover .ck-card-icon,
.category-card:hover .ck-card-icon,
.product-card:hover .ck-card-icon,
.feature-card:hover .ck-card-icon,
.system-card:hover .ck-card-icon {
  border-color: rgba(245, 245, 255, 0.76) !important;
  box-shadow:
    0 0 0 1px rgba(245, 245, 255, 0.28),
    0 0 12px rgba(245, 245, 255, 0.34),
    0 0 34px rgba(255, 42, 163, 0.78),
    inset 0 0 22px rgba(255, 42, 163, 0.24) !important;
}

/* Card text gets a cold silver lift */
.ck-sweep-card:hover h2,
.ck-sweep-card:hover h3,
.ck-sweep-card:hover h4,
.ck-card:hover h2,
.ck-card:hover h3,
.ck-card:hover h4,
.category-card:hover h2,
.category-card:hover h3,
.category-card:hover h4,
.product-card:hover h2,
.product-card:hover h3,
.product-card:hover h4,
.feature-card:hover h2,
.feature-card:hover h3,
.feature-card:hover h4,
.system-card:hover h2,
.system-card:hover h3,
.system-card:hover h4 {
  color: #f5f5ff !important;
  text-shadow:
    0 0 10px rgba(245, 245, 255, 0.22),
    0 0 18px rgba(255, 42, 163, 0.24) !important;
}

/* Bottom bars and arrow react */
.ck-sweep-card:hover .ck-bars i,
.ck-card:hover .ck-bars i,
.category-card:hover .ck-bars i,
.product-card:hover .ck-bars i,
.feature-card:hover .ck-bars i,
.system-card:hover .ck-bars i {
  background: #f5f5ff !important;
  box-shadow:
    0 0 8px rgba(245, 245, 255, 0.55),
    0 0 18px rgba(255, 42, 163, 0.46) !important;
}

.ck-sweep-card:hover .ck-card-arrow,
.ck-card:hover .ck-card-arrow,
.category-card:hover .ck-card-arrow,
.product-card:hover .ck-card-arrow,
.feature-card:hover .ck-card-arrow,
.system-card:hover .ck-card-arrow {
  border-color: rgba(245, 245, 255, 0.62) !important;
  color: #f5f5ff !important;
  box-shadow:
    0 0 12px rgba(245, 245, 255, 0.24),
    0 0 24px rgba(255, 42, 163, 0.35) !important;
}

@media (prefers-reduced-motion: reduce) {
  .ck-sweep-card,
  .ck-card,
  .category-card,
  .product-card,
  .feature-card,
  .system-card {
    transition: none !important;
  }

  .ck-sweep-card:hover,
  .ck-card:hover,
  .category-card:hover,
  .product-card:hover,
  .feature-card:hover,
  .system-card:hover {
    transform: none !important;
  }
}
/* CK CARD HOVER SWEEP GLOW END */
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
line = 'import "./ck-card-sweep-glow.js";'

text = "\n".join(row for row in text.splitlines() if row.strip() != line)
text = line + "\n" + text.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo
echo "Card hover glow installed:"
echo "  - white/cold-silver outline glow"
echo "  - magenta sweep glow follows mouse movement"
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
