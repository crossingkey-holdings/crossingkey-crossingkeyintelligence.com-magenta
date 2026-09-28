#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/refine_crossingkey_hero_stack_$STAMP"

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
cp -a src/ck-hero-stack.js "$BACKUP_DIR/ck-hero-stack.js" 2>/dev/null || true

cat > src/ck-hero-stack.js <<'JS'
function refineCrossingKeyHero() {
  const title =
    document.querySelector(".ck-title") ||
    Array.from(document.querySelectorAll("h1")).find((node) =>
      String(node.textContent || "").toLowerCase().includes("crossingkey")
    );

  if (!title) return;

  title.innerHTML = "CrossingKey";
  title.classList.add("ck-crossingkey-title-final");

  let doctrine = document.querySelector(".ck-hero-doctrine-line");

  if (!doctrine) {
    doctrine = document.createElement("div");
    doctrine.className = "ck-hero-doctrine-line";
    doctrine.textContent = "Intelligence is the standard.";
    title.insertAdjacentElement("afterend", doctrine);
  }

  const subtitle =
    document.querySelector(".ck-subtitle") ||
    document.querySelector(".hero-subtitle") ||
    Array.from(document.querySelectorAll("p")).find((node) =>
      String(node.textContent || "").toLowerCase().includes("inspect, govern")
    );

  if (subtitle) {
    subtitle.textContent = "Intelligence systems built to inspect, govern, automate, and deliver.";
    subtitle.classList.add("ck-hero-subtitle-final");
  }
}

function bootHeroStack() {
  refineCrossingKeyHero();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(refineCrossingKeyHero);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true,
    characterData: true
  });

  setTimeout(refineCrossingKeyHero, 250);
  setTimeout(refineCrossingKeyHero, 1000);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootHeroStack, { once: true });
} else {
  bootHeroStack();
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
    r"/\* CK HERO STACK FINAL START \*/.*?/\* CK HERO STACK FINAL END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK HERO STACK FINAL START */
.ck-crossingkey-title-final,
.ck-title {
  max-width: 840px !important;
  margin-bottom: 0 !important;
  font-size: clamp(88px, 9.5vw, 148px) !important;
  line-height: 0.78 !important;
  letter-spacing: -0.078em !important;
}

.ck-title span {
  display: none !important;
}

.ck-hero-doctrine-line {
  margin-top: 18px;
  color: #ff2aa3;
  font-size: clamp(34px, 4.1vw, 62px);
  line-height: 0.95;
  letter-spacing: -0.055em;
  font-weight: 300;
  text-shadow:
    0 0 18px rgba(255, 42, 163, 0.32),
    0 0 38px rgba(255, 42, 163, 0.18);
}

.ck-hero-subtitle-final,
.ck-subtitle {
  margin-top: 22px !important;
  max-width: 720px !important;
  width: 720px !important;
  color: rgba(215, 215, 223, 0.78) !important;
  font-size: 20px !important;
  line-height: 1.42 !important;
}

@media (max-width: 900px) {
  .ck-crossingkey-title-final,
  .ck-title {
    font-size: clamp(62px, 16vw, 96px) !important;
  }

  .ck-hero-doctrine-line {
    font-size: clamp(34px, 10vw, 54px);
  }

  .ck-hero-subtitle-final,
  .ck-subtitle {
    width: auto !important;
    max-width: 100% !important;
    font-size: 18px !important;
  }
}
/* CK HERO STACK FINAL END */
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
line = 'import "./ck-hero-stack.js";'

text = "\n".join(row for row in text.splitlines() if row.strip() != line)
text = line + "\n" + text.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo
echo "Hero refined:"
echo "  CrossingKey"
echo "  Intelligence is the standard."
echo "  Intelligence systems built to inspect, govern, automate, and deliver."
echo
echo "Backup saved to: $BACKUP_DIR"
