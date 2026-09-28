#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/force_founder_banner_over_status_$STAMP"

mkdir -p "$BACKUP_DIR" src public/assets .ck_backups

if [ -x "./ck_visual_unlock.sh" ]; then
  ./ck_visual_unlock.sh || true
fi

cp -a src/main.js "$BACKUP_DIR/main.js" 2>/dev/null || true
cp -a src/main.jsx "$BACKUP_DIR/main.jsx" 2>/dev/null || true
cp -a src/main.ts "$BACKUP_DIR/main.ts" 2>/dev/null || true
cp -a src/main.tsx "$BACKUP_DIR/main.tsx" 2>/dev/null || true
cp -a src/styles.css "$BACKUP_DIR/styles.css" 2>/dev/null || true
cp -a src/style.css "$BACKUP_DIR/style.css" 2>/dev/null || true
cp -a src/ck-founder-status-banner.js "$BACKUP_DIR/ck-founder-status-banner.js" 2>/dev/null || true
cp -a src/ck-founder-newsletter.js "$BACKUP_DIR/ck-founder-newsletter.js" 2>/dev/null || true

if [ ! -f public/assets/founder.jpg ] && [ ! -f public/assets/founder.png ]; then
  cat > public/assets/founder-placeholder.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 1100">
  <defs>
    <radialGradient id="bg" cx="50%" cy="25%" r="80%">
      <stop offset="0%" stop-color="#350021"/>
      <stop offset="55%" stop-color="#11000b"/>
      <stop offset="100%" stop-color="#050508"/>
    </radialGradient>
  </defs>
  <rect width="900" height="1100" fill="url(#bg)"/>
  <circle cx="450" cy="340" r="138" fill="none" stroke="#ff2aa3" stroke-width="12" opacity=".78"/>
  <path d="M210 880c42-210 438-210 480 0" fill="none" stroke="#ff2aa3" stroke-width="14" opacity=".78"/>
  <text x="450" y="995" text-anchor="middle" fill="#d7d7df" font-family="Arial" font-size="44" letter-spacing="9">FOUNDER</text>
</svg>
SVG
fi

