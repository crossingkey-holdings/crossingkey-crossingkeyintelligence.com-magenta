(() => {
  "use strict";

  const normalize = (value = "") =>
    String(value)
      .toLowerCase()
      .replace(/&/g, " and ")
      .replace(/\+/g, " and ")
      .replace(/[^a-z0-9]+/g, " ")
      .trim();

  const state = {
    categories: [],
    categoryByName: new Map(),
    offerById: new Map()
  };

  const interactiveSelector =
    "a,button,input,select,textarea,summary,[role='button']";

  function findCategoryForCard(card) {
    const explicit = [
      card.dataset.category,
      card.dataset.categoryName,
      card.dataset.categorySlug
    ].filter(Boolean);

    for (const value of explicit) {
      const normalized = normalize(value);
      for (const category of state.categories) {
        if (
          normalized === normalize(category.name) ||
          normalized === normalize(category.slug)
        ) {
          return category;
        }
      }
    }

    const headings = card.querySelectorAll(
      "h1,h2,h3,h4,h5,h6,[data-card-title],.card-title,.title"
    );

    for (const heading of headings) {
      const category = state.categoryByName.get(normalize(heading.textContent));
      if (category) return category;
    }

    const fullText = normalize(card.textContent);
    for (const category of state.categories) {
      const categoryName = normalize(category.name);
      if (
        fullText === categoryName ||
        fullText.startsWith(`${categoryName} `) ||
        fullText.includes(` ${categoryName} `)
      ) {
        return category;
      }
    }

    return null;
  }

  function wireCategoryCards() {
    const selectors = [
      "[data-category]",
      "[data-category-name]",
      "[data-category-slug]",
      ".category-card",
      ".category-tile",
      ".card"
    ];

    const cards = [...document.querySelectorAll(selectors.join(","))];

    for (const card of cards) {
      if (
        card.dataset.ckCategoryCard === "true" ||
        card.closest("nav,footer,.legal,.policy,[data-no-category-commerce]")
      ) {
        continue;
      }

      const category = findCategoryForCard(card);
      if (!category) continue;

      const target = `/categories/${encodeURIComponent(category.slug)}/`;
      card.dataset.ckCategoryCard = "true";
      card.dataset.ckCategoryHref = target;

      const existingLink = card.querySelector("a[href]");
      if (existingLink) {
        existingLink.href = target;
      }

      if (!card.hasAttribute("tabindex")) card.tabIndex = 0;
      if (!card.hasAttribute("role")) card.setAttribute("role", "link");
      card.setAttribute("aria-label", `Explore ${category.name} offers`);

      card.addEventListener("click", (event) => {
        if (event.target.closest(interactiveSelector)) return;
        window.location.assign(target);
      });

      card.addEventListener("keydown", (event) => {
        if (event.key !== "Enter" && event.key !== " ") return;
        if (
          event.target !== card &&
          event.target.closest(interactiveSelector)
        ) {
          return;
        }
        event.preventDefault();
        window.location.assign(target);
      });
    }
  }

  async function beginCheckout(offerId, button, statusNode) {
    const originalText = button.textContent;
    button.disabled = true;
    button.textContent = "Opening secure checkout…";
    statusNode.textContent = "";

    try {
      const response = await fetch("/api/checkout/session", {
        method: "POST",
        headers: {
          "content-type": "application/json",
          "x-idempotency-key": crypto.randomUUID()
        },
        body: JSON.stringify({ offerId })
      });

      const data = await response.json().catch(() => ({}));

      if (!response.ok || !data.url) {
        throw new Error(data.error || "Secure checkout is not ready.");
      }

      window.location.assign(data.url);
    } catch (error) {
      statusNode.textContent = error.message;
      button.disabled = false;
      button.textContent = originalText;
    }
  }

  function wireBuyButtons() {
    const buttons = document.querySelectorAll("[data-ck-offer-id]");

    for (const button of buttons) {
      const offerId = button.dataset.ckOfferId;
      if (!state.offerById.has(offerId)) {
        button.disabled = true;
        continue;
      }

      const card = button.closest(".ck-offer-card") || button.parentElement;
      const status =
        card.querySelector(".ck-buy-status") ||
        document.createElement("p");

      if (!status.classList.contains("ck-buy-status")) {
        status.className = "ck-buy-status";
        status.setAttribute("role", "status");
        status.setAttribute("aria-live", "polite");
        card.appendChild(status);
      }

      button.addEventListener("click", () =>
        beginCheckout(offerId, button, status)
      );
    }
  }

  async function boot() {
    try {
      const response = await fetch("/api/category-offers.json", {
        cache: "no-store"
      });

      if (!response.ok) return;

      const payload = await response.json();
      state.categories = Array.isArray(payload.categories)
        ? payload.categories
        : [];

      for (const category of state.categories) {
        state.categoryByName.set(normalize(category.name), category);
        for (const offer of category.offers || []) {
          state.offerById.set(offer.id, {
            ...offer,
            categorySlug: category.slug,
            categoryName: category.name
          });
        }
      }

      wireCategoryCards();
      wireBuyButtons();
    } catch (error) {
      console.warn("CrossingKey category income layer did not initialize.", error);
    }
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot, { once: true });
  } else {
    boot();
  }
})();
