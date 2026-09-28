#!/usr/bin/env bash
set -euo pipefail

echo "🗂️ Refining CrossingKey cards 6–15..."

[ -f src/main.js ] || {
  echo "[CK ERROR] src/main.js not found. Run this from the Vite project root."
  exit 1
}

[ -f src/ck-reboot.css ] || {
  echo "[CK ERROR] src/ck-reboot.css not found."
  exit 1
}

STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p .ck-backups

cp src/main.js ".ck-backups/main.js.cards-6-15-$STAMP.bak"
cp src/ck-reboot.css ".ck-backups/ck-reboot.css.cards-6-15-$STAMP.bak"

python3 - <<'PY'
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
    text: 'Reusable prompt engines, operator instructions, tone controls, and AI workflow patterns for repeatable output.',
  },
  {
    number: '07',
    tier: 'Governance Layer',
    title: 'Governance Packs',
    text: 'Approval gates, rulebooks, review flows, compliance language, and audit-ready AI execution boundaries.',
  },
  {
    number: '08',
    tier: 'Security Layer',
    title: 'Security Reviews',
    text: 'Risk maps, hardening checklists, exposure notes, boundary reviews, and controlled inspection assets.',
  },
  {
    number: '09',
    tier: 'Commerce Layer',
    title: 'Commerce Systems',
    text: 'Storefront structures, product logic, checkout paths, paid access gates, and sales-ready delivery rails.',
  },
  {
    number: '10',
    tier: 'Signal Layer',
    title: 'Intelligence Briefings',
    text: 'Market signals, threat notes, executive summaries, research packs, and decision-ready information flows.',
  },
  {
    number: '11',
    tier: 'Creative Layer',
    title: 'Creative Assets',
    text: 'Brand systems, visual prompts, media kits, product imagery, design language, and production direction.',
  },
  {
    number: '12',
    tier: 'Training Layer',
    title: 'Operator Training',
    text: 'Command references, onboarding guides, practice drills, skill paths, and human-in-the-loop training assets.',
  },
  {
    number: '13',
    tier: 'Local AI Layer',
    title: 'Local AI Stacks',
    text: 'Local-first AI layouts, model-running patterns, offline workflows, workstation maps, and private compute rails.',
  },
  {
    number: '14',
    tier: 'Release Layer',
    title: 'Distribution Pipelines',
    text: 'Versioned packaging, manifests, checksums, release notes, delivery folders, and product handoff systems.',
  },
  {
    number: '15',
    tier: 'Private Layer',
    title: 'Private Builds',
    text: 'Scoped systems, internal infrastructure, custom operator tools, and protected builds available by review.',
  },
]"""

s = re.sub(r"const cards = \[[\s\S]*?\]\n\nconst chips =", cards_js + "\n\nconst chips =", s)

p.write_text(s)
PY

cat >> src/ck-reboot.css <<'CSS'

/* CrossingKey cards 6–15 refinement pass */

.ck-card:nth-child(n+6) {
  min-height: 226px;
  padding: 18px 18px 16px;
  border-color: rgba(216, 76, 153, 0.24);
  background:
    radial-gradient(circle at 16% 10%, rgba(216, 76, 153, 0.055), transparent 42%),
    linear-gradient(180deg, rgba(34, 0, 23, 0.20), rgba(5, 0, 7, 0.62));
  box-shadow:
    inset 0 0 12px rgba(216, 76, 153, 0.026),
    0 0 14px rgba(210, 60, 139, 0.07);
}

.ck-card:nth-child(n+6)::after {
  content: "ARCHIVE NODE";
  position: absolute;
  right: 18px;
  bottom: 16px;
  color: rgba(255, 229, 242, 0.20);
  font-size: 0.58rem;
  font-weight: 800;
  letter-spacing: 0.18em;
  pointer-events: none;
}

.ck-card:nth-child(n+6) .ck-card-icon {
  width: 36px;
  height: 36px;
  border-radius: 11px;
  color: rgba(216, 76, 153, 0.78);
  background: rgba(18, 0, 12, 0.46);
  border-color: rgba(216, 76, 153, 0.20);
}

.ck-card:nth-child(n+6) .ck-card-number {
  color: rgba(255, 229, 242, 0.38);
  font-size: 0.76rem;
}

.ck-card:nth-child(n+6) .ck-card-tier {
  margin-bottom: 8px;
  color: rgba(216, 76, 153, 0.72);
  font-size: 0.62rem;
  letter-spacing: 0.19em;
}

.ck-card:nth-child(n+6) .ck-card-title {
  max-width: 92%;
  color: rgba(255, 229, 242, 0.92);
  font-size: 1.04rem;
  line-height: 1.12;
}

.ck-card:nth-child(n+6) .ck-card-text {
  max-width: 96%;
  margin-top: 12px;
  color: rgba(239, 191, 216, 0.76);
  font-size: 0.9rem;
  line-height: 1.46;
}

.ck-card:nth-child(n+6) .ck-card-arrow {
  width: 34px;
  height: 34px;
  color: rgba(216, 76, 153, 0.78);
  border-color: rgba(216, 76, 153, 0.22);
  background: rgba(14, 0, 10, 0.54);
}

.ck-card:nth-child(n+6):hover {
  border-color: rgba(216, 76, 153, 0.48);
  background:
    radial-gradient(circle at 16% 10%, rgba(216, 76, 153, 0.10), transparent 42%),
    linear-gradient(180deg, rgba(44, 0, 29, 0.28), rgba(7, 0, 9, 0.68));
  box-shadow:
    inset 0 0 12px rgba(216, 76, 153, 0.04),
    0 0 18px rgba(210, 60, 139, 0.13);
}

.ck-card:nth-child(n+6):hover .ck-card-title {
  color: #ffe5f2;
}

.ck-card:nth-child(n+6):hover .ck-card-tier,
.ck-card:nth-child(n+6):hover .ck-card-arrow {
  color: #d84c99;
}

/* Keep the first five heavier and more executive */
.ck-card:nth-child(-n+5) {
  min-height: 286px;
  border-color: rgba(216, 76, 153, 0.38);
}

.ck-card:nth-child(-n+5) .ck-card-title {
  color: #f05cab;
}

.ck-card:nth-child(-n+5) .ck-card-tier {
  color: rgba(255, 229, 242, 0.70);
}

/* Make the full 15-card archive breathe better */
.ck-card-grid {
  gap: 16px;
  padding-bottom: 18px;
}

@media (min-width: 1181px) {
  .ck-card-grid {
    grid-template-columns: repeat(5, minmax(0, 1fr));
  }

  .ck-card:nth-child(n+6) {
    min-height: 232px;
  }
}

@media (max-width: 1180px) {
  .ck-card:nth-child(n+6) {
    min-height: 220px;
  }
}

@media (max-width: 760px) {
  .ck-card:nth-child(n+6)::after {
    display: none;
  }

  .ck-card:nth-child(n+6),
  .ck-card:nth-child(-n+5) {
    min-height: auto;
  }
}
CSS

rm -rf node_modules/.vite .vite dist

echo ""
echo "✅ Cards 6–15 refined."
echo "Backup saved with stamp: $STAMP"
echo ""
echo "Restart Vite:"
echo "npm run dev -- --host 127.0.0.1 --port 6020"
