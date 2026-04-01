#!/usr/bin/env bats
# tests/test_zshrc.bats — Tests for lib/zshrc.sh (.zshrc generation)

load 'helpers/setup'

setup() {
  setup_sandbox
  export DEVTERM_ROOT
  export DEVTERM_THEME="mocha"
  export DEVTERM_MODE="full"
  source "$DEVTERM_ROOT/lib/utils.sh"
  source "$DEVTERM_ROOT/lib/zshrc.sh"
}

teardown() {
  teardown_sandbox
}

# ── File creation ──────────────────────────────────────────────────────────

@test "generate_zshrc creates ~/.zshrc" {
  run generate_zshrc
  assert_success
  assert_file_exists "$HOME/.zshrc"
}

@test "generate_zshrc produces non-empty ~/.zshrc" {
  generate_zshrc
  [[ -s "$HOME/.zshrc" ]] || { echo "~/.zshrc is empty"; return 1; }
}

# ── Starship (not p10k) ────────────────────────────────────────────────────

@test "generated .zshrc initialises Starship" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "starship init zsh"
}

@test "generated .zshrc does NOT reference powerlevel10k theme" {
  generate_zshrc
  run grep "powerlevel10k/powerlevel10k" "$HOME/.zshrc"
  assert_failure
}

@test "generated .zshrc sets ZSH_THEME to empty string" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" 'ZSH_THEME=""'
}

# ── Required content ───────────────────────────────────────────────────────

@test "generated .zshrc sources oh-my-zsh" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "oh-my-zsh.sh"
}

@test "generated .zshrc includes git aliases" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" 'alias gs='
}

@test "generated .zshrc includes eza aliases" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "eza"
}

@test "generated .zshrc includes Gradle aliases for Spartan stack" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "alias gwb="
}

@test "generated .zshrc sets EDITOR to code" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" 'EDITOR="code"'
}

@test "generated .zshrc exports HOME/.local/bin to PATH (Linux Starship support)" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" '/.local/bin'
}

@test "generated .zshrc includes fzf configuration" {
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "FZF_DEFAULT_OPTS"
}

# ── Platform conditionals (Linux vs macOS) ────────────────────────────────

@test "generated .zshrc on macOS includes 'macos' OMZ plugin" {
  export DEVTERM_OS="macos"
  generate_zshrc
  # The 'macos' OMZ plugin must appear as an indented entry in plugins=()
  assert_file_contains "$HOME/.zshrc" "  macos"
}

@test "generated .zshrc on Linux excludes 'macos' OMZ plugin from plugins list" {
  export DEVTERM_OS="linux"
  generate_zshrc
  # Grep for '  macos' as a plugin list entry — must NOT be present on Linux
  run grep -E "^  macos$" "$HOME/.zshrc"
  assert_failure
}

@test "generated .zshrc on Linux still has all required cross-platform plugins" {
  export DEVTERM_OS="linux"
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "zsh-autosuggestions"
  assert_file_contains "$HOME/.zshrc" "zsh-syntax-highlighting"
  assert_file_contains "$HOME/.zshrc" "git"
}

@test "generated .zshrc wraps flush-dns alias in Darwin conditional" {
  generate_zshrc
  # flush-dns must be inside an OS guard — not a bare alias
  assert_file_contains "$HOME/.zshrc" 'uname.*Darwin'
  assert_file_contains "$HOME/.zshrc" "flush-dns"
}

@test "generated .zshrc OS label matches the set DEVTERM_OS" {
  export DEVTERM_OS="linux"
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "OS: linux"
}

# ── Theme injection ────────────────────────────────────────────────────────

@test "generated .zshrc reflects the selected theme name" {
  DEVTERM_THEME="latte"
  generate_zshrc
  assert_file_contains "$HOME/.zshrc" "Latte"
}

# ── Backup behaviour ───────────────────────────────────────────────────────

@test "generate_zshrc backs up existing ~/.zshrc before overwriting" {
  echo "# old config" > "$HOME/.zshrc"
  generate_zshrc
  local backups=("$HOME"/.zshrc.backup.*)
  [[ ${#backups[@]} -ge 1 ]] || { echo "No backup created"; return 1; }
  grep -q "# old config" "${backups[0]}" || { echo "Backup missing original content"; return 1; }
}

@test "generate_zshrc is idempotent — running twice yields identical output" {
  generate_zshrc
  cp "$HOME/.zshrc" "$HOME/.zshrc.first"

  generate_zshrc

  # diff is POSIX — available on macOS and Linux (no md5sum/md5 dependency)
  diff "$HOME/.zshrc.first" "$HOME/.zshrc" || {
    echo "Second run produced a different .zshrc"; return 1
  }
}
