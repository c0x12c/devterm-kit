#!/usr/bin/env bash
# lib/utils.sh — Shared logging, colors, and helper utilities

# Terminal formatting
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Catppuccin Mocha palette (for themed output)
MOCHA_MAUVE='\033[38;2;203;166;247m'
MOCHA_BLUE='\033[38;2;137;180;250m'
MOCHA_GREEN='\033[38;2;166;227;161m'
MOCHA_RED='\033[38;2;243;139;168m'
MOCHA_YELLOW='\033[38;2;249;226;175m'
MOCHA_TEXT='\033[38;2;205;214;244m'

# ── Logging ────────────────────────────────────────────────────────────────

log_header() {
  echo -e "\n${MOCHA_MAUVE}${BOLD}━━━ $1 ━━━${NC}"
}

log_step() {
  echo -e "\n${MOCHA_BLUE}${BOLD}▶ $1${NC}"
}

log_ok() {
  echo -e "  ${MOCHA_GREEN}✓${NC} $1"
}

log_skip() {
  echo -e "  ${DIM}⊘ $1 — already installed, skipping${NC}"
}

log_info() {
  echo -e "  ${MOCHA_BLUE}ℹ${NC} $1"
}

log_warn() {
  echo -e "  ${MOCHA_YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "  ${MOCHA_RED}✗${NC} $1" >&2
}

log_section() {
  echo ""
  echo -e "${MOCHA_MAUVE}${BOLD}╔══════════════════════════════════════════╗${NC}"
  printf "${MOCHA_MAUVE}${BOLD}║  %-42s║${NC}\n" "$1"
  echo -e "${MOCHA_MAUVE}${BOLD}╚══════════════════════════════════════════╝${NC}"
}

# ── Utilities ──────────────────────────────────────────────────────────────

# Capitalize the first letter of a string.
# Uses portable POSIX tools — safe on bash 3.2 (macOS built-in).
# Do NOT use ${var^} — that requires bash 4.0+ and fails on macOS built-in bash.
_capitalize() {
  local str="$1"
  local first
  first="$(printf '%s' "${str:0:1}" | tr '[:lower:]' '[:upper:]')"
  printf '%s' "${first}${str:1}"
}

# Check if a command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# Check if a brew package is installed
brew_installed() {
  brew list "$1" &>/dev/null 2>&1
}

# Check if a directory exists and is non-empty
dir_exists() {
  [[ -d "$1" ]] && [[ -n "$(ls -A "$1" 2>/dev/null)" ]]
}

# Confirm prompt — returns 0 for yes, 1 for no
confirm() {
  local prompt="${1:-Continue?}"
  local default="${2:-y}"

  if [[ "$default" == "y" ]]; then
    read -r -p "  $prompt [Y/n] " response
    response="${response:-y}"
  else
    read -r -p "  $prompt [y/N] " response
    response="${response:-n}"
  fi

  [[ "$response" =~ ^[Yy]$ ]]
}

# Spinner for long operations
spinner() {
  local pid=$1
  local msg="${2:-Working...}"
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r  ${MOCHA_BLUE}%s${NC} %s" "${frames[$((i % 10))]}" "$msg"
    sleep 0.1
    i=$((i + 1))   # safe: ((i++)) returns exit 1 when i=0, breaks set -e
  done
  printf "\r  ${MOCHA_GREEN}✓${NC} %s\n" "$msg"
}

# Run command with spinner
run_with_spinner() {
  local msg="$1"
  shift
  "$@" &>/dev/null &
  local pid=$!
  spinner "$pid" "$msg"
  wait "$pid"
  return $?
}

# Backup a file with timestamp
backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup
    backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"  # SC2155: separate to catch date errors
    cp "$file" "$backup"
    log_info "Backed up $(basename "$file") → $backup"
  fi
}

# Print devterm banner
print_banner() {
  echo ""
  echo -e "${MOCHA_MAUVE}${BOLD}"
  echo "  ██████╗ ███████╗██╗   ██╗████████╗███████╗██████╗ ███╗   ███╗"
  echo "  ██╔══██╗██╔════╝██║   ██║╚══██╔══╝██╔════╝██╔══██╗████╗ ████║"
  echo "  ██║  ██║█████╗  ██║   ██║   ██║   █████╗  ██████╔╝██╔████╔██║"
  echo "  ██║  ██║██╔══╝  ╚██╗ ██╔╝   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║"
  echo "  ██████╔╝███████╗ ╚████╔╝    ██║   ███████╗██║  ██║██║ ╚═╝ ██║"
  echo "  ╚═════╝ ╚══════╝  ╚═══╝     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝"
  echo -e "${NC}"
  echo -e "  ${MOCHA_TEXT}Professional terminal setup — macOS & Linux${NC}"
  echo -e "  ${DIM}Catppuccin · Starship · Oh My Zsh${NC}"
  echo ""
}
