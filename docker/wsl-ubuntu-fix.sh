#!/bin/bash

# Exit on error
set -e

echo "Fixing Playwright container for WSL Ubuntu environments"
echo "----------------------------------------------------"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker not found. Please install Docker first."
    exit 1
fi

# Create screenshots directory
mkdir -p screenshots
echo "Created screenshots directory"

# Stop and remove container if it already exists
echo "Cleaning up any existing containers..."
docker stop playwright-chromium &> /dev/null || true
docker rm playwright-chromium &> /dev/null || true

# Option 1: Pull the image and run with a simple echo command to Bash
echo "Starting Playwright container with WSL compatibility fix..."
echo "#!/bin/bash
Xvfb :99 -screen 0 1280x1024x24 &
echo 'Starting Playwright server on port 9222...'
cd /app
export DISPLAY=:99
npx playwright@1.42.0 run-server --port=9222 --host=0.0.0.0" > ./wsl-start.sh

# Make the script executable
chmod +x ./wsl-start.sh

# Run with the custom script mount
docker run -d \
  --name playwright-chromium \
  -p 9222:9222 \
  --shm-size=2gb \
  -v "$(pwd)/screenshots:/app/screenshots" \
  -v "$(pwd)/wsl-start.sh:/app/wsl-start.sh" \
  --restart unless-stopped \
  sahajamit/playwright-chromium-server:latest \
  /bin/bash /app/wsl-start.sh

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