#!/usr/bin/env bash
# lib/fonts.sh — MesloLGS NF font installation (required for Nerd Font icons)

FONT_BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

MESLO_FONTS=(
  "MesloLGS NF Regular.ttf"
  "MesloLGS NF Bold.ttf"
  "MesloLGS NF Italic.ttf"
  "MesloLGS NF Bold Italic.ttf"
)

install_fonts() {
  log_step "Installing MesloLGS NF fonts"

  # Set font directory based on OS
  local font_dir
  if [[ "${DEVTERM_OS:-macos}" == "macos" ]]; then
    font_dir="$HOME/Library/Fonts"
  else
    font_dir="$HOME/.local/share/fonts"
  fi

  # Count missing fonts
  local missing=0
  for font in "${MESLO_FONTS[@]}"; do
    if [[ ! -f "$font_dir/$font" ]]; then missing=$((missing + 1)); fi
  done

  if [[ $missing -eq 0 ]]; then
    log_skip "MesloLGS NF (all 4 variants already installed)"
    return 0
  fi

  mkdir -p "$font_dir"
  log_info "Installing $missing missing font variant(s) to $font_dir..."

  local installed=0
  for font in "${MESLO_FONTS[@]}"; do
    if [[ -f "$font_dir/$font" ]]; then
      log_skip "$font"
      continue
    fi

    # URL-encode spaces in font filename
    local encoded_font="${font// /%20}"

    if curl -fsSL --retry 3 "$FONT_BASE_URL/$encoded_font" -o "$font_dir/$font" 2>/dev/null; then
      log_ok "Downloaded: $font"
      installed=$((installed + 1))   # avoids ((n++)) == 0 false-failure under set -e
    else
      log_error "Failed to download: $font"
      log_info "Manual download: $FONT_BASE_URL/$encoded_font"
    fi
  done

  # Refresh font cache
  if [[ $installed -gt 0 ]]; then
    if [[ "${DEVTERM_OS:-macos}" == "macos" ]]; then
      atsutil databases -remove 2>/dev/null || true
    else
      # Linux: refresh fontconfig cache
      fc-cache -fv "$font_dir" &>/dev/null || true
    fi
    log_ok "Font cache refreshed ($installed font(s) installed)"
  fi
}
