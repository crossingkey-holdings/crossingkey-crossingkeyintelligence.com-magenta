#!/usr/bin/env bash
set -euo pipefail
find index.html src public assets -type f -exec chmod u+w {} \; 2>/dev/null || true
echo "Visual files unlocked for approved edits."
