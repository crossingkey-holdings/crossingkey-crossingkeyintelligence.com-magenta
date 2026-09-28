function cleanupFounderBannerRollback() {
  document.querySelectorAll(
    "#founder-signal, .ck-founder-hard-banner, .ck-founder-status-replacement, .ck-founder-banner"
  ).forEach((node) => node.remove());

  document.querySelectorAll("[data-ck-hidden-system-status='1']").forEach((node) => {
    node.style.display = "";
    node.removeAttribute("data-ck-hidden-system-status");
  });
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", cleanupFounderBannerRollback, { once: true });
} else {
  cleanupFounderBannerRollback();
}
