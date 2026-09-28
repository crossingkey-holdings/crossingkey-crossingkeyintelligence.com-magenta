# Founder Studio Rules

Founder Studio is private control infrastructure, not a public feature.

- Build and deploy it as a separate application protected by identity-aware
  access control. A hidden route, client-side password, query parameter, or CSS
  display rule is not access control.
- Keep editor code, persistence adapters, and sensitive configuration out of
  the public-site build.
- Browser-local drafts are `LOCAL_DRAFT_ONLY`, not durable backup or shared
  persistence. Label them honestly.
- Any production publish control must require explicit confirmation, record the
  changed configuration/version, and provide a rollback target.
- Media replacement must preserve original files, record provenance/licensing,
  support transparent assets, validate file type/size, and avoid public private
  asset URLs.
- Do not claim a control is runtime-enforced until the actual server/edge
  middleware or access policy is implemented and tested.
