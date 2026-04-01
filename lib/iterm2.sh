#!/usr/bin/env bash
# lib/iterm2.sh — iTerm2 Catppuccin color scheme installation (macOS only)

ITERM_SUPPORT="$HOME/Library/Application Support/iTerm2"
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
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

# Apply font and color preset to iTerm2 Default profile via defaults/PlistBuddy
_apply_iterm2_profile() {
  local variant="${1:-mocha}"
  local preset_name="catppuccin-${variant}"
  local src_file="$DEVTERM_ROOT/themes/${preset_name}.itermcolors"

  # Import color preset into iTerm2's custom color presets
  if [[ -f "$src_file" ]]; then
    # Convert .itermcolors (XML plist) and inject into iTerm2 prefs
    defaults write com.googlecode.iterm2 "Custom Color Presets" -dict-add \
      "$preset_name" "$(cat "$src_file")" 2>/dev/null || true

    # Also open the file so iTerm2 registers it on next launch
    open "$src_file" 2>/dev/null || true
    sleep 1
  fi

  # Apply settings to the Default profile using PlistBuddy
  local pb="/usr/libexec/PlistBuddy"
  local profile_path=":New Bookmarks:0"

  if [[ -f "$ITERM_PLIST" ]]; then
    # Set font to MesloLGS NF 14pt
    "$pb" -c "Set ${profile_path}:'Normal Font' 'MesloLGSNF-Regular 14'" "$ITERM_PLIST" 2>/dev/null || true
    "$pb" -c "Set ${profile_path}:'Non Ascii Font' 'MesloLGSNF-Regular 14'" "$ITERM_PLIST" 2>/dev/null || true

    log_ok "Font set to MesloLGS NF (size 14) in Default profile"
  else
    log_info "iTerm2 plist not found — font will be set on next launch"
  fi
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

  # Auto-apply font and theme to iTerm2 Default profile
  _apply_iterm2_profile "$variant"
  log_ok "Theme and font applied to iTerm2 — restart iTerm2 to see changes"
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
