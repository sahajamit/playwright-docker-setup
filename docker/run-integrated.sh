#!/bin/bash

# Make script exit on any error
set -e

echo "Building and starting integrated Playwright container"
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
$CONTAINER_CMD compose -f integrated-docker-compose.yml down || true

# Build and start the container
echo "Building and starting the integrated container..."
$CONTAINER_CMD compose -f integrated-docker-compose.yml up --build -d

echo "Waiting for Playwright server to start..."
sleep 5

# Check container logs
echo "Container logs:"
$CONTAINER_CMD logs playwright-integrated

echo ""
echo "Container is now running. To use it with your Java application, run:"
echo "cd .. && mvn clean package && java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar"
echo ""
echo "To stop the container, run:"
echo "$CONTAINER_CMD compose -f integrated-docker-compose.yml down" 