cat > src/ck-founder-status-banner.js <<'JS'
const CK_NAVIGATOR_QUOTES = [
  "I don't look up to find meaning; I build it on the concrete I'm standing on.",
  "When the machine breaks, I don't panic. I get my hands in the wiring and force it to work.",
  "The life I lived wasn't a tragedy. It was the exact friction I needed to grind myself into a weapon.",
  "Being tough is for the streets. I built my mind like armor—matte-black and built to take the hit without flinching.",
  "I didn't just recover from addiction. I ripped the compromised code out of my head and wrote a new baseline from scratch.",
  "Motivation is a fleeting high for amateurs. I run on cold, engineered intent.",
  "I spent years in the shadows of this system, not hiding, but learning exactly how to take it apart.",
  "I don't wait for a light at the end of the tunnel. I strike the match and burn my own path through the dark.",
  "Hope is for victims waiting to be saved. I guarantee my survival through absolute execution.",
  "Despair is a dead end. When I hit the wall, I strip everything down to zero and start swinging a hammer.",
  "I don't dream about the future. I lay the iron down and build the damn thing.",
  "I use destruction like a scalpel. You have to burn the old structures down to the studs before you can build an empire.",
  "I'm not looking to be saved. I take the broken pieces, own the failure, and engineer a better outcome.",
  "I've looked damnation in the eye. It's just another room you have to walk through to get to the work.",
  "Let them condemn my past. The ghost of who I was has absolutely no bearing on the strike I'm making today.",
  "The cell wasn't a cage; it was the violent isolation I required to burn away the noise and figure out who I actually am.",
  "True freedom isn't doing whatever you want. It's having absolute control over the parameters of your own mind.",
  "I don't serve a broken machine. I build systems that serve my exact intent, and I hold them to the fire until they deliver.",
  "My duty is holding the line. I take the heaviest cognitive load so the people I care about don't have to carry it.",
  "I don't tolerate amateur hour. I strip away the weak variables until all that's left is pure, disciplined execution.",
  "I don't sit around waiting for divine intervention. I act as the architect of the reality in front of me.",
  "I've danced with the devil, and I learned his rhythm. Now I extract the flaws and crush them under my own weight.",
  "Good is subjective. I measure my actions by one metric: does it advance the objective or does it hold me back?",
  "Evil is just a misaligned intent. You don't negotiate with it; you aggressively correct the trajectory.",
  "In that gray, muddy middle ground, I am the one who draws a hard line in the dirt.",
  "A real woman isn't a distraction. She is a vital, stabilizing pillar when the rest of the grid is tearing itself apart.",
  "Sex isn't an escape. It's a raw transfer of kinetic energy that pulls a high-speed mind violently back into the physical world.",
  "Love isn't a vulnerability. It’s the highest-bandwidth connection you can forge in a world that’s constantly trying to disconnect you.",
  "I don't let hate consume me. I refine it into a high-yield fuel and use it to power a relentless advance.",
  "I left the blind street fights behind. Now, I control the theater. I decide when we clash, and I decide when it ends.",
  "I don't relax. I decompress. It's a calculated cooldown so the engine doesn't blow before the next strike.",
  "My calm isn't peace. It's the absolute zero-point focus right before I execute the command.",
  "When everything around me shakes, I lock my eyes forward, dig my heels in, and hold the center.",
  "I don't fear an enemy. I study them, deconstruct their logic, and systematically take them apart.",
  "The only enemy that can actually kill me is my own hesitation.",
  "A friend is someone who has proven they can hold the line next to you when the pressure drops.",
  "I know the false frequency of drugs. I rejected that synthetic static for the raw, brutal clarity of reality.",
  "I don't drink to forget. I use the friction of a glass of whiskey to momentarily drop the shield and see where I'm bruised.",
  "Hotels are just transient waystations. Temporary outposts while I push this vision forward.",
  "I did my quietest, most desperate work in the shadow of cheap motels, turning barren rooms into command centers.",
  "I know death is the final reset. That's why I'm building a legacy that survives long after my hardware gives out.",
  "Life is the raw, uncut material. You have to force it through the grinder to extract anything of value.",
  "I don't float down the river. I dam the chaotic flow and force the water exactly where I need the power.",
  "I don't climb the mountain for the view. I look at the geometry and figure out the fastest way to blast through the rock.",
  "Staring down the deep water, I don't look for a lighthouse. I become the emerald-green Northstar of my own fleet.",
  "The stars aren't there to grant wishes. They're fixed coordinates so I can plot my exact trajectory.",
  "I don't bask in the sun. I channel that blinding heat into a focused beam that cuts straight through the noise.",
  "While the rest of the world sleeps under the silver light, I'm running the background processes, letting the pieces clash.",
  "Discipline isn't a punishment. It's the absolute bedrock I had to lay down before I could build anything real.",
  "I weaponize patience. It's holding the kinetic tension in your hands until the exact microsecond you need to strike."
];

const CK_QUOTE_CHANGE_MS = 240000;
const CK_MIDPOINT_PULSE_MS = 120000;

function founderPhotoSource() {
  if (document.querySelector("img[src='/assets/founder.png']")) return "/assets/founder.png";
  return "/assets/founder.jpg";
}

function fallbackPhotoSource() {
  return "/assets/founder-placeholder.svg";
}

