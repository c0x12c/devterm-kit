#!/usr/bin/env bash
# lib/plugins.sh — Zsh plugin installation

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_plugins() {
  log_step "Installing Zsh plugins"

  _install_zsh_plugin \
    "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "Fish-like auto-suggestions as you type"

  _install_zsh_plugin \
    "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "Syntax highlighting for commands"
}

_install_zsh_plugin() {
  local name="$1"
  local url="$2"
  local desc="$3"
  local target="$ZSH_CUSTOM/plugins/$name"

  if [[ -d "$target" ]]; then
    log_skip "$name ($desc)"
    return 0
  fi

  log_info "Installing $name..."
  if git clone --depth=1 "$url" "$target" 2>/dev/null; then
    log_ok "$name installed ($desc)"
  else
    log_error "Failed to install $name"
    return 1
  fi
}
