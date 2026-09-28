import './styles.css'
import './division-copy.css'
import './about.css'
import '@fontsource/tektur/latin-400.css'
import '@fontsource/tektur/latin-500.css'
import '@fontsource/tektur/latin-700.css'
import { initCKWebGLField } from './ck-webgl-field.js'
import { initCKParticles } from './ck-particles.js'
import siteContent from './content/site-content.json'
import siteTheme from './content/site-theme.json'
import { divisionCopy } from './division-copy.js'

const SHOP_URL = 'https://shop.crossingkeyintelligence.com/'
const EXCHANGE_URL = 'https://exchange.crossingkeyintelligence.com/'
const CONTACT_EMAIL = 'navigator@crossingkeyintelligence.com'
const TURNSTILE_SITE_KEY = import.meta.env.VITE_TURNSTILE_SITE_KEY || ''
const OPERATOR_VAULT_CHECKOUT_URL = (import.meta.env.VITE_OPERATOR_VAULT_CHECKOUT_URL || '').trim()

const cards = [
  ['01', 'Core archive', 'Documentation Archives', 'Readable records, manuals, proof files, and delivery boundaries.', '▤'],
  ['02', 'Builder layer', 'Developer Libraries', 'Reusable code, utilities, and clean implementation patterns.', '⌘'],
  ['03', 'Infrastructure layer', 'Infrastructure Toolkits', 'Deployment maps, local infrastructure, and operational rails.', '◫'],
  ['04', 'Execution layer', 'Automation Frameworks', 'Repeatable workflows with reviewable, human-directed execution.', '⇄'],
  ['05', 'Integration layer', 'API Components', 'Contracts, schemas, checklists, and integration-ready system pieces.', '⟨/⟩'],
  ['06', 'Prompt layer', 'Prompt Systems', 'Operator instructions and AI workflow patterns for reliable output.', '✦'],
  ['07', 'Governance layer', 'Governance Packs', 'Approval gates, rulebooks, and practical operating boundaries.', '⛉'],
  ['08', 'Security layer', 'Security Reviews', 'Risk maps, hardening checklists, and controlled inspection assets.', '◈'],
  ['09', 'Commerce layer', 'Commerce Systems', 'Storefront systems and delivery patterns designed for clear buying.', '⌁'],
  ['10', 'Signal layer', 'Intelligence Briefings', 'Clear decision notes, field signals, and release context.', '◌'],
  ['11', 'Creative layer', 'Creative Assets', 'Public-ready creative systems, brand work, and production direction.', '◒'],
  ['12', 'Training layer', 'Operator Training', 'Guides, practice drills, and human-in-the-loop learning assets.', '↗'],
  ['13', 'Local AI layer', 'Local AI Stacks', 'Local-first AI patterns, offline workflows, and workstation maps.', '◎'],
  ['14', 'Release layer', 'Distribution Pipelines', 'Versioned releases, manifests, checksums, and handoff systems.', '□'],
  ['15', 'Private layer', 'Private Builds', 'Scoped engagements available by discussion—not a public preview.', '◇'],
]

const publicIndex = [
  { title: 'Exchange', type: 'AI commerce interface', text: 'Tell me what you need and use the Exchange to discover matching CrossingKey products.', href: EXCHANGE_URL, external: true, tags: 'exchange ai commerce search products recommendations crossingkey' },
  { title: 'Fleet', type: 'Shopify storefront', text: 'Browse the CrossingKey products, licenses, and delivery details I make available through Fleet.', href: SHOP_URL, external: true, tags: 'products shopify digital downloads fleet buy tools' },
  { title: 'EdgeNode-X', type: 'Product', text: 'Local AI provisioning framework for controlled, local-first operations.', href: `${SHOP_URL}products/edgenode-x-local-ai-provisioning-framework`, external: true, tags: 'edgenode local ai provisioning infrastructure developer' },
  { title: 'Standards & Verification', type: 'Public standard', text: 'How releases are documented, bounded, and checked before completion claims.', href: '/standards', tags: 'standards verification proof boundaries mop security documentation' },
  { title: 'The Navigator', type: 'Weekly field note', text: 'AI, systems, psychology, and building with control.', href: '/join', tags: 'navigator newsletter psychology ai systems operator weekly' },
  { title: 'Local AI', type: 'Resource path', text: 'Public overview of local-first AI capabilities and available paid paths.', href: '/resources', tags: 'local ai offline workstation models resource guide' },
  { title: 'Enterprise Systems', type: 'Custom work', text: 'Scoped architecture, automation, governance, integration, and documentation work.', href: '/contact?intent=project', tags: 'enterprise systems custom automation architecture governance integration' },
  { title: 'About CrossingKey', type: 'Technology firm', text: 'My technology firm, my public operating principles, and the people I design for.', href: '/about', tags: 'about technology firm founder operators developers independent builders' },
  { title: 'Authorship, Trademark & Rights', type: 'Rights record', text: 'Founder identity, human authorship, claimed marks, third-party boundaries, and the CrossingKey rights structure.', href: '/authorship-trademark-rights', tags: 'authorship trademark copyright rights founder jeremy paul allen crossingkey ownership provenance' },
  { title: 'Creative Licensing', type: 'Inquiry path', text: 'Ask about characters, visual worlds, music, writing, or creative systems.', href: '/contact?intent=licensing', tags: 'creative licensing characters music books video images universe' },
]

const divisionTargets = {
  'Documentation Archives': '/resources',
  'Developer Libraries': `${SHOP_URL}search?q=developer`,
  'Infrastructure Toolkits': `${SHOP_URL}search?q=infrastructure`,
  'Automation Frameworks': `${SHOP_URL}search?q=automation`,
  'API Components': `${SHOP_URL}search?q=api`,
  'Prompt Systems': `${SHOP_URL}search?q=prompt`,
  'Governance Packs': `${SHOP_URL}search?q=governance`,
  'Security Reviews': '/contact?intent=project',
  'Commerce Systems': `${SHOP_URL}collections/production-ready-ai-systems`,
  'Intelligence Briefings': '/resources',
  'Creative Assets': '/contact?intent=licensing',
  'Operator Training': `${SHOP_URL}search?q=workshop`,
  'Local AI Stacks': `${SHOP_URL}products/edgenode-x-local-ai-provisioning-framework`,
  'Distribution Pipelines': '/contact?intent=project',
  'Private Builds': '/contact?intent=project',
}

