#!/usr/bin/env bash
set -euo pipefail

echo "⚡ CrossingKey Approved Render v2 controlled pass starting..."

PROJECT_DIR="$(pwd)"

[ -f package.json ] || {
  echo "[CK ERROR] Run this from the Vite project root."
  exit 1
}

[ -f src/main.js ] || {
  echo "[CK ERROR] src/main.js not found."
  exit 1
}

[ -f src/ck-reboot.css ] || {
  echo "[CK ERROR] src/ck-reboot.css not found."
  exit 1
}

STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p .ck-approved-builds .ck-backups src

tar -czf ".ck-backups/ck-before-approved-render-v2-$STAMP.tar.gz" \
  src public package.json vite.config.* index.html 2>/dev/null || true

cp src/main.js ".ck-backups/main.js.v2-before-$STAMP.bak"
cp src/ck-reboot.css ".ck-backups/ck-reboot.css.v2-before-$STAMP.bak"

cat > /tmp/ck_patch_main_v2.py <<'PY'
from pathlib import Path
import re

p = Path("src/main.js")
s = p.read_text()

cards_js = """const cards = [
  {
    number: '01',
    tier: 'Core Archive',
    title: 'Documentation Archives',
    text: 'Engineering records, manuals, proof files, policies, receipts, and product documentation that make every system inspectable.',
  },
  {
    number: '02',
    tier: 'Builder Layer',
    title: 'Developer Libraries',
    text: 'Reusable code, utilities, components, and implementation patterns for builders who need clean foundations.',
  },
  {
    number: '03',
    tier: 'Infrastructure Layer',
    title: 'Infrastructure Toolkits',
    text: 'Deployment maps, server logic, Cloudflare assets, install flows, and operational rails for public or private systems.',
  },
  {
    number: '04',
    tier: 'Execution Layer',
    title: 'Automation Frameworks',
    text: 'Repeatable workflows that turn manual tasks into governed, reviewable execution pipelines.',
  },
  {
    number: '05',
    tier: 'Integration Layer',
    title: 'API Components',
    text: 'Endpoints, request contracts, schemas, payment gates, mocks, and integration-ready service pieces.',
  },
  {
    number: '06',
    tier: 'Prompt Layer',
    title: 'Prompt Systems',
    text: 'Reusable prompt architectures, operator instructions, and controlled AI workflows for repeatable output quality.',
  },
  {
    number: '07',
    tier: 'Governance Layer',
    title: 'Governance Packs',
    text: 'Rules, review gates, approval flows, policy language, and audit-ready structures for controlled AI execution.',
  },
  {
    number: '08',
    tier: 'Security Layer',
    title: 'Security Reviews',
    text: 'Inspection checklists, boundary maps, risk notes, hardening paths, and operational review assets.',
  },
  {
    number: '09',
    tier: 'Commerce Layer',
    title: 'Commerce Systems',
    text: 'Storefront structures, product logic, checkout routes, paid access patterns, and market-ready sales rails.',
  },
  {
    number: '10',
    tier: 'Signal Layer',
    title: 'Intelligence Briefings',
    text: 'Research formats, alert patterns, market signals, executive summaries, and decision-ready information flows.',
  },
  {
    number: '11',
    tier: 'Creative Layer',
    title: 'Creative Assets',
    text: 'Brand systems, visual prompts, media kits, design language, and production-ready creative direction.',
  },
  {
    number: '12',
    tier: 'Training Layer',
    title: 'Operator Training',
    text: 'Guides, drills, onboarding flows, command references, and skill-building assets for human-in-the-loop operators.',
  },
  {
    number: '13',
    tier: 'Local AI Layer',
    title: 'Local AI Stacks',
    text: 'Local-first AI provisioning, model-running patterns, offline workflows, and workstation-ready system layouts.',
  },
  {
    number: '14',
    tier: 'Release Layer',
    title: 'Distribution Pipelines',
    text: 'Versioned packaging, manifests, checksums, release notes, delivery folders, and clean product handoff systems.',
  },
  {
    number: '15',
    tier: 'Private Layer',
    title: 'Private Builds',
    text: 'Custom infrastructure, scoped engagements, internal systems, and operator-specific builds protected by review.',
  },
]"""

