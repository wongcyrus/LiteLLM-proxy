#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$ROOT_DIR/.env"
KEY_FILE="$ROOT_DIR/.keys/litellm_user_key.txt"

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  set -a
  source "$ENV_FILE"
  set +a
fi

if [[ -f "$KEY_FILE" ]]; then
  LITELLM_API_KEY="$(tr -d '[:space:]' < "$KEY_FILE")"
else
  LITELLM_API_KEY="${LITELLM_API_KEY:-}"
fi

LITELLM_BASE_URL="${LITELLM_BASE_URL:-http://localhost:4000/v1}"
DEFAULT_MODEL="${OPENCLAW_DEFAULT_MODEL:-litellm/gemini-3.1-flash-lite}"

if [[ -z "$LITELLM_API_KEY" ]]; then
  echo "Error: no LiteLLM key found. Run ./gen_key.sh first or set LITELLM_API_KEY in .env"
  exit 1
fi

if ! command -v openclaw >/dev/null 2>&1; then
  echo "Error: openclaw CLI is not installed or not on PATH"
  exit 1
fi

# --- Onboarding ---
echo "1. Onboarding OpenClaw to LiteLLM Proxy..."

openclaw onboard --non-interactive --accept-risk \
  --auth-choice litellm-api-key \
  --litellm-api-key "$LITELLM_API_KEY" \
  --custom-base-url "$LITELLM_BASE_URL" \
  --install-daemon --skip-channels --skip-skills

# --- Model Setup ---
echo -e "\n2. Configuring Models..."

# Setting the default LiteLLM-backed model
echo "Setting active model to: $DEFAULT_MODEL"
openclaw models set "$DEFAULT_MODEL"

echo -e "\nSetup Complete!"
echo "------------------------------------------------"
echo "To switch to your Azure model, run:"
echo "openclaw models set litellm/gpt-5.2"
echo "------------------------------------------------"
