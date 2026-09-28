#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR=".ck_backups/hard_mount_founder_banner_$STAMP"

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
cp -a src/ck-founder-hard-banner.js "$BACKUP_DIR/ck-founder-hard-banner.js" 2>/dev/null || true

cat > src/ck-founder-hard-banner.js <<'JS'
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

const CK_CHANGE_MS = 240000;
const CK_PULSE_MS = 120000;

function hideOldStatusRows() {
  const nodes = Array.from(document.querySelectorAll("section, div, article"));

  nodes.forEach((node) => {
    if (node.id === "founder-signal") return;

    const text = (node.textContent || "").toLowerCase().replace(/\s+/g, " ");
    const looksLikeStatus =
      text.includes("public interface") &&
      text.includes("shopify") &&
      text.includes("digital") &&
      (text.includes("15") || text.includes("categories"));

    if (looksLikeStatus) {
      node.style.display = "none";
      node.setAttribute("data-ck-hidden-system-status", "1");
    }
  });
}

function founderImage() {
  return "/assets/founder.jpg";
}

function createBanner() {
  const banner = document.createElement("section");
  banner.id = "founder-signal";
  banner.className = "ck-founder-hard-banner";

  banner.innerHTML = `
    <div class="ck-founder-hard-photo">
      <img src="${founderImage()}" alt="CrossingKey Intelligence founder" onerror="this.src='/assets/founder-placeholder.svg'">
    </div>

    <div class="ck-founder-hard-main">
      <div class="ck-label">Founder Signal</div>
      <h2>Weekly intelligence from the operator seat.</h2>
      <p>Subscribe free for the CrossingKey weekly signal: AI systems, operator engineering, commercial infrastructure, documentation discipline, and founder-grade execution notes.</p>

      <form class="ck-founder-hard-form" data-ck-founder-form>
        <input type="email" name="email" placeholder="Enter your email for the free weekly signal" required>
        <button type="submit">Subscribe Free</button>
      </form>

      <div class="ck-founder-hard-message" data-ck-founder-message></div>

      <div class="ck-founder-hard-upgrade">
        <span>After the free issue lands, readers can upgrade into the paid educational newsletter for deeper lessons, build systems, and implementation frameworks.</span>
        <a href="/pricing.html#newsletter">Paid Education Path</a>
      </div>
    </div>

    <aside class="ck-founder-hard-quote">
      <div class="ck-label">Navigator Quote</div>
      <blockquote data-ck-founder-quote>Loading Navigator quote...</blockquote>
      <div class="ck-founder-hard-count">
        <span data-ck-founder-count>01 / 50</span>
        <span>240s cycle · 120s pulse</span>
      </div>
    </aside>
  `;

  return banner;
}

function findMountPoint() {
  return (
    document.querySelector("#products") ||
    document.querySelector(".ck-grid") ||
    document.querySelector(".categories-grid") ||
    document.querySelector(".category-grid") ||
    document.querySelector("[class*='grid']")
  );
}

function mountBanner() {
  hideOldStatusRows();

  if (document.querySelector("#founder-signal")) {
    return true;
  }

  const mount = findMountPoint();
  if (!mount || !mount.parentElement) {
    return false;
  }

  const banner = createBanner();
  mount.insertAdjacentElement("afterend", banner);

  startQuotes(banner);
  startNewsletter(banner);

  return true;
}

function startQuotes(root) {
  const quote = root.querySelector("[data-ck-founder-quote]");
  const count = root.querySelector("[data-ck-founder-count]");
  let index = 0;

  function render() {
    root.classList.remove("ck-founder-hard-pulse", "ck-founder-hard-change");
    quote.textContent = CK_NAVIGATOR_QUOTES[index];
    count.textContent = `${String(index + 1).padStart(2, "0")} / ${CK_NAVIGATOR_QUOTES.length}`;
  }

  function schedule() {
    setTimeout(() => {
      root.classList.add("ck-founder-hard-pulse");
    }, CK_PULSE_MS);

    setTimeout(() => {
      root.classList.add("ck-founder-hard-change");

      setTimeout(() => {
        index = (index + 1) % CK_NAVIGATOR_QUOTES.length;
        render();
        schedule();
      }, 900);
    }, CK_CHANGE_MS);
  }

  render();
  schedule();
}

function startNewsletter(root) {
  const form = root.querySelector("[data-ck-founder-form]");
  const msg = root.querySelector("[data-ck-founder-message]");

  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const email = String(new FormData(form).get("email") || "").trim();

    if (!email || !email.includes("@")) {
      msg.textContent = "Enter a valid email address.";
      return;
    }

    localStorage.setItem("ck_founder_signal_email", email);
    msg.textContent = "Captured locally. Connect the newsletter endpoint next for automatic weekly delivery.";
    form.reset();
  });
}

function bootFounderBanner() {
  if (mountBanner()) return;

  const observer = new MutationObserver(() => {
    if (mountBanner()) {
      observer.disconnect();
    }
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });

  setTimeout(() => {
    mountBanner();
    observer.disconnect();
  }, 5000);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", bootFounderBanner, { once: true });
} else {
  bootFounderBanner();
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
    r"/\* CK HARD MOUNT FOUNDER BANNER START \*/.*?/\* CK HARD MOUNT FOUNDER BANNER END \*/",
    "",
    text,
    flags=re.S
)

