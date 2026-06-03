#!/bin/bash
set -euo pipefail

# Generate a LiteLLM virtual key using values from .env and save it locally.
# Usage:
#   ./gen_key.sh [key_alias] [max_budget] [budget_duration]
# Example:
#   ./gen_key.sh user-key 10 1d

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$ROOT_DIR/.env"
OUT_DIR="$ROOT_DIR/.keys"
OUT_FILE="$OUT_DIR/litellm_user_key.txt"

KEY_ALIAS="${1:-user-key}"
MAX_BUDGET="${2:-10}"
BUDGET_DURATION="${3:-1d}"
PROXY_URL="${LITELLM_PROXY_URL:-http://localhost:4000}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found"
  exit 1
fi

# shellcheck disable=SC1090
set -a
source "$ENV_FILE"
set +a

if [[ -z "${LITELLM_MASTER_KEY:-}" ]]; then
  echo "Error: LITELLM_MASTER_KEY is missing in .env"
  exit 1
fi

mkdir -p "$OUT_DIR"

RESPONSE="$(curl -sS -X POST "$PROXY_URL/key/generate" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  --data-raw "{\"key_alias\":\"$KEY_ALIAS\",\"models\":[],\"max_budget\":$MAX_BUDGET,\"budget_duration\":\"$BUDGET_DURATION\",\"metadata\":{\"owner\":\"local-script\"}}")"

KEY=""
if command -v jq >/dev/null 2>&1; then
  KEY="$(printf '%s' "$RESPONSE" | jq -r '.key // .token // .data.key // empty')"
else
  KEY="$(printf '%s' "$RESPONSE" | sed -n 's/.*"key"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
fi

if [[ -z "$KEY" || "$KEY" == "null" ]]; then
  echo "Error: could not parse key from response"
  echo "Response: $RESPONSE"
  exit 1
fi

printf '%s\n' "$KEY" > "$OUT_FILE"
chmod 600 "$OUT_FILE"

echo "Key generated and saved to: $OUT_FILE"
