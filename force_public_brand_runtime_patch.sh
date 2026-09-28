#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/force_public_brand_runtime_$STAMP"

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
cp -a src/ck-public-brand-runtime.js "$BACKUP_DIR/ck-public-brand-runtime.js" 2>/dev/null || true

cat > src/ck-public-brand-runtime.js <<'JS'
function normalizeText(value) {
  return String(value || "").replace(/\s+/g, " ").trim();
}

function forceHeroToCrossingKey() {
  const heroTitle =
    document.querySelector(".ck-title") ||
    Array.from(document.querySelectorAll("h1")).find((node) =>
      normalizeText(node.textContent).toLowerCase().includes("crossingkey")
    );

  if (heroTitle) {
    heroTitle.innerHTML = "CrossingKey";
    heroTitle.dataset.ckPublicBrandPatched = "1";
  }
}

function forceShopifyCopy() {
  const allNodes = Array.from(document.querySelectorAll("h1,h2,h3,p,a,button,span,div"));

  allNodes.forEach((node) => {
    const text = normalizeText(node.textContent);

    if (text === "Open Shopify Store" || text === "Open Store") {
      node.textContent = "Join CrossingKey";
    }

    if (text === "Checkout lives on Shopify.") {
      node.textContent = "Join CrossingKey.";
    }

    if (
      text ===
      "Current products, pricing, availability, order confirmation, checkout, and delivery details are handled through the official CrossingKey Intelligence Shopify storefront."
    ) {
      node.textContent =
        "Enter the official CrossingKey storefront for products, pricing, availability, checkout, order confirmation, and digital delivery.";
    }

    if (
      text ===
      "Current products, pricing, availability, order confirmation, checkout, and delivery details are handled through the official CrossingKey Shopify storefront."
    ) {
      node.textContent =
        "Enter the official CrossingKey storefront for products, pricing, availability, checkout, order confirmation, and digital delivery.";
    }
  });
}

function forcePublicBrand() {
  forceHeroToCrossingKey();
  forceShopifyCopy();

  document.title = "CrossingKey | Intelligence is the standard";
}

function bootPublicBrandPatch() {
  forcePublicBrand();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(forcePublicBrand);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
    characterData: true
  });

  setTimeout(forcePublicBrand, 250);
  setTimeout(forcePublicBrand, 1000);
  setTimeout(forcePublicBrand, 2500);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootPublicBrandPatch, { once: true });
} else {
  bootPublicBrandPatch();
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
    r"/\* CK PUBLIC BRAND RUNTIME PATCH START \*/.*?/\* CK PUBLIC BRAND RUNTIME PATCH END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK PUBLIC BRAND RUNTIME PATCH START */
.ck-title,
h1[data-ck-public-brand-patched="1"] {
  max-width: 820px !important;
  font-size: clamp(84px, 9.5vw, 146px) !important;
  line-height: 0.82 !important;
  letter-spacing: -0.075em !important;
}

.ck-title span {
  display: none !important;
}

@media (max-width: 760px) {
  .ck-title,
  h1[data-ck-public-brand-patched="1"] {
    font-size: clamp(62px, 17vw, 92px) !important;
    line-height: 0.88 !important;
  }
}
/* CK PUBLIC BRAND RUNTIME PATCH END */
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
line = 'import "./ck-public-brand-runtime.js";'

text = "\n".join(row for row in text.splitlines() if row.strip() != line)
text = line + "\n" + text.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo
echo "Runtime brand patch installed."
echo "Hero will force to: CrossingKey"
echo "Shopify button will force to: Join CrossingKey"
echo "Backup saved to: $BACKUP_DIR"
