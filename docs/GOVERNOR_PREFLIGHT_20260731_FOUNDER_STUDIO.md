# CrossingKey Governor Preflight

**Run ID:** `ck-site-founder-studio-20260731`

**Mode:** `Build`

**Operator request:** Add the locked hero identity and emblem favicons, then stage a separately built founder-only visual editing surface.

**Desired outcome:** A reviewable public-site change plus a private Studio foundation with no external writes or automatic publishing.

**Economic objective:** Increase brand consistency and create an owner-controlled editing workflow without exposing administrative controls.

**Buyer or user:** Public CrossingKey visitors; the founder is the sole Studio user.

**Existing safe assets:** Approved silver circuit-and-rose medallion; authoritative Vite source; locked background, particles, navigation, archive, typography, and cursor behavior.

**Source of truth:** `/home/founder/Downloads/www.crossingkeyintelligence.com`

**Scope and exclusions:** Local source, local builds, local previews. No deployment, Cloudflare, Shopify, Stripe, DNS, credentials, or production publishing.

**Information classification:** Public site fields `PUBLIC_SAFE`; Founder Studio source and drafts `PRIVATE_CK`; credentials `SECRET` and excluded.

**Authority level:** `INTERNAL_AUTONOMOUS`

**Evidence available:** Source inspection, asset checksum, two production builds, DOM read-back, screenshots, reduced-motion and bundle-boundary audits.

**Provenance / ownership status:** Silver emblem classified `CROSSINGKEY_ORIGINAL`; source checksum retained.

**Capability attestation:** Local read/write and tests available. Internet documentation read available. No Cloudflare mutation, deployment, or payment action used.

**Proof bundle required before release:** `yes`

**Material exposure:** Studio would be sensitive if served publicly without Access. Current artifact is local and not deployed.

**Success test:** Public hero renders exact requested identity; favicon links resolve; Studio builds separately; public output contains no Studio bundle; publish remains disabled; both builds pass.

**Rollback / recovery:** Restore the previous public source files, delete the new content/icon/Studio directories, and rebuild. No external rollback exists because nothing was deployed.

**Next money action:** Founder review of the staged local surfaces before any separate Studio hosting or Access configuration.