function createFounderBanner() {
  const section = document.createElement("section");
  section.id = "founder-signal";
  section.className = "ck-founder-status-replacement";

  section.innerHTML = `
    <div class="ck-founder-signal-photo-wrap">
      <img class="ck-founder-signal-photo" src="${founderPhotoSource()}" alt="CrossingKey Intelligence founder">
      <div class="ck-founder-signal-photo-overlay"></div>
    </div>

    <div class="ck-founder-signal-main">
      <div class="ck-label">Founder Signal</div>
      <h2>Weekly intelligence from the operator seat.</h2>
      <p>
        Subscribe free for the CrossingKey weekly signal: AI systems, operator engineering,
        commercial infrastructure, documentation discipline, and founder-grade execution notes.
      </p>

      <form class="ck-founder-newsletter-form" data-ck-founder-newsletter-form>
        <input type="email" name="email" placeholder="Enter your email for the free weekly signal" required>
        <button type="submit">Subscribe Free</button>
      </form>

      <div class="ck-founder-newsletter-msg" data-ck-founder-newsletter-msg></div>

      <div class="ck-founder-upgrade-line">
        <span>After the free issue lands, readers can upgrade into the paid educational newsletter for deeper systems, lessons, and implementation frameworks.</span>
        <a href="/pricing.html#newsletter">Paid Education Path</a>
      </div>
    </div>

    <aside class="ck-founder-quote-box">
      <div class="ck-label">Navigator Quote</div>
      <blockquote data-ck-founder-quote></blockquote>
      <div class="ck-founder-quote-footer">
        <span data-ck-founder-quote-count>01 / 50</span>
        <span>changes every 240s</span>
      </div>
    </aside>
  `;

  return section;
}

function isSystemStatusNode(node) {
  if (!node || node.nodeType !== 1) return false;
  if (node.id === "founder-signal") return false;

  const text = (node.textContent || "").toLowerCase().replace(/\s+/g, " ");

  const hasOldStatus =
    text.includes("public interface") &&
    text.includes("shopify") &&
    (text.includes("15 mapped") || text.includes("15 categories") || text.includes("categories")) &&
    text.includes("digital");

  const hasCommandGateway =
    text.includes("checkout") &&
    text.includes("shopify") &&
    text.includes("categories");

  return hasOldStatus || hasCommandGateway;
}

function findBestStatusContainer() {
  const all = Array.from(document.querySelectorAll("section, .ck-section, div"));

  const candidates = all
    .filter(isSystemStatusNode)
    .map((node) => {
      const rect = node.getBoundingClientRect();
      const text = node.textContent || "";
      return { node, area: rect.width * rect.height, textLength: text.length };
    })
    .filter((item) => item.area > 5000 && item.textLength < 2600)
    .sort((a, b) => b.area - a.area);

  if (candidates.length) {
    let target = candidates[0].node;

    const sectionParent = target.closest("section");
    if (sectionParent && isSystemStatusNode(sectionParent)) {
      target = sectionParent;
    }

    return target;
  }

  return null;
}

function replaceStatusWithFounderBanner() {
  if (document.querySelector("#founder-signal")) return true;

  const target = findBestStatusContainer();
  if (!target || !target.parentElement) return false;

  const banner = createFounderBanner();
  target.replaceWith(banner);

  const img = banner.querySelector(".ck-founder-signal-photo");
  if (img) {
    img.addEventListener("error", () => {
      img.src = fallbackPhotoSource();
    }, { once: true });
  }

  bootQuoteCycle(banner);
  bootNewsletterCapture(banner);

  return true;
}

function bootQuoteCycle(root) {
  const quoteEl = root.querySelector("[data-ck-founder-quote]");
  const countEl = root.querySelector("[data-ck-founder-quote-count]");
  if (!quoteEl || !countEl) return;

  let index = 0;
  let midpointTimer = null;
  let changeTimer = null;

  function renderQuote() {
    root.classList.remove("ck-founder-quote-midpoint", "ck-founder-quote-changing");

    quoteEl.textContent = CK_NAVIGATOR_QUOTES[index];
    countEl.textContent = `${String(index + 1).padStart(2, "0")} / ${CK_NAVIGATOR_QUOTES.length}`;
  }

  function scheduleNext() {
    clearTimeout(midpointTimer);
    clearTimeout(changeTimer);

    midpointTimer = setTimeout(() => {
      root.classList.add("ck-founder-quote-midpoint");
    }, CK_MIDPOINT_PULSE_MS);

    changeTimer = setTimeout(() => {
      root.classList.add("ck-founder-quote-changing");

      setTimeout(() => {
        index = (index + 1) % CK_NAVIGATOR_QUOTES.length;
        renderQuote();
        scheduleNext();
      }, 900);
    }, CK_QUOTE_CHANGE_MS);
  }

  renderQuote();
  scheduleNext();
}

