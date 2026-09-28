import { CATEGORIES } from "../../_category_catalog.js";
import { json } from "../../_helpers.js";

export function onRequestGet(context) {
  const key = context.env.STRIPE_SECRET_KEY || "";

  const mode = key.startsWith("sk_test_")
    ? "test"
    : key.startsWith("sk_live_")
      ? "live"
      : "unconfigured";

  const liveLocked =
    mode === "live" &&
    context.env.ALLOW_LIVE_PAYMENTS !== "true";

  const offerCount = CATEGORIES.reduce(
    (count, category) =>
      count + (category.offers || []).length,
    0
  );

  return json(
    {
      ok:
        mode === "test" ||
        (mode === "live" && !liveLocked),
      service:
        "crossingkey-15-category-income-system",
      checkout_mode: mode,
      live_payments_locked: liveLocked,
      categories: CATEGORIES.length,
      offers: offerCount
    },
    mode === "unconfigured" || liveLocked ? 503 : 200
  );
}
