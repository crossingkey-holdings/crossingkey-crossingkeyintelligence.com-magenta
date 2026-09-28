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