function bootNewsletterCapture(root) {
  const form = root.querySelector("[data-ck-founder-newsletter-form]");
  const msg = root.querySelector("[data-ck-founder-newsletter-msg]");
  if (!form || !msg) return;

  form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const email = String(new FormData(form).get("email") || "").trim();

    if (!email || !email.includes("@")) {
      msg.textContent = "Enter a valid email address.";
      return;
    }

    localStorage.setItem("ck_founder_signal_email", email);

    msg.textContent = "Captured. Connect the newsletter endpoint next so weekly emails send automatically.";
    form.reset();
  });
}

function bootFounderStatusReplacement() {
  if (replaceStatusWithFounderBanner()) return;

  const observer = new MutationObserver(() => {
    if (replaceStatusWithFounderBanner()) {
      observer.disconnect();
    }
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });

  setTimeout(() => observer.disconnect(), 15000);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootFounderStatusReplacement, { once: true });
} else {
  bootFounderStatusReplacement();
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
    r"/\* CK FOUNDER STATUS REPLACEMENT START \*/.*?/\* CK FOUNDER STATUS REPLACEMENT END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK FOUNDER STATUS REPLACEMENT START */
.ck-founder-status-replacement {
  margin: 58px 0 0;
  display: grid;
  grid-template-columns: 300px minmax(0, 1fr) 390px;
  gap: 26px;
  align-items: stretch;
  border: 1px solid rgba(255, 42, 163, 0.34);
  border-radius: 28px;
  padding: 28px;
  background:
    radial-gradient(circle at 14% 20%, rgba(255, 42, 163, 0.25), transparent 18rem),
    radial-gradient(circle at 88% 14%, rgba(255, 42, 163, 0.16), transparent 18rem),
    linear-gradient(180deg, rgba(22, 7, 18, 0.84), rgba(6, 3, 8, 0.92));
  box-shadow:
    0 36px 90px rgba(0, 0, 0, 0.44),
    0 0 36px rgba(255, 42, 163, 0.14);
  position: relative;
  overflow: hidden;
}

.ck-founder-status-replacement::before {
  content: "";
  position: absolute;
  inset: 0;
  background:
    repeating-linear-gradient(90deg, transparent 0 42px, rgba(255, 42, 163, 0.08) 43px 44px, transparent 45px 84px);
  opacity: .52;
  pointer-events: none;
}

.ck-founder-status-replacement > * {
  position: relative;
  z-index: 1;
}

.ck-founder-signal-photo-wrap {
  min-height: 360px;
  border: 1px solid rgba(255, 42, 163, 0.46);
  border-radius: 24px;
  overflow: hidden;
  background: #050508;
  box-shadow:
    0 0 24px rgba(255, 42, 163, 0.24),
    inset 0 0 24px rgba(255, 42, 163, 0.10);
  position: relative;
}

.ck-founder-signal-photo {
  width: 100%;
  height: 100%;
  min-height: 360px;
  object-fit: cover;
  display: block;
  filter: grayscale(1) contrast(1.08);
}

.ck-founder-signal-photo-overlay {
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at 52% 34%, transparent 0 34%, rgba(255, 42, 163, 0.20) 70%, rgba(0, 0, 0, 0.58) 100%),
    linear-gradient(180deg, transparent 38%, rgba(0, 0, 0, 0.62));
  pointer-events: none;
}

.ck-founder-signal-main {
  padding: 12px 4px;
}

.ck-founder-signal-main h2 {
  margin: 12px 0 16px;
  font-size: clamp(34px, 4vw, 60px);
  line-height: .95;
  letter-spacing: -.045em;
  font-weight: 300;
}

.ck-founder-signal-main p {
  max-width: 760px;
  color: rgba(215, 215, 223, .74);
  font-size: 17px;
  line-height: 1.65;
}

.ck-founder-newsletter-form {
  margin-top: 24px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  max-width: 780px;
}

.ck-founder-newsletter-form input {
  min-height: 58px;
  border: 1px solid rgba(255, 42, 163, .38);
  border-radius: 999px;
  background: rgba(0, 0, 0, .32);
  color: #f4f4f7;
  padding: 0 22px;
  outline: none;
}

