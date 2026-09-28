const ALLOWED_HOSTS = new Set(['www.crossingkeyintelligence.com', 'crossingkeyintelligence.com', 'localhost', '127.0.0.1'])

export function json(payload, status = 200) {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { 'content-type': 'application/json; charset=utf-8', 'cache-control': 'no-store' },
  })
}

export function isSameOrigin(request) {
  const origin = request.headers.get('origin')
  if (!origin) return true
  try { return new URL(origin).origin === new URL(request.url).origin } catch { return false }
}

export function cleanText(value, max) {
  return String(value || '').replace(/[\u0000-\u001f\u007f]/g, ' ').replace(/\s+/g, ' ').trim().slice(0, max)
}

export function cleanEmail(value) {
  const email = cleanText(value, 254).toLowerCase()
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ? email : ''
}

export async function verifyTurnstile(token, secret, request) {
  if (!token || !secret) return false
  const response = await fetch('https://challenges.cloudflare.com/turnstile/v0/siteverify', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ secret, response: token }),
  })
  const result = await response.json()
  return Boolean(result.success && ALLOWED_HOSTS.has(result.hostname))
}
