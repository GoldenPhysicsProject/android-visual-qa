#!/usr/bin/env bash
set -euo pipefail

: "${GPP_SOURCE_SHA:?GPP_SOURCE_SHA is required}"
: "${GITHUB_RUN_ID:?GITHUB_RUN_ID is required}"
: "${ACTIONS_ID_TOKEN_REQUEST_URL:?GitHub OIDC request URL unavailable}"
: "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:?GitHub OIDC request token unavailable}"

APP_ID="${1:-api-vault}"
DIR="${2:-source/visual-qa}"
BRIDGE_URL="${GPP_BRIDGE_URL:-https://dunrgpupddbmzffntwph.supabase.co/functions/v1/gpp-bridge}"

test -d "$DIR"

oidc_response="$(curl --fail-with-body --silent --show-error   --header "Authorization: Bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN"   "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=gpp-app-visual-results")"
OIDC="$(jq -r '.value // empty' <<<"$oidc_response")"
test -n "$OIDC"

count=0
while IFS= read -r -d '' file; do
  name="$(basename "$file")"
  request="/tmp/gpp-visual-${count}.json"
  python3 - "$file" "$APP_ID" "$GITHUB_RUN_ID" "$GPP_SOURCE_SHA" "$name" "$request" <<'PY'
import base64, json, pathlib, sys
file_path, app_id, run_id, source_sha, name, out = sys.argv[1:]
raw = pathlib.Path(file_path).read_bytes()
payload = {
    "app_id": app_id,
    "run_id": run_id,
    "source_sha": source_sha,
    "name": name,
    "png_base64": base64.b64encode(raw).decode("ascii"),
}
pathlib.Path(out).write_text(json.dumps(payload), encoding="utf-8")
PY
  code="$(curl --silent --show-error     --output /tmp/gpp-visual-response.json     --write-out '%{http_code}'     --request POST     --header "Authorization: Bearer $OIDC"     --header 'Content-Type: application/json'     --data-binary "@$request"     "$BRIDGE_URL/gha-app-visual-result")"
  if [ "$code" != "201" ]; then
    echo "visual result upload failed for $name (HTTP $code)" >&2
    cat /tmp/gpp-visual-response.json >&2 || true
    exit 1
  fi
  rm -f "$request" /tmp/gpp-visual-response.json
  count=$((count + 1))
  echo "stored private visual result: $name"
done < <(find "$DIR" -maxdepth 1 -type f -name '*.png' -print0 | sort -z)

test "$count" -gt 0
echo "stored $count visual QA screenshots privately"
