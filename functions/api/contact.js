import { cleanEmail, cleanText, isSameOrigin, json, verifyTurnstile } from '../_lib/security.js'

const TOPICS = new Set(['product', 'project', 'licensing', 'support', 'archive'])

export async function onRequestPost({ request, env }) {
  if (!isSameOrigin(request)) return json({ error: 'Request not accepted.' }, 403)
  let body
  try { body = await request.json() } catch { return json({ error: 'Use the secure form.' }, 400) }
  const name = cleanText(body.name, 100)
  const email = cleanEmail(body.email)
  const topic = cleanText(body.topic, 24)
  const message = cleanText(body.message, 5000)
  if (!name || !email || !TOPICS.has(topic) || message.length < 12) return json({ error: 'Complete each field so the request can be routed correctly.' }, 400)
  if (!(await verifyTurnstile(body.turnstileToken, env.TURNSTILE_SECRET_KEY, request))) return json({ error: 'Verification expired. Please try again.' }, 400)
  if (!env.CK_INTAKE_DB) return json({ error: 'Secure contact is not configured yet.' }, 503)
  await env.CK_INTAKE_DB.prepare(
    'INSERT INTO inquiries (name, email, topic, message, created_at, source) VALUES (?, ?, ?, ?, ?, ?)'
  ).bind(name, email, topic, message, new Date().toISOString(), body.source === 'archive' ? 'archive' : 'contact').run()
  return json({ ok: true })
}
