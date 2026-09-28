#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/cold_silver_cursor_hover_glow_$STAMP"

mkdir -p "$BACKUP_DIR" src .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

STYLE_FILE=""
if [ -f "src/styles.css" ]; then
  STYLE_FILE="src/styles.css"
elif [ -f "src/style.css" ]; then
  STYLE_FILE="src/style.css"
else
  echo "Could not find src/styles.css or src/style.css"
  exit 1
fi

cp -a "$STYLE_FILE" "$BACKUP_DIR/$(basename "$STYLE_FILE")"

python3 - "$STYLE_FILE" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

text = re.sub(
    r"/\* CK COLD SILVER CURSOR AND HOVER GLOW START \*/.*?/\* CK COLD SILVER CURSOR AND HOVER GLOW END \*/",
    "",
    text,
    flags=re.S
)

block = r'''
/* CK COLD SILVER CURSOR AND HOVER GLOW START */
:root {
  --ck-cold-silver: #d7d7df;
  --ck-cold-silver-hot: #f5f5ff;
  --ck-cold-silver-dim: rgba(215, 215, 223, 0.58);
  --ck-hover-magenta: rgba(255, 42, 163, 0.78);
  --ck-hover-magenta-soft: rgba(255, 42, 163, 0.28);
}

/* Cold silver cursor */
html,
body,
a,
button,
input,
textarea,
select,
label,
[role="button"],
.ck-card,
.category-card,
.product-card,
.feature-card,
.system-card {
  cursor:
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32' viewBox='0 0 32 32'%3E%3Cdefs%3E%3Cfilter id='g' x='-80%25' y='-80%25' width='260%25' height='260%25'%3E%3CfeGaussianBlur stdDeviation='1.3' result='b'/%3E%3CfeColorMatrix in='b' type='matrix' values='0 0 0 0 0.84 0 0 0 0 0.84 0 0 0 0 0.9 0 0 0 0.9 0' result='s'/%3E%3CfeMerge%3E%3CfeMergeNode in='s'/%3E%3CfeMergeNode in='SourceGraphic'/%3E%3C/feMerge%3E%3C/filter%3E%3C/defs%3E%3Cpath filter='url(%23g)' d='M6 4 L24 16 L15.5 18.1 L12 27 Z' fill='%23d7d7df' stroke='%23ffffff' stroke-width='1.2'/%3E%3Cpath d='M15.5 18.1 L20 26' stroke='%23ff2aa3' stroke-width='1.7' stroke-linecap='round'/%3E%3C/svg%3E") 6 4,
    auto !important;
}

/* Text entry keeps precision cursor */
input,
textarea,
[contenteditable="true"] {
  cursor:
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32' viewBox='0 0 32 32'%3E%3Cdefs%3E%3Cfilter id='g' x='-80%25' y='-80%25' width='260%25' height='260%25'%3E%3CfeGaussianBlur stdDeviation='1.2' result='b'/%3E%3CfeColorMatrix in='b' type='matrix' values='0 0 0 0 0.84 0 0 0 0 0.84 0 0 0 0 0.9 0 0 0 0.9 0' result='s'/%3E%3CfeMerge%3E%3CfeMergeNode in='s'/%3E%3CfeMergeNode in='SourceGraphic'/%3E%3C/feMerge%3E%3C/filter%3E%3C/defs%3E%3Cpath filter='url(%23g)' d='M14 5 H18 M16 5 V27 M14 27 H18' stroke='%23d7d7df' stroke-width='2.4' stroke-linecap='round'/%3E%3Cpath d='M16 8 V24' stroke='%23ffffff' stroke-width='0.8' stroke-linecap='round'/%3E%3C/svg%3E") 16 16,
    text !important;
}

/* Universal interactive glow */
a,
button,
.ck-chip,
.ck-pill-button,
.ck-menu,
.ck-card,
.category-card,
.product-card,
.feature-card,
.system-card,
.ck-card-icon,
.ck-search,
input,
textarea {
  transition:
    transform 220ms ease,
    border-color 220ms ease,
    box-shadow 220ms ease,
    background 220ms ease,
    color 220ms ease,
    filter 220ms ease,
    opacity 220ms ease !important;
}

/* Cards: magenta aura + cold silver edge */
.ck-card:hover,
.category-card:hover,
.product-card:hover,
.feature-card:hover,
.system-card:hover {
  transform: translateY(-8px) scale(1.012) !important;
  border-color: rgba(245, 245, 255, 0.54) !important;
  box-shadow:
    0 34px 92px rgba(0, 0, 0, 0.52),
    0 0 0 1px rgba(215, 215, 223, 0.18),
    0 0 26px rgba(215, 215, 223, 0.18),
    0 0 48px rgba(255, 42, 163, 0.34),
    inset 0 0 28px rgba(255, 42, 163, 0.10) !important;
}

.ck-card:hover h3,
.category-card:hover h3,
.product-card:hover h3,
.feature-card:hover h3,
.system-card:hover h3 {
  color: var(--ck-cold-silver-hot) !important;
  text-shadow:
    0 0 10px rgba(215, 215, 223, 0.22),
    0 0 18px rgba(255, 42, 163, 0.20) !important;
}

/* Card icon glow */
.ck-card:hover .ck-card-icon,
.category-card:hover .ck-card-icon,
.product-card:hover .ck-card-icon,
.feature-card:hover .ck-card-icon,
.system-card:hover .ck-card-icon {
  border-color: rgba(245, 245, 255, 0.62) !important;
  box-shadow:
    0 0 10px rgba(245, 245, 255, 0.28),
    0 0 28px rgba(255, 42, 163, 0.70),
    inset 0 0 22px rgba(255, 42, 163, 0.22) !important;
  filter: saturate(1.16) brightness(1.08) !important;
}

/* Buttons and chips */
.ck-pill-button:hover,
.ck-chip:hover,
.ck-menu:hover,
button:hover,
a.button:hover,
[role="button"]:hover {
  border-color: rgba(245, 245, 255, 0.58) !important;
  box-shadow:
    0 0 0 1px rgba(215, 215, 223, 0.14),
    0 0 22px rgba(215, 215, 223, 0.16),
    0 0 34px rgba(255, 42, 163, 0.38) !important;
  color: var(--ck-cold-silver-hot) !important;
}

/* Primary magenta button keeps hot magenta but gains silver edge */
.ck-pill-button.primary:hover,
button.primary:hover,
.ck-newsletter-form button:hover,
.ck-founder-hard-form button:hover {
  transform: translateY(-3px) scale(1.015) !important;
  box-shadow:
    0 0 0 1px rgba(245, 245, 255, 0.34),
    0 0 22px rgba(245, 245, 255, 0.18),
    0 0 48px rgba(255, 42, 163, 0.58) !important;
}

/* Search bar hover/focus state */
.ck-search:hover,
.ck-search:focus-within {
  border-color: rgba(245, 245, 255, 0.48) !important;
  box-shadow:
    0 0 0 1px rgba(215, 215, 223, 0.12),
    0 0 30px rgba(215, 215, 223, 0.14),
    0 0 56px rgba(255, 42, 163, 0.30),
    inset 0 0 34px rgba(255, 42, 163, 0.09) !important;
}

.ck-search:hover svg,
.ck-search:focus-within svg {
  color: var(--ck-cold-silver-hot) !important;
  filter:
    drop-shadow(0 0 7px rgba(215, 215, 223, 0.58))
    drop-shadow(0 0 13px rgba(255, 42, 163, 0.46)) !important;
}

.ck-search input:focus {
  color: var(--ck-cold-silver-hot) !important;
}

/* Nav link silver shimmer */
.ck-links a:hover,
nav a:hover {
  color: var(--ck-cold-silver-hot) !important;
  text-shadow:
    0 0 8px rgba(215, 215, 223, 0.34),
    0 0 16px rgba(255, 42, 163, 0.24) !important;
}

/* Arrow/bars glow inside cards */
.ck-card:hover .ck-card-arrow,
.category-card:hover .ck-card-arrow,
.product-card:hover .ck-card-arrow {
  border-color: rgba(245, 245, 255, 0.48) !important;
  color: var(--ck-cold-silver-hot) !important;
  box-shadow:
    0 0 12px rgba(215, 215, 223, 0.20),
    0 0 22px rgba(255, 42, 163, 0.28) !important;
}

.ck-card:hover .ck-bars i,
.category-card:hover .ck-bars i,
.product-card:hover .ck-bars i {
  background: var(--ck-cold-silver-hot) !important;
  box-shadow:
    0 0 8px rgba(245, 245, 255, 0.46),
    0 0 16px rgba(255, 42, 163, 0.36) !important;
}

/* Respect users who prefer reduced motion */
@media (prefers-reduced-motion: reduce) {
  a,
  button,
  .ck-chip,
  .ck-pill-button,
  .ck-menu,
  .ck-card,
  .category-card,
  .product-card,
  .feature-card,
  .system-card,
  .ck-card-icon,
  .ck-search,
  input,
  textarea {
    transition: none !important;
  }

  .ck-card:hover,
  .category-card:hover,
  .product-card:hover,
  .feature-card:hover,
  .system-card:hover,
  .ck-pill-button.primary:hover {
    transform: none !important;
  }
}
/* CK COLD SILVER CURSOR AND HOVER GLOW END */
'''

text = text.rstrip() + "\n\n" + block.strip() + "\n"
path.write_text(text, encoding="utf-8")
PY

echo
echo "Installed cold silver cursor and hover glow."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
