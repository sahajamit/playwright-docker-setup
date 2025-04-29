#!/bin/bash

# Exit on error
set -e

echo "Fixing Playwright container for WSL Ubuntu environments"
echo "----------------------------------------------------"


# Create screenshots directory
mkdir -p screenshots
echo "Created screenshots directory"

# Stop and remove container if it already exists
echo "Cleaning up any existing containers..."
docker stop playwright-chromium &> /dev/null || true
docker rm playwright-chromium &> /dev/null || true

# Pull the image with platform specification
echo "Pulling the Playwright image with platform specification..."
docker pull --platform linux/amd64 sahajamit/playwright-chromium-server:latest

# Create a temporary container to fix line endings
echo "Creating temporary container to fix line endings..."
TEMP_CONTAINER=$(docker create --platform linux/amd64 sahajamit/playwright-chromium-server:latest)

# Copy the script from the container
echo "Extracting script from container..."
docker cp $TEMP_CONTAINER:/app/start-playwright-server.sh ./start-playwright-server.sh

# Fix line endings using sed
echo "Fixing line endings with sed..."
sed -i 's/\r$//' ./start-playwright-server.sh
chmod +x ./start-playwright-server.sh

# Create a simple start script
echo "Creating a simple shell script for the container..."
cat > ./wsl-container-start.sh << 'EOF'
#!/bin/bash
Xvfb :99 -screen 0 1280x1024x24 &
export DISPLAY=:99
cd /app
echo "Starting Playwright server on port 9222..."
npx playwright@1.42.0 run-server --port=9222 --host=0.0.0.0
EOF
chmod +x ./wsl-container-start.sh

# Skip Docker build and just run the container with the fixed script
echo "Running container with script mounted directly (skipping build)..."
docker run --platform linux/amd64 -d \
  --name playwright-chromium \
  -p 9222:9222 \
  --shm-size=2gb \
  -v "$(pwd)/screenshots:/app/screenshots" \
  -v "$(pwd)/wsl-container-start.sh:/app/wsl-container-start.sh" \
  --restart unless-stopped \
  --entrypoint "/bin/bash" \
  sahajamit/playwright-chromium-server:latest \
  "/app/wsl-container-start.sh"

# Remove temporary container
docker rm $TEMP_CONTAINER

echo "Waiting for container to initialize..."
sleep 5

echo "Container logs:"
docker logs playwright-chromium

echo ""
echo "WSL-compatible Playwright Chromium container is now running!"
echo "-------------------------------------------------------"
echo "WebSocket URL: ws://localhost:9222"
echo ""
echo "To run the Java client:"
echo "cd .. && mvn clean package && java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar"
echo ""
echo "To stop the container:"
echo "docker stop playwright-chromium"
echo ""
echo "To clean up temporary files:"
echo "rm -f ./start-playwright-server.sh ./wsl-container-start.sh" 