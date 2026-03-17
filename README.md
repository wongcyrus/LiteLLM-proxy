# LiteLLM Proxy

A production-ready LiteLLM Proxy configuration supporting **Google Vertex AI (Gemini 3.1)** and **Azure OpenAI (GPT-5.2)** with PostgreSQL persistence and virtual key budgeting.

## 🚀 Quick Start

### 1. Prerequisites
*   **Docker & Docker Compose** installed.
*   **Google Cloud SDK (`gcloud`)** authenticated for Vertex AI:
    ```bash
    gcloud auth application-default login
    ```
*   **Azure OpenAI API Key** and Resource Endpoint.

### 2. Configuration
Update the `.env` file with your actual credentials:
```env
# Vertex AI
VERTEXAI_PROJECT=<YOUR_GCP_PROJECT_ID>
VERTEXAI_LOCATION=global

# Azure OpenAI
AZURE_API_KEY=<YOUR_AZURE_API_KEY>
AZURE_API_BASE=https://<YOUR_RESOURCE_NAME>.openai.azure.com/

# Security
LITELLM_MASTER_KEY=<YOUR_CHOSEN_MASTER_KEY>
```

### 3. Deployment
Start the stack (LiteLLM + PostgreSQL):
```bash
docker compose up -d
```
The API will be available at `http://localhost:4000` (and your local network IP).

---

## 🛠 Supported Models

| Model Alias | Provider | Underlying Model |
| :--- | :--- | :--- |
| `gemini-3.1-flash-lite-preview` | Vertex AI | `vertex_ai/gemini-3.1-flash-lite-preview` |
| `gpt-5.2` | Azure OpenAI | `azure/gpt-5.2` (with reasoning support) |

---

## 🔑 Key & Budget Management

This setup uses a **PostgreSQL database** to persist virtual keys and track spending.

### Master Key
Use this for administrative tasks (generating keys, checking stats).

### Virtual Keys (Budgeting)
Generate keys with specific budget limits and reset durations.

#### Generate a new key with a budget:
```bash
curl -X POST 'http://localhost:4000/key/generate' \
-H 'Authorization: Bearer <YOUR_MASTER_KEY>' \
-H 'Content-Type: application/json' \
-d "{
    \"key_alias\": \"user-key\",
    \"max_budget\": 10.00,
    \"budget_duration\": \"1d\"
}"
```

---

## 📡 Network Access
The proxy is configured to listen on `0.0.0.0:4000`, making it accessible to other machines in your local network.

**Endpoint:** `http://<YOUR_HOST_IP>:4000/v1/chat/completions`

---

## 🧪 Testing
Run the included test script to verify both providers:
```bash
./test_litellm.sh
```
