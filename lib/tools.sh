#!/usr/bin/env bash
# lib/tools.sh — CLI productivity tools installation

install_tools() {
  log_step "Installing CLI productivity tools"

  _install_brew_tool "fzf"    "Fuzzy finder for history and files"
  _install_brew_tool "eza"    "Modern ls with icons and git status"
  _install_brew_tool "bat"    "cat with syntax highlighting"
  _install_brew_tool "zoxide" "Smarter cd that learns your habits"

  # Setup fzf key bindings and completions
  _setup_fzf

  # Setup bat Catppuccin theme
  _setup_bat_theme
}

_install_brew_tool() {
  local pkg="$1"
  local desc="$2"

  if brew_installed "$pkg"; then
    log_skip "$pkg ($desc)"
    return 0
  fi

  log_info "Installing $pkg — $desc..."
  if brew install "$pkg" &>/dev/null; then
    log_ok "$pkg installed"
  else
    log_error "Failed to install $pkg"
    return 1
  fi
}

_setup_fzf() {
  local fzf_install
  fzf_install="$(brew --prefix)/opt/fzf/install"

  if [[ -f "$fzf_install" ]]; then
    # Non-interactive: install bindings without modifying rc files (we do that in zshrc.sh)
    "$fzf_install" --key-bindings --completion --no-update-rc 2>/dev/null
    log_ok "fzf key bindings configured (Ctrl+R history, Ctrl+T files, Alt+C dirs)"
  fi
}

_setup_bat_theme() {
  if ! command_exists bat; then
    return 0
  fi

  local bat_themes_dir
  bat_themes_dir="$(bat --config-dir)/themes"
  local theme_file="$bat_themes_dir/Catppuccin-Mocha.tmTheme"

  if [[ -f "$theme_file" ]]; then
    log_skip "bat Catppuccin Mocha theme"
    return 0
  fi

  mkdir -p "$bat_themes_dir"
  local url="https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"

  if curl -fsSL --retry 3 "$url" -o "$theme_file" 2>/dev/null; then
    bat cache --build 2>/dev/null
    log_ok "bat Catppuccin Mocha theme installed"
  else
    log_warn "Could not download bat theme (bat will still work with default theme)"
  fi
}