s = re.sub(r"const cards = \\[[\\s\\S]*?\\]\\n\\nconst chips =", cards_js + "\n\nconst chips =", s)

if "import { initCKParticles } from './ck-particles.js'" not in s:
    s = s.replace("import './ck-reboot.css'", "import './ck-reboot.css'\nimport { initCKParticles } from './ck-particles.js'")

if "initCKParticles()" not in s:
    s = s.rstrip() + "\n\ninitCKParticles()\n"

# Add a signal rail between hero and cards if not present.
if 'class="ck-signal-rail"' not in s:
    s = s.replace(
        '<section class="ck-card-grid" id="solutions">',
        '''<section class="ck-signal-rail" aria-label="CrossingKey signal rail">
        <div class="ck-rail-line"></div>
        <div class="ck-rail-pulse ck-rail-pulse-a"></div>
        <div class="ck-rail-pulse ck-rail-pulse-b"></div>
        <div class="ck-rail-pulse ck-rail-pulse-c"></div>
        <div class="ck-rail-counts">
          <span>00</span>
          <span>05</span>
          <span>10</span>
          <span>15</span>
        </div>
      </section>

      <section class="ck-card-grid" id="solutions">'''
    )

# Card tier line if not present.
if 'ck-card-tier' not in s:
    s = s.replace(
        '<h2 class="ck-card-title">${card.title}</h2>',
        '<div class="ck-card-tier">${card.tier}</div>\\n              <h2 class="ck-card-title">${card.title}</h2>'
    )

p.write_text(s)
PY

python3 /tmp/ck_patch_main_v2.py

