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
│   └── docker-compose.yml     # Docker configuration for Playwright server
├── src/
│   └── main/
│       └── java/
│           └── dev/
│               └── amitrawat/
│                   └── PlaywrightRemoteDemo.java  # Main Java application
├── pom.xml                    # Maven configuration
└── README.md                  # This file
```

## How to Run

### 1. Start the Playwright Docker Container

```bash
cd docker
docker compose up -d
# Or for podman:
# podman compose up -d
```

This will start a Docker container running a Playwright server with Chromium, exposed on port 9222.

### 2. Build and Run the Java Application

```bash
mvn clean package
java -jar target/playwright-setup-1.0-SNAPSHOT-jar-with-dependencies.jar
```

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
- Check container logs with `docker logs playwright-chrome` if you encounter connection issues 