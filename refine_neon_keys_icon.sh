#!/usr/bin/env bash
set -euo pipefail

if [ -x "./ck_visual_unlock.sh" ]; then
  echo "Unlocking visuals for founder-approved icon refinement..."
  ./ck_visual_unlock.sh
fi

mkdir -p public/assets

cat > public/assets/crossingkey-keys.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128" role="img" aria-label="CrossingKey neon crossed keys">
  <defs>
    <radialGradient id="bg" cx="50%" cy="50%" r="75%">
      <stop offset="0%" stop-color="#2a0018"/>
      <stop offset="58%" stop-color="#13000b"/>
      <stop offset="100%" stop-color="#070006"/>
    </radialGradient>

    <linearGradient id="neon" x1="18" y1="18" x2="110" y2="110">
      <stop offset="0%" stop-color="#ffd6f3"/>
      <stop offset="38%" stop-color="#ff66c7"/>
      <stop offset="72%" stop-color="#ff1f9f"/>
      <stop offset="100%" stop-color="#ff006e"/>
    </linearGradient>

    <filter id="neonGlow" x="-100%" y="-100%" width="300%" height="300%">
      <feGaussianBlur stdDeviation="2.2" result="blur1"/>
      <feGaussianBlur in="SourceGraphic" stdDeviation="5.5" result="blur2"/>
      <feColorMatrix in="blur2" type="matrix"
        values="1 0 0 0 1
                0 0 0 0 0.08
                0 0 0 0 0.56
                0 0 0 1 0" result="pinkGlow"/>
      <feMerge>
        <feMergeNode in="pinkGlow"/>
        <feMergeNode in="blur1"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>

  <rect x="8" y="8" width="112" height="112" rx="24" fill="url(#bg)"/>
  <rect x="9.5" y="9.5" width="109" height="109" rx="22" fill="none" stroke="#ff2aa3" stroke-width="2.5" opacity=".72"/>

  <g filter="url(#neonGlow)" fill="none" stroke="url(#neon)" stroke-width="5.5" stroke-linecap="round" stroke-linejoin="round">

    <!-- key 1 -->
    <g transform="rotate(-45 64 64)">
      <!-- bow -->
      <circle cx="39" cy="64" r="12"/>
      <circle cx="39" cy="64" r="4.2"/>
      <!-- shaft -->
      <path d="M51 64 H84"/>
      <!-- teeth -->
      <path d="M84 64 h8"/>
      <path d="M77 64 v-9"/>
      <path d="M86 64 v-6"/>
      <!-- shoulder -->
      <path d="M51 64 l-5 -5"/>
    </g>

    <!-- key 2 -->
    <g transform="rotate(45 64 64)">
      <!-- bow -->
      <circle cx="39" cy="64" r="12"/>
      <circle cx="39" cy="64" r="4.2"/>
      <!-- shaft -->
      <path d="M51 64 H84"/>
      <!-- teeth -->
      <path d="M84 64 h8"/>
      <path d="M77 64 v-9"/>
      <path d="M86 64 v-6"/>
      <!-- shoulder -->
      <path d="M51 64 l-5 -5"/>
    </g>
  </g>

  <g fill="#ffe7f8" opacity=".95">
    <circle cx="64" cy="64" r="2.2"/>
    <circle cx="33" cy="33" r="1.3"/>
    <circle cx="95" cy="33" r="1.3"/>
    <circle cx="33" cy="95" r="1.3"/>
    <circle cx="95" cy="95" r="1.3"/>
  </g>
</svg>
SVG

echo "Refined neon keys icon written to:"
echo "  public/assets/crossingkey-keys.svg"
echo
echo "Restart Vite if needed, then hard refresh:"
echo "  npm run dev -- --host 127.0.0.1 --port 6020"
echo "  Ctrl+Shift+R"
echo
echo "If approved, lock it in with:"
echo "  ./ck_visual_accept_new_baseline.sh"
