#!/usr/bin/env bats
#
# Tests for scripts/validate-inputs.sh.

setup() {
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  REQUIRED=(
    PRISMATIC_URL=https://example.invalid
    PRISM_REFRESH_TOKEN=tok
  )
}

@test "passes when required inputs are set" {
  run env "${REQUIRED[@]}" "$PROJECT_ROOT/scripts/validate-inputs.sh"
  [ "$status" -eq 0 ]
}

@test "fails when PRISMATIC_URL is empty" {
  run env "${REQUIRED[@]}" PRISMATIC_URL= "$PROJECT_ROOT/scripts/validate-inputs.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"PRISMATIC_URL"* ]]
}

@test "fails when PRISM_REFRESH_TOKEN is empty" {
  run env "${REQUIRED[@]}" PRISM_REFRESH_TOKEN= "$PROJECT_ROOT/scripts/validate-inputs.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"PRISM_REFRESH_TOKEN"* ]]
}
