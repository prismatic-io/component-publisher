#!/usr/bin/env bash
# Compute the next release tag from the latest semver-shaped git tag.
# Floating major tags (v2) are excluded from the source-of-truth scan.
#
# Inputs (env):
#   BUMP   "major", "minor", or "patch"
#
# Outputs (stdout):
#   The next version tag, e.g. "v2.1.0".

set -euo pipefail

: "${BUMP:?BUMP is required (major, minor, or patch)}"

case "$BUMP" in
  major|minor|patch) ;;
  *)
    echo "::error::BUMP must be 'major', 'minor', or 'patch', got '$BUMP'" >&2
    exit 1
    ;;
esac

latest=$(git tag --list 'v*.*.*' --sort=-v:refname \
  | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
  | head -1 || true)

if [[ -z "$latest" ]]; then
  base="0.0.0"
else
  base="${latest#v}"
fi

next=$(semver bump "$BUMP" "$base")
echo "v${next}"
