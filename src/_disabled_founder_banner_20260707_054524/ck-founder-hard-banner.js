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
      <div class="ck-label">The Navigator</div>
      <h2>A weekly field note for builders, operators, and AI-era founders.</h2>
      <p>Subscribe free to The Navigator: a weekly CrossingKey dispatch on AI systems, operator engineering, commercial infrastructure, documentation discipline, and founder-grade execution.</p>

      <form class="ck-founder-hard-form" data-ck-founder-form>
        <input type="email" name="email" placeholder="Enter your email for The Navigator" required>
        <button type="submit">Subscribe Free</button>
      </form>

      <div class="ck-founder-hard-message" data-ck-founder-message></div>

      <div class="ck-founder-hard-upgrade">
        <span>Start with the free weekly dispatch. Upgrade later for deeper educational lessons, build systems, operator frameworks, and implementation guides.</span>
        <a href="/pricing.html#newsletter">Upgrade to Paid</a>
      </div>
    </div>

    <aside class="ck-founder-hard-quote">
      <div class="ck-label">Navigator Signal</div>
      <blockquote data-ck-founder-quote>Loading Navigator quote...</blockquote>
      <div class="ck-founder-hard-count">
        <span data-ck-founder-count>01 / 50</span>

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
    msg.textContent = "You’re on the list. Connect the newsletter endpoint next for automatic weekly delivery.";
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
