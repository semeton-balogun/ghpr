#!/usr/bin/env bash
# install.sh — Install ghpr as a global command on this machine.
#
# Usage:
#   ./install.sh                        # installs to /usr/local/bin (may need sudo)
#   INSTALL_DIR=~/.local/bin ./install.sh  # installs to a user-local directory
#
# To uninstall:
#   rm "$(command -v ghpr)"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/bin/ghpr"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
TARGET="$INSTALL_DIR/ghpr"

# ─── Checks ───────────────────────────────────────────────────────────────────

[[ -f "$SOURCE" ]] || {
  echo "❌ Could not find bin/ghpr in $SCRIPT_DIR"
  exit 1
}

# ─── Create install dir if it doesn't exist ───────────────────────────────────

if [[ ! -d "$INSTALL_DIR" ]]; then
  echo "→ Creating $INSTALL_DIR ..."
  mkdir -p "$INSTALL_DIR"
fi

# ─── Copy and make executable ─────────────────────────────────────────────────

copy_and_chmod() {
  cp "$SOURCE" "$TARGET"
  chmod +x "$TARGET"
}

if copy_and_chmod 2>/dev/null; then
  : # success without sudo
else
  echo "→ Permission denied — retrying with sudo..."
  sudo cp "$SOURCE" "$TARGET"
  sudo chmod +x "$TARGET"
fi

# ─── PATH check ───────────────────────────────────────────────────────────────

echo ""
echo "✅ ghpr installed → $TARGET"
echo ""

if ! command -v ghpr &>/dev/null; then
  echo "⚠️  $INSTALL_DIR is not in your PATH."
  echo "   Add the following to your ~/.zshrc or ~/.bash_profile:"
  echo ""
  echo "     export PATH=\"$INSTALL_DIR:\$PATH\""
  echo ""
else
  echo "   Run 'ghpr --help' to get started."
fi
