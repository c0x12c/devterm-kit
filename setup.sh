#!/usr/bin/env bash
# =============================================================================
# devterm — Professional terminal setup for macOS & Linux
# https://github.com/c0x12c/devterm-kit
#
# Usage:
#   ./setup.sh                  Interactive (recommended)
#   ./setup.sh --theme mocha    Non-interactive with theme
#   ./setup.sh --minimal        Core only (no CLI tools)
#   ./setup.sh --doctor         Health check (no changes made)
#   ./setup.sh --help           Show help
# =============================================================================

set -euo pipefail

# Resolve project root (works even if called from different directories)
DEVTERM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DEVTERM_ROOT

# ── Source all lib modules ─────────────────────────────────────────────────
source "$DEVTERM_ROOT/lib/utils.sh"
source "$DEVTERM_ROOT/lib/detect.sh"
source "$DEVTERM_ROOT/lib/fonts.sh"
source "$DEVTERM_ROOT/lib/shell.sh"
source "$DEVTERM_ROOT/lib/starship.sh"
source "$DEVTERM_ROOT/lib/plugins.sh"
source "$DEVTERM_ROOT/lib/tools.sh"
source "$DEVTERM_ROOT/lib/iterm2.sh"
source "$DEVTERM_ROOT/lib/zshrc.sh"
source "$DEVTERM_ROOT/lib/doctor.sh"

# ── Defaults ───────────────────────────────────────────────────────────────
DEVTERM_THEME="mocha"
DEVTERM_MODE="full"     # full | minimal
DEVTERM_NONINTERACTIVE=false
DEVTERM_OS="macos"      # set by detect_system

# ── Argument parsing ───────────────────────────────────────────────────────
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --theme)
        shift
        DEVTERM_THEME="${1:-mocha}"
        DEVTERM_NONINTERACTIVE=true
        ;;
      --minimal)
        DEVTERM_MODE="minimal"
        ;;
      --non-interactive|--yes|-y)
        DEVTERM_NONINTERACTIVE=true
        ;;
      --doctor)
        doctor
        exit $?
        ;;
      --help|-h)
        show_help
        exit 0
        ;;
      --version|-v)
        echo "devterm v2.0.0"
        exit 0
        ;;
      *)
        log_warn "Unknown option: $1"
        ;;
    esac
    shift
  done
  export DEVTERM_THEME DEVTERM_MODE DEVTERM_NONINTERACTIVE
}

show_help() {
  cat << 'EOF'

  devterm — Professional terminal setup for macOS & Linux

  USAGE:
    ./setup.sh [OPTIONS]

  OPTIONS:
    --theme <variant>    Set Catppuccin theme: mocha (default), latte, frappe, macchiato
    --minimal            Install core only (skip CLI tools)
    --non-interactive    Skip all prompts, use defaults
    --doctor             Diagnose your devterm installation (no changes made)
    -h, --help           Show this help
    -v, --version        Show version

  EXAMPLES:
    ./setup.sh                        # Interactive setup
    ./setup.sh --theme macchiato      # Non-interactive, Macchiato theme
    ./setup.sh --minimal --yes        # Minimal, no prompts
    ./setup.sh --doctor               # Health check

  WHAT GETS INSTALLED:
    ✓ MesloLGS NF fonts (required for icons)
    ✓ Zsh + Oh My Zsh (plugin framework)
    ✓ Starship (fast, cross-shell prompt — Catppuccin themed)
    ✓ zsh-autosuggestions + zsh-syntax-highlighting
    ✓ Catppuccin color scheme for iTerm2 (macOS)
    ✓ Optimized ~/.zshrc

    Full mode also installs:
    ✓ fzf   — fuzzy history search (Ctrl+R)
    ✓ eza   — modern ls with icons
    ✓ bat   — cat with syntax highlighting
    ✓ zoxide — smart cd navigation

  SUPPORTED PLATFORMS:
    ✓ macOS 12+ (Monterey and later)
    ✓ Ubuntu / Debian Linux

EOF
}

