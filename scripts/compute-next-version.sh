#!/usr/bin/env bash
# Compute the next release tag from the latest semver-shaped git tag.
#
# Supports both 2-part legacy tags (v2.0, normalized to 2.0.0) and 3-part
# tags (v2.1.0). Always emits a 3-part tag. Floating major tags (v2) are
# excluded from the source-of-truth scan.
#
# Inputs (env):
#   BUMP   "major" or "minor"
#
# Outputs (stdout):
#   The next version tag, e.g. "v2.1.0".

set -euo pipefail

: "${BUMP:?BUMP is required (major or minor)}"

case "$BUMP" in
  major|minor) ;;
  *)
    echo "::error::BUMP must be 'major' or 'minor', got '$BUMP'" >&2
    exit 1
    ;;
esac

latest=$(git tag --list 'v*.*' --sort=-v:refname \
  | grep -E '^v[0-9]+\.[0-9]+(\.[0-9]+)?$' \
  | head -1 || true)

if [[ -z "$latest" ]]; then
  base="0.0.0"
else
  base="${latest#v}"
  if [[ "$base" =~ ^[0-9]+\.[0-9]+$ ]]; then
    base="${base}.0"
  fi
fi

next=$(semver bump "$BUMP" "$base")
echo "v${next}"
