#!/bin/bash

# Make script exit on any error
set -e

echo "Starting Playwright container from Docker Hub registry"
echo "------------------------------------------------------"

# Check if Docker or Podman is installed
if command -v docker &> /dev/null; then
    CONTAINER_CMD="docker"
elif command -v podman &> /dev/null; then
    CONTAINER_CMD="podman"
else
    echo "Error: Neither Docker nor Podman is installed. Please install one of them."
    exit 1
fi

echo "Using container runtime: $CONTAINER_CMD"

# Create screenshots directory if it doesn't exist
mkdir -p screenshots

# Stop any existing container
echo "Stopping any existing containers..."
$CONTAINER_CMD compose -f docker-compose-registry.yml down || true

# Pull the latest image and start the container
echo "Pulling latest image and starting the container..."
$CONTAINER_CMD compose -f docker-compose-registry.yml pull
$CONTAINER_CMD compose -f docker-compose-registry.yml up -d

echo "Waiting for Playwright server to start..."
sleep 5

# Check container logs
echo "Container logs:"
$CONTAINER_CMD logs playwright-chromium

echo ""
echo "Container is now running. To use it with your Java application, run:"
echo "cd .. && mvn clean package && java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar"
echo ""
echo "To stop the container, run:"
echo "$CONTAINER_CMD compose -f docker-compose-registry.yml down" 