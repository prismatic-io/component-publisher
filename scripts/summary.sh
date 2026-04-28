#!/usr/bin/env bash
set -euo pipefail

: "${GITHUB_STEP_SUMMARY:?GITHUB_STEP_SUMMARY is required}"
: "${PRISMATIC_URL:?PRISMATIC_URL is required}"

skip_row() {
  local label="$1" skip="$2"
  if [[ "$skip" == "false" ]]; then
    echo "| $label | ✅ |"
  else
    echo "| $label | ❌ |"
  fi
}

if [[ "${PUBLISH_SKIPPED:-false}" == "true" ]]; then
  {
    echo "### Component Not Published 🚫"
    echo "#### A component with this signature is already published."
  } >> "$GITHUB_STEP_SUMMARY"
  exit 0
fi

{
  echo "### Component Published :rocket:"
  echo "|![Prismatic Logo](https://app.prismatic.io/logo_fullcolor_white.svg)| Publish Info |"
  echo "| --------------------- | --------------- |"

  if [[ -n "${COMPONENT_PATH:-}" ]]; then
    echo "| Source Directory      | $COMPONENT_PATH |"
  fi

  echo "| Target Stack          | $PRISMATIC_URL |"

  if [[ -n "${PRISMATIC_TENANT_ID:-}" ]]; then
    echo "| Tenant ID             | $PRISMATIC_TENANT_ID |"
  fi

  echo "| Commit Link           | ${COMMIT_URL:-} |"

  if [[ -n "${PR_URL:-}" ]]; then
    echo "| PR Link               | $PR_URL |"
  fi

  skip_row "Commit Hash Published" "${SKIP_COMMIT_HASH_PUBLISH:-false}"
  skip_row "Commit Link Published" "${SKIP_COMMIT_URL_PUBLISH:-false}"
  skip_row "Repository Link Published" "${SKIP_REPO_URL_PUBLISH:-false}"
  skip_row "PR Link Published" "${SKIP_PULL_REQUEST_URL_PUBLISH:-false}"
} >> "$GITHUB_STEP_SUMMARY"
