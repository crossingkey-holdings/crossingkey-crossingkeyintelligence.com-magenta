import { CATEGORIES } from "../../_category_catalog.js";
import {
  findOffer,
  json,
  sameOrigin
} from "../../_helpers.js";

const API_VERSION = "2026-06-24.dahlia";

export async function onRequestGet(context) {
  const { request, env } = context;

  if (!sameOrigin(request)) {
    return json(
      { error: "Cross-origin delivery checks are not accepted." },
      403
    );
  }

  if (!env.STRIPE_SECRET_KEY) {
    return json(
      { error: "Delivery verification is not configured." },
      503
    );
  }

  const url = new URL(request.url);
  const sessionId =
    url.searchParams.get("session_id") || "";

  if (!/^cs_(test|live)_[A-Za-z0-9_]+$/.test(sessionId)) {
    return json(
      { error: "A valid Checkout Session ID is required." },
      400
    );
  }

  const stripeResponse = await fetch(
    `https://api.stripe.com/v1/checkout/sessions/${encodeURIComponent(
      sessionId
    )}`,
    {
      headers: {
        authorization: `Bearer ${env.STRIPE_SECRET_KEY}`,
        "stripe-version": API_VERSION
      }
    }
  );

  const session = await stripeResponse
    .json()
    .catch(() => ({}));

  if (!stripeResponse.ok) {
    return json(
      {
        error:
          session?.error?.message ||
          "Payment session could not be verified."
      },
      502
    );
  }

  const offerId =
    session?.metadata?.offer_id ||
    session?.client_reference_id;

  const offer = findOffer(CATEGORIES, offerId);

  if (!offer) {
    return json(
      { error: "The paid offer is not recognized." },
      404
    );
  }

  const paid =
    session.payment_status === "paid" &&
    session.status === "complete";

  if (!paid) {
    return json(
      {
        paid: false,
        status: session.status || "unknown",
        paymentStatus:
          session.payment_status || "unpaid",
        offerId: offer.id
      },
      402
    );
  }

  return json({
    paid: true,
    receipt: {
      session_id: session.id,
      payment_intent: session.payment_intent || null,
      amount_total: session.amount_total,
      currency: session.currency,
      customer_email:
        session.customer_details?.email ||
        session.customer_email ||
        null,
      offer_id: offer.id,
      offer_name: offer.name,
      category_slug: offer.category_slug,
      category_name: offer.category_name,
      verified_at: new Date().toISOString()
    },
    delivery: {
      promise: offer.promise,
      deliverables: offer.deliverables,
      intake: offer.intake,
      support_email:
        "crossingkey.intelligence@gmail.com",
      instructions: [
        "Download the verified paid packet.",
        "Complete the intake fields with concrete details.",
        "Reply using the generated receipt subject.",
        "CrossingKey begins the stated deliverable after receiving the completed intake."
      ]
    }
  });
}
