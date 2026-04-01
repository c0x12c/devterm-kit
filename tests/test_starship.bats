#!/usr/bin/env bats
# tests/test_starship.bats — Tests for lib/starship.sh

load 'helpers/setup'

setup() {
  setup_sandbox
  export DEVTERM_ROOT
  export DEVTERM_THEME="mocha"
  export DEVTERM_OS="macos"
  source "$DEVTERM_ROOT/lib/utils.sh"
  # Stub brew and curl so tests run offline
  brew()    { echo "[stub] brew $*"; return 0; }
  curl()    { echo "[stub] curl $*"; return 0; }
  export -f brew curl
  source "$DEVTERM_ROOT/lib/starship.sh"
}

teardown() {
  teardown_sandbox
}

# ── Config files exist ─────────────────────────────────────────────────────

@test "starship-mocha.toml exists in config/" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-mocha.toml"
}

@test "starship-latte.toml exists in config/" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-latte.toml"
}

@test "starship-frappe.toml exists in config/" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-frappe.toml"
}

@test "starship-macchiato.toml exists in config/" {
  assert_file_exists "$DEVTERM_ROOT/config/starship-macchiato.toml"
}

# ── Config content ─────────────────────────────────────────────────────────

@test "mocha config declares catppuccin_mocha palette" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-mocha.toml" \
    'palette = "catppuccin_mocha"'
}

@test "latte config declares catppuccin_latte palette" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-latte.toml" \
    'palette = "catppuccin_latte"'
}

@test "mocha config has git_branch module" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-mocha.toml" "[git_branch]"
}

@test "mocha config has nodejs module" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-mocha.toml" "[nodejs]"
}

@test "mocha config has python module" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-mocha.toml" "[python]"
}

@test "mocha config has kotlin module (Spartan stack)" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-mocha.toml" "[kotlin]"
}

@test "mocha config has java module" {
  assert_file_contains "$DEVTERM_ROOT/config/starship-mocha.toml" "[java]"
}

@test "mocha config includes all 26 Catppuccin Mocha palette colors" {
  local config="$DEVTERM_ROOT/config/starship-mocha.toml"
  for color in rosewater flamingo pink mauve red maroon peach yellow green \
               teal sky sapphire blue lavender text subtext1 subtext0 \
               overlay2 overlay1 overlay0 surface2 surface1 surface0 \
               base mantle crust; do
    assert_file_contains "$config" "$color"
  done
}

# ── _install_starship_config ───────────────────────────────────────────────

@test "_install_starship_config copies mocha config to ~/.config/starship.toml" {
  mkdir -p "$HOME/.config"
  DEVTERM_THEME="mocha"

  _install_starship_config

  assert_file_exists "$HOME/.config/starship.toml"
  assert_file_contains "$HOME/.config/starship.toml" "catppuccin_mocha"
}

@test "_install_starship_config copies latte config when theme is latte" {
  mkdir -p "$HOME/.config"
  DEVTERM_THEME="latte"

  _install_starship_config

  assert_file_exists "$HOME/.config/starship.toml"
  assert_file_contains "$HOME/.config/starship.toml" "catppuccin_latte"
}

@test "_install_starship_config preserves existing non-devterm config" {
  mkdir -p "$HOME/.config"
  echo "# my custom starship config" > "$HOME/.config/starship.toml"

  _install_starship_config

  # Should NOT overwrite because file has no 'devterm' marker
  assert_file_contains "$HOME/.config/starship.toml" "my custom starship config"
}

@test "_install_starship_config overwrites devterm-generated config on theme change" {
  mkdir -p "$HOME/.config"
  # Simulate a previous devterm-generated config
  echo "# devterm generated" > "$HOME/.config/starship.toml"
  echo 'palette = "catppuccin_mocha"' >> "$HOME/.config/starship.toml"

  DEVTERM_THEME="latte"
  _install_starship_config

  assert_file_contains "$HOME/.config/starship.toml" "catppuccin_latte"
}

@test "_install_starship_config falls back to mocha for unknown theme" {
  mkdir -p "$HOME/.config"
  DEVTERM_THEME="nonexistent_theme"

  _install_starship_config

  assert_file_exists "$HOME/.config/starship.toml"
  assert_file_contains "$HOME/.config/starship.toml" "catppuccin_mocha"
}
