# CrossingKey Intelligence — Elite WebGL public build v2.1.1

This is the public front door. It intentionally contains only approved public copy, a static public search index, and links to the Shopify Fleet. It contains no private files, source releases, credentials, customer data, or creative masters. The technical display typeface is self-hosted in the production build; it does not depend on a third-party font request.

## Local run

```bash
npm install
npm run dev
```

## Cloudflare Pages setup

1. If a Pages project already exists, download its current configuration before making a Wrangler file:
   ```bash
   npx wrangler pages download config YOUR_EXISTING_PROJECT_NAME
   ```
   Otherwise, use `wrangler.template.jsonc` as the starting point.
2. Create a D1 database named `crossingkey-intake`, add its ID to the `CK_INTAKE_DB` binding, and apply `db/0001_intake.sql`.
3. Create a Turnstile widget for `www.crossingkeyintelligence.com` and `crossingkeyintelligence.com`.
4. Add `VITE_TURNSTILE_SITE_KEY` as a Pages build variable and `TURNSTILE_SECRET_KEY` as a Pages secret.
5. Build with `npm run build`.
6. From this project root, deploy with Wrangler so the `functions/` folder is deployed with `dist`:
   ```bash
   npx wrangler pages deploy dist --project-name=YOUR_EXISTING_PROJECT_NAME
   ```

Do not use dashboard drag-and-drop for this version: dashboard uploads do not compile the Pages Functions that power secure forms.

Without the Turnstile key and D1 binding, the signup and contact forms intentionally do not collect data.

## Founder Studio security boundary

`founder-studio/` is a separate Vite application and must be built and deployed separately from this public website. Its intended production hostname is a private surface such as `studio.crossingkeyintelligence.com`.

- Protect the entire Studio hostname with Cloudflare Access and restrict it to the founder's explicitly approved email identity.
- A private-looking URL is not access control. Never use a query parameter, CSS hiding, local storage, or a client-side password as the security boundary.
- Never place credentials, admin passwords, Cloudflare tokens, API secrets, or signing keys in either client bundle.
- Public visitors must never receive Studio controls, Studio JavaScript, or editor assets from the public-site deployment.
- Production publishing remains confirmation-gated and versioned. The initial adapter only saves browser-local drafts; its Publish button intentionally cannot publish.

Local Studio commands:

```bash
npm run studio:dev
npm run studio:build
```

The Studio's persistence interface is designed so a future authenticated server adapter can use Cloudflare D1/R2 or another secure API. Connecting that adapter, configuring Access, and deploying either application are separate approval-gated actions.
