#!/bin/bash

# Quick start script for using the Playwright Chromium server image directly from Docker Hub
# This script doesn't depend on any other files in the repository

# Make script exit on any error
set -e

echo "Playwright Chromium Server - Quick Start"
echo "----------------------------------------"

# Check for Docker or Podman
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

# Pull the latest image
echo "Pulling latest image from Docker Hub..."
$CMD pull sahajamit/playwright-chromium-server:latest

# Run the container
echo "Starting Playwright Chromium container..."
$CMD run -d \
  --name playwright-chromium \
  -p 9222:9222 \
  --shm-size=2gb \
  -v "$(pwd)/screenshots:/app/screenshots" \
  --restart unless-stopped \
  sahajamit/playwright-chromium-server:latest

echo "Waiting for container to initialize..."
sleep 5

echo "Container logs:"
$CMD logs playwright-chromium

echo ""
echo "Playwright Chromium Server is now running!"
echo "----------------------------------------"
echo "WebSocket URL: ws://localhost:9222"
echo ""
echo "To run the Java client:"
echo "cd .. && mvn clean package && java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar"
echo ""
echo "To stop the container:"
echo "$CMD stop playwright-chromium"
echo ""
echo "To stop and remove the container:"
echo "$CMD stop playwright-chromium && $CMD rm playwright-chromium" 