block = """
/* CK HARD MOUNT FOUNDER BANNER START */
[data-ck-hidden-system-status="1"] {
  display: none !important;
}

.ck-founder-hard-banner {
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

.ck-founder-hard-banner::before {
  content: "";
  position: absolute;
  inset: 0;
  background:
    repeating-linear-gradient(90deg, transparent 0 42px, rgba(255, 42, 163, 0.08) 43px 44px, transparent 45px 84px);
  opacity: .52;
  pointer-events: none;
}

.ck-founder-hard-banner > * {
  position: relative;
  z-index: 1;
}

.ck-founder-hard-photo {
  min-height: 360px;
  border: 1px solid rgba(255, 42, 163, 0.46);
  border-radius: 24px;
  overflow: hidden;
  background: #050508;
  box-shadow:
    0 0 24px rgba(255, 42, 163, 0.24),
    inset 0 0 24px rgba(255, 42, 163, 0.10);
}

.ck-founder-hard-photo img {
  width: 100%;
  height: 100%;
  min-height: 360px;
  object-fit: cover;
  display: block;
  filter: grayscale(1) contrast(1.08);
}

.ck-founder-hard-main {
  padding: 12px 4px;
}

.ck-founder-hard-main h2 {
  margin: 12px 0 16px;
  font-size: clamp(34px, 4vw, 60px);
  line-height: .95;
  letter-spacing: -.045em;
  font-weight: 300;
}

.ck-founder-hard-main p {
  max-width: 760px;
  color: rgba(215, 215, 223, .74);
  font-size: 17px;
  line-height: 1.65;
}

.ck-founder-hard-form {
  margin-top: 24px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  max-width: 780px;
}

.ck-founder-hard-form input {
  min-height: 58px;
  border: 1px solid rgba(255, 42, 163, .38);
  border-radius: 999px;
  background: rgba(0, 0, 0, .32);
  color: #f4f4f7;
  padding: 0 22px;
  outline: none;
}

.ck-founder-hard-form button {
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

.ck-founder-hard-message {
  min-height: 22px;
  margin-top: 12px;
  color: rgba(255, 42, 163, .92);
  font-size: 13px;
  font-weight: 800;
}

.ck-founder-hard-upgrade {
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

.ck-founder-hard-upgrade a {
  white-space: nowrap;
  color: #ff2aa3;
  font-weight: 900;
}

.ck-founder-hard-quote {
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
  transition: box-shadow 1.8s ease, border-color 1.8s ease;
}

.ck-founder-hard-quote blockquote {
  margin: 28px 0;
  color: #f4f4f7;
  font-size: clamp(23px, 2.1vw, 31px);
  line-height: 1.24;
  letter-spacing: -.03em;
  font-weight: 300;
  opacity: 1;
  transition: opacity .9s ease, transform .9s ease;
}

.ck-founder-hard-count {
  display: flex;
  justify-content: space-between;
  gap: 18px;
  color: rgba(215, 215, 223, .54);
  font-size: 11px;
  letter-spacing: .14em;
  text-transform: uppercase;
}

.ck-founder-hard-banner.ck-founder-hard-pulse .ck-founder-hard-quote {
  border-color: rgba(255, 42, 163, .58);
  box-shadow:
    0 0 18px rgba(255, 42, 163, .26),
    inset 0 0 20px rgba(255, 42, 163, .10);
}

.ck-founder-hard-banner.ck-founder-hard-change .ck-founder-hard-quote blockquote {
  opacity: .18;
  transform: translateY(6px);
}

@media (max-width: 1250px) {
  .ck-founder-hard-banner {
    grid-template-columns: 280px 1fr;
  }

  .ck-founder-hard-quote {
    grid-column: 1 / -1;
    min-height: 260px;
  }
}

@media (max-width: 760px) {
  .ck-founder-hard-banner {
    grid-template-columns: 1fr;
    padding: 20px;
  }

  .ck-founder-hard-photo,
  .ck-founder-hard-photo img {
    min-height: 320px;
  }

  .ck-founder-hard-form {
    grid-template-columns: 1fr;
  }

  .ck-founder-hard-upgrade {
    flex-direction: column;
    align-items: flex-start;
  }
}
/* CK HARD MOUNT FOUNDER BANNER END */
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

remove = {
    'import "./ck-founder-newsletter.js";',
    'import "./ck-founder-status-banner.js";',
    'import "./ck-founder-hard-banner.js";'
}

rows = [row for row in text.splitlines() if row.strip() not in remove]
rows.insert(0, 'import "./ck-founder-hard-banner.js";')

path.write_text("\n".join(rows).strip() + "\n", encoding="utf-8")
PY

echo
echo "Hard-mounted Founder Banner installed."
echo "It mounts after the 15-card grid and hides the old status row."
echo "Backup saved to: $BACKUP_DIR"
