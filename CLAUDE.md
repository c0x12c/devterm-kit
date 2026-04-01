# Project: devterm

## About
One-command terminal setup for macOS and Linux. Installs and configures Starship, Catppuccin, Oh My Zsh, MesloLGS NF font, and modern CLI tools (eza, bat, fzf, zoxide) in under 2 minutes.

## Tech Stack
- **Language:** Bash (100% shell scripts)
- **Shell Framework:** Oh My Zsh + Starship prompt
- **Theme System:** Catppuccin (mocha, macchiato, frappe, latte)
- **Testing:** BATS (Bash Automated Testing System)
- **Linting:** ShellCheck
- **CI:** GitHub Actions (ShellCheck + bash syntax + structure tests)
- **Platforms:** macOS (Homebrew) + Linux (apt / pacman / dnf)

## Architecture

Modular shell script design — `setup.sh` orchestrates, `lib/*.sh` modules handle each concern:

```
setup.sh            Main orchestrator + argument parsing
install.sh          One-liner remote entry point (curl | bash)
lib/
  utils.sh          Logging, colors, helpers (no side effects) — 147 lines
  detect.sh         OS/package-manager detection — 116 lines
  fonts.sh          MesloLGS NF font installation — 67 lines
  shell.sh          Zsh + Oh My Zsh installation — 49 lines
  starship.sh       Starship prompt + config deployment — 70 lines
  plugins.sh        Zsh plugin installation — 38 lines
  tools.sh          CLI tools (fzf, eza, bat, zoxide) — 71 lines
  iterm2.sh         iTerm2 color scheme installation — 78 lines
  zshrc.sh          .zshrc generation with aliases — 207 lines
  doctor.sh         Health check / diagnostic command — 341 lines
  p10k.sh           Deprecated stub (migration helper) — 8 lines
config/
  starship-{flavor}.toml    Starship prompt configs per Catppuccin variant
themes/
  catppuccin-{flavor}.itermcolors    iTerm2 color schemes
tests/
  test_structure.bats    Project structure + file integrity
  test_zshrc.bats        .zshrc generation tests
  test_utils.bats        Utility function tests
  test_doctor.bats       Doctor command tests
  test_starship.bats     Starship config tests
  helpers/setup.bash     Test helper/assertion functions
```

## Coding Rules

### Shell Style
- Shebang: `#!/usr/bin/env bash` (not `#!/bin/bash`)
- `set -euo pipefail` in main scripts
- Quote ALL variables: `"$variable"` not `$variable`
- Use `[[ ]]` not `[ ]` for conditionals
- Functions: `snake_case`, private helpers prefixed with `_`

### Idempotency (Critical)
Every step MUST check if already installed and skip gracefully. Users re-run devterm multiple times.
```bash
if [[ -d "$TARGET" ]]; then
  log_skip "Already installed"
  return 0
fi
```

### No Hardcoded Paths
- Use `$HOME` not `/Users/yourname`
- Use `command -v` to find binaries
- Use `brew --prefix` for Homebrew paths (Intel vs Apple Silicon differ)

### Error Handling
- `log_error` + `return 1` for non-fatal failures
- `log_error` + `exit 1` only for unrecoverable errors
- Never silently fail

### Cross-Platform
- All lib functions must work on both macOS and Linux
- Platform-conditional blocks for macOS-only features (flush-dns, iTerm2)
- No `darwin.*exit 1` guards in install.sh

## Commit Convention
```
type(scope): short description

- detail 1
- detail 2
```
Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
Scopes: `tools`, `fonts`, `starship`, `doctor`, `zshrc`, `plugins`, `ci`

## Testing
- **Framework:** BATS (bats-core)
- **Run:** `bats tests/` (requires `brew install bats-core` on macOS)
- **CI runs:** ShellCheck + bash syntax check + BATS structure tests
- Tests validate: file existence, bash syntax, config correctness, no placeholder URLs, cross-platform guards

## Key Design Decisions
- **Starship over Powerlevel10k** — p10k is effectively unmaintained; Starship is Rust-based, faster, actively developed
- **Catppuccin theme** — modern, popular, 4 variants for preference
- **No foreign dependencies at runtime** — pure bash, no Python/Ruby/Node needed for setup
- **Backup before modify** — existing `.zshrc` backed up with timestamp before any changes
- **Doctor command** — built-in diagnostic for troubleshooting (`--doctor` flag)

## Current Focus
- Demo GIF creation (highest-priority for launch)
- Growth/community strategy execution (see `docs/GROWTH_PLAN.md`)
- Potential additions: Ghostty support, WezTerm support, Fish shell, WSL2

## GSD State
Not using GSD — run `/gsd:new-project` to start if needed for multi-day work.
