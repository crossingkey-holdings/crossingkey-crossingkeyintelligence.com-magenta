# CrossingKey Source Catalog

**Purpose:** a source-routing map for research and implementation. This is not
a permanent proof that a page is current. An agent must retrieve the relevant
source at task time, record the access date, and prefer the current primary
documentation over remembered behavior.

## Trust order

| Tier | Use | Examples |
|---|---|---|
| A — primary | Product behavior, API schemas, policies, pricing, deployment requirements | official platform/framework documentation and release notes |
| B — standards | Web, accessibility, security, language standards | W3C, WAI, WHATWG, TC39, IETF, OWASP, NIST |
| C — reputable secondary | Learning roadmaps, patterns, comparisons, community context | roadmap.sh, web.dev, official engineering blogs, maintained open-source docs |
| D — leads only | Discovery and non-authoritative examples | search snippets, social media, forum posts, videos, generated answers |

Tier C and D material must not be the sole support for a money, security,
privacy, policy, or compatibility claim.

## Source routing by work

| Work area | Planning/discovery | Primary source of truth | Required check |
|---|---|---|---|
| Web platform | [roadmap.sh/frontend](https://roadmap.sh/frontend), [web.dev](https://web.dev/) | [MDN](https://developer.mozilla.org/), [WHATWG HTML](https://html.spec.whatwg.org/), [W3C](https://www.w3.org/TR/) | semantic HTML, browser support, keyboard/mobile behavior |
| Accessibility | [roadmap.sh/frontend](https://roadmap.sh/frontend) | [W3C WAI](https://www.w3.org/WAI/standards-guidelines/wcag/), [MDN accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility) | keyboard, focus, contrast, reduced motion, labels |
| CSS/UI | [roadmap.sh/frontend](https://roadmap.sh/frontend) | [MDN CSS](https://developer.mozilla.org/en-US/docs/Web/CSS) | responsive layout, motion, contrast, fallback |
| JavaScript | [roadmap.sh/javascript](https://roadmap.sh/javascript) | [MDN JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript), [TC39](https://tc39.es/) | browser/runtime support and error behavior |
| TypeScript | [roadmap.sh/typescript](https://roadmap.sh/typescript) | [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html) | compile, external-input validation, no suppressed errors |
| Node/Vite/React | [roadmap.sh/frontend](https://roadmap.sh/frontend) | [Node](https://nodejs.org/docs/latest/api/), [Vite](https://vite.dev/guide/), [React](https://react.dev/reference/react) | existing version compatibility and build |
| Backend/databases | [roadmap.sh/backend](https://roadmap.sh/backend) | target runtime/framework docs, [PostgreSQL](https://www.postgresql.org/docs/), [OpenAPI](https://spec.openapis.org/oas/latest.html) | input validation, auth, migrations, errors, tests |
| UI/UX and GUI | [roadmap.sh/ux-design](https://roadmap.sh/ux-design) | [W3C WAI](https://www.w3.org/WAI/), [Figma Help](https://help.figma.com/), target UI-framework docs | flows, semantic controls, keyboard/focus, responsive states, handoff evidence |
| CI/CD | [roadmap.sh/devops](https://roadmap.sh/devops) | [GitHub Actions](https://docs.github.com/actions), [GitLab CI/CD](https://docs.gitlab.com/ci/) | branch, environments, required checks, secrets, rollback |
| Python | [roadmap.sh/python](https://roadmap.sh/python) | [Python docs](https://docs.python.org/3/) | venv-safe installation, tests, CLI failure behavior |
| Bash/Linux/Termux | [roadmap.sh/linux](https://roadmap.sh/linux) | [GNU Bash manual](https://www.gnu.org/software/bash/manual/), [Linux kernel docs](https://docs.kernel.org/), [Termux docs](https://termux.dev/en/) | quoting, path safety, repeat run, permissions |
| GitHub/Git | [roadmap.sh/git-github](https://roadmap.sh/git-github) | [Git](https://git-scm.com/doc), [GitHub Docs](https://docs.github.com/) | branch, visibility, diff, no secrets |
| Cloudflare | [roadmap.sh/devops](https://roadmap.sh/devops) | [Cloudflare Docs](https://developers.cloudflare.com/) | account/zone/environment, preview, rollback |
| Shopify | [roadmap.sh](https://roadmap.sh/) | [Shopify Dev](https://shopify.dev/docs) | exact store/product/theme, delivery and policy |
| Stripe | [roadmap.sh](https://roadmap.sh/) | [Stripe Docs](https://docs.stripe.com/) | test mode, checkout, webhook, fulfillment |
| OpenAI/Codex | [roadmap.sh/ai-engineer](https://roadmap.sh/ai-engineer) | [OpenAI Developers](https://developers.openai.com/), [Codex docs](https://developers.openai.com/codex/) | current model/API, tool scope, evaluation, approval boundary |
| Anthropic/Google AI | [roadmap.sh/ai-engineer](https://roadmap.sh/ai-engineer) | [Claude platform docs](https://platform.claude.com/docs/), [Google AI docs](https://ai.google.dev/) | current model and API guidance |
| Agent interoperability | [roadmap.sh/ai-engineer](https://roadmap.sh/ai-engineer) | [Model Context Protocol](https://modelcontextprotocol.io/) | client/server auth, least privilege, tool policy |
| Security/privacy | [roadmap.sh/cyber-security](https://roadmap.sh/cyber-security) | [OWASP](https://owasp.org/), [NIST CSRC](https://csrc.nist.gov/) | threat model, secrets, input trust, logging |
| Browser extensions/userscripts | [roadmap.sh/frontend](https://roadmap.sh/frontend) | [MDN WebExtensions](https://developer.mozilla.org/docs/Mozilla/Add-ons/WebExtensions), [Violentmonkey API](https://violentmonkey.github.io/api/) | permissions, match patterns, privacy, browser validation |

## Source intake record

For material guidance, create a short record:

```md
- Claim: [precise statement]
- Status: OBSERVED | TESTED | INFERRED | PLANNED
- Primary source: [title](https://canonical.example/)
- Publisher: [source owner]
- Accessed: YYYY-MM-DD
- Scope/version: [product, feature, runtime, or policy]
- Implementation check: [test, screenshot, build, read-back]
- Limits or conflict: [what this does not prove]
```

## Disallowed source shortcuts

- Do not use an LLM answer, search snippet, SEO blog, social post, or copied
  Stack Overflow code as proof of a current platform rule.
- Do not use roadmaps as API documentation.
- Do not infer account access, pricing, product availability, security posture,
  or deployment success from a public page.
- Do not copy copyrighted documentation or paid course material into products;
  teach original explanations and link to sources.
