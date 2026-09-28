export function json(data, status = 200, headers = {}) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
      ...headers
    }
  });
}

export function sameOrigin(request) {
  const origin = request.headers.get("origin");
  if (!origin) return true;

  try {
    return new URL(origin).host === new URL(request.url).host;
  } catch {
    return false;
  }
}

export function randomLetters(length = 8) {
  const alphabet = "abcdefghijklmnopqrstuvwxyz";
  const values = crypto.getRandomValues(new Uint8Array(length));

  return [...values]
    .map((value) => alphabet[value % alphabet.length])
    .join("");
}

export function findOffer(categories, offerId) {
  for (const category of categories) {
    const offer = (category.offers || []).find(
      (candidate) => candidate.id === offerId
    );

    if (offer) {
      return {
        ...offer,
        category_slug: category.slug,
        category_name: category.name
      };
    }
  }

  return null;
}