# ── Powerlevel10k migration detection ─────────────────────────────────────
# Detects an existing p10k setup and informs the developer what devterm will
# replace — before any changes are made.  Never blocks or errors; info only.
_detect_p10k_migration() {
  local has_p10k_zshrc=false
  local has_p10k_config=false
  local has_p10k_theme=false

  # Check if existing .zshrc references powerlevel10k
  if [[ -f "$HOME/.zshrc" ]] && grep -q "powerlevel10k" "$HOME/.zshrc" 2>/dev/null; then
    has_p10k_zshrc=true
  fi

  # Check for ~/.p10k.zsh
  if [[ -f "$HOME/.p10k.zsh" ]]; then
    has_p10k_config=true
  fi

  # Check for p10k OMZ theme directory
  if [[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
    has_p10k_theme=true
  fi

  # Only print notice if any p10k artifact detected
  if [[ "$has_p10k_zshrc" == "false" && \
        "$has_p10k_config" == "false" && \
        "$has_p10k_theme" == "false" ]]; then
    return 0
  fi

  echo ""
  echo -e "  ${MOCHA_YELLOW}${BOLD}⚡ Existing Powerlevel10k setup detected${NC}"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  [[ "$has_p10k_zshrc" == "true" ]]   && echo -e "  ${DIM}·  ~/.zshrc references powerlevel10k${NC}"
  [[ "$has_p10k_config" == "true" ]]  && echo -e "  ${DIM}·  ~/.p10k.zsh exists${NC}"
  [[ "$has_p10k_theme" == "true" ]]   && echo -e "  ${DIM}·  Oh My Zsh p10k theme installed${NC}"
  echo ""
  echo -e "  ${MOCHA_YELLOW}What devterm will do:${NC}"
  echo -e "  ${MOCHA_GREEN}✓${NC} Back up your current ~/.zshrc to ~/.zshrc.backup.YYYYMMDD_HHMMSS"
  echo -e "  ${MOCHA_GREEN}✓${NC} Generate a new ~/.zshrc using Starship (not p10k)"
  echo -e "  ${MOCHA_GREEN}✓${NC} Install Catppuccin config for Starship"
  echo ""
  echo -e "  ${DIM}Your p10k files (${HOME}/.p10k.zsh, p10k theme) are ${BOLD}not deleted${NC}${DIM}.${NC}"
  echo -e "  ${DIM}Run './setup.sh --doctor' after install to see a cleanup guide.${NC}"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo ""
}

# ── Pre-flight checks ──────────────────────────────────────────────────────
preflight_check() {
  # Ensure not running as root
  if [[ $EUID -eq 0 ]]; then
    log_error "Do not run devterm as root (sudo). Run as your normal user."
    exit 1
  fi

  # Ensure internet connectivity — skip if all required tools are already installed
  local _needs_internet=false
  for _tool in zsh starship git; do
    if ! command_exists "$_tool"; then
      _needs_internet=true
      break
    fi
  done
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    _needs_internet=true
  fi

  if [[ "$_needs_internet" == "true" ]]; then
    # Try multiple endpoints in case one is blocked
    if ! curl -fsSL --connect-timeout 5 https://github.com &>/dev/null && \
       ! curl -fsSL --connect-timeout 5 https://1.1.1.1 &>/dev/null; then
      log_error "No internet connection. devterm requires internet to download components."
      exit 1
    fi
  fi
}

# ── Interactive mode ───────────────────────────────────────────────────────
interactive_setup() {
  print_banner

  echo -e "  ${MOCHA_TEXT}This will set up your professional terminal environment.${NC}"
  echo -e "  ${DIM}Safe to re-run — existing installations are detected and skipped.${NC}"

  # Inform developer if migrating from p10k (runs before theme selection)
  _detect_p10k_migration

  # Theme selection
  if [[ "$DEVTERM_NONINTERACTIVE" == "false" ]]; then
    pick_theme
  fi

  echo ""
  echo -e "  ${MOCHA_MAUVE}${BOLD}Installation plan:${NC}"
  echo -e "  ${DIM}────────────────────────────────${NC}"
  echo -e "  ${MOCHA_GREEN}✓${NC} MesloLGS NF fonts"
  echo -e "  ${MOCHA_GREEN}✓${NC} Zsh + Oh My Zsh"
  echo -e "  ${MOCHA_GREEN}✓${NC} Starship prompt (Catppuccin $(_capitalize "$DEVTERM_THEME"))"
  echo -e "  ${MOCHA_GREEN}✓${NC} zsh plugins"
  if [[ "$DEVTERM_OS" == "macos" ]]; then
    echo -e "  ${MOCHA_GREEN}✓${NC} Catppuccin $(_capitalize "$DEVTERM_THEME") for iTerm2"
  fi
  echo -e "  ${MOCHA_GREEN}✓${NC} ~/.zshrc (existing backed up)"
  if [[ "$DEVTERM_MODE" == "full" ]]; then
    echo -e "  ${MOCHA_GREEN}✓${NC} CLI tools: fzf, eza, bat, zoxide"
  fi
  echo ""

  if [[ "$DEVTERM_NONINTERACTIVE" == "false" ]]; then
    confirm "Ready to install?" "y" || { echo "Aborted."; exit 0; }
  fi
}

# ── Main execution ─────────────────────────────────────────────────────────
main() {
  parse_args "$@"
  preflight_check
  interactive_setup

  local start_time=$SECONDS

  # Run installation steps
  detect_system
  install_fonts
  install_zsh
  install_omz
  install_starship
  install_plugins

  if [[ "$DEVTERM_MODE" == "full" ]]; then
    install_tools
  fi

  # iTerm2 color scheme (macOS only)
  if [[ "$DEVTERM_OS" == "macos" ]]; then
    install_iterm2_theme
  fi

  generate_zshrc

  # ── Summary ──────────────────────────────────────────────────────────────
  local elapsed=$((SECONDS - start_time))
  echo ""
  echo -e "${MOCHA_GREEN}${BOLD}"
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║        ✅  Setup complete!               ║"
  printf "  ║  Finished in %-28s║\n" "${elapsed}s"
  echo "  ╚══════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "  ${BOLD}Next steps:${NC}"
  echo ""

  if [[ "$DEVTERM_OS" == "macos" ]]; then
    echo -e "  ${MOCHA_BLUE}1.${NC} ${BOLD}Fully quit and reopen iTerm2${NC}"
    echo "     (Cmd+Q, not just close window)"
    echo ""
    echo -e "  ${MOCHA_BLUE}2.${NC} ${BOLD}Reload your shell:${NC}"
    echo "     exec zsh"
    echo ""
    echo -e "  ${DIM}Font (MesloLGS NF 14pt) and color scheme (catppuccin-${DEVTERM_THEME})${NC}"
    echo -e "  ${DIM}have been applied to your iTerm2 Default profile automatically.${NC}"
  else
    echo -e "  ${MOCHA_BLUE}1.${NC} ${BOLD}Set font in your terminal to 'MesloLGS NF'${NC}"
    echo ""
    echo -e "  ${MOCHA_BLUE}2.${NC} ${BOLD}Reload your shell:${NC}"
    echo "     exec zsh"
  fi

  echo ""
  echo -e "  ${DIM}Tip: Run './setup.sh --doctor' anytime to check your environment.${NC}"
  echo ""
}

main "$@"
