#!/usr/bin/env bash
set -euo pipefail

if command -v prism >/dev/null 2>&1; then
  echo "Prism CLI is already installed."
  exit 0
fi

PRISM_VERSION="${PRISM_VERSION:-^9}"
echo "Installing @prismatic-io/prism@$PRISM_VERSION..."
npm install --global "@prismatic-io/prism@$PRISM_VERSION"
