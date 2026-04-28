#!/usr/bin/env bash
# Assert the stub prism captured an expected components:publish call
# during the action-smoke CI job.

set -euo pipefail
shopt -s nullglob

calls=("$RUNNER_TEMP"/prism-calls/*)
if [[ ${#calls[@]} -eq 0 ]]; then
  echo "::error::stub prism was not invoked"
  exit 1
fi

publish_call=""
for f in "${calls[@]}"; do
  argv="$(tr '\0' '\n' < "$f")"
  if grep -qx 'components:publish' <<<"$argv"; then
    publish_call="$f"
    break
  fi
done

if [[ -z "$publish_call" ]]; then
  echo "::error::no components:publish call captured"
  for f in "${calls[@]}"; do
    echo "--- $f"
    tr '\0' '\n' < "$f"
  done
  exit 1
fi

argv="$(tr '\0' '\n' < "$publish_call")"
echo "captured publish argv:"
echo "$argv"

grep -qx -- '--skip-on-signature-match' <<<"$argv"
grep -qx -- '--no-confirm' <<<"$argv"
grep -q  -- '--commitHash=' <<<"$argv"
grep -q  -- '--commitUrl=' <<<"$argv"
grep -qx -- '--repoUrl=prismatic-io/component-publisher' <<<"$argv"
grep -qx -- '--customer=cust_smoke' <<<"$argv"
grep -qx -- '--comment=smoke comment' <<<"$argv"
