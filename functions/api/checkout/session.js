import { CATEGORIES } from "../../_category_catalog.js";
import {
  findOffer,
  json,
  randomLetters,
  sameOrigin
} from "../../_helpers.js";

const API_VERSION = "2026-06-24.dahlia";

export async function onRequestPost(context) {
  const { request, env } = context;

  if (!sameOrigin(request)) {
    return json(
      { error: "Cross-origin checkout requests are not accepted." },
      403
    );
  }

  if (!env.STRIPE_SECRET_KEY) {
    return json(
      { error: "Secure checkout is not configured yet." },
      503
    );
  }

  const isLive = env.STRIPE_SECRET_KEY.startsWith("sk_live_");

  if (isLive && env.ALLOW_LIVE_PAYMENTS !== "true") {
    return json(
      { error: "Live payments are locked. Test mode is required." },
      503
    );
  }

  if (
    !env.STRIPE_SECRET_KEY.startsWith("sk_test_") &&
    !isLive
  ) {
    return json(
      { error: "The configured Stripe credential is not recognized." },
      503
    );
  }

  let body;

  try {
    body = await request.json();
  } catch {
    return json({ error: "Invalid JSON request." }, 400);
  }

  const offer = findOffer(
    CATEGORIES,
    String(body.offerId || "")
  );

  if (!offer) {
    return json({ error: "This offer is not available." }, 404);
  }

  const origin = new URL(request.url).origin;
  const form = new URLSearchParams();

  form.set("mode", "payment");
  form.set(
    "success_url",
    `${origin}/delivery/?session_id={CHECKOUT_SESSION_ID}`
  );
  form.set(
    "cancel_url",
    `${origin}/categories/${encodeURIComponent(
      offer.category_slug
    )}/?checkout=cancelled`
  );
  form.set("client_reference_id", offer.id);
  form.set("customer_creation", "always");
  form.set("billing_address_collection", "auto");
  form.set("submit_type", "pay");
  form.set(
    "integration_identifier",
    `crossingkey_category_${randomLetters(8)}`
  );

  form.set(
    "line_items[0][price_data][currency]",
    "usd"
  );
  form.set(
    "line_items[0][price_data][unit_amount]",
    String(Math.round(offer.price * 100))
  );
  form.set(
    "line_items[0][price_data][product_data][name]",
    offer.name
  );
  form.set(
    "line_items[0][price_data][product_data][description]",
    `${offer.category_name}: ${offer.promise}`.slice(0, 250)
  );
  form.set("line_items[0][quantity]", "1");

  form.set("metadata[offer_id]", offer.id);
  form.set("metadata[category_slug]", offer.category_slug);
  form.set("metadata[category_name]", offer.category_name);
  form.set(
    "metadata[source]",
    "crossingkey-15-category-income-system"
  );

  form.set(
    "payment_intent_data[metadata][offer_id]",
    offer.id
  );
  form.set(
    "payment_intent_data[metadata][category_slug]",
    offer.category_slug
  );
  form.set(
    "payment_intent_data[metadata][source]",
    "crossingkey-15-category-income-system"
  );

  const suppliedKey =
    request.headers.get("x-idempotency-key");

  const idempotencyKey =
    suppliedKey &&
    /^[A-Za-z0-9._:-]{8,255}$/.test(suppliedKey)
      ? suppliedKey
      : crypto.randomUUID();

  const stripeResponse = await fetch(
    "https://api.stripe.com/v1/checkout/sessions",
    {
      method: "POST",
      headers: {
        authorization: `Bearer ${env.STRIPE_SECRET_KEY}`,
        "content-type":
          "application/x-www-form-urlencoded",
        "stripe-version": API_VERSION,
        "idempotency-key": idempotencyKey
      },
      body: form.toString()
    }
  );

  const stripeData = await stripeResponse
    .json()
    .catch(() => ({}));

  if (!stripeResponse.ok || !stripeData.url) {
    console.error(
      JSON.stringify({
        event: "stripe_checkout_error",
        offer_id: offer.id,
        category_slug: offer.category_slug,
        status: stripeResponse.status,
        stripe_error_type:
          stripeData?.error?.type || "unknown"
      })
    );

    return json(
      {
        error:
          stripeData?.error?.message ||
          "Stripe could not create secure checkout."
      },
      502
    );
  }

  return json({
    checkoutSessionId: stripeData.id,
    mode: isLive ? "live" : "test",
    offerId: offer.id,
    category: offer.category_slug,
    url: stripeData.url
  });
}

export function onRequestGet() {
  return json(
    { error: "Use POST to create a Checkout Session." },
    405,
    { allow: "POST" }
  );
}
