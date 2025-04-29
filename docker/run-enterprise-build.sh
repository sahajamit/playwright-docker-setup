#!/bin/bash

# Exit on error
set -e

echo "Building and running enterprise-compatible Playwright container"
echo "-------------------------------------------------------------"

# Check if Docker or Podman is installed
if command -v docker &> /dev/null; then
    CMD="docker"
elif command -v podman &> /dev/null; then
    CMD="podman"
else
    echo "Error: Neither Docker nor Podman found. Please install one of them first."
    exit 1
fi

echo "Using $CMD for container management"

# Create screenshots directory
mkdir -p screenshots
echo "Created screenshots directory"

# Stop and remove container if it already exists
echo "Cleaning up any existing containers..."
$CMD stop playwright-chromium &> /dev/null || true
$CMD rm playwright-chromium &> /dev/null || true

# Build and start the container
echo "Building and starting the enterprise-compatible container..."
$CMD compose -f enterprise-docker-compose.yml build --no-cache
$CMD compose -f enterprise-docker-compose.yml up -d

echo "Waiting for container to initialize..."
sleep 5

echo "Container logs:"
$CMD logs playwright-chromium

echo ""
echo "Enterprise-compatible Playwright Chromium container is now running!"
echo "--------------------------------------------------------------"
echo "WebSocket URL: ws://localhost:9222"
echo ""
echo "To run the Java client:"
echo "cd .. && mvn clean package && java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar"
echo ""
echo "To stop the container:"
echo "$CMD stop playwright-chromium"
echo ""
echo "If you want to build and push this image to your enterprise registry:"
echo "1. Build the image: $CMD build -t your-registry.example.com/playwright-chromium-server:latest -f enterprise-dockerfile ."
echo "2. Push to registry: $CMD push your-registry.example.com/playwright-chromium-server:latest" 