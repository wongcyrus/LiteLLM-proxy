#!/bin/bash

# --- Configuration ---
# Replace these with your actual keys and host IP
LITELLM_API_KEY="sk--XXXXXXXXXXX"
LITELLM_BASE_URL="http://172.30.61.74:4000/v1"

# --- Onboarding ---
echo "1. Onboarding OpenClaw to LiteLLM Proxy..."

openclaw onboard --non-interactive --accept-risk \
  --auth-choice litellm-api-key \
  --litellm-api-key "$LITELLM_API_KEY" \
  --custom-base-url "$LITELLM_BASE_URL" \
  --install-daemon --skip-channels --skip-skills

# --- Model Setup ---
echo -e "\n2. Configuring Models..."

# Setting Gemini 3.1 as the active model
echo "Setting active model to: gemini-3.1-flash-lite-preview"
openclaw models set litellm/gemini-3.1-flash-lite-preview

echo -e "\nSetup Complete!"
echo "------------------------------------------------"
echo "To switch to your Azure model, run:"
echo "openclaw models set litellm/gpt-5.2"
echo "------------------------------------------------"
