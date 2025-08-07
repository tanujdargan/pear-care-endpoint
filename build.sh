#!/bin/bash

# Exit on error
set -e

# Configuration
IMAGE_NAME="pear-care-endpoint"
IMAGE_TAG="latest"

echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Build the Docker image
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

echo "Build complete!"
echo ""
echo "To run locally for testing:"
echo "docker run --gpus all -e HF_TOKEN='your-token-here' -p 8000:8000 ${IMAGE_NAME}:${IMAGE_TAG}"
echo ""
echo "To push to Docker Hub:"
echo "docker tag ${IMAGE_NAME}:${IMAGE_TAG} your-dockerhub-username/${IMAGE_NAME}:${IMAGE_TAG}"
echo "docker push your-dockerhub-username/${IMAGE_NAME}:${IMAGE_TAG}"
