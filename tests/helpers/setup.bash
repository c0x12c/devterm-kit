#!/usr/bin/env bash
# tests/helpers/setup.bash — Shared test utilities for devterm BATS tests

# Resolve project root relative to this file
DEVTERM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# ── Fixtures / sandbox ─────────────────────────────────────────────────────

# Create an isolated temp $HOME for each test
setup_sandbox() {
  TEST_HOME="$(mktemp -d)"
  export HOME="$TEST_HOME"
  export XDG_CACHE_HOME="$TEST_HOME/.cache"
  mkdir -p "$TEST_HOME"
}

teardown_sandbox() {
  [[ -d "${TEST_HOME:-}" ]] && rm -rf "$TEST_HOME"
}

# Source a lib module in the context of the sandbox
source_lib() {
  local module="$1"
  # Stub out functions that require Homebrew / network so unit tests stay fast
  _stub_external_commands
  source "$DEVTERM_ROOT/lib/$module"
}

# Replace brew/curl/git with no-op stubs so tests run offline
_stub_external_commands() {
  brew()    { echo "[stub] brew $*"; return 0; }
  curl()    { echo "[stub] curl $*"; return 0; }
  git()     { echo "[stub] git $*"; return 0; }
  # Accept flags so callers like `sw_vers -productVersion` work correctly
  sw_vers() {
    case "${1:-}" in
      -productVersion) echo "14.0" ;;
      -buildVersion)   echo "23A344" ;;
      *)               echo "ProductName: macOS" ;;
    esac
  }
  # Accept -m flag so `uname -m` returns the architecture correctly
  uname() {
    case "${1:-}" in
      -m) echo "arm64" ;;
      -s) echo "Darwin" ;;
      *)  echo "Darwin" ;;
    esac
  }
  export -f brew curl git sw_vers uname
}

# ── Assertion helpers ──────────────────────────────────────────────────────

# Assert a file exists
assert_file_exists() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "Expected file to exist: $file" >&2
    return 1
  fi
}

# Assert a file contains a string
assert_file_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -q "$pattern" "$file" 2>/dev/null; then
    echo "Expected '$pattern' in $file" >&2
    echo "File contents:" >&2
    cat "$file" >&2
    return 1
  fi
}

# Assert a command succeeds
assert_success() {
  if [[ "$status" -ne 0 ]]; then
    echo "Expected success (exit 0), got: $status" >&2
    echo "Output: $output" >&2
    return 1
  fi
}

# Assert a command fails
assert_failure() {
  if [[ "$status" -eq 0 ]]; then
    echo "Expected failure (exit != 0), got: $status" >&2
    return 1
  fi
}

# Assert output contains string
assert_output_contains() {
  local expected="$1"
  if [[ "$output" != *"$expected"* ]]; then
    echo "Expected output to contain: $expected" >&2
    echo "Actual output: $output" >&2
    return 1
  fi
}
