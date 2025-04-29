# Playwright Remote Demo

This project demonstrates using Playwright for browser automation in a containerized environment. It opens https://amitrawat.dev/ in a Chromium browser running in a Docker container and captures a screenshot.

## Prerequisites

- Java 17
- Maven 3.9
- Docker or Podman (for running containers)

## Project Structure

```
playwright-setup/
├── docker/
│   ├── docker-compose.yml             # Docker configuration for Playwright server
│   ├── integrated-dockerfile          # Self-contained Dockerfile with all dependencies
│   ├── integrated-docker-compose.yml  # Docker Compose for the integrated setup
│   ├── run-integrated.sh              # Script to run the integrated container
│   ├── docker-compose-registry.yml    # Docker Compose for the Docker Hub image
│   ├── run-from-registry.sh           # Script to run container from Docker Hub
│   ├── quick-start.sh                 # Standalone script for Docker Hub image
│   ├── enterprise-dockerfile          # Dockerfile with enterprise compatibility fixes
│   ├── enterprise-docker-compose.yml  # Docker Compose for enterprise build
│   ├── run-enterprise-build.sh        # Script to build for enterprise environments
│   ├── .npmrc                         # npm configuration for enterprise environments
│   └── enterprise-setup.sh            # Script to configure for enterprise environments
├── src/
│   └── main/
│       └── java/
│           └── dev/
│               └── amitrawat/
│                   └── PlaywrightRemoteDemo.java  # Main Java application
├── pom.xml                            # Maven configuration
└── README.md                          # This file
```

## How to Run

### Quick Start (Simplest Method)

For the quickest setup using the pre-built Docker image from Docker Hub:

```bash
cd docker
./quick-start.sh
```

This standalone script:
1. Pulls the latest `sahajamit/playwright-chromium-server` image from Docker Hub
2. Creates a local directory for screenshots
3. Runs the container with all necessary settings
4. Shows how to connect, check logs, and clean up

### Standard Setup

1. Start the Playwright Docker Container

```bash
cd docker
docker compose up -d
# Or for podman:
# podman compose up -d
```

This will start a Docker container running a Playwright server with Chromium, exposed on port 9222.

2. Build and Run the Java Application

```bash
mvn clean package
java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar
```

### Enterprise Setup (Self-contained)

For enterprise environments where external network access might be limited, we've provided a fully integrated setup that packages all dependencies inside the Docker image:

```bash
cd docker
./run-integrated.sh
```

This script:
1. Builds a Docker image with Java, Node.js, Playwright, and Chromium pre-installed
2. Starts a container using this image
3. No external network calls are needed during runtime

After the container is running, you can run the Java application as usual:

```bash
cd ..
mvn clean package
java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar
```

### Enterprise-Compatible Build (For Strict Environments)

If you're encountering "Exec format error" or other script-related issues in enterprise environments:

```bash
cd docker
./run-enterprise-build.sh
```

This script:
1. Builds a Docker image with enhanced compatibility for strict enterprise environments
2. Uses explicit `/bin/sh` with proper line endings for all scripts
3. Provides fallback mechanisms for various execution contexts
4. Fixes common issues with executable permissions and script formats

### Using Pre-built Docker Image

For the simplest setup, you can use our pre-built Docker image that's already hosted on Docker Hub:

#### Using the Provided Script

```bash
cd docker
./run-from-registry.sh
```

This script:
1. Pulls the latest `sahajamit/playwright-chromium-server` image from Docker Hub
2. Starts a container using this image
3. No need to build anything locally

#### Direct Docker Commands (No Scripts Required)

You can also run the containerized Playwright server directly with Docker commands:

```bash
# Pull the image from Docker Hub (only needed once or when updating)
docker pull sahajamit/playwright-chromium-server:latest

# Create a directory for screenshots if needed
mkdir -p screenshots

# Run the container
docker run -d \
  --name playwright-chromium \
  -p 9222:9222 \
  --shm-size=2gb \
  -v "$(pwd)/screenshots:/app/screenshots" \
  --restart unless-stopped \
  sahajamit/playwright-chromium-server:latest
```

For Podman:
```bash
podman pull sahajamit/playwright-chromium-server:latest

mkdir -p screenshots

podman run -d \
  --name playwright-chromium \
  -p 9222:9222 \
  --shm-size=2gb \
  -v "$(pwd)/screenshots:/app/screenshots:Z" \
  sahajamit/playwright-chromium-server:latest
```

