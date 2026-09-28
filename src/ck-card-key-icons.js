const CK_KEY_ICON_SRC = "/assets/k3y.png?v=k3y-card-icons-20260707_024416";

function createK3yImage() {
  const img = document.createElement("img");
  img.src = CK_KEY_ICON_SRC;
  img.alt = "";
  img.className = "ck-k3y-card-icon-image";
  img.setAttribute("aria-hidden", "true");
  img.dataset.ckK3yIcon = "1";
  return img;
}

function isCard(card) {
  if (!card || card.nodeType !== 1) return false;

  const rect = card.getBoundingClientRect();
  if (rect.width < 120 || rect.height < 120) return false;
  if (card.closest("header, nav, footer, form, .ck-search")) return false;

  const text = (card.textContent || "").replace(/\s+/g, " ").trim();
  return text.length >= 20;
}

function getIconSlot(card) {
  let slot =
    card.querySelector(".ck-card-icon") ||
    card.querySelector(".card-icon") ||
    card.querySelector(".ck-exact-key-holder") ||
    card.querySelector(".ck-real-key-holder") ||
    card.querySelector(".ck-final-key-holder") ||
    card.querySelector(".ck-glowing-key-holder") ||
    card.querySelector(".ck-card-key-holder") ||
    card.querySelector("[class*='icon']");

  if (!slot) {
    slot = document.createElement("span");
    slot.className = "ck-card-icon ck-k3y-card-icon-holder";

    const heading = card.querySelector("h1,h2,h3,h4");
    if (heading) card.insertBefore(slot, heading);
    else card.insertBefore(slot, card.firstChild);
  }

  return slot;
}

function applyK3yIcons() {
  const cards = document.querySelectorAll(
    ".ck-card, .category-card, .product-card, .feature-card, .system-card, [class*='card'], [class*='Card']"
  );

  cards.forEach((card) => {
    if (!isCard(card)) return;

    const slot = getIconSlot(card);
    slot.classList.add("ck-card-icon", "ck-k3y-card-icon-holder");

    const existing = slot.querySelector("img[data-ck-k3y-icon='1']");
    if (existing && existing.src.includes("k3y-card-icons-20260707_024416")) return;

    slot.innerHTML = "";
    slot.appendChild(createK3yImage());
  });
}

function boot() {
  applyK3yIcons();

  const observer = new MutationObserver(() => {
    window.requestAnimationFrame(applyK3yIcons);
  });

  observer.observe(document.documentElement, {
    childList: true,
    subtree: true
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", boot, { once: true });
} else {
  boot();
}
