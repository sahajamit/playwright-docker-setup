#!/bin/bash

echo "Stopping Playwright container..."

# Check if Docker or Podman is installed
if command -v docker &> /dev/null; then
    CONTAINER_CMD="docker"
elif command -v podman &> /dev/null; then
    CONTAINER_CMD="podman"
else
    echo "Error: Neither Docker nor Podman is installed."
    exit 1
fi

echo "Using container runtime: $CONTAINER_CMD"

# Stop the container
cd docker
if [ "$CONTAINER_CMD" = "docker" ]; then
    docker-compose down
else
    podman-compose down
fi

echo "Playwright container stopped." 