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
- Check container logs with `docker logs playwright-chrome` or `docker logs playwright-integrated` if you encounter connection issues
- For SSL certificate issues in enterprise environments, see the "Enterprise Environment Setup" section
- For air-gapped or highly restricted environments, use the integrated Docker setup 

