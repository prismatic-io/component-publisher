#!/usr/bin/env bash
# Validate required inputs before any expensive setup runs (Node install,
# Prism install, etc.). Inputs are read from the environment so values
# containing shell metacharacters cannot break out into command execution.

set -euo pipefail

fail=0

if [[ -z "${PRISMATIC_URL:-}" ]]; then
  echo "::error::PRISMATIC_URL is not set"
  fail=1
fi

if [[ -z "${PRISM_REFRESH_TOKEN:-}" ]]; then
  echo "::error::PRISM_REFRESH_TOKEN is not set"
  fail=1
fi

(( fail == 0 ))
