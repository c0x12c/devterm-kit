#!/usr/bin/env bash
# =============================================================================
# devterm installer — one-liner entry point
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/c0x12c/devterm-kit/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/c0x12c/devterm-kit/main/install.sh | bash -s -- --theme macchiato
# =============================================================================

set -euo pipefail

DEVTERM_REPO="https://github.com/c0x12c/devterm-kit"
DEVTERM_ARCHIVE="https://github.com/c0x12c/devterm-kit/archive/refs/heads/main.tar.gz"
INSTALL_DIR="$HOME/.devterm"

# Colors (minimal, no lib dependency)
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

echo ""
echo -e "${BOLD}${BLUE}devterm installer${NC}"
echo -e "${BLUE}─────────────────────${NC}"
echo ""

# Check internet
if ! curl -fsSL --connect-timeout 5 https://github.com &>/dev/null; then
  echo -e "${RED}✗ No internet connection${NC}"
  exit 1
fi

# Method 1: Use git if available (preferred — gets full history for updates)
if command -v git &>/dev/null; then
  echo -e "${BLUE}→${NC} Cloning devterm..."
  if [[ -d "$INSTALL_DIR" ]]; then
    echo -e "${YELLOW}⊘${NC} Found existing install at $INSTALL_DIR — updating..."
    git -C "$INSTALL_DIR" pull --ff-only --quiet
  else
    git clone --depth=1 "$DEVTERM_REPO" "$INSTALL_DIR" --quiet
  fi
  echo -e "${GREEN}✓${NC} devterm downloaded to $INSTALL_DIR"

# Method 2: Fallback to tarball download
else
  echo -e "${BLUE}→${NC} Downloading devterm (git not found, using tarball)..."
  rm -rf "$INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
  curl -fsSL "$DEVTERM_ARCHIVE" | tar -xz -C "$INSTALL_DIR" --strip-components=1
  echo -e "${GREEN}✓${NC} devterm downloaded to $INSTALL_DIR"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/setup.sh"
chmod +x "$INSTALL_DIR/lib/"*.sh

# Run setup with any passed arguments
echo ""
exec "$INSTALL_DIR/setup.sh" "$@"
