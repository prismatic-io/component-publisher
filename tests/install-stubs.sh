#!/usr/bin/env bash
# Install action-smoke stub binaries onto $GITHUB_PATH and prepare the
# capture directory the stubs write to.

set -euo pipefail

: "${RUNNER_TEMP:?RUNNER_TEMP is required (run from a GitHub Actions runner)}"
: "${GITHUB_PATH:?GITHUB_PATH is required}"

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
stub_dir="$RUNNER_TEMP/bin"

mkdir -p "$stub_dir" "$RUNNER_TEMP/prism-calls"
install -m 0755 "$here/stubs/prism" "$stub_dir/prism"

echo "$stub_dir" >> "$GITHUB_PATH"
