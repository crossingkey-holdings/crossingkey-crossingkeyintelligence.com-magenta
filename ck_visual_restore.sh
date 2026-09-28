#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ".visual_lock/baseline" ]; then
  echo "Missing .visual_lock/baseline"
  exit 1
fi

echo "Restoring approved visual baseline..."
find index.html src public assets -type f -exec chmod u+w {} \; 2>/dev/null || true
cp -a .visual_lock/baseline/. .
echo "Restored."
./ck_visual_verify.sh
