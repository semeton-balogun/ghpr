#!/usr/bin/env bash
# ghpr-check-updates.sh — Check for ghpr updates on shell startup (like oh-my-zsh)
#
# Add to your ~/.zshrc or ~/.bashrc:
#   source ~/.ghpr/ghpr-check-updates.sh

GHPR_CHECK_INTERVAL=${GHPR_CHECK_INTERVAL:-7}  # days between checks (default: 7)
GHPR_LAST_CHECK_FILE="${HOME}/.ghpr/.last-update-check"

# Create .ghpr directory if needed
mkdir -p "${HOME}/.ghpr"

should_check_for_updates() {
  [[ ! -f "$GHPR_LAST_CHECK_FILE" ]] && return 0
  
  local last_check
  last_check=$(stat -f%m "$GHPR_LAST_CHECK_FILE" 2>/dev/null || stat -c%Y "$GHPR_LAST_CHECK_FILE" 2>/dev/null || echo 0)
  local now
  now=$(date +%s)
  local diff=$(( (now - last_check) / 86400 ))
  
  [[ $diff -ge $GHPR_CHECK_INTERVAL ]]
}

check_ghpr_updates() {
  # Only check if ghpr is installed
  command -v ghpr &>/dev/null || return 0
  
  # Only check if interval has passed
  should_check_for_updates || return 0
  
  # Run check in background so it doesn't block shell startup
  (
    local current_version
    current_version=$(ghpr --version 2>/dev/null | awk '{print $2}')
    [[ -z "$current_version" ]] && return 0
    
    # Try to get latest tag from the ghpr installation directory
    local ghpr_path
    ghpr_path="$(command -v ghpr | xargs dirname)/.."
    
    local latest_version
    latest_version=$(cd "$ghpr_path" 2>/dev/null && git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "")
    
    # Update last check time
    touch "$GHPR_LAST_CHECK_FILE"
    
    # Notify if update available (but don't block)
    if [[ -n "$latest_version" && "$latest_version" != "$current_version" ]]; then
      if printf '%s\n' "$latest_version" "$current_version" | sort -V | head -1 | grep -q "$current_version" && [[ "$latest_version" != "$current_version" ]]; then
        echo ""
        echo "📦 A new version of ghpr is available: $latest_version (current: $current_version)"
        echo "   Run 'ghpr-update' or './update.sh' to upgrade."
        echo ""
      fi
    fi
  ) &
  disown 2>/dev/null || true
}

# Run check if this is an interactive shell
if [[ $- == *i* ]]; then
  check_ghpr_updates
fi
