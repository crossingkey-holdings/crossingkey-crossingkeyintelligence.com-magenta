# Frontend and Web Experience Rules

This directory implements the public CrossingKey web experience.

## Build rules

- Reuse existing components, design tokens, route conventions, and approved
  visual effects before adding new ones.
- Keep editable public content in structured content files. Never make a paid
  or public page depend on manual DOM mutation.
- Use semantic HTML first. Prefer native controls over custom controls unless a
  custom control is necessary and keyboard/focus behavior is fully implemented.
- Make all new routes work with direct navigation, refresh, back/forward,
  narrow mobile viewports, and reduced motion.
- Validate internal links, external HTTPS links, forms, empty/error/loading
  states, image dimensions, alt text, and visible keyboard focus.

## Visual guardrails

- Preserve the established void-black, cold-silver, atomic-magenta, glass-panel
  and circuit-field system.
- Do not replace the approved emblem or introduce stock/glossy SaaS imagery.
- Motion must be decorative, pausable by `prefers-reduced-motion`, and reduced
  on mobile. Never make key text or CTAs depend on animation.
- Optimize media before shipping and reserve canvas/WebGL effects for layers
  that retain a visible static fallback.

## Payments and external links

- A checkout/product URL must come from verified configuration, be HTTPS, and
  map to the stated product. No placeholder purchase URLs.
- If a commerce configuration value is absent, use an honest “preparing
  release” or contact path.
- Do not place API keys, private download paths, or fulfillment logic in the
  client bundle.

## Verification

Run discovered project build/lint/test commands. For user-facing route changes,
also check desktop, narrow mobile, keyboard navigation, direct route refresh,
and browser console errors. Record the actual commands and results.
