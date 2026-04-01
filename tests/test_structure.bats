#!/usr/bin/env bats
# tests/test_structure.bats — Validate project structure and file integrity

load 'helpers/setup'

# ── Required files ─────────────────────────────────────────────────────────

@test "install.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/install.sh"
}

@test "setup.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/setup.sh"
}

@test "README.md exists" {
  assert_file_exists "$DEVTERM_ROOT/README.md"
}

@test "LICENSE exists" {
  assert_file_exists "$DEVTERM_ROOT/LICENSE"
}

@test "CONTRIBUTING.md exists" {
  assert_file_exists "$DEVTERM_ROOT/CONTRIBUTING.md"
}

# ── Lib modules ────────────────────────────────────────────────────────────

@test "lib/utils.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/utils.sh"
}

@test "lib/detect.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/detect.sh"
}

@test "lib/fonts.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/fonts.sh"
}

@test "lib/shell.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/shell.sh"
}

@test "lib/starship.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/starship.sh"
}

@test "lib/plugins.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/plugins.sh"
}

@test "lib/tools.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/tools.sh"
}

@test "lib/iterm2.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/iterm2.sh"
}

@test "lib/zshrc.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/zshrc.sh"
}

@test "lib/doctor.sh exists" {
  assert_file_exists "$DEVTERM_ROOT/lib/doctor.sh"
}

# ── Starship configs ───────────────────────────────────────────────────────

@test "config/starship-mocha.toml exists" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-mocha.toml"
}

@test "config/starship-latte.toml exists" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-latte.toml"
}

@test "config/starship-frappe.toml exists" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-frappe.toml"
}

@test "config/starship-macchiato.toml exists" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-macchiato.toml"
}

@test "each starship config declares its palette" {
  for flavor in mocha latte frappe macchiato; do
    assert_file_contains \
      "$DEVTERM_ROOT/config/starship-${flavor}.toml" \
      "palette = \"catppuccin_${flavor}\""
  done
}

@test "each starship config defines its palette colors" {
  for flavor in mocha latte frappe macchiato; do
    assert_file_contains \
      "$DEVTERM_ROOT/config/starship-${flavor}.toml" \
      "[palettes.catppuccin_${flavor}]"
  done
}

# ── Themes ─────────────────────────────────────────────────────────────────

@test "Catppuccin Mocha iTerm2 theme file exists" {
  assert_file_exists "$DEVTERM_ROOT/themes/catppuccin-mocha.itermcolors"
}

@test "Catppuccin Latte iTerm2 theme file exists" {
  assert_file_exists "$DEVTERM_ROOT/themes/catppuccin-latte.itermcolors"
}

@test "Catppuccin Frappé iTerm2 theme file exists" {
  assert_file_exists "$DEVTERM_ROOT/themes/catppuccin-frappe.itermcolors"
}

@test "Catppuccin Macchiato iTerm2 theme file exists" {
  assert_file_exists "$DEVTERM_ROOT/themes/catppuccin-macchiato.itermcolors"
}

# ── Script syntax ──────────────────────────────────────────────────────────

@test "install.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/install.sh"
  assert_success
}

@test "setup.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/setup.sh"
  assert_success
}

@test "lib/utils.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/utils.sh"
  assert_success
}

@test "lib/detect.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/detect.sh"
  assert_success
}

@test "lib/starship.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/starship.sh"
  assert_success
}

@test "lib/zshrc.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/zshrc.sh"
  assert_success
}

@test "lib/doctor.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/doctor.sh"
  assert_success
}

@test "lib/fonts.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/fonts.sh"
  assert_success
}

@test "lib/iterm2.sh has valid bash syntax" {
  run bash -n "$DEVTERM_ROOT/lib/iterm2.sh"
  assert_success
}

# ── No p10k references in active scripts ──────────────────────────────────

@test "setup.sh does not source p10k" {
  run grep "source.*p10k" "$DEVTERM_ROOT/setup.sh"
  assert_failure
}

@test "lib/zshrc.sh does not reference powerlevel10k theme" {
  run grep 'ZSH_THEME="powerlevel10k' "$DEVTERM_ROOT/lib/zshrc.sh"
  assert_failure
}

@test "lib/zshrc.sh initialises starship" {
  assert_file_contains "$DEVTERM_ROOT/lib/zshrc.sh" "starship init zsh"
}

# ── Cross-platform guards ──────────────────────────────────────────────────

@test "install.sh does not block Linux (no darwin-only OSTYPE guard)" {
  # The old install.sh had: if [[ "$OSTYPE" != "darwin"* ]]; then exit 1; fi
  # v2.0 must NOT have this — it should run on Linux too
  run grep 'darwin.*exit 1\|OSTYPE.*darwin' "$DEVTERM_ROOT/install.sh"
  assert_failure
}

@test "lib/zshrc.sh has conditional OMZ plugin list per platform" {
  # The platform-conditional plugins block must exist to prevent the
  # 'macos' OMZ plugin warning on Linux
  assert_file_contains "$DEVTERM_ROOT/lib/zshrc.sh" 'omz_plugins'
}

@test "lib/zshrc.sh wraps flush-dns in a Darwin runtime check" {
  assert_file_contains "$DEVTERM_ROOT/lib/zshrc.sh" 'flush-dns'
  assert_file_contains "$DEVTERM_ROOT/lib/zshrc.sh" 'Darwin'
}

@test "docs/demo.tape exists (VHS script for generating demo GIF)" {
  assert_file_exists "$DEVTERM_ROOT/docs/demo.tape"
}

@test "docs/GROWTH_PLAN.md exists" {
  assert_file_exists "$DEVTERM_ROOT/docs/GROWTH_PLAN.md"
}

@test "lib/doctor.sh contains check_p10k_leftovers function" {
  assert_file_contains "$DEVTERM_ROOT/lib/doctor.sh" "check_p10k_leftovers"
}

@test "setup.sh contains _detect_p10k_migration function" {
  assert_file_contains "$DEVTERM_ROOT/setup.sh" "_detect_p10k_migration"
}

# ── No placeholder URLs in lib/ ────────────────────────────────────────────

@test "lib/*.sh files do not contain 'yourusername' placeholder" {
  run grep -rl "yourusername" "$DEVTERM_ROOT/lib/"
  [[ -z "$output" ]] || { echo "Found placeholder in: $output"; return 1; }
}
