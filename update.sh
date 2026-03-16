#!/usr/bin/env bash
# update.sh — Pull latest code and reinstall ghpr.
#
# Usage:
#   ./update.sh
#   UPDATE_BRANCH=main ./update.sh

set -euo pipefail

PROGRESS_WIDTH=30

progress_bar() {
  local current="$1"
  local total="$2"
  local label="${3:-Progress}"
  
  local percent=$(( (current * 100) / total ))
  local filled=$(( (percent * PROGRESS_WIDTH) / 100 ))
  local empty=$(( PROGRESS_WIDTH - filled ))
  
  printf "\r%s: [" "$label"
  printf "%${filled}s" | tr ' ' '▰'
  printf "%${empty}s" | tr ' ' '▱'
  printf "] %3d%%  " "$percent"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRANCH="${UPDATE_BRANCH:-main}"

cd "$SCRIPT_DIR"

echo "→ Fetching updates from origin/$BRANCH ..."
progress_bar 0 2 "Updating"
echo ""

git pull origin "$BRANCH" >/dev/null 2>&1

progress_bar 1 2 "Updating"
echo ""

echo "→ Reinstalling ghpr ..."
"$SCRIPT_DIR/install.sh"

progress_bar 2 2 "Updating"
echo ""
echo ""
echo "✅ ghpr update complete."
