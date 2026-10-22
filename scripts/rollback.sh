#!/usr/bin/env bash
set -euo pipefail

REVISION="${1:?Provide the known working deployment revision}"
CONTEXT="kind-practicum"

if ! [[ "$REVISION" =~ ^[1-9][0-9]*$ ]]; then
  echo "Revision must be a positive integer"
  exit 1
fi

echo "Restoring deployment revision $REVISION"

kubectl --context "$CONTEXT" -n test rollout undo \
  deployment/practicum-app \
  --to-revision="$REVISION"

kubectl --context "$CONTEXT" -n test rollout status \
  deployment/practicum-app \
  --timeout=120s

echo "Rollback rollout completed; a smoke test must verify recovery"