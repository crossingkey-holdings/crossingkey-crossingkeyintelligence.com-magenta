# CrossingKey Site Change Receipt

**Live reference URL:** https://www.crossingkeyintelligence.com/

**Reference capture date:** 2026-07-31 local source baseline; no live-site mutation.

**Authoritative repository / branch:** Local source at `/home/founder/Downloads/www.crossingkeyintelligence.com`; directory is not a Git worktree.

**Change requested:** Hero identity, emblem favicons, versioned editable configuration, and a separately bundled Founder Studio foundation.

**Expansion type:** section / accessibility / integration foundation

**Design-lock impact:** Approved requested hero copy change only. Background, typography, particles, navigation, cursor, glass system, routes, and 15-card architecture preserved.

**Locked elements preserved:** Void-black/magenta field, Tektur typography, cold-silver surfaces, public navigation and routes, signal search, particles, cursor assets, archive cards, commerce links.

**New elements and how they reuse the system:** Emblem favicon derivatives; explicit JSON configuration; editable IDs on four homepage hero fields; separate Studio using the locked black/silver/magenta tokens.

**Public/private content review:** Public output receives only approved hero configuration and identifiers. Studio controls, persistence code, and editing UI compile to `founder-studio/dist`, not public `dist`.

**Verification performed:** `npm run build:all`; Chromium DOM read-back; public and Studio screenshots; asset checksum comparison; favicon format/dimension inspection; public-bundle search for Studio identifiers; reduced-motion and mobile-particle source inspection.

**Rollback:** Restore prior `src/main.js`, `index.html`, `package.json`, and `README.md`; remove `src/content`, `public/icons`, `founder-studio`, and these receipts; rebuild public output.

**Approval required or used:** Local build authorized. Deployment, Access configuration, DNS, and production publish remain withheld.

**Status:** `READY_FOR_REVIEW`
