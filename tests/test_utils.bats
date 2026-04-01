#!/usr/bin/env bats
# tests/test_utils.bats — Unit tests for lib/utils.sh

load 'helpers/setup'

setup() {
  setup_sandbox
  source "$DEVTERM_ROOT/lib/utils.sh"
}

teardown() {
  teardown_sandbox
}

# ── command_exists ─────────────────────────────────────────────────────────

@test "command_exists returns 0 for 'bash' (always present)" {
  # Double-quote the outer string so $DEVTERM_ROOT is expanded by BATS before
  # being passed to the bash -c subshell (single quotes prevent expansion).
  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; command_exists bash && echo found"
  assert_success
  assert_output_contains "found"
}

@test "command_exists returns 1 for a non-existent command" {
  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; command_exists __devterm_no_such_cmd_xyz"
  assert_failure
}

# ── dir_exists ─────────────────────────────────────────────────────────────

@test "dir_exists returns 0 for a non-empty directory" {
  local tmpdir
  tmpdir="$(mktemp -d)"
  touch "$tmpdir/somefile"

  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; dir_exists \"$tmpdir\" && echo yes"
  assert_success
  assert_output_contains "yes"

  rm -rf "$tmpdir"
}

@test "dir_exists returns 1 for an empty directory" {
  local tmpdir
  tmpdir="$(mktemp -d)"

  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; dir_exists \"$tmpdir\" && echo yes || echo no"
  assert_output_contains "no"

  rm -rf "$tmpdir"
}

@test "dir_exists returns 1 for a path that does not exist" {
  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; dir_exists /totally/fake/path/xyz && echo yes || echo no"
  assert_output_contains "no"
}

# ── backup_file ────────────────────────────────────────────────────────────

@test "backup_file creates a timestamped backup of an existing file" {
  local original="$TEST_HOME/testfile"
  echo "original content" > "$original"

  source "$DEVTERM_ROOT/lib/utils.sh"
  backup_file "$original"

  # At least one backup should exist
  local backups=("$TEST_HOME"/testfile.backup.*)
  [[ ${#backups[@]} -ge 1 ]] || {
    echo "No backup file created"; return 1
  }
  grep -q "original content" "${backups[0]}"
}

@test "backup_file does nothing when the file does not exist" {
  source "$DEVTERM_ROOT/lib/utils.sh"
  run backup_file "$TEST_HOME/nonexistent_file"
  # Should succeed silently — no error
  assert_success
}

# ── log functions ──────────────────────────────────────────────────────────

@test "log_ok outputs to stdout" {
  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; log_ok 'all good'"
  assert_success
  assert_output_contains "all good"
}

@test "log_error outputs to stderr" {
  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; log_error 'something broke' 2>&1"
  assert_output_contains "something broke"
}

@test "log_warn outputs a warning message" {
  run bash -c "source \"$DEVTERM_ROOT/lib/utils.sh\"; log_warn 'watch out'"
  assert_success
  assert_output_contains "watch out"
}
