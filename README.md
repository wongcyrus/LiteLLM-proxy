# LiteLLM Proxy Setup

A production-ready LiteLLM Proxy configuration supporting **Google Vertex AI (Gemini 3.1, 2.5, 1.5)** and **Azure OpenAI (GPT-5.2)** with PostgreSQL persistence and virtual key budgeting.

## 🚀 Quick Start

### 1. Prerequisites
*   **Docker & Docker Compose** installed.
*   **Google Cloud SDK (`gcloud`)** authenticated for Vertex AI:
    ```bash
    gcloud auth application-default login
    ```
*   **Azure OpenAI API Key** and Resource Endpoint.

### 2. Configuration
Create the `.env` file with your actual credentials from `.env.template`.
#### Google Cloud Authentication
Execute the authentication command to set up your Google Cloud credentials:
```bash
gcloud auth application-default login
```

#### Azure OpenAI Setup
Ensure your Azure OpenAI API Key and Resource Endpoint are available for the `.env` configuration.

### 3. Deployment
```bash
docker compose up -d
```

---

## 🛠 Supported Models

| Model Alias | Provider | Underlying Model |
| :--- | :--- | :--- |
| **`gemini-3.1-flash-lite-preview`** | Vertex AI | `vertex_ai/gemini-3.1-flash-lite-preview` |
| **`gemini-3.1-pro-preview`** | Vertex AI | `vertex_ai/gemini-3.1-pro-preview` |
| **`gemini-3.1-pro-preview-customtools`** | Vertex AI | `vertex_ai/gemini-3.1-pro-preview` (with tools) |
| **`gemini-3-flash-preview`** | Vertex AI | `vertex_ai/gemini-3-flash-preview` |
| **`gemini-2.5-pro`** | Vertex AI | `vertex_ai/gemini-2.5-pro` |
| **`gemini-2.5-flash`** | Vertex AI | `vertex_ai/gemini-2.5-flash` |
| **`gemini-2.5-flash-lite`** | Vertex AI | `vertex_ai/gemini-2.5-flash-lite` |
| **`gemini-1.5-pro`** | Vertex AI | `vertex_ai/gemini-1.5-pro` |
| **`gpt-5.2`** | Azure OpenAI | `azure/gpt-5.2` (with reasoning support) |

---

## 🔑 Key & Budget Management
Track spending and create virtual keys with PostgreSQL.

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


## Model Configire in OpenClaw

```
  "models": {
    "mode": "merge",
    "providers": {
      "litellm": {
        "baseUrl": "http://<your proxy ip>:4000",
        "api": "openai-completions",
        "models": [
          {
            "id": "gemini-3.1-flash-lite-preview",
            "name": "gemini-3.1-flash-lite-preview",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 128000,
            "maxTokens": 8192
          },
          {
            "id": "gpt-5.2",
            "name": "gpt-5.2",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 128000,
            "maxTokens": 8192
          },
          {
            "id": "gemini-3.1-pro-preview",
            "name": "gemini-3.1-pro-preview",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 2097152,
            "maxTokens": 8192
          },
          {
            "id": "gemini-3.1-pro-preview-customtools",
            "name": "gemini-3.1-pro-preview-customtools",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 2097152,
            "maxTokens": 8192
          },
          {
            "id": "gemini-3-flash-preview",
            "name": "gemini-3-flash-preview",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 1048576,
            "maxTokens": 8192
          },
          {
            "id": "gemini-2.5-pro",
            "name": "gemini-2.5-pro",
            "reasoning": true,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 2097152,
            "maxTokens": 8192
          },
          {
            "id": "gemini-2.5-flash",
            "name": "gemini-2.5-flash",
            "reasoning": false,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 1048576,
            "maxTokens": 8192
          },
          {
            "id": "gemini-2.5-flash-lite",
            "name": "gemini-2.5-flash-lite",
            "reasoning": false,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 1048576,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
```

---

## 🧪 Testing
Run the included test script:
```bash
./test_litellm.sh
```
To test specific models, use `curl` or `openclaw models set litellm/<model-alias>`.