cat > src/ck-particles.js <<'JS'
export function initCKParticles() {
  const shell = document.querySelector('.ck-app-shell')
  if (!shell) return

  const prefersReduced = window.matchMedia?.('(prefers-reduced-motion: reduce)')?.matches
  if (prefersReduced) return

  const existing = document.querySelector('#ck-particle-field')
  if (existing) existing.remove()

  const canvas = document.createElement('canvas')
  canvas.id = 'ck-particle-field'
  canvas.setAttribute('aria-hidden', 'true')
  shell.prepend(canvas)

  const ctx = canvas.getContext('2d', { alpha: true })
  if (!ctx) return

  const state = {
    width: 0,
    height: 0,
    dpr: 1,
    particles: [],
    pointer: { x: -9999, y: -9999, active: false },
    lastMove: performance.now(),
    wake: 0,
    idle: 0,
    running: true,
    mobile: window.innerWidth < 760,
  }

  function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value))
  }

  function resize() {
    state.mobile = window.innerWidth < 760
    state.dpr = Math.min(window.devicePixelRatio || 1, state.mobile ? 1.15 : 1.5)
    state.width = shell.clientWidth || window.innerWidth
    state.height = shell.clientHeight || window.innerHeight

    canvas.width = Math.floor(state.width * state.dpr)
    canvas.height = Math.floor(state.height * state.dpr)
    canvas.style.width = `${state.width}px`
    canvas.style.height = `${state.height}px`
    ctx.setTransform(state.dpr, 0, 0, state.dpr, 0, 0)

    const area = state.width * state.height
    const baseCount = state.mobile ? 36 : 72
    const maxCount = state.mobile ? 70 : 132
    const count = clamp(Math.floor(area / 18000) + baseCount, baseCount, maxCount)

    state.particles = Array.from({ length: count }, (_, i) => ({
      x: Math.random() * state.width,
      y: Math.random() * state.height,
      vx: (Math.random() - 0.5) * 0.16,
      vy: (Math.random() - 0.5) * 0.16,
      r: Math.random() * 1.35 + 0.35,
      phase: Math.random() * Math.PI * 2,
      drift: Math.random() * 0.45 + 0.18,
      hot: i % 7 === 0,
    }))
  }

  function onPointerMove(event) {
    const rect = shell.getBoundingClientRect()
    state.pointer.x = event.clientX - rect.left
    state.pointer.y = event.clientY - rect.top
    state.pointer.active = true
    state.lastMove = performance.now()
    state.wake = 1
    state.idle = 0
  }

  function onPointerLeave() {
    state.pointer.active = false
  }

  function frame(now) {
    if (!state.running) return

    const timeStill = now - state.lastMove
    const targetIdle = timeStill > 2400 ? clamp((timeStill - 2400) / 3600, 0, 1) : 0
    state.idle += (targetIdle - state.idle) * 0.025
    state.wake *= 0.94

    ctx.clearRect(0, 0, state.width, state.height)

    const densityAlpha = 0.12 + state.idle * 0.38
    const lineAlpha = 0.025 + state.idle * 0.075
    const wakeAlpha = state.wake * 0.22

    for (const p of state.particles) {
      const dx = p.x - state.pointer.x
      const dy = p.y - state.pointer.y
      const distSq = dx * dx + dy * dy
      const influence = state.pointer.active ? clamp(1 - distSq / 21000, 0, 1) : 0

      if (influence > 0) {
        const dist = Math.sqrt(distSq) || 1
        p.vx += (dx / dist) * influence * 0.035
        p.vy += (dy / dist) * influence * 0.035
      }

      p.phase += 0.012 + state.idle * 0.018
      p.x += p.vx + Math.cos(p.phase) * 0.018 * p.drift
      p.y += p.vy + Math.sin(p.phase) * 0.018 * p.drift

      p.vx *= 0.985
      p.vy *= 0.985

      if (p.x < -20) p.x = state.width + 20
      if (p.x > state.width + 20) p.x = -20
      if (p.y < -20) p.y = state.height + 20
      if (p.y > state.height + 20) p.y = -20

      const glow = p.hot ? 1 : 0.52
      const alpha = densityAlpha * glow + influence * 0.42
      const radius = p.r + state.idle * 0.8 + influence * 1.5

      ctx.beginPath()
      ctx.arc(p.x, p.y, radius, 0, Math.PI * 2)
      ctx.fillStyle = `rgba(216, 76, 153, ${alpha})`
      ctx.shadowBlur = 12 + state.idle * 18 + influence * 18
      ctx.shadowColor = 'rgba(216, 76, 153, 0.78)'
      ctx.fill()
      ctx.shadowBlur = 0
    }

    const linkDistance = state.mobile ? 88 : 118
    for (let i = 0; i < state.particles.length; i++) {
      const a = state.particles[i]
      for (let j = i + 1; j < state.particles.length; j++) {
        const b = state.particles[j]
        const dx = a.x - b.x
        const dy = a.y - b.y
        const d = Math.sqrt(dx * dx + dy * dy)
        if (d < linkDistance) {
          const alpha = (1 - d / linkDistance) * lineAlpha
          ctx.beginPath()
          ctx.moveTo(a.x, a.y)
          ctx.lineTo(b.x, b.y)
          ctx.strokeStyle = `rgba(210, 60, 139, ${alpha})`
          ctx.lineWidth = 1
          ctx.stroke()
        }
      }
    }

    if (state.pointer.active && state.wake > 0.02) {
      const gradient = ctx.createRadialGradient(
        state.pointer.x,
        state.pointer.y,
        0,
        state.pointer.x,
        state.pointer.y,
        180
      )
      gradient.addColorStop(0, `rgba(216, 76, 153, ${wakeAlpha})`)
      gradient.addColorStop(0.42, `rgba(210, 60, 139, ${wakeAlpha * 0.35})`)
      gradient.addColorStop(1, 'rgba(210, 60, 139, 0)')
      ctx.fillStyle = gradient
      ctx.beginPath()
      ctx.arc(state.pointer.x, state.pointer.y, 180, 0, Math.PI * 2)
      ctx.fill()
    }

    requestAnimationFrame(frame)
  }

  document.addEventListener('visibilitychange', () => {
    state.running = !document.hidden
    if (state.running) requestAnimationFrame(frame)
  })

  window.addEventListener('resize', resize, { passive: true })
  shell.addEventListener('pointermove', onPointerMove, { passive: true })
  shell.addEventListener('pointerleave', onPointerLeave, { passive: true })

  resize()
  requestAnimationFrame(frame)
}
JS

cat >> src/ck-reboot.css <<'CSS'

/* CrossingKey Approved Render v2 — controlled refinements */

#ck-particle-field {
  position: absolute;
  inset: 0;
  z-index: 1;
  pointer-events: none;
  opacity: 0.82;
  mix-blend-mode: screen;
}

