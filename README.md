# pear-care-endpoint

A RunPod serverless endpoint for serving the MedGemma-27B model with 4-bit quantization.

## Prerequisites

- Docker installed on your system
- RunPod account with API access
- Hugging Face token with access to the MedGemma-27B model

## Environment Variables

The following environment variables are required:

- `HF_TOKEN`: Your Hugging Face access token
- `MODEL_PATH` (optional): Path to pre-downloaded model (defaults to `google/medgemma-27b`)

## Building the Docker Image

```bash
docker build -t pear-care-endpoint:latest .
```

## Running Locally for Testing

```bash
docker run --gpus all \
  -e HF_TOKEN="your-hugging-face-token" \
  -p 8000:8000 \
  pear-care-endpoint:latest
```

## Deploying to RunPod

1. Push your Docker image to a container registry (Docker Hub, ECR, etc.)
2. Create a new serverless endpoint on RunPod
3. Configure the endpoint with your Docker image URL
4. Set the required environment variables in RunPod

## API Usage

Send a POST request with the following JSON payload:

```json
{
  "input": {
    "prompt": "Your medical question here",
    "max_new_tokens": 256,
    "temperature": 0.7
  }
}
```

Response format:

```json
{
  "response": "Generated medical response"
}
```

## Pre-downloading the Model

To speed up cold starts, you can pre-download the model to a network volume using the script in `download_model_to_network_storage.md`.