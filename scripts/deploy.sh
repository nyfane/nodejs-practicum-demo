#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

export DEPLOY_IMAGE="${1:-nodejs-practicum-demo:local}"
CONTEXT="kind-practicum"

echo "Deploying $DEPLOY_IMAGE to $CONTEXT"

kubectl --context "$CONTEXT" apply -f k8s/namespace.yml
kubectl --context "$CONTEXT" apply -f k8s/service.yml

# Generate the deployment YAML with the selected image.
node <<'NODE' |
const fs = require('node:fs');

const yaml = fs.readFileSync('k8s/deployment.yml', 'utf8');
const imageLine = /^([ \t]*)image:.*$/gm;
const matches = [...yaml.matchAll(imageLine)];

if (matches.length !== 1) {
  throw new Error('Expected exactly one image entry in deployment.yml');
}

process.stdout.write(
  yaml.replace(
    imageLine,
    (_, indent) =>
      `${indent}image: ${JSON.stringify(process.env.DEPLOY_IMAGE)}`
  )
);
NODE
  kubectl --context "$CONTEXT" apply -f -

kubectl --context "$CONTEXT" -n test rollout status \
  deployment/practicum-app \
  --timeout=120s

kubectl --context "$CONTEXT" -n test get pods

echo "Deployment rollout completed successfully"