#!/usr/bin/env bats
#
# Tests for scripts/publish.sh.
#
# Each test runs the script with a stub `prism` that records its argv to a
# file and emits canned stdout, then asserts on the captured argv and step
# output.

setup() {
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  WORKDIR="$(mktemp -d)"
  ARGV_FILE="$WORKDIR/argv"
  CWD_FILE="$WORKDIR/cwd"
  CANARY="$WORKDIR/pwned"
  GITHUB_OUTPUT="$WORKDIR/github_output"
  : > "$GITHUB_OUTPUT"
  export ARGV_FILE CWD_FILE GITHUB_OUTPUT

  cat > "$WORKDIR/prism" <<'STUB'
#!/usr/bin/env bash
pwd > "$CWD_FILE"
{ printf '%s\0' "$@"; } > "$ARGV_FILE"
echo "Component published successfully."
STUB
  chmod +x "$WORKDIR/prism"
  export PRISM_BIN="$WORKDIR/prism"
}

teardown() {
  rm -rf "$WORKDIR"
}

captured_argv() {
  tr '\0' '\n' < "$ARGV_FILE"
}

@test "publish emits components:publish with skip-on-signature-match and no-confirm" {
  "$PROJECT_ROOT/scripts/publish.sh"

  run captured_argv
  [ "$status" -eq 0 ]
  [[ "$output" == *"components:publish"* ]]
  [[ "$output" == *"--skip-on-signature-match"* ]]
  [[ "$output" == *"--no-confirm"* ]]
}

@test "PUBLISH_SKIPPED=false on a normal publish" {
  "$PROJECT_ROOT/scripts/publish.sh"
  grep -qx 'PUBLISH_SKIPPED=false' "$GITHUB_OUTPUT"
}

@test "PUBLISH_SKIPPED=true when prism reports a signature match" {
  cat > "$WORKDIR/prism" <<'STUB'
#!/usr/bin/env bash
echo "Package signatures match, skipping publish"
STUB
  chmod +x "$WORKDIR/prism"

  PRISM_BIN="$WORKDIR/prism" GITHUB_OUTPUT="$GITHUB_OUTPUT" \
    "$PROJECT_ROOT/scripts/publish.sh"

  grep -qx 'PUBLISH_SKIPPED=true' "$GITHUB_OUTPUT"
}

@test "metadata flags are appended when SKIP_* are false" {
  COMMIT_HASH=abc1234 \
  COMMIT_URL=https://example.invalid/c/abc1234 \
  REPO=owner/repo \
  PR_URL=https://example.invalid/pull/9 \
  SKIP_COMMIT_HASH_PUBLISH=false \
  SKIP_COMMIT_URL_PUBLISH=false \
  SKIP_REPO_URL_PUBLISH=false \
  SKIP_PULL_REQUEST_URL_PUBLISH=false \
    "$PROJECT_ROOT/scripts/publish.sh"

  run captured_argv
  [[ "$output" == *"--commitHash=abc1234"* ]]
  [[ "$output" == *"--commitUrl=https://example.invalid/c/abc1234"* ]]
  [[ "$output" == *"--repoUrl=owner/repo"* ]]
  [[ "$output" == *"--pullRequestUrl=https://example.invalid/pull/9"* ]]
}

@test "metadata flags are omitted when SKIP_* are true" {
  COMMIT_HASH=abc1234 \
  COMMIT_URL=https://example.invalid/c/abc1234 \
  REPO=owner/repo \
  PR_URL=https://example.invalid/pull/9 \
  SKIP_COMMIT_HASH_PUBLISH=true \
  SKIP_COMMIT_URL_PUBLISH=true \
  SKIP_REPO_URL_PUBLISH=true \
  SKIP_PULL_REQUEST_URL_PUBLISH=true \
    "$PROJECT_ROOT/scripts/publish.sh"

  run captured_argv
  [[ "$output" != *"--commitHash="* ]]
  [[ "$output" != *"--commitUrl="* ]]
  [[ "$output" != *"--repoUrl="* ]]
  [[ "$output" != *"--pullRequestUrl="* ]]
}

@test "CUSTOMER_ID adds --customer flag" {
  CUSTOMER_ID=cust_42 \
    "$PROJECT_ROOT/scripts/publish.sh"

  run captured_argv
  [[ "$output" == *"--customer=cust_42"* ]]
}

@test "COMMENT adds --comment flag" {
  COMMENT="release notes" \
    "$PROJECT_ROOT/scripts/publish.sh"

  run captured_argv
  [[ "$output" == *"--comment=release notes"* ]]
}

@test "COMPONENT_PATH cds before invoking prism" {
  mkdir -p "$WORKDIR/comp"
  COMPONENT_PATH="$WORKDIR/comp" \
    "$PROJECT_ROOT/scripts/publish.sh"

  grep -q "/comp\$" "$CWD_FILE"
}

@test "shell metacharacters in COMMENT do not execute" {
  COMMENT="\$(touch $CANARY)" \
    "$PROJECT_ROOT/scripts/publish.sh"

  [ ! -e "$CANARY" ]
  run captured_argv
  [[ "$output" == *"--comment=\$(touch $CANARY)"* ]]
}

@test "non-zero prism exit fails the script and surfaces output" {
  cat > "$WORKDIR/prism" <<'STUB'
#!/usr/bin/env bash
echo "boom"
exit 7
STUB
  chmod +x "$WORKDIR/prism"

  run env PRISM_BIN="$WORKDIR/prism" GITHUB_OUTPUT="$GITHUB_OUTPUT" \
    "$PROJECT_ROOT/scripts/publish.sh"

  [ "$status" -eq 7 ]
  [[ "$output" == *"prism components:publish failed"* ]]
  [[ "$output" == *"boom"* ]]
  ! grep -q PUBLISH_SKIPPED "$GITHUB_OUTPUT"
}