const divisionDetails = {
  '01': {
    overview: 'A public archive layer for keeping releases understandable after the build is finished. It turns working files into readable records with identity, purpose, provenance, verification, delivery boundaries, and recovery guidance.',
    audience: 'Developers, technical founders, operators, customers receiving digital work, and anyone responsible for maintaining a release after handoff.',
    problem: 'A finished folder can still become an unexplained folder. Documentation Archives preserves what was delivered, where it came from, what it requires, how it was checked, and what complete means.',
    covers: ['Release identity and version records', 'Manifests, checksums, and provenance', 'Requirements, dependencies, and limitations', 'Acceptance criteria, rollback, and delivery boundaries'],
    verification: 'A usable archive lets another person identify the release, confirm its contents, repeat its checks, understand its limitations, and recover without relying on the original builder.',
    boundary: 'Documentation improves clarity and continuity; it does not guarantee that a release is error-free or appropriate for every environment.'
  },
  '02': {
    overview: 'Reusable code, utilities, and module contracts made understandable outside the file where they were created. This division defines public interfaces, inputs, outputs, failures, dependencies, side effects, and compatibility.',
    audience: 'Developers, technical founders, integration builders, internal-tool teams, and operators maintaining code written by someone else.',
    problem: 'Code can work perfectly and still be difficult to reuse. Developer Libraries prevents reusable modules from becoming undocumented tribal knowledge.',
    covers: ['Public interfaces and supported inputs', 'Outputs, errors, and duplicate behavior', 'Dependencies, permissions, and side effects', 'Examples, tests, versions, and breaking changes'],
    verification: 'A library is ready when its examples run, valid inputs produce documented results, invalid inputs fail predictably, and external effects are visible.',
    boundary: 'A module contract documents supported behavior; it does not promise compatibility with unstated runtimes, dependencies, or future breaking changes.'
  },
  '03': {
    overview: 'Deployment maps, local infrastructure, service inventories, storage relationships, health checks, ownership, and recovery paths assembled into an inspectable operating picture.',
    audience: 'Founders, system operators, developers, small teams, and maintainers responsible for keeping connected services available.',
    problem: 'Infrastructure becomes fragile when nobody can clearly answer what runs where, which route reaches it, who owns it, or what must be restored first.',
    covers: ['Hosts, ports, domains, and service routes', 'Storage, bindings, and external dependencies', 'Health checks, logs, and ownership', 'Deployment, backup, recovery, and rollback'],
    verification: 'The infrastructure map is useful when every public route resolves to a known service, health checks are repeatable, ownership is explicit, and recovery steps identify the correct source of truth.',
    boundary: 'An inventory reveals dependencies and operating gaps; it does not replace provider access, backups, monitoring, or tested disaster recovery.'
  },
  '04': {
    overview: 'Human-directed automation blueprints that make triggers, decisions, approval gates, evidence, failure handling, retries, and completion conditions explicit.',
    audience: 'Operators, founders, automation builders, AI workflow designers, and teams turning repeated work into controlled execution.',
    problem: 'Automation becomes dangerous or unreliable when it hides decisions, repeats consequential actions, or declares success without evidence.',
    covers: ['Triggers, inputs, and decision rules', 'Human approvals and prohibited actions', 'Idempotency, retries, and failure handling', 'Receipts, completion tests, and rollback'],
    verification: 'A workflow passes when normal, duplicate, rejected, and failed executions behave predictably and consequential actions stop at the intended approval boundary.',
    boundary: 'A blueprint defines control logic; it does not authorize access, eliminate human responsibility, or guarantee that an external service will remain available.'
  },
  '05': {
    overview: 'Contracts, schemas, authentication boundaries, stable errors, replay handling, and integration-ready route definitions prepared before implementation begins.',
    audience: 'API designers, developers, technical founders, automation builders, and partners integrating separate systems.',
    problem: 'Integrations fail when callers and providers disagree about inputs, authentication, errors, retries, or what a successful response actually means.',
    covers: ['Routes, methods, inputs, and outputs', 'Authentication and authorization boundaries', 'Stable errors, retries, and replay behavior', 'Examples, compatibility, and acceptance tests'],
    verification: 'An API component is ready when the documented request succeeds, invalid requests fail consistently, unauthorized callers are rejected, and duplicates do not create unintended effects.',
    boundary: 'A contract specifies behavior; it does not create credentials, grant permissions, or prove that an undocumented implementation is secure.'
  },
  '06': {
    overview: 'Operator prompt contracts that separate objectives, source authority, constraints, tool permissions, evidence, uncertainty, output structure, and verified completion.',
    audience: 'People directing AI systems, building repeatable model workflows, evaluating outputs, or handing prompts to other operators.',
    problem: 'A clever prompt is not an operating system. Prompt Systems prevents intent, authority, evidence, and completion criteria from collapsing into vague instructions.',
    covers: ['Objective, context, and source authority', 'Constraints, tools, and approval boundaries', 'Evidence, uncertainty, and halt conditions', 'Output contracts and completion tests'],
    verification: 'A prompt system is useful when independent runs preserve the required structure, respect tool boundaries, expose uncertainty, and stop when evidence is insufficient.',
    boundary: 'Prompt instructions influence model behavior; they do not permanently override platform rules or guarantee deterministic, factual output.'
  },
  '07': {
    overview: 'Approval matrices, rulebooks, exception paths, evidence requirements, and practical boundaries for AI-assisted and automated operations.',
    audience: 'Founders, operators, automation owners, internal teams, and clients who need to know what a system may do independently.',
    problem: 'Without governance, autonomy becomes an assumption. Governance Packs make autonomous, approval-required, prohibited, and emergency actions explicit.',
    covers: ['Action classes and authority levels', 'Approval, escalation, and exception rules', 'Evidence, logging, and review requirements', 'Ownership, access, and recovery boundaries'],
    verification: 'Governance works when representative actions are classified consistently, prohibited actions stop, approvals are recorded, and exceptions remain visible for review.',
    boundary: 'A governance document is policy until enforcing code and passing tests prove that a control is implemented at runtime.'
  },
  '08': {
    overview: 'Controlled release reviews covering secrets, private data, access control, dependencies, integrity, recovery, findings, and release decisions.',
    audience: 'Developers, founders, release owners, automation builders, and customers preparing technical assets for deployment or handoff.',
    problem: 'A functioning build can still expose credentials, customer data, unsafe permissions, vulnerable dependencies, or an unusable recovery path.',
    covers: ['Secret and private-data exposure', 'Authentication, authorization, and permissions', 'Dependencies, integrity, and configuration', 'Findings, severity, remediation, and release decisions'],
    verification: 'A review is complete when findings link to evidence, material risks have owners and dispositions, release blockers are explicit, and the recovery path is documented.',
    boundary: 'This division supports structured release review; it is not a penetration test, formal certification, or guarantee that no vulnerability exists.'
  },
  '09': {
    overview: 'Commerce-readiness systems connecting offer identity, payment verification, entitlement, protected delivery, customer policies, support, and reconciliation.',
    audience: 'Digital-product sellers, founders, developers, storefront operators, and teams automating payment-to-delivery workflows.',
    problem: 'A buy button is not a commerce system. Customers need the correct product, verified payment, reliable entitlement, clear delivery, and a support path.',
    covers: ['Product, price, currency, and buyer promise', 'Payment verification and replay-safe events', 'Entitlement, fulfillment, and protected delivery', 'Policies, support, reconciliation, and recovery'],
    verification: 'Commerce is ready when paid, unpaid, duplicate, expired, missing-file, and refund-related paths produce the intended access and evidence.',
    boundary: 'Commerce tooling does not determine legal, tax, accounting, sanctions, privacy, or consumer-protection obligations.'
  },
  '10': {
    overview: 'Decision briefings that separate confirmed evidence, inference, unknowns, contradictions, operational meaning, confidence, and watch signals.',
    audience: 'Founders, operators, researchers, technical teams, and decision-makers who need signal without pretending uncertainty has disappeared.',
    problem: 'Updates become noise when facts, opinions, forecasts, and missing information are blended together without confidence or consequences.',
    covers: ['Confirmed evidence and primary sources', 'Inference, uncertainty, and contradictions', 'Operational meaning and decision options', 'Confidence, watch signals, and next checks'],
    verification: 'A briefing is useful when each material claim has a source or status, contradictions remain visible, decisions follow from evidence, and watch items can be checked later.',
    boundary: 'A briefing structures current information; it does not make uncertain claims certain or replace specialized legal, medical, or financial advice.'
  },
  '11': {
    overview: 'Public-ready visual, audio, narrative, and brand assets organized with specifications, usage rights, variants, source files, and production direction.',
    audience: 'Creators, founders, designers, editors, production partners, and customers receiving creative deliverables.',
    problem: 'A beautiful asset is difficult to use when formats, dimensions, variants, ownership, allowed uses, or source files are unclear.',
    covers: ['Asset identity, purpose, and approved variants', 'Formats, dimensions, color, and production specs', 'Source files, exports, and handoff notes', 'Ownership, licensing, attribution, and restrictions'],
    verification: 'A creative handoff passes when files open correctly, required variants exist, specifications match, rights are clear, and the recipient can reproduce the intended use.',
    boundary: 'Public presentation does not release private source material, customer assets, unreleased story canon, or third-party rights beyond their stated license.'
  },
  '12': {
    overview: 'Guides, operator drills, practice scenarios, review exercises, and human-in-the-loop learning assets focused on controlled use rather than passive reading.',
    audience: 'New and experienced operators learning AI workflows, verification, automation review, prompt control, and evidence-backed execution.',
    problem: 'Instructions are forgotten when the operator never practices decisions, failure recognition, verification, and intervention.',
    covers: ['Objectives, prerequisites, and operating vocabulary', 'Guided exercises and realistic scenarios', 'Expected results and review questions', 'Scoring, corrections, and repeat practice'],
    verification: 'Training works when the operator can complete the exercise, explain the decision boundary, detect an incorrect result, and repeat the process without hidden assistance.',
    boundary: 'Training assets build practical familiarity; they do not create professional licensure, certification, or guaranteed competence in every environment.'
  },
  '13': {
    overview: 'Local-first AI patterns, offline workflows, model and hardware planning, workstation maps, storage choices, and privacy-aware operating boundaries.',
    audience: 'Individuals, developers, small teams, researchers, and businesses evaluating AI workloads on hardware they control.',
    problem: 'Local AI choices become expensive or disappointing when hardware limits, model size, context, storage, privacy, and workflow requirements are ignored.',
    covers: ['Hardware, memory, storage, and acceleration', 'Model size, quantization, context, and runtime', 'Offline workflows, data boundaries, and updates', 'Performance checks, fallback plans, and maintenance'],
    verification: 'A stack is viable when the target model loads, representative tasks complete within acceptable limits, private data stays inside the declared boundary, and recovery is documented.',
    boundary: 'Local operation improves control but does not automatically make a model accurate, secure, private, fast, or suitable for every workload.'
  },
  '14': {
    overview: 'Versioned release pipelines using manifests, checksums, packaging rules, validation, distribution targets, handoff instructions, and rollback evidence.',
    audience: 'Developers, creators, product owners, operators, and teams turning working project folders into repeatable deliveries.',
    problem: 'Distribution fails when the wrong version ships, files are missing, integrity is unknown, or the recipient cannot install or verify what arrived.',
    covers: ['Version identity and release source', 'Packaging, manifests, and checksums', 'Validation, publishing, and distribution targets', 'Install, handoff, rollback, and release receipts'],
    verification: 'A pipeline passes when a clean environment can obtain the intended version, validate integrity, install it, run acceptance checks, and identify the rollback target.',
    boundary: 'A distribution pipeline proves the declared package flow; it does not guarantee third-party availability or compatibility outside tested environments.'
  },
  '15': {
    overview: 'Scoped private engagements for architecture, automation, AI systems, integration, documentation, commerce, local infrastructure, and specialized implementation.',
    audience: 'Founders, operators, developers, businesses, and partners whose requirements cannot be responsibly reduced to a public template or product page.',
    problem: 'Custom work fails when scope, inputs, confidentiality, ownership, acceptance, support, and delivery responsibilities remain implied.',
    covers: ['Problem definition, desired outcome, and constraints', 'Client inputs, confidentiality, and access boundaries', 'Deliverables, milestones, acceptance, and revisions', 'Ownership, support, handoff, and change control'],
    verification: 'A private build begins only after the scope identifies the parties, inputs, deliverables, boundaries, acceptance criteria, and authorized path to execution.',
    boundary: 'This public page explains the engagement layer without exposing customer information, private CrossingKey methods, credentials, or unreleased implementation material.'
  }
}

