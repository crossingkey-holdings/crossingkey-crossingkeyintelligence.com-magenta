Timestamp — 2026-07-31 08:05:27 UTC

# CrossingKey governance installation receipt

## Outcome

Status: `verified`

Installed the matching local project guidance from:

`/home/founder/Downloads/ck-agent-governance-install-20260731-v3/crossingkey-agent-governance/`

No external service, deployment, publication, credential, DNS, Shopify,
Cloudflare, or Stripe action was performed.

## Backup manifest

Pre-install inspection found no existing destination file at any requested
path. There was therefore no prior file content to copy into this backup
directory. This receipt preserves that observed pre-install state.

| Destination | Pre-install state | Action |
|---|---|---|
| `AGENTS.md` | absent | installed |
| `src/AGENTS.md` | absent | installed |
| `src/content/AGENTS.md` | absent | installed |
| `founder-studio/AGENTS.md` | absent | installed |
| `docs/AGENTS.md` | absent; parent existed | installed |
| `scripts/AGENTS.md` | absent; parent absent | skipped per conditional request |
| `gigs/AGENTS.md` | absent; parent absent | skipped per conditional request |
| `research/SOURCE_CATALOG.md` | absent; parent absent | parent created and file installed |

## Integrity verification

Each installed file passed a byte-for-byte `cmp` against its named source.

| Installed file | SHA-256 |
|---|---|
| `AGENTS.md` | `10b3d1a26a3956521b64d16308d0bd50396e1c425cd75a384f915e5d40bf49be` |
| `src/AGENTS.md` | `8bc3628b15be2dad56b91b5b3e6cd5d3df0c60d391fd9317383a3f549268d3dc` |
| `src/content/AGENTS.md` | `eabfffaf28674e7671a813cb13e70bfb83e10d453363e59f32f3254af3c87eb1` |
| `founder-studio/AGENTS.md` | `e6794ab28235f5bc4944ed07c0471233625f6546c6df3b89074e1f93ef51b85a` |
| `docs/AGENTS.md` | `1040134470153588aeb77e0b29726d01badc74f67ed83d2f164295c056a8f6cf` |
| `research/SOURCE_CATALOG.md` | `f4c4a3999161b415f480d62fc15cd1abd71246157e9fe47007993ac7d357dde8` |

## Active instruction chain for a new session

Observed ancestor scan: no `AGENTS.md` exists at `/`, `/home`,
`/home/founder`, or `/home/founder/Downloads`. The repository root file is the
first filesystem-backed project instruction file.

- Project-root work: `AGENTS.md`
- Work under `src/`: `AGENTS.md` → `src/AGENTS.md`
- Work under `src/content/`: `AGENTS.md` → `src/AGENTS.md` →
  `src/content/AGENTS.md`
- Work under `founder-studio/`: `AGENTS.md` → `founder-studio/AGENTS.md`
- Work under `docs/`: `AGENTS.md` → `docs/AGENTS.md`
- Work under `research/`: `AGENTS.md`; `research/SOURCE_CATALOG.md` is the
  required source-routing map, not an `AGENTS.md` layer.
- `scripts/` and `gigs/`: no local chain exists because those directories do
  not currently exist.

The current session also received the CrossingKey global contract directly in
the session instructions. A fresh Codex session from the project root is the
definitive test that the host rebuilds and reports the expected instruction
chain.

## Rollback

Because all installed destinations were absent before this change, rollback is
removal of the six installed files and the newly created `research/` directory
only if it remains otherwise empty. No rollback was performed.

## Limitations

- This directory is not a Git repository, so no Git diff or commit-based
  provenance was available.
- Instruction files are policy controls. This installation does not establish
  runtime enforcement.

— 𝙅̶△𝘼̶
crossingkey_
CrossingKey Intelligence
intelligence is the standard.
