#!/usr/bin/env bash
set -euo pipefail

: "${GPP_SOURCE_REPOSITORY:?GPP_SOURCE_REPOSITORY is required}"
: "${GPP_SOURCE_REF:?GPP_SOURCE_REF is required}"
: "${ACTIONS_ID_TOKEN_REQUEST_URL:?GitHub OIDC request URL unavailable}"
: "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:?GitHub OIDC request token unavailable}"

BRIDGE_URL="${GPP_BRIDGE_URL:-https://dunrgpupddbmzffntwph.supabase.co/functions/v1/gpp-bridge}"
DEST="${GPP_SOURCE_DEST:-source}"

oidc_response="$(curl --fail-with-body --silent --show-error   --header "Authorization: Bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN"   "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=gpp-private-app-ci")"
GPP_OIDC="$(jq -r '.value // empty' <<<"$oidc_response")"
test -n "$GPP_OIDC"

rm -rf "$DEST" .gpp-source-extract source.zip source.headers
jq -nc   --arg repository "$GPP_SOURCE_REPOSITORY"   --arg source_ref "$GPP_SOURCE_REF"   '{repository:$repository,source_ref:$source_ref}' > source-request.json

curl --fail-with-body --silent --show-error   --request POST   --header "Authorization: Bearer $GPP_OIDC"   --header 'Content-Type: application/json'   --dump-header source.headers   --data-binary @source-request.json   "$BRIDGE_URL/gha-app-source"   --output source.zip

SOURCE_SHA="$(awk 'BEGIN{IGNORECASE=1} /^x-gpp-source-sha:/ {gsub("\r","",$2); print $2}' source.headers | tail -n1)"
[[ "$SOURCE_SHA" =~ ^[0-9a-f]{40}$ ]]

mkdir -p .gpp-source-extract
unzip -q source.zip -d .gpp-source-extract
ROOT="$(find .gpp-source-extract -mindepth 1 -maxdepth 1 -type d | head -n1)"
test -n "$ROOT"
mv "$ROOT" "$DEST"
rm -rf .gpp-source-extract source.zip source.headers source-request.json

echo "GPP_SOURCE_SHA=$SOURCE_SHA"
if [ -n "${GITHUB_ENV:-}" ]; then
  printf 'GPP_SOURCE_SHA=%s\n' "$SOURCE_SHA" >> "$GITHUB_ENV"
fi
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  printf 'source_sha=%s\n' "$SOURCE_SHA" >> "$GITHUB_OUTPUT"
fi