.ck-topbar,
.ck-main {
  position: relative;
  z-index: 3;
}

.ck-bg-grid,
.ck-bg-glow,
.ck-bg-lines {
  z-index: 0;
}

/* Sharper logo lockup */
.ck-brand {
  gap: 14px;
}

.ck-brand-mark {
  border-color: rgba(216, 76, 153, 0.58);
  background:
    linear-gradient(180deg, rgba(52, 3, 31, 0.36), rgba(3, 0, 6, 0.62));
  color: #f2bfd9;
  text-shadow: none;
  box-shadow:
    inset 0 0 10px rgba(216, 76, 153, 0.08),
    0 0 10px rgba(216, 76, 153, 0.10);
}

.ck-brand-copy span:first-child {
  color: #ffe5f2;
  letter-spacing: 0.25em;
  font-size: 0.82rem;
}

.ck-brand-copy span:last-child {
  color: rgba(242, 191, 217, 0.82);
  letter-spacing: 0.29em;
  font-size: 0.68rem;
}

/* Button glow balance */
.ck-btn-primary {
  background:
    radial-gradient(circle at 30% 18%, rgba(255,255,255,0.28), transparent 17%),
    linear-gradient(135deg, #e260a8 0%, #d84c99 28%, #d23c8b 58%, #83043c 100%);
  box-shadow:
    0 0 12px rgba(216, 76, 153, 0.22),
    0 0 28px rgba(210, 60, 139, 0.16),
    inset 0 0 12px rgba(255,255,255,0.10);
}

.ck-btn-primary:hover {
  box-shadow:
    0 0 16px rgba(216, 76, 153, 0.34),
    0 0 44px rgba(210, 60, 139, 0.22),
    inset 0 0 12px rgba(255,255,255,0.12);
}

.ck-btn-ghost {
  border-color: rgba(216, 76, 153, 0.46);
  color: #ffe5f2;
  background:
    linear-gradient(180deg, rgba(22, 0, 16, 0.52), rgba(6, 0, 8, 0.54));
}

.ck-btn-ghost:hover {
  border-color: rgba(216, 76, 153, 0.72);
  box-shadow:
    0 0 16px rgba(216, 76, 153, 0.16),
    inset 0 0 12px rgba(216, 76, 153, 0.04);
}

/* Search panel polish */
.ck-signal-panel {
  border-color: rgba(216, 76, 153, 0.26);
  background:
    radial-gradient(circle at 72% 18%, rgba(216, 76, 153, 0.10), transparent 18rem),
    linear-gradient(180deg, rgba(24, 0, 17, 0.42), rgba(8, 0, 10, 0.28));
}

.ck-search-wrap {
  min-height: 68px;
  border-color: rgba(216, 76, 153, 0.48);
  background:
    linear-gradient(180deg, rgba(16, 0, 12, 0.76), rgba(8, 0, 10, 0.70));
  box-shadow:
    inset 0 0 18px rgba(216, 76, 153, 0.045),
    0 0 14px rgba(216, 76, 153, 0.08);
}

.ck-search-input {
  font-size: 1.32rem;
  letter-spacing: -0.02em;
}

.ck-search-input::placeholder {
  color: rgba(255, 229, 242, 0.68);
}

.ck-search-go {
  background:
    linear-gradient(180deg, rgba(52, 3, 31, 0.74), rgba(18, 0, 13, 0.84));
  color: #d84c99;
}

.ck-search-go:hover {
  color: #ffe5f2;
  box-shadow:
    0 0 14px rgba(216, 76, 153, 0.22),
    inset 0 0 12px rgba(216, 76, 153, 0.06);
}

/* Visual-first signal rail */
.ck-signal-rail {
  position: relative;
  z-index: 3;
  margin: 8px 0 28px;
  height: 42px;
  border-radius: 999px;
  overflow: hidden;
  opacity: 0.78;
}

.ck-rail-line {
  position: absolute;
  top: 50%;
  left: 2%;
  right: 2%;
  height: 1px;
  background:
    linear-gradient(90deg,
      transparent,
      rgba(216, 76, 153, 0.12),
      rgba(216, 76, 153, 0.42),
      rgba(216, 76, 153, 0.12),
      transparent);
}

.ck-rail-pulse {
  position: absolute;
  top: 50%;
  width: 58px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(216, 76, 153, 0.86), transparent);
  box-shadow: 0 0 14px rgba(216, 76, 153, 0.52);
  animation: ckRailPulse 6.8s linear infinite;
}

