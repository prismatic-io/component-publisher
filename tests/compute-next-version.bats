#!/usr/bin/env bats
#
# Tests for scripts/compute-next-version.sh.
#
# Tests cover the script's own logic — tag filtering, version-sorted
# selection, and BUMP validation — not the underlying `semver bump`
# arithmetic.

setup() {
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  WORKDIR="$(mktemp -d)"
  cd "$WORKDIR"
  git init -q
  git config user.email "test@example.invalid"
  git config user.name "test"
  git commit --allow-empty -q -m "init"
}

teardown() {
  cd "$BATS_TEST_DIRNAME"
  rm -rf "$WORKDIR"
}

@test "version sort picks the highest tag, not the lex-greatest" {
  for t in v1.0.0 v1.5.0 v1.2.0 v1.10.0 v1.10.5; do git tag "$t"; done
  run env BUMP=minor "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "v1.11.0" ]
}

@test "floating major tags (e.g. v2) are excluded from the scan" {
  for t in v1.0.0 v2.0.0 v2; do git tag "$t"; done
  run env BUMP=patch "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "v2.0.1" ]
}

@test "no tags falls back to v0.x.0 baseline" {
  run env BUMP=minor "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "v0.1.0" ]
}

@test "invalid BUMP value is rejected" {
  run env BUMP=banana "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"BUMP must be"* ]]
}
