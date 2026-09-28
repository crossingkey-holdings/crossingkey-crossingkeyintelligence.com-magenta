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