.ck-rail-pulse-a { left: -12%; animation-delay: 0s; }
.ck-rail-pulse-b { left: -12%; animation-delay: 2.1s; opacity: 0.7; }
.ck-rail-pulse-c { left: -12%; animation-delay: 4.4s; opacity: 0.45; }

.ck-rail-counts {
  position: absolute;
  inset: 0 6%;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  padding-bottom: 2px;
  font-size: 0.68rem;
  color: rgba(255, 229, 242, 0.34);
  letter-spacing: 0.16em;
}

@keyframes ckRailPulse {
  from { transform: translateX(0); }
  to { transform: translateX(140vw); }
}

/* 15-card archive system */
.ck-card-grid {
  grid-template-columns: repeat(5, minmax(0, 1fr));
  align-items: stretch;
}

.ck-card {
  position: relative;
  overflow: hidden;
}

.ck-card::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: inherit;
  pointer-events: none;
  background:
    linear-gradient(115deg,
      transparent 0%,
      transparent 38%,
      rgba(216, 76, 153, 0.16) 48%,
      rgba(255, 229, 242, 0.10) 50%,
      rgba(216, 76, 153, 0.10) 52%,
      transparent 62%,
      transparent 100%);
  transform: translateX(-130%);
  transition: transform 560ms ease;
}

.ck-card:hover::before {
  transform: translateX(130%);
}

.ck-card:hover {
  border-color: rgba(216, 76, 153, 0.58);
  box-shadow:
    inset 0 0 14px rgba(216, 76, 153, 0.055),
    0 0 20px rgba(210, 60, 139, 0.16);
}

.ck-card:nth-child(n+6) {
  min-height: 238px;
  background:
    linear-gradient(180deg, rgba(38, 0, 24, 0.22), rgba(6, 0, 8, 0.60));
}

.ck-card:nth-child(n+6) .ck-card-title {
  font-size: 1.06rem;
}

.ck-card:nth-child(n+6) .ck-card-text {
  font-size: 0.92rem;
  line-height: 1.48;
}

.ck-card-tier {
  position: relative;
  z-index: 1;
  margin-bottom: 9px;
  color: rgba(242, 191, 217, 0.62);
  font-size: 0.68rem;
  font-weight: 800;
  letter-spacing: 0.17em;
  text-transform: uppercase;
}

.ck-card-title,
.ck-card-text,
.ck-card-head,
.ck-card-foot {
  position: relative;
  z-index: 1;
}

/* Mobile polish */
@media (max-width: 1180px) {
  .ck-card-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .ck-signal-rail {
    margin-top: 18px;
  }
}

@media (max-width: 860px) {
  .ck-card-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .ck-hero {
    gap: 34px;
  }

  .ck-signal-panel {
    padding: 20px;
  }
}

@media (max-width: 760px) {
  #ck-particle-field {
    opacity: 0.42;
  }

  .ck-topbar-actions {
    width: 100%;
    justify-content: space-between;
  }

  .ck-btn-top {
    flex: 1;
  }

  .ck-hero-title-main {
    font-size: clamp(3.1rem, 16vw, 4.4rem);
  }

  .ck-hero-title-sub {
    font-size: clamp(2.1rem, 10vw, 3rem);
  }

  .ck-hero-actions {
    display: grid;
    grid-template-columns: 1fr;
  }

  .ck-btn {
    width: 100%;
  }

  .ck-card-grid {
    grid-template-columns: 1fr;
    gap: 14px;
  }

  .ck-signal-rail {
    height: 34px;
    margin-bottom: 20px;
  }
}
CSS

echo ""
echo "✅ Approved Render v2 modules installed."
echo "Backup saved:"
echo ".ck-backups/ck-before-approved-render-v2-$STAMP.tar.gz"
echo ""
echo "Restart Vite:"
echo "npm run dev -- --host 127.0.0.1 --port 6020"
echo ""
