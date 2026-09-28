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
