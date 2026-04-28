#!/usr/bin/env bats
#
# Tests for scripts/compute-next-version.sh.
#
# These tests exist to document the 2-part → 3-part version migration:
# the script must read existing legacy tags (v2.0) and produce 3-part
# successors (v2.1.0). Once all reachable tags are 3-part, this script
# becomes a thin wrapper over `semver bump` and these tests can be
# retired.

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

@test "minor bump from 2-part legacy v2.0 produces v2.1.0" {
  for t in v1.0 v1.1 v2.0; do git tag "$t"; done
  run env BUMP=minor "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "v2.1.0" ]
}

@test "major bump from 2-part legacy v2.0 produces v3.0.0" {
  for t in v1.0 v1.1 v2.0; do git tag "$t"; done
  run env BUMP=major "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "v3.0.0" ]
}

@test "version sort picks the highest across mixed 2-part and 3-part tags" {
  for t in v1.0 v1.5 v1.2 v1.10 v1.10.5; do git tag "$t"; done
  run env BUMP=minor "$PROJECT_ROOT/scripts/compute-next-version.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "v1.11.0" ]
}
