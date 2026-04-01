#!/usr/bin/env bash
# lib/detect.sh — System detection and environment checks

detect_system() {
  log_step "Detecting system environment"

  # ── OS detection ────────────────────────────────────────────────────────
  case "$OSTYPE" in
    darwin*)
      DEVTERM_OS="macos"
      _detect_macos
      ;;
    linux*)
      DEVTERM_OS="linux"
      _detect_linux
      ;;
    *)
      log_error "Unsupported OS: $OSTYPE. devterm supports macOS and Linux."
      exit 1
      ;;
  esac

  export DEVTERM_OS

  # ── Current shell ────────────────────────────────────────────────────────
  CURRENT_SHELL=$(basename "$SHELL")
  log_ok "Current shell: $CURRENT_SHELL"
}

_detect_macos() {
  # macOS version check
  MACOS_VERSION=$(sw_vers -productVersion)
  MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)
  if [[ "$MACOS_MAJOR" -lt 12 ]]; then
    log_warn "macOS $MACOS_VERSION detected. Recommend macOS 12 (Monterey) or later."
  else
    log_ok "macOS $MACOS_VERSION"
  fi

  # Architecture
  ARCH=$(uname -m)
  if [[ "$ARCH" == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
    log_ok "Apple Silicon (M1/M2/M3) — Homebrew at $BREW_PREFIX"
  else
    BREW_PREFIX="/usr/local"
    log_ok "Intel x86_64 — Homebrew at $BREW_PREFIX"
  fi
  export BREW_PREFIX

  # Homebrew
  if command_exists brew; then
    BREW_VERSION=$(brew --version | head -1)
    log_ok "$BREW_VERSION"
  else
    log_info "Homebrew not found — will install"
    install_homebrew
  fi

  # iTerm2 check
  if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
    log_warn "Not running in iTerm2. Color scheme installation requires iTerm2."
    log_info "Download at: https://iterm2.com"
  else
    ITERM_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" \
      "/Applications/iTerm.app/Contents/Info.plist" 2>/dev/null || echo "unknown")
    log_ok "iTerm2 $ITERM_VERSION"
  fi
}

_detect_linux() {
  # Distro detection
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    LINUX_DISTRO="${ID:-unknown}"
    log_ok "Linux: $NAME $VERSION_ID"
  else
    LINUX_DISTRO="unknown"
    log_warn "Could not detect Linux distribution"
  fi
  export LINUX_DISTRO

  # Package manager
  if command_exists apt-get; then
    PKGMGR="apt"
    log_ok "Package manager: apt"
  elif command_exists pacman; then
    PKGMGR="pacman"
    log_ok "Package manager: pacman"
  elif command_exists dnf; then
    PKGMGR="dnf"
    log_ok "Package manager: dnf"
  else
    PKGMGR="unknown"
    log_warn "Could not detect package manager — some installs may fail"
  fi
  export PKGMGR

  # Architecture
  ARCH=$(uname -m)
  log_ok "Architecture: $ARCH"
}

install_homebrew() {
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH immediately
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  log_ok "Homebrew installed"
}
