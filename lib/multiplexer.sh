#!/usr/bin/env bash
# lib/multiplexer.sh — Install and configure tmux / zellij with Catppuccin theme

# ── Interactive picker ────────────────────────────────────────────────────

pick_multiplexer() {
  echo ""
  echo -e "  ${MOCHA_MAUVE}${BOLD}Terminal multiplexer (optional):${NC}"
  echo -e "  ${DIM}─────────────────────────────────────${NC}"
  echo -e "    ${BOLD}1)${NC} tmux       Classic, widely supported"
  echo -e "    ${BOLD}2)${NC} zellij     Modern, beginner-friendly"
  echo -e "    ${BOLD}3)${NC} both       Install both"
  echo -e "    ${BOLD}4)${NC} skip       No multiplexer ${DIM}(default)${NC}"
  echo ""
  echo -n "  Choose [1-4, default=4]: "
  local choice
  read -r choice < /dev/tty
  case "${choice:-4}" in
    1) DEVTERM_MULTIPLEXER="tmux" ;;
    2) DEVTERM_MULTIPLEXER="zellij" ;;
    3) DEVTERM_MULTIPLEXER="both" ;;
    *) DEVTERM_MULTIPLEXER="" ;;
  esac
  export DEVTERM_MULTIPLEXER
}

# ── Main entry point ──────────────────────────────────────────────────────

install_multiplexer() {
  local mux="${DEVTERM_MULTIPLEXER:-}"
  if [[ -z "$mux" ]]; then
    return 0  # Nothing to install
  fi

  log_step "Installing multiplexer ($mux)"

  if [[ "$mux" == "tmux" || "$mux" == "both" ]]; then
    _install_tmux
    _install_tmux_config
  fi

  if [[ "$mux" == "zellij" || "$mux" == "both" ]]; then
    _install_zellij
    _install_zellij_config
  fi
}

# ── tmux ──────────────────────────────────────────────────────────────────

_install_tmux() {
  if command_exists tmux; then
    log_skip "tmux"
    return 0
  fi

  log_info "Installing tmux..."
  _install_pkg tmux
  if command_exists tmux; then
    log_ok "tmux installed"
  else
    log_error "tmux installation failed"
    return 1
  fi
}

_install_tmux_config() {
  local tmux_conf="$HOME/.tmux.conf"
  local src="$DEVTERM_ROOT/config/tmux.conf"

  if [[ ! -f "$src" ]]; then
    log_error "tmux config not found at $src"
    return 1
  fi

  # Skip if already devterm-managed
  if [[ -f "$tmux_conf" ]] && grep -q "devterm" "$tmux_conf" 2>/dev/null; then
    log_skip "$HOME/.tmux.conf (devterm-managed)"
    return 0
  fi

  # Backup existing config
  backup_file "$tmux_conf"

  cp "$src" "$tmux_conf"
  log_ok "$HOME/.tmux.conf installed (Catppuccin Mocha)"
}

# ── zellij ────────────────────────────────────────────────────────────────

_install_zellij() {
  if command_exists zellij; then
    log_skip "zellij"
    return 0
  fi

  log_info "Installing zellij..."

  if [[ "${DEVTERM_OS:-}" == "macos" ]]; then
    _install_pkg zellij
  elif command_exists cargo; then
    cargo install zellij 2>/dev/null
  else
    # Direct binary download (like Starship handles Linux)
    local arch
    arch="$(uname -m)"
    local url="https://github.com/zellij-org/zellij/releases/latest/download/zellij-${arch}-unknown-linux-musl.tar.gz"
    local tmpdir
    tmpdir="$(mktemp -d)"
    if curl -fsSL "$url" | tar xz -C "$tmpdir" 2>/dev/null; then
      mkdir -p "$HOME/.local/bin"
      mv "$tmpdir/zellij" "$HOME/.local/bin/zellij"
      chmod +x "$HOME/.local/bin/zellij"
    else
      log_error "zellij binary download failed — install manually or use cargo"
      rm -rf "$tmpdir"
      return 1
    fi
    rm -rf "$tmpdir"
  fi

  if command_exists zellij; then
    log_ok "zellij installed"
  else
    log_error "zellij installation failed"
    return 1
  fi
}

_install_zellij_config() {
  local zellij_dir="$HOME/.config/zellij"
  local zellij_conf="$zellij_dir/config.kdl"
  local src="$DEVTERM_ROOT/config/zellij.kdl"

  if [[ ! -f "$src" ]]; then
    log_error "zellij config not found at $src"
    return 1
  fi

  # Skip if already devterm-managed
  if [[ -f "$zellij_conf" ]] && grep -q "devterm" "$zellij_conf" 2>/dev/null; then
    log_skip "$HOME/.config/zellij/config.kdl (devterm-managed)"
    return 0
  fi

  # Backup existing config
  backup_file "$zellij_conf"

  mkdir -p "$zellij_dir"
  cp "$src" "$zellij_conf"
  log_ok "$HOME/.config/zellij/config.kdl installed (Catppuccin Mocha)"
}
