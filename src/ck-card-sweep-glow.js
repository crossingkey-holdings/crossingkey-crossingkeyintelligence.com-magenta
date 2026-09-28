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
