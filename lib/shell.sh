#!/usr/bin/env bash
# lib/shell.sh — Zsh and Oh My Zsh installation

install_zsh() {
  log_step "Setting up Zsh"

  # Install zsh if missing
  if ! command_exists zsh; then
    log_info "Installing zsh via Homebrew..."
    brew install zsh
    log_ok "Zsh installed"
  else
    log_skip "Zsh $(zsh --version | awk '{print $2}')"
  fi

  # Set as default shell
  local zsh_path
  zsh_path=$(command -v zsh)
  if [[ "$SHELL" != "$zsh_path" ]]; then
    log_info "Setting zsh as default shell..."
    # Add to /etc/shells if not already present
    if ! grep -qF "$zsh_path" /etc/shells; then
      echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
    fi
    if chsh -s "$zsh_path"; then
      log_ok "Default shell changed to zsh"
    else
      log_warn "Could not change shell. Run: chsh -s $zsh_path"
    fi
  else
    log_skip "Zsh is already the default shell"
  fi
}

install_omz() {
  log_step "Installing Oh My Zsh"

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log_skip "Oh My Zsh (~/.oh-my-zsh exists)"
    return 0
  fi

  log_info "Downloading Oh My Zsh..."
  # RUNZSH=no prevents auto-switching shell mid-install
  # CHSH=no we handle shell change ourselves
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log_ok "Oh My Zsh installed"
}