const root = document.querySelector('#app')
const icon = (value) => `<span class="ck-icon" aria-hidden="true">${value}</span>`

function safe(value) {
  return String(value).replace(/[&<>'"]/g, (char) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[char]))
}

function currentPath() { return window.location.pathname.replace(/\/+$/, '') || '/' }
function isExternal(url) { return /^https?:\/\//.test(url) }

function go(to) {
  if (isExternal(to)) return window.open(to, '_blank', 'noopener,noreferrer')
  window.history.pushState({}, '', to)
  render()
  const hash = new URL(to, window.location.origin).hash
  if (hash) document.querySelector(hash)?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  else window.scrollTo(0, 0)
}

function link(label, href, className = '') {
  const external = isExternal(href)
  return `<a class="${className}" href="${href}" ${external ? 'target="_blank" rel="noopener noreferrer"' : `data-route="${href}"`}>${label}${external ? '<span class="ck-external" aria-hidden="true">↗</span>' : ''}</a>`
}

function nav() {
  return `
    <header class="ck-topbar">
      <a class="ck-brand" href="/" data-route="/" aria-label="CrossingKey Intelligence home">
        <span class="ck-brand-mark" aria-hidden="true"><img src="/assets/ck-medallion-silver.png" alt="" width="1254" height="1254" decoding="async"></span>
        <span class="ck-brand-copy"><b>CROSSINGKEY™</b><small>INTELLIGENCE™</small><span class="ck-brand-signature">CrossingKey Intelligence is the standard.</span></span>
      </a>
      <nav class="ck-nav" aria-label="Primary navigation">
        ${link('Exchange', EXCHANGE_URL)}
        ${link('Fleet', SHOP_URL)}
        ${link('Join CrossingKey', '/join')}
        ${link('Resources', '/resources')}
        ${link('About', '/about')}
      </nav>
      <div class="ck-topbar-actions">
        ${link('Join CrossingKey', '/join', 'ck-btn ck-btn-primary ck-btn-top')}
        <button class="ck-menu-btn" type="button" data-menu-toggle aria-label="Open site menu" aria-expanded="false"><i></i><i></i></button>
      </div>
      <div class="ck-mobile-menu" data-mobile-menu hidden>
        <div class="ck-mobile-brand" aria-label="CrossingKey Intelligence">
          <img src="/assets/ck-medallion-silver.png" alt="" width="1254" height="1254" decoding="async">
          <span><b>CROSSINGKEY™ INTELLIGENCE™</b><small>CrossingKey Intelligence is the standard.</small></span>
        </div>
        ${link('Exchange', EXCHANGE_URL)}
        ${link('Fleet', SHOP_URL)}
        ${link('Join CrossingKey', '/join')}
        ${link('Resources', '/resources')}
        ${link('About', '/about')}
        ${link('Contact', '/contact')}
        ${link('The CrossingKey Archive', '/archive')}
      </div>
    </header>`
}

function footer() {
  return `<footer class="ck-footer">
    <div><b>CROSSINGKEY INTELLIGENCE</b><span>I design systems for people who intend to operate.</span></div>
    <div class="ck-footer-links">${link('Standards', '/standards')}${link('Authorship & Rights', '/authorship-trademark-rights')}${link('Contact', '/contact')}${link('Support', `${SHOP_URL}pages/contact`)}</div>
  </footer>`
}

function pageHero(eyebrow, title, copy, actions = '') {
  return `<section class="ck-page-hero"><p class="ck-kicker"><span></span>${eyebrow}</p><h1>${title}</h1><p>${copy}</p>${actions ? `<div class="ck-hero-actions">${actions}</div>` : ''}</section>`
}

function home() {
  const quick = ['EdgeNode-X', 'Product Fleet', 'Standards & Verification', 'The Navigator', 'Local AI', 'Enterprise Systems']
  const hero = siteContent.home.hero
  const heroTheme = siteTheme.home.hero
  return `
    <section class="ck-hero">
      <div class="ck-hero-emblem" aria-hidden="true"><img src="/assets/ck-medallion-silver.png" alt="" width="1254" height="1254" decoding="async" fetchpriority="high"></div>
      <div class="ck-hero-copy">
        <p class="ck-kicker" data-editable-id="home.hero.eyebrow"><span></span>${safe(hero.eyebrow)}</p>
        <h1 class="ck-hero-title"><span data-editable-id="home.hero.brand" style="font-size:${safe(heroTheme.brand.fontSize)};font-weight:${safe(heroTheme.brand.fontWeight)};letter-spacing:${safe(heroTheme.brand.letterSpacing)};opacity:${safe(heroTheme.brand.opacity)};text-align:${safe(heroTheme.brand.alignment)}">${safe(hero.brand)}</span><em data-editable-id="home.hero.statement" style="font-size:${safe(heroTheme.statement.fontSize)};font-weight:${safe(heroTheme.statement.fontWeight)};letter-spacing:${safe(heroTheme.statement.letterSpacing)};opacity:${safe(heroTheme.statement.opacity)};text-align:${safe(heroTheme.statement.alignment)}">${safe(hero.statement)}</em></h1>
        <p class="ck-hero-text" data-editable-id="home.hero.body">${safe(hero.body)}</p>
        <div class="ck-hero-actions">
          ${link('Get The Signal', '/join', 'ck-btn ck-btn-primary')}
          ${link('How It Works', '/about#overview', 'ck-btn ck-btn-ghost')}
          ${link('Start a Conversation', '/contact?intent=project', 'ck-btn ck-btn-ghost')}
        </div>
      </div>
      <aside class="ck-signal-panel" aria-label="Public CrossingKey index">
        <div class="ck-search-wrap">
          <span class="ck-search-icon" aria-hidden="true">⌕</span>
          <input class="ck-search-input" data-search aria-label="Search the public CrossingKey index" placeholder="Search the public CrossingKey index" autocomplete="off" />
          <button class="ck-search-go" type="button" data-search-go aria-label="Search public index">✦</button>
        </div>
        <div class="ck-search-results" data-search-results aria-live="polite"></div>
        <p class="ck-trending-label">PUBLIC INDEX</p>
        <div class="ck-chip-row">${quick.map((item) => `<button class="ck-chip" type="button" data-search-chip="${item}">${item}</button>`).join('')}</div>
        <p class="ck-search-boundary">I index only public pages, public standards, and product links here. I do not index private work.</p>
      </aside>
    </section>
    <section class="ck-signal-rail" aria-hidden="true"><span></span><i></i><i></i><i></i></section>
    <section class="ck-section-intro" id="overview"><p>15 public-facing divisions. One operating standard.</p><h2>Find the layer you need. Buy through Fleet. Bring higher-scope work directly to me through the portal.</h2></section>
    <section class="ck-card-grid" aria-label="CrossingKey divisions">
      ${cards.map(([number, tier, title, text, symbol]) => `<article class="ck-card"><header><div>${icon(symbol)}<span>${number}</span></div><p>${tier}</p></header><h3>${title}</h3><p>${text}</p><button type="button" data-route="/division${Number(number)}" aria-label="Explore ${title}">→</button></article>`).join('')}
    </section>`
}

function divisionPage(number) {
  const copy = divisionCopy[String(number)]
  if (!copy) return notFound()
  return `<article class="ck-division-copy" data-division="${number}">${copy.replace('href="/fleet"', `href="${SHOP_URL}" target="_blank" rel="noopener noreferrer"`)}</article>`
}

function about() {
  return `<article class="ck-about-page">
    ${pageHero('JEREMY PAUL ALLEN // crossingkey_ // FOUNDER & NAVIGATOR', 'CrossingKey™ a connected system of technology, intelligence, and original work.', 'I am Jeremy Paul Allen, founder of CrossingKey Intelligence™ and known online as crossingkey_. My work spans software, artificial intelligence, human + AI co-evolution, automation, research, systems design, and original creative work.', `${link('Explore the 15 divisions', '/#overview', 'ck-btn ck-btn-primary')}${link('Work with CrossingKey', '/contact?intent=project', 'ck-btn ck-btn-ghost')}`)}

    <section class="ck-about-founder" id="overview">
      <div class="ck-about-founder-mark" aria-hidden="true"><img src="/assets/ck-medallion-silver.png" alt="" width="1254" height="1254" decoding="async"></div>
      <div class="ck-about-founder-copy"><p class="ck-kicker"><span></span>THE FOUNDER</p><h2>Designed from the command line outward.</h2><p>I did not arrive here through a conventional technology career. I taught myself by designing: first through Termux and command-line tools, then across Linux workstations, local servers, Cloudflare, GitHub, APIs, storefronts, payment systems, automation, AI workflows, documentation, and release infrastructure.</p><p>The education came through direct contact with the work—systems breaking, evidence being gathered, assumptions being corrected, and each successful recovery becoming part of a stronger operating method. CrossingKey grew from that process.</p><p>I use <strong>the Navigator</strong> as the founder role because the work is not about pretending intelligence can replace human direction. It is about choosing the destination, reading the conditions, defining the boundaries, and remaining accountable for the route.</p></div>
    </section>

    <section class="ck-about-statement"><p class="ck-kicker"><span></span>CROSSINGKEY INTELLIGENCE™</p><h2>CrossingKey Intelligence is a technology firm offering private systems design, custom implementation, and consulting.</h2><p>I design inspectable systems intended to be understood, tested, delivered, maintained, and improved without surrendering human direction. Public material describes the standard and the outcome; reusable methods, internal architecture, decision logic, and implementation detail remain protected.</p></section>

    <section class="ck-section-intro"><p class="ck-kicker"><span></span>CROSSINGKEY</p><h2>CROSSINGKEY HAS A CLEAR PURPOSE.</h2></section>
    <section class="ck-about-constellation">
      <article><p>TECHNOLOGY FIRM</p><h3>CrossingKey Intelligence™</h3><span>My public operating center for software, AI systems, human–AI co-evolution, governance, products, technical services, research, verification, and delivery.</span>${link('Explore the divisions', '/#overview', 'ck-text-link')}</article>
      <article><p>COMMERCE INTERFACE</p><h3>CrossingKey Exchange</h3><span>I use the Exchange to help you describe a need and discover the most relevant CrossingKey product, resource, or service path.</span>${link('Enter Exchange', EXCHANGE_URL, 'ck-text-link')}</article>
      <article><p>PRODUCT FLEET</p><h3>Fleet</h3><span>I use Fleet as the commercial catalog for my CrossingKey digital products, tools, frameworks, libraries, guides, and operating assets.</span>${link('Browse Fleet', SHOP_URL, 'ck-text-link')}</article>
      <article><p>FIELD SIGNAL</p><h3>The Navigator</h3><span>I publish The Navigator as my field-note and founder-signal path for AI, systems, psychology, systems design, control, and what I learn in motion.</span>${link('Join The Navigator', '/join', 'ck-text-link')}</article>
      <article><p>KNOWLEDGE ENVIRONMENT</p><h3>CrossingKey Alexandria</h3><span>I am developing Alexandria as a consumer knowledge environment that combines useful preassembled material with the buyer’s own growing library.</span><em>In development</em></article>
      <article><p>OPERATIONAL FORMAT</p><h3>.xkey</h3><span>I developed .xkey as a proprietary CrossingKey structured-work format. Its public description identifies its role; the specification, reusable methods, and implementation logic remain protected.</span><em>Used across selected CrossingKey systems</em></article>
      <article><p>LOCAL INTELLIGENCE</p><h3>Local AI & Agentic Systems</h3><span>I design local-first AI, operator-controlled workflows, agentic tools, and infrastructure around human authority, inspectability, and recovery.</span>${link('Explore Local AI', '/division13', 'ck-text-link')}</article>
      <article><p>ORIGINAL CREATIVE IP</p><h3>The CrossingKey Universe</h3><span>Jeremy Paul Allen’s original science-fiction universe—developed through CrossingKey creative production with its own characters, continuity, visual language, and canon.</span><em>Creative work remains distinct from client-confidential systems</em></article>
    </section>

    <section class="ck-divisions-intro">
      <p class="ck-kicker"><span></span>15-divisions</p>
    </section>
    <section class="ck-about-division-map">
      ${cards.map(([number, tier, title]) => `<a href="/division${Number(number)}" data-route="/division${Number(number)}"><span>${number}</span><div><p>${safe(tier)}</p><h3>${safe(title)}</h3></div><b aria-hidden="true">→</b></a>`).join('')}
    </section>

    <section class="ck-about-principles">
      <div><p class="ck-kicker"><span></span>HOW THE WORK IS HELD</p><h2>Intelligence needs direction, boundaries, evidence, and an owner.</h2><p>I do not treat volume as proof, automation as authority, or a polished interface as evidence that the system underneath is complete.</p></div>
      <ul><li><strong>Intent before output.</strong> The desired result and the affected person are defined first.</li><li><strong>Human authority remains visible.</strong> Consequential actions require an accountable decision-maker.</li><li><strong>Verification before completion.</strong> Claims are tied to tests, records, or clearly labeled limitations.</li><li><strong>Public and private stay separated.</strong> Customer information, credentials, private source, and unreleased mechanics are protected.</li><li><strong>Delivery has boundaries.</strong> Scope, ownership, acceptance, support, and exclusions are stated.</li><li><strong>Recovery is part of design.</strong> A system that cannot be understood or restored is not finished merely because it runs today.</li></ul>
    </section>

    <section class="ck-about-now"><p class="ck-kicker"><span></span>WHAT I DESIGN NOW</p><h2>I make products for repeatable needs and private systems for specific problems.</h2><div class="ck-about-now-grid"><article><h3>Buy a finished CrossingKey product</h3><p>Use Fleet or a division page to purchase one of my guides, toolkits, frameworks, libraries, templates, or software products through its verified checkout path.</p>${link('Browse Fleet', SHOP_URL, 'ck-btn ck-btn-primary')}</article><article><h3>Commission a scoped system</h3><p>Bring me a defined operational problem that requires private architecture, automation, integration, documentation, research, or implementation.</p>${link('Request a private build', '/contact?intent=project', 'ck-btn ck-btn-ghost')}</article></div></section>

    <section class="ck-callout"><p>I designed CrossingKey and direct it through evidence. My products and services are tools and scoped professional work—not guarantees of revenue, compliance, security, approval, or commercial outcomes.</p>${link('Read the public standards', '/standards', 'ck-text-link')} ${link('Read the authorship and rights record', '/authorship-trademark-rights', 'ck-text-link')}</section>
  </article>`
}

function resources() {
  const archive = siteContent.resources
  return `${pageHero(safe(archive.eyebrow), safe(archive.headline), safe(archive.supportingCopy), `<a class="ck-btn ck-btn-primary" href="#public-documents">${safe(archive.primaryCta)}</a><a class="ck-btn ck-btn-ghost" href="#operator-vault">${safe(archive.secondaryCta)}</a>`)}
    <section class="ck-document-grid" id="public-documents" aria-label="Public CrossingKey previews">
      ${archive.articles.map((article, index) => `<article class="ck-document-card"><p>FIELD NOTE ${String(index + 1).padStart(2, '0')}</p><h2>${safe(article.title)}</h2><span>${safe(article.description)}</span><small>${safe(article.readingTime)}</small>${link('Read the public preview', article.route, 'ck-text-link')}</article>`).join('')}
    </section>
    ${operatorVault()}`
}

function isVerifiedVaultUrl(value) {
  try {
    const url = new URL(value)
    const allowedPath = /^\/(products|cart|checkouts)\//.test(url.pathname)
    return url.protocol === 'https:' && url.hostname === 'shop.crossingkeyintelligence.com' && allowedPath
  } catch {
    return false
  }
}

function operatorVault() {
  const vault = siteContent.resources.vault
  const ready = isVerifiedVaultUrl(OPERATOR_VAULT_CHECKOUT_URL)
  const cta = ready
    ? `<a class="ck-btn ck-btn-primary" href="${safe(OPERATOR_VAULT_CHECKOUT_URL)}" target="_blank" rel="noopener noreferrer">Get the Operator Vault — $29<span class="ck-external" aria-hidden="true">↗</span></a>`
    : link('Operator Vault — preparing release', '/contact?interest=operator-vault', 'ck-btn ck-btn-ghost')
  return `<section class="ck-vault" id="operator-vault">
    <div class="ck-vault-copy"><p class="ck-kicker"><span></span>${safe(vault.eyebrow)}</p><h2>${safe(vault.title)}</h2><p>${safe(vault.description)}</p><div class="ck-vault-prices"><strong>${safe(vault.launchPrice)}</strong><span>${safe(vault.standardPrice)}</span></div>${cta}</div>
    <div class="ck-vault-contents"><p>VOLUME I INCLUDES</p><ul>${vault.includes.map((item) => `<li>${safe(item)}</li>`).join('')}</ul></div>
  </section>`
}

function resourceArticle(article) {
  if (!article) return notFound()
  return `<article class="ck-article">
    <header class="ck-article-head"><p class="ck-kicker"><span></span>DOCUMENTATION ARCHIVE</p><p class="ck-article-meta">${safe(article.readingTime)}</p><h1>${safe(article.title)}</h1><p>${safe(article.description)}</p></header>
    <div class="ck-article-body">
      ${article.sections.map((section) => `<section><h2>${safe(section.heading)}</h2>${section.paragraphs.map((paragraph) => `<p>${safe(paragraph)}</p>`).join('')}</section>`).join('')}
      <section class="ck-article-takeaways"><h2>Operator takeaways</h2><ul>${article.takeaways.map((item) => `<li>${safe(item)}</li>`).join('')}</ul></section>
    </div>
    <aside class="ck-article-vault"><p>The reusable prompts, blueprints, templates, evaluation assets, and operating methods are available in the paid Operator Vault.</p><a class="ck-text-link" href="/resources#operator-vault">Enter the Operator Vault →</a></aside>
  </article>`
}

function join() {
  return `${pageHero('THE NAVIGATOR', 'A weekly issue from crossingkey_.', 'Subscribe to The Navigator for one issue each week: what I am thinking about, building, testing, questioning, and discovering across AI, human + AI co-evolution, systems, technology, research, and CrossingKey development.')}
    <section class="ck-form-layout"><div><h2>What you join</h2><ul><li>One issue every week, directed by crossingkey_</li><li>AI, human + AI co-evolution, systems, technology, and research</li><li>What I am building, testing, questioning, and learning in motion</li><li>Selected CrossingKey releases and developments when they belong in the issue</li></ul><p class="ck-form-note">No spam. Unsubscribe anytime.</p></div>${newsletterForm()}</section>`
}

function newsletterForm() {
  return `<form class="ck-form" data-intake-form="subscribe"><label>Email<input type="email" name="email" autocomplete="email" required placeholder="you@example.com" /></label><label>What are you building?<select name="interest" required><option value="">Choose one</option><option>Founder</option><option>Operator</option><option>Developer</option><option>Local AI</option></select></label><label class="ck-checkbox"><input type="checkbox" name="consent" required /> I agree to receive The Navigator and release notes. I can unsubscribe anytime.</label><div class="ck-turnstile" data-turnstile="join"></div><button class="ck-btn ck-btn-primary" type="submit">Get The Signal</button><p class="ck-form-status" data-form-status aria-live="polite"></p></form>`
}

function contact() {
  const query = new URLSearchParams(window.location.search)
  const initial = ['product', 'project', 'licensing', 'support', 'archive'].includes(query.get('intent')) ? query.get('intent') : 'project'
  return `${pageHero('CONTACT PORTAL', 'Bring me the real question.', 'Choose the right route and give me enough context to make my response useful.')}
    <section class="ck-contact-paths"><article>${icon('□')}<h2>Ask about a product</h2><p>Access, compatibility, documentation, license, or delivery questions.</p></article><article>${icon('⇄')}<h2>Scope a system</h2><p>Custom AI, operations, automation, local-first tools, or implementation planning.</p></article><article>${icon('◒')}<h2>Creative licensing</h2><p>Characters, worlds, music, writing, visual direction, or commercial usage.</p></article><article>${icon('◈')}<h2>Order support</h2><p>Verified delivery errors, missing files, or documented product-use questions.</p></article></section>
    <section class="ck-form-layout"><div><h2>Before you send</h2><p>If you want a response from me, include at least one thoughtful paragraph about a technology topic of your choice. It does not have to relate to CrossingKey. I want to see what interests you, how you think about it, and that you brought more than “Hi, Navigator.”</p><p>Serious project inquiries should also explain what you are trying to build, solve, investigate, or improve.</p><p>Do not send passwords, payment-card data, API keys, seed phrases, or private credentials. For product support, include your order number and checkout email.</p></div>${contactForm(initial)}</section>`
}

function contactForm(initial, source = 'contact') {
  return `<form class="ck-form" data-intake-form="contact" data-source="${source}"><label>Name<input name="name" autocomplete="name" required maxlength="100" placeholder="Your name" /></label><label>Email<input type="email" name="email" autocomplete="email" required placeholder="you@example.com" /></label><label>Route<select name="topic" required><option value="product" ${initial === 'product' ? 'selected' : ''}>Ask about a product</option><option value="project" ${initial === 'project' ? 'selected' : ''}>Scope a system</option><option value="licensing" ${initial === 'licensing' ? 'selected' : ''}>Creative licensing</option><option value="support" ${initial === 'support' ? 'selected' : ''}>Order support</option><option value="archive" ${initial === 'archive' ? 'selected' : ''}>Archive access</option></select></label><label>Message<textarea name="message" required minlength="120" maxlength="5000" placeholder="Start with at least one paragraph about a technology topic of your choice. Then tell me what you need, your constraints, and the outcome you are aiming for."></textarea></label><div class="ck-turnstile" data-turnstile="contact"></div><button class="ck-btn ck-btn-primary" type="submit">Send securely</button><p class="ck-form-status" data-form-status aria-live="polite"></p></form>`
}

function archive() {
  return `${pageHero('THE CROSSINGKEY ARCHIVE', 'The creative record behind the CrossingKey constellation.', 'I preserve my original music, writing, visual development, artifacts, and world-building with authorship, context, and licensing boundaries intact.', `${link('Request Archive Access', '/contact?intent=archive', 'ck-btn ck-btn-primary')}${link('Discuss creative licensing', '/contact?intent=licensing', 'ck-btn ck-btn-ghost')}`)}
    <section class="ck-prose-grid"><article><h2>What the Archive preserves</h2><p>I use the Archive to bring together selected work from my CrossingKey creative archive and the wider CrossingKey universe: original writing, music, visual development, characters, worlds, production fragments, and the ideas that connect them. I present each public or approved preview with its authorship and creative context intact.</p></article><article><h2>How the work can be engaged</h2><p>Readers, collaborators, publishers, producers, and creative partners can ask me for access to relevant selections and discuss material suited to publication, production, exhibition, soundtrack use, adaptation, or licensing. I confirm available rights and permitted uses separately for every project.</p></article></section>
    <section class="ck-callout"><p>Rights in Jeremy Paul Allen’s protectable original contributions are retained by Jeremy Paul Allen unless a specific written credit, license, assignment, or agreement states otherwise. Public viewing does not transfer ownership or grant permission to reproduce, distribute, adapt, train on, or commercially use protected material. Third-party material remains subject to its respective ownership and terms. Unreleased stories, production masters, source files, customer information, and private creative systems remain non-public.</p>${link('Read the complete rights record', '/authorship-trademark-rights', 'ck-text-link')}</section>`
}

function authorshipTrademarkRights() {
  return `${pageHero(
    'AUTHORSHIP, TRADEMARK & RIGHTS',
    'Human direction. Traceable authorship. Accurate ownership.',
    'I use this record to state the public identity, authorship, trademark, copyright, and third-party boundaries behind CrossingKey Intelligence.',
    `${link('About CrossingKey Intelligence', '/about', 'ck-btn ck-btn-primary')}${link('Contact CrossingKey', '/contact?intent=project', 'ck-btn ck-btn-ghost')}`
  )}
    <section class="ck-prose-grid">
      <article>
        <p class="ck-kicker"><span></span>FOUNDER & HUMAN AUTHORITY</p>
        <h2>I am Jeremy Paul Allen, operating online as crossingkey_.</h2>
        <p>I am the founder, directing human authority, and present rights holder for my protectable original CrossingKey contributions. I operate publicly under the handle <strong>crossingkey_</strong>.</p>
        <p>CrossingKey Intelligence™ is my technology firm. Through it, I develop software, artificial-intelligence systems, AI-governance architecture, human–AI co-evolution frameworks, automation, interaction models, local-first infrastructure, documentation, research, products, and related technical work.</p>
      </article>

    </section>

    <section class="ck-about-statement">
      <p class="ck-kicker"><span></span>HUMAN + AI CO-EVOLUTION</p>
      <h2>Human + AI co-evolution.</h2>
      <p>CrossingKey is designed around a simple premise: the future of intelligence is not human versus artificial intelligence. It is what becomes possible when both learn to work together.</p>
      <p>I use AI as an active part of exploration, creation, engineering, research, and execution while human experience, judgment, imagination, curiosity, and intent remain part of the process.</p>
      <p>The relationship is reciprocal. Humans shape the systems they design, and increasingly capable systems change how humans think, create, discover, and operate. Each expands the possibilities available to the other.</p>
      <p>CrossingKey explores that boundary deliberately: not the replacement of human intelligence, but the development of new forms of collaboration between human and machine intelligence.</p>
      <p>The objective is not surrendering human agency to AI.</p>
      <p>It is discovering what both can become together.</p>
    </section>

    <section class="ck-callout">
      ${link('Read the public standards', '/standards', 'ck-text-link')}
      ${link('Contact the founder', '/contact?intent=licensing', 'ck-text-link')}
    </section>`
}

function standards() {
  return `${pageHero('STANDARDS & VERIFICATION', 'Proof, boundaries, and control.', 'I do not call a release complete because it sounds complete. I require identifiable contents, a defined purpose, clear limits, and a way to check what arrived.')}
    <section class="ck-resource-grid"><article>${icon('▤')}<p>INSPECTABLE</p><h2>Clear artifacts</h2><span>Readable files, stated deliverables, documentation, version identification, and public scope.</span></article><article>${icon('◈')}<p>VERIFIABLE</p><h2>Checked claims</h2><span>Manifests, checksums, tests, release notes, and read-back steps where applicable.</span></article><article>${icon('⛉')}<p>BOUNDED</p><h2>Honest limits</h2><span>No invented guarantees, concealed dependencies, vague fulfillment, or fake proof.</span></article><article>${icon('⇄')}<p>HUMAN-DIRECTED</p><h2>Approval gates</h2><span>Consequential actions require human judgment, recorded constraints, and recovery paths where practical.</span></article></section>
    <section class="ck-callout"><p>I may apply stricter standards to specific products than this public baseline. My public standard is a commitment to clarity, not a claim that every environment is risk-free.</p></section>`
}

function notFound() { return `${pageHero('404', 'That public page does not exist.', 'The route may have moved, or it was never meant to be public.', `${link('Return home', '/', 'ck-btn ck-btn-primary')}`)}` }

function view() {
  const path = currentPath()
  if (path === '/') return home()
  const divisionMatch = path.match(/^\/division([1-9]|1[0-5])$/)
  if (divisionMatch) return divisionPage(Number(divisionMatch[1]))
  if (path === '/about') return about()
  if (path === '/resources') return resources()
  if (path.startsWith('/resources/')) return resourceArticle(siteContent.resources.articles.find((article) => article.route === path))
  if (path === '/join') return join()
  if (path === '/contact') return contact()
  if (path === '/archive') return archive()
  if (path === '/standards') return standards()
  if (path === '/authorship-trademark-rights') return authorshipTrademarkRights()
  return notFound()
}

function showSearch(query) {
  const box = root.querySelector('[data-search-results]')
  if (!box) return
  const q = query.trim().toLowerCase()
  if (!q) { box.innerHTML = ''; return }
  const results = publicIndex.filter((item) => `${item.title} ${item.type} ${item.text} ${item.tags}`.toLowerCase().includes(q)).slice(0, 5)
  box.innerHTML = results.length ? results.map((item) => `<button type="button" data-search-result="${safe(item.href)}"><span>${safe(item.type)}</span><b>${safe(item.title)}</b><em>${safe(item.text)}</em></button>`).join('') : `<p>No public result for that query. Try Fleet, standards, local AI, or Navigator.</p>`
}

function enableSearch() {
  const input = root.querySelector('[data-search]')
  if (!input) return
  const execute = () => showSearch(input.value)
  input.addEventListener('input', execute)
  input.addEventListener('keydown', (event) => { if (event.key === 'Enter') { event.preventDefault(); execute() } })
  root.querySelector('[data-search-go]')?.addEventListener('click', execute)
  root.querySelectorAll('[data-search-chip]').forEach((button) => button.addEventListener('click', () => { input.value = button.dataset.searchChip; execute() }))
  root.querySelector('[data-search-results]')?.addEventListener('click', (event) => {
    const button = event.target.closest('[data-search-result]')
    if (button) go(button.dataset.searchResult)
  })
}

function loadTurnstile() {
  if (window.turnstile) return Promise.resolve(window.turnstile)
  return new Promise((resolve, reject) => {
    const existing = document.querySelector('script[data-ck-turnstile-script]')
    if (existing) { existing.addEventListener('load', () => resolve(window.turnstile), { once: true }); return }
    const script = document.createElement('script')
    script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit'
    script.async = true
    script.defer = true
    script.dataset.ckTurnstileScript = 'true'
    script.onload = () => resolve(window.turnstile)
    script.onerror = reject
    document.head.append(script)
  })
}

async function mountTurnstile() {
  const slots = root.querySelectorAll('[data-turnstile]')
  if (!slots.length) return
  if (!TURNSTILE_SITE_KEY) {
    slots.forEach((slot) => { slot.textContent = `Secure email fallback is active. Your email app will open so you can review before sending to ${CONTACT_EMAIL}.` })
    root.querySelectorAll('[data-intake-form]').forEach((form) => { form.dataset.delivery = 'email-fallback' })
    return
  }
  try {
    const turnstile = await loadTurnstile()
    slots.forEach((slot) => turnstile.render(slot, { sitekey: TURNSTILE_SITE_KEY, theme: 'dark', size: 'flexible', action: slot.dataset.turnstile }))
  } catch { slots.forEach((slot) => { slot.textContent = 'Verification could not load. Please refresh or email navigator@crossingkeyintelligence.com.' }) }
}

async function submitForm(form) {
  const status = form.querySelector('[data-form-status]')
  const button = form.querySelector('button[type="submit"]')
  const type = form.dataset.intakeForm
  const data = Object.fromEntries(new FormData(form).entries())
  const payload = type === 'subscribe'
    ? { email: data.email, interest: data.interest, consent: data.consent === 'on', turnstileToken: data['cf-turnstile-response'] || '' }
    : { name: data.name, email: data.email, topic: data.topic, message: data.message, source: form.dataset.source || 'contact', turnstileToken: data['cf-turnstile-response'] || '' }
  if (form.dataset.delivery === 'email-fallback') {
    const subject = type === 'subscribe' ? 'Join The Navigator' : `CrossingKey inquiry — ${data.topic}`
    const body = type === 'subscribe'
      ? `Email: ${data.email}\nInterest: ${data.interest}\nConsent to receive The Navigator: yes`
      : `Name: ${data.name}\nEmail: ${data.email}\nRoute: ${data.topic}\nSource: ${form.dataset.source || 'contact'}\n\n${data.message}`
    window.location.href = `mailto:${CONTACT_EMAIL}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`
    status.textContent = 'Your email app is opening. Review the message, then send it when ready.'
    return
  }
  button.disabled = true
  status.textContent = 'Sending securely…'
  try {
    const response = await fetch(type === 'subscribe' ? '/api/subscribe' : '/api/contact', { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(payload) })
    const result = await response.json()
    if (!response.ok) throw new Error(result.error || 'Unable to send right now.')
    form.reset()
    status.textContent = type === 'subscribe' ? 'You are on my signal list.' : 'Received. I will review the request.'
  } catch (error) {
    status.textContent = error.message || 'Unable to send right now. Email navigator@crossingkeyintelligence.com.'
  } finally { button.disabled = false }
}

function bindInteractions() {
  root.querySelectorAll('[data-route]').forEach((anchor) => anchor.addEventListener('click', (event) => { event.preventDefault(); go(anchor.dataset.route) }))
  const menu = root.querySelector('[data-mobile-menu]')
  root.querySelector('[data-menu-toggle]')?.addEventListener('click', (event) => { const open = menu.hidden; menu.hidden = !open; event.currentTarget.setAttribute('aria-expanded', String(open)) })
  root.querySelectorAll('[data-intake-form]').forEach((form) => form.addEventListener('submit', (event) => { event.preventDefault(); submitForm(form) }))
  root.querySelectorAll('.ck-division-copy .example-release button').forEach((button) => button.addEventListener('click', async () => {
    const example = button.closest('.example-release')?.querySelector('pre')?.textContent || ''
    if (!example) return
    try {
      await navigator.clipboard.writeText(example)
      const original = button.innerHTML
      button.textContent = 'Copied'
      window.setTimeout(() => { button.innerHTML = original }, 1600)
    } catch { button.textContent = 'Select and copy the example below' }
  }))
  enableSearch()
  mountTurnstile()
}

function render() {
  root.innerHTML = `<div class="ck-app-shell"><div class="ck-webgl-fallback" aria-hidden="true"></div>${nav()}<main class="ck-main">${view()}</main>${footer()}</div>`
  bindInteractions()
  if (!document.documentElement.dataset.ckRenderer) {
    const started = initCKWebGLField()
    if (!started) initCKParticles()
  }
}

window.addEventListener('popstate', render)
render()
