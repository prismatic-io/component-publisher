#!/usr/bin/env bash
# Resolve the short commit hash, commit URL, and (if any) PR URL for the
# current run, then write them to $GITHUB_OUTPUT for downstream steps.

set -euo pipefail

: "${REPO:?REPO is required}"
: "${SHA:?SHA is required}"
: "${GITHUB_OUTPUT:?GITHUB_OUTPUT is required}"

short_sha="${SHA:0:7}"
echo "COMMIT_HASH=$short_sha" >> "$GITHUB_OUTPUT"
echo "COMMIT_URL=https://github.com/$REPO/commit/$short_sha" >> "$GITHUB_OUTPUT"

pr_url=""
pr_number=""
if details=$(gh api "repos/$REPO/commits/$SHA/pulls" --jq '.[0]' 2>/dev/null) \
   && [[ -n "$details" ]]; then
  pr_url=$(jq -r '.html_url' <<<"$details")
  pr_number=$(jq -r '.number' <<<"$details")
fi
echo "PR_URL=$pr_url" >> "$GITHUB_OUTPUT"
echo "PR_NUMBER=$pr_number" >> "$GITHUB_OUTPUT"
