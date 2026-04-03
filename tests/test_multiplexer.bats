#!/usr/bin/env bats
# tests/test_multiplexer.bats — Tests for lib/multiplexer.sh

load 'helpers/setup'

setup() {
  setup_sandbox
  export DEVTERM_ROOT
  export DEVTERM_OS="macos"
  source "$DEVTERM_ROOT/lib/utils.sh"
  source "$DEVTERM_ROOT/lib/multiplexer.sh"
}

teardown() {
  teardown_sandbox
}

# ── Skip behavior ─────────────────────────────────────────────────────────

@test "install_multiplexer does nothing when DEVTERM_MULTIPLEXER is empty" {
  export DEVTERM_MULTIPLEXER=""
  run install_multiplexer
  assert_success
}

@test "install_multiplexer does nothing when DEVTERM_MULTIPLEXER is unset" {
  unset DEVTERM_MULTIPLEXER
  run install_multiplexer
  assert_success
}

# ── Config files ──────────────────────────────────────────────────────────

@test "tmux config file exists in repo" {
  assert_file_exists "$DEVTERM_ROOT/config/tmux.conf"
}

@test "tmux config contains devterm marker" {
  assert_file_contains "$DEVTERM_ROOT/config/tmux.conf" "devterm"
}

@test "tmux config contains Catppuccin Mocha colors" {
  assert_file_contains "$DEVTERM_ROOT/config/tmux.conf" "MOCHA_BASE"
  assert_file_contains "$DEVTERM_ROOT/config/tmux.conf" "#1e1e2e"
}

@test "tmux config sets prefix to Ctrl+A" {
  assert_file_contains "$DEVTERM_ROOT/config/tmux.conf" "prefix C-a"
}

@test "zellij config file exists in repo" {
  assert_file_exists "$DEVTERM_ROOT/config/zellij.kdl"
}

@test "zellij config contains devterm marker" {
  assert_file_contains "$DEVTERM_ROOT/config/zellij.kdl" "devterm"
}

@test "zellij config contains Catppuccin Mocha colors" {
  assert_file_contains "$DEVTERM_ROOT/config/zellij.kdl" "catppuccin-mocha"
  assert_file_contains "$DEVTERM_ROOT/config/zellij.kdl" "#1e1e2e"
}

# ── Config deployment ─────────────────────────────────────────────────────

@test "_install_tmux_config copies config to HOME" {
  run _install_tmux_config
  assert_success
  assert_file_exists "$HOME/.tmux.conf"
  assert_file_contains "$HOME/.tmux.conf" "devterm"
}

@test "_install_tmux_config skips when already devterm-managed" {
  echo "# devterm managed" > "$HOME/.tmux.conf"
  run _install_tmux_config
  assert_success
  # Should contain skip message
  assert_output_contains "already installed"
}

@test "_install_tmux_config backs up existing non-devterm config" {
  echo "# my custom tmux config" > "$HOME/.tmux.conf"
  run _install_tmux_config
  assert_success
  local backups=("$HOME"/.tmux.conf.backup.*)
  [[ ${#backups[@]} -ge 1 ]] || { echo "No backup created"; return 1; }
}

@test "_install_zellij_config copies config to ~/.config/zellij/" {
  run _install_zellij_config
  assert_success
  assert_file_exists "$HOME/.config/zellij/config.kdl"
  assert_file_contains "$HOME/.config/zellij/config.kdl" "devterm"
}

@test "_install_zellij_config skips when already devterm-managed" {
  mkdir -p "$HOME/.config/zellij"
  echo "// devterm managed" > "$HOME/.config/zellij/config.kdl"
  run _install_zellij_config
  assert_success
  assert_output_contains "already installed"
}
