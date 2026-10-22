#!/usr/bin/env bash
set -euo pipefail

URL="${1:?Provide the application URL}"
EXPECTED_VERSION="${2:?Provide the expected version}"

for attempt in {1..20}; do
  if RESPONSE=$(curl --fail --silent --show-error \
    --connect-timeout 2 --max-time 5 \
    "$URL/health"); then

    if printf '%s' "$RESPONSE" |
      node -e '
        let input = "";
        process.stdin.on("data", chunk => input += chunk);
        process.stdin.on("end", () => {
          try {
            const health = JSON.parse(input);
            const expected = process.argv[1];

            if (health.status !== "ok" ||
                health.version !== expected) {
              process.exit(1);
            }

            console.log("Health and version checks passed");
          } catch {
            process.exit(1);
          }
        });
      ' "$EXPECTED_VERSION"; then
      exit 0
    fi
  fi

  echo "Waiting for the expected release: attempt $attempt"
  sleep 3
done

echo "Health or version check failed"
exit 1