.ck-founder-newsletter-form input::placeholder {
  color: rgba(215, 215, 223, .44);
}

.ck-founder-newsletter-form button {
  min-height: 58px;
  border: 0;
  border-radius: 999px;
  padding: 0 24px;
  color: #090006;
  background: linear-gradient(135deg, #ff1493, #ff55bf);
  font-weight: 900;
  cursor: pointer;
  box-shadow: 0 0 28px rgba(255, 42, 163, .38);
}

.ck-founder-newsletter-msg {
  min-height: 22px;
  margin-top: 12px;
  color: rgba(255, 42, 163, .92);
  font-size: 13px;
  font-weight: 800;
}

.ck-founder-upgrade-line {
  margin-top: 20px;
  max-width: 780px;
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  border: 1px solid rgba(255, 42, 163, .26);
  border-radius: 18px;
  padding: 16px 18px;
  background: rgba(0, 0, 0, .24);
  color: rgba(215, 215, 223, .68);
  font-size: 14px;
  line-height: 1.45;
}

.ck-founder-upgrade-line a {
  white-space: nowrap;
  color: #ff2aa3;
  font-weight: 900;
}

.ck-founder-quote-box {
  border: 1px solid rgba(255, 42, 163, .32);
  border-radius: 24px;
  padding: 24px;
  background:
    radial-gradient(circle at 20% 0%, rgba(255, 42, 163, .20), transparent 14rem),
    rgba(0, 0, 0, .30);
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 360px;
  transition:
    box-shadow 1.8s ease,
    border-color 1.8s ease,
    transform 1.8s ease;
}

.ck-founder-quote-box blockquote {
  margin: 28px 0;
  color: #f4f4f7;
  font-size: clamp(23px, 2.1vw, 31px);
  line-height: 1.24;
  letter-spacing: -.03em;
  font-weight: 300;
  opacity: 1;
  transition: opacity .9s ease, transform .9s ease;
}

.ck-founder-quote-footer {
  display: flex;
  justify-content: space-between;
  gap: 18px;
  color: rgba(215, 215, 223, .54);
  font-size: 11px;
  letter-spacing: .14em;
  text-transform: uppercase;
}

.ck-founder-status-replacement.ck-founder-quote-midpoint .ck-founder-quote-box {
  border-color: rgba(255, 42, 163, .58);
  box-shadow:
    0 0 18px rgba(255, 42, 163, .26),
    inset 0 0 20px rgba(255, 42, 163, .10);
}

.ck-founder-status-replacement.ck-founder-quote-changing .ck-founder-quote-box blockquote {
  opacity: .18;
  transform: translateY(6px);
}

@media (max-width: 1250px) {
  .ck-founder-status-replacement {
    grid-template-columns: 280px 1fr;
  }

  .ck-founder-quote-box {
    grid-column: 1 / -1;
    min-height: 260px;
  }
}

@media (max-width: 760px) {
  .ck-founder-status-replacement {
    grid-template-columns: 1fr;
    padding: 20px;
  }

  .ck-founder-signal-photo-wrap,
  .ck-founder-signal-photo {
    min-height: 320px;
  }

  .ck-founder-newsletter-form {
    grid-template-columns: 1fr;
  }

  .ck-founder-upgrade-line {
    flex-direction: column;
    align-items: flex-start;
  }
}
/* CK FOUNDER STATUS REPLACEMENT END */
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

lines_to_remove = {
    'import "./ck-founder-newsletter.js";',
    'import "./ck-founder-status-banner.js";'
}

rows = [row for row in text.splitlines() if row.strip() not in lines_to_remove]
line = 'import "./ck-founder-status-banner.js";'
rows.insert(0, line)

path.write_text("\n".join(rows).strip() + "\n", encoding="utf-8")
PY

echo
echo "Founder banner is now forced over the System Status row."
echo "Quotes change every 240 seconds with a midpoint pulse at 120 seconds."
echo "Backup saved to: $BACKUP_DIR"
echo
echo "Restart Vite:"
echo "  pkill -f 'vite.*6020' 2>/dev/null || true"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
