#!/usr/bin/env bats
#
# Tests for scripts/summary.sh.
#
# Each test runs the script with a temp GITHUB_STEP_SUMMARY file and the
# minimum required env, then asserts on the captured markdown content.

setup() {
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  WORKDIR="$(mktemp -d)"
  GITHUB_STEP_SUMMARY="$WORKDIR/summary.md"
  : > "$GITHUB_STEP_SUMMARY"
  export GITHUB_STEP_SUMMARY
  export PRISMATIC_URL="https://example.invalid"
}

teardown() {
  rm -rf "$WORKDIR"
}

@test "skipped publish uses neutral skip icon, not 🚫" {
  PUBLISH_SKIPPED=true \
    "$PROJECT_ROOT/scripts/summary.sh"

  run cat "$GITHUB_STEP_SUMMARY"
  [ "$status" -eq 0 ]
  [[ "$output" != *"🚫"* ]]
  [[ "$output" != *"Component Not Published"* ]]
  [[ "$output" == *":fast_forward:"* ]]
  [[ "$output" == *"Component Skipped"* ]]
}

@test "skipped publish includes COMPONENT_PATH identifier" {
  COMPONENT_PATH="components/slack" \
  PUBLISH_SKIPPED=true \
    "$PROJECT_ROOT/scripts/summary.sh"

  run cat "$GITHUB_STEP_SUMMARY"
  [[ "$output" == *"\`components/slack\`"* ]]
}

@test "skipped publish falls back to '.' when COMPONENT_PATH is unset" {
  PUBLISH_SKIPPED=true \
    "$PROJECT_ROOT/scripts/summary.sh"

  run cat "$GITHUB_STEP_SUMMARY"
  [[ "$output" == *"\`.\`"* ]]
}

@test "published summary includes COMPONENT_PATH in heading" {
  COMPONENT_PATH="components/slack" \
    "$PROJECT_ROOT/scripts/summary.sh"

  run cat "$GITHUB_STEP_SUMMARY"
  [[ "$output" == *"Component Published"* ]]
  [[ "$output" == *"#### \`components/slack\`"* ]]
}

@test "published summary works without COMPONENT_PATH" {
  "$PROJECT_ROOT/scripts/summary.sh"

  run cat "$GITHUB_STEP_SUMMARY"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Component Published"* ]]
  [[ "$output" == *"#### \`.\`"* ]]
}
