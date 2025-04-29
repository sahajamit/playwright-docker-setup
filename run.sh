#!/bin/bash

# Make script exit on any error
set -e

echo "Starting Playwright Remote Demo"
echo "-------------------------------"

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

# Start the container
echo "Starting Playwright container..."
cd docker
if [ "$CONTAINER_CMD" = "docker" ]; then
    docker-compose up -d
else
    podman-compose up -d
fi
cd ..

echo "Waiting for Playwright server to start..."
sleep 5

# Build the Java project
echo "Building Java project..."
mvn clean package

# Run the Java application
echo "Running Java application..."
java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar

echo "Done!" 