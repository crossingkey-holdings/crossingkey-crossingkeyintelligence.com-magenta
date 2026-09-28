import { cleanEmail, cleanText, isSameOrigin, json, verifyTurnstile } from '../_lib/security.js'

export async function onRequestPost({ request, env }) {
  if (!isSameOrigin(request)) return json({ error: 'Request not accepted.' }, 403)
  let body
  try { body = await request.json() } catch { return json({ error: 'Use the secure form.' }, 400) }
  const email = cleanEmail(body.email)
  const interest = cleanText(body.interest, 40)
  const consent = body.consent === true
  if (!email || !['Founder', 'Operator', 'Developer', 'Local AI'].includes(interest) || !consent) {
    return json({ error: 'Enter a valid email, choose an interest, and confirm consent.' }, 400)
  }
  if (!(await verifyTurnstile(body.turnstileToken, env.TURNSTILE_SECRET_KEY, request))) {
    return json({ error: 'Verification expired. Please try again.' }, 400)
  }
  if (!env.CK_INTAKE_DB) return json({ error: 'Secure signup is not configured yet.' }, 503)
  await env.CK_INTAKE_DB.prepare(
    'INSERT INTO subscribers (email, interest, consented_at, source) VALUES (?, ?, ?, ?) ON CONFLICT(email) DO UPDATE SET interest = excluded.interest, consented_at = excluded.consented_at'
  ).bind(email, interest, new Date().toISOString(), 'join').run()
  return json({ ok: true })
}
