#!/usr/bin/env bash
# Build and run `prism components:publish` from environment variables.
# Inputs are read from env — never interpolated into the shell by the
# caller — so values containing shell metacharacters cannot break out
# into command execution.
#
# PRISM_BIN overrides the prism executable for testing.

set -uo pipefail

: "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"

PRISM_BIN="${PRISM_BIN:-prism}"
COMPONENT_PATH="${COMPONENT_PATH:-}"

if [[ -n "$COMPONENT_PATH" ]]; then
  cd "$COMPONENT_PATH" || exit 1
fi

args=("components:publish" "--skip-on-signature-match" "--no-confirm")

[[ "${SKIP_COMMIT_HASH_PUBLISH:-false}" == "false" && -n "${COMMIT_HASH:-}" ]] && args+=("--commitHash=$COMMIT_HASH")
[[ "${SKIP_COMMIT_URL_PUBLISH:-false}" == "false" && -n "${COMMIT_URL:-}" ]] && args+=("--commitUrl=$COMMIT_URL")
[[ "${SKIP_REPO_URL_PUBLISH:-false}" == "false" && -n "${REPO:-}" ]] && args+=("--repoUrl=$REPO")
[[ "${SKIP_PULL_REQUEST_URL_PUBLISH:-false}" == "false" && -n "${PR_URL:-}" ]] && args+=("--pullRequestUrl=$PR_URL")
[[ -n "${CUSTOMER_ID:-}" ]] && args+=("--customer=$CUSTOMER_ID")
[[ -n "${COMMENT:-}" ]] && args+=("--comment=$COMMENT")

output=$("$PRISM_BIN" "${args[@]}" 2>&1)
status=$?

if (( status != 0 )); then
  echo "::error::prism components:publish failed (exit $status)"
  echo "$output"
  exit "$status"
fi

echo "$output"

if grep -q "Package signatures match, skipping publish" <<<"$output"; then
  echo "PUBLISH_SKIPPED=true" >> "$GITHUB_OUTPUT"
else
  echo "PUBLISH_SKIPPED=false" >> "$GITHUB_OUTPUT"
fi
