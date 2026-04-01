#!/usr/bin/env bash
# lib/iterm2.sh — iTerm2 Catppuccin color scheme installation (macOS only)

ITERM_SUPPORT="$HOME/Library/Application Support/iTerm2"
# Guard: only compute DEVTERM_ROOT if not already set by setup.sh
_iterm2_root() { dirname "$(dirname "${BASH_SOURCE[0]}")"; }
DEVTERM_ROOT="${DEVTERM_ROOT:-$(_iterm2_root)}"
unset -f _iterm2_root

# Available themes — use a function instead of declare -A (bash 3.2 compatible)
# Do NOT use declare -A — associative arrays require bash 4.0+
_theme_display_name() {
  case "$1" in
    mocha)     echo "Catppuccin Mocha (Dark)" ;;
    latte)     echo "Catppuccin Latte (Light)" ;;
    frappe)    echo "Catppuccin Frappé (Medium Dark)" ;;
    macchiato) echo "Catppuccin Macchiato (Dark)" ;;
    *)         echo "Catppuccin $1" ;;
  esac
}

install_iterm2_theme() {
  # macOS only — Linux terminals use terminal-specific theme configs
  if [[ "${DEVTERM_OS:-macos}" != "macos" ]]; then
    log_info "iTerm2 color scheme: skipped (Linux — configure your terminal manually)"
    log_info "Catppuccin themes for popular terminals: https://github.com/catppuccin"
    return 0
  fi

  local variant="${DEVTERM_THEME:-mocha}"
  log_step "Installing iTerm2 color scheme: $(_theme_display_name "$variant")"

  mkdir -p "$ITERM_SUPPORT"

  local src_file="$DEVTERM_ROOT/themes/catppuccin-${variant}.itermcolors"
  local dest_file="$ITERM_SUPPORT/catppuccin-${variant}.itermcolors"

  if [[ ! -f "$src_file" ]]; then
    log_error "Theme file not found: $src_file"
    return 1
  fi

  cp "$src_file" "$dest_file"
  log_ok "Copied catppuccin-${variant}.itermcolors to iTerm2 folder"

  # Open the file to trigger iTerm2 import
  if open "$dest_file" 2>/dev/null; then
    log_ok "iTerm2 import dialog should appear — click 'OK' to confirm"
    log_info "Then: Preferences → Profiles → Colors → Color Presets → catppuccin-${variant}"
  else
    log_info "Import manually: Preferences → Profiles → Colors → Color Presets → Import"
    log_info "  File: $dest_file"
  fi
}

# Interactive theme picker (shared between macOS and Linux)
pick_theme() {
  echo ""
  echo -e "  ${MOCHA_MAUVE}${BOLD}Choose your Catppuccin variant:${NC}"
  echo ""
  echo -e "  ${MOCHA_BLUE}1)${NC} Mocha      — Dark (recommended for most devs)"
  echo -e "  ${MOCHA_BLUE}2)${NC} Macchiato  — Dark (slightly lighter than Mocha)"
  echo -e "  ${MOCHA_BLUE}3)${NC} Frappé     — Medium dark"
  echo -e "  ${MOCHA_BLUE}4)${NC} Latte      — Light (for bright environments)"
  echo ""
  read -r -p "  Your choice [1-4, default: 1]: " choice < /dev/tty

  case "${choice:-1}" in
    1) DEVTERM_THEME="mocha" ;;
    2) DEVTERM_THEME="macchiato" ;;
    3) DEVTERM_THEME="frappe" ;;
    4) DEVTERM_THEME="latte" ;;
    *) DEVTERM_THEME="mocha" ;;
  esac

  export DEVTERM_THEME
  log_info "Selected: $(_theme_display_name "$DEVTERM_THEME")"
}
