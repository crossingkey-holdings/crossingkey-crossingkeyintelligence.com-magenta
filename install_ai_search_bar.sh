#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/ai_search_bar_$STAMP"

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
cp -a src/ck-ai-search.js "$BACKUP_DIR/ck-ai-search.js" 2>/dev/null || true

cat > src/ck-ai-search.js <<'JS'
const CK_CATEGORIES = [
  {
    title: "Documentation Archives",
    tags: "documentation records manuals proof files policies receipts product docs engineering standard"
  },
  {
    title: "Developer Libraries",
    tags: "developer code utilities components implementation patterns reusable libraries"
  },
  {
    title: "Infrastructure Toolkits",
    tags: "infrastructure deployment maps cloudflare server logic install flows public private systems"
  },
  {
    title: "Automation Frameworks",
    tags: "automation workflows governed execution pipelines scripts repeatable tasks"
  },
  {
    title: "API Components",
    tags: "api endpoints request contracts schemas payment gates mocks integration modules"
  },
  {
    title: "Website & Business Templates",
    tags: "website templates storefront landing pages business pages shopify dashboards"
  },
  {
    title: "Dashboard Systems",
    tags: "dashboard console operator status board control panel monitoring interface"
  },
  {
    title: "AI Agent Systems",
    tags: "ai agents roles routing memory instructions controlled execution"
  },
  {
    title: "Prompt & Workflow Systems",
    tags: "prompts prompt packs workflows sops decision flows ai work patterns"
  },
  {
    title: "Creator Systems",
    tags: "creator assets story visual packs content series pipelines"
  },
  {
    title: "Knowledge Systems",
    tags: "knowledge vault memory bank index research maps searchable intelligence"
  },
  {
    title: "Brand Systems",
    tags: "brand identity copy naming ui language public architecture"
  },
  {
    title: "Education Systems",
    tags: "education training guides lessons operator handbooks skill paths"
  },
  {
    title: "Internal Governance Systems",
    tags: "governance rules controls audits access approval standards authority"
  },
  {
    title: "Enterprise Solution Suites",
    tags: "enterprise suites strategy infrastructure documentation deployment support"
  }
];

function normalize(value) {
  return String(value || "").toLowerCase().trim();
}

function findSearchInput() {
  return (
    document.querySelector("[data-ck-search]") ||
    document.querySelector(".ck-search input") ||
    document.querySelector("input[type='search']") ||
    document.querySelector("input[placeholder*='Search']")
  );
}

function findCards() {
  return Array.from(
    document.querySelectorAll(".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']")
  ).filter((card) => {
    const rect = card.getBoundingClientRect();
    const text = normalize(card.textContent);
    return rect.width >= 120 && rect.height >= 120 && text.length >= 20 && !card.closest("header, nav, footer, form, .ck-search");
  });
}

function filterCards(query) {
  const q = normalize(query);
  const cards = findCards();

  cards.forEach((card) => {
    const haystack = normalize([
      card.dataset.title,
      card.dataset.tags,
      card.textContent
    ].join(" "));

    const show = !q || haystack.includes(q);
    card.style.display = show ? "" : "none";
  });
}

function bestLocalMatch(query) {
  const q = normalize(query);
  if (!q) return "";

  let best = null;
  let bestScore = 0;

  for (const item of CK_CATEGORIES) {
    const hay = normalize(item.title + " " + item.tags);
    let score = 0;

    for (const word of q.split(/\s+/).filter(Boolean)) {
      if (hay.includes(word)) score += 1;
    }

    if (score > bestScore) {
      best = item;
      bestScore = score;
    }
  }

  return best ? best.title : query;
}

async function getBrowserAIAnswer(query) {
  const prompt = [
    "You are CrossingKey Intelligence search routing logic.",
    "Map this user search into one concise CrossingKey category or short product-search phrase.",
    "Do not answer conversationally.",
    "Return only the improved search phrase.",
    "",
    "Categories:",
    ...CK_CATEGORIES.map((item) => `- ${item.title}: ${item.tags}`),
    "",
    `User search: ${query}`
  ].join("\n");

  try {
    if (window.LanguageModel && typeof window.LanguageModel.create === "function") {
      const session = await window.LanguageModel.create();
      const result = await session.prompt(prompt);
      return String(result || "").trim();
    }

    if (window.ai && window.ai.languageModel && typeof window.ai.languageModel.create === "function") {
      const session = await window.ai.languageModel.create();
      const result = await session.prompt(prompt);
      return String(result || "").trim();
    }

    if (window.ai && typeof window.ai.createTextSession === "function") {
      const session = await window.ai.createTextSession();
      const result = await session.prompt(prompt);
      return String(result || "").trim();
    }

    return "";
  } catch (error) {
    console.warn("CrossingKey browser AI search unavailable:", error);
    return "";
  }
}

function setSearchStatus(text) {
  let status = document.querySelector("[data-ck-ai-search-status]");

  if (!status) {
    status = document.createElement("div");
    status.dataset.ckAiSearchStatus = "1";
    status.className = "ck-ai-search-status";

    const search = document.querySelector(".ck-search");
    if (search && search.parentElement) {
      search.parentElement.insertBefore(status, search.nextSibling);
    }
  }

  status.textContent = text;
}

async function runAISearch(rawQuery) {
  const query = String(rawQuery || "").trim();
  if (!query) {
    filterCards("");
    setSearchStatus("");
    return;
  }

  setSearchStatus("Routing search through CrossingKey command logic…");

  const aiPhrase = await getBrowserAIAnswer(query);
  const finalPhrase = aiPhrase || bestLocalMatch(query);

  filterCards(finalPhrase);
  setSearchStatus(
    aiPhrase
      ? `AI route: ${finalPhrase}`
      : `Local route: ${finalPhrase}`
  );
}

function bootAISearch() {
  const input = findSearchInput();
  if (!input) return;

  const searchButton =
    document.querySelector(".ck-search button") ||
    input.closest(".ck-search")?.querySelector("button");

  let timer = null;

  input.addEventListener("input", () => {
    clearTimeout(timer);
    timer = setTimeout(() => {
      filterCards(input.value);
    }, 120);
  });

  input.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      runAISearch(input.value);
    }
  });

  if (searchButton) {
    searchButton.addEventListener("click", (event) => {
      event.preventDefault();
      runAISearch(input.value);
    });
  }

  const hasPromptAPI =
    Boolean(window.LanguageModel && typeof window.LanguageModel.create === "function") ||
    Boolean(window.ai);

  setSearchStatus(
    hasPromptAPI
      ? "Browser AI route available. Press Enter to run command search."
      : "Local command search active. Browser AI will activate when supported."
  );
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootAISearch, { once: true });
} else {
  bootAISearch();
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

text = re.sub(
    r"/\* CK AI SEARCH BAR START \*/.*?/\* CK AI SEARCH BAR END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK AI SEARCH BAR START */
.ck-ai-search-status {
  margin-top: 12px;
  color: rgba(255, 42, 163, 0.92);
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  text-shadow: 0 0 14px rgba(255, 42, 163, 0.35);
}
/* CK AI SEARCH BAR END */
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
line = 'import "./ck-ai-search.js";'

text = "\n".join(row for row in text.splitlines() if row.strip() != line)
text = line + "\n" + text.strip() + "\n"

path.write_text(text, encoding="utf-8")
PY

echo
echo "AI-enhanced CrossingKey search bar installed."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
