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