#### Using in Enterprise Private Registries

For enterprise environments with private Docker registries:

1. First, push the image to your private registry:
```bash
# Pull from Docker Hub (if you have internet access on this machine)
docker pull sahajamit/playwright-chromium-server:latest

# Tag for your private registry
docker tag sahajamit/playwright-chromium-server:latest your-registry.example.com/playwright-chromium-server:latest

# Push to your private registry
docker push your-registry.example.com/playwright-chromium-server:latest
```

2. On machines with access to the private registry, pull and run:
```bash
docker pull your-registry.example.com/playwright-chromium-server:latest

docker run -d \
  --name playwright-chromium \
  -p 9222:9222 \
  --shm-size=2gb \
  -v "$(pwd)/screenshots:/app/screenshots" \
  --restart unless-stopped \
  your-registry.example.com/playwright-chromium-server:latest
```

These approaches are especially useful in:
- Continuous Integration environments
- Environments with limited or no internet access (using private registry)
- When you want a quick setup without building anything

## Enterprise Environment Setup

If you're running the standard setup in an enterprise environment with SSL certificate issues, use the provided script:

```bash
cd docker
./enterprise-setup.sh
```

This script:
1. Creates an `.npmrc` file to bypass SSL certificate validation
2. Optionally configures a custom npm registry if needed
3. Provides instructions for restarting the container

If you're still experiencing SSL issues, the Docker Compose file has been configured to:
- Set `strict-ssl=false` for npm
- Set the `NODE_TLS_REJECT_UNAUTHORIZED=0` environment variable
- Mount the `.npmrc` file into the container

## What It Does

1. The Docker container runs a Playwright server with Chromium browser accessible via WebSocket
2. The Java application connects to this remote browser using WebSocket protocol (`ws://localhost:9222`)
3. The application navigates to https://amitrawat.dev/
4. A screenshot is captured and saved in the project directory (with name format `screenshot_connect_YYYYMMDD_HHMMSS.png`)

## Important Notes

- The Java client version (1.42.0) must match the Playwright server version in the Docker container
- Browser downloads are skipped in the Java code by setting the appropriate environment variables
- The screenshot serves as verification that the browser opened correctly
- The Java code runs on the host machine while the browser runs in the container
- No browser installation is needed on the host machine

## Troubleshooting

- If you see version mismatch errors, make sure the Playwright version in `pom.xml` matches the version in `docker-compose.yml`
- Check container logs with `docker logs playwright-chromium` if you encounter connection issues
- For SSL certificate issues in enterprise environments, see the "Enterprise Environment Setup" section
- For air-gapped or highly restricted environments, use the integrated Docker setup or pre-built Docker image
- If you see "Exec format error" in enterprise environments, use the enterprise-compatible build script

### Fixing "Exec format error" on Ubuntu

If you encounter this specific error on Ubuntu when running the image from Docker Hub:

```
{"msg":"exec container process `/app/start-playwright-server.sh`: Exec format error"}
```

This is typically caused by line ending issues or script format incompatibilities. To fix:

1. Use the enterprise-compatible build instead:
   ```bash
   cd docker
   ./run-enterprise-build.sh
   ```

2. Alternatively, if you need to use the image from the registry, use the correct script path:
   ```bash
   docker run -d \
     --name playwright-chromium \
     -p 9222:9222 \
     --shm-size=2gb \
     -v "$(pwd)/screenshots:/app/screenshots" \
     --restart unless-stopped \
     --entrypoint "/bin/sh" \
     sahajamit/playwright-chromium-server:latest \
     -c "/app/start-playwright-server.sh"
   ```

If you encounter a "not found" error:
```
/bin/sh: 1: /app/start.sh: not found
```

This is because the registry image has `start-playwright-server.sh` instead of `start.sh`. The enterprise build includes `dos2unix` to fix line endings and provides additional script options for maximum compatibility across platforms.

### Special Fix for WSL Ubuntu

If you're using WSL (Windows Subsystem for Linux) with Ubuntu and encounter the "Exec format error" despite trying the above solutions, use the dedicated WSL fix script:

```bash
cd docker
./wsl-ubuntu-fix.sh
```

This script:
1. Creates a clean Linux-formatted startup script on your local system
2. Mounts this script into the container
3. Uses a direct `/bin/bash` execution to avoid any line ending or format issues
4. Does not require running `dos2unix` or other utilities

This approach is more reliable on WSL systems where Windows and Linux line endings can cause compatibility issues.

