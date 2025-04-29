# UI Automation with Playwright in Docker Container

## Project Overview
Create a simple automation script that opens https://amitrawat.dev/ in a Chromium browser using Playwright.

## Technical Requirements

### Host Machine Environment
- **Language**: Java 17
- **Build Tool**: Maven 3.9
- **Limitations**: No admin privileges to install Chromium or its dependencies

### Container Environment
- **Browser**: Chromium
- **Automation Tool**: Playwright
- **Container Technology**: Docker with podman-compatible compose file

## Architecture
1. **Java code** runs on the host machine
2. **Playwright & Chromium** run in a Docker container
3. **Communication**: Java code connects to containerized browser via remote CDP URL

## Rationale
Since the host machine doesn't allow installation of Chromium and its dependencies, the solution employs a containerized approach where the browser automation components run in Docker while the test code executes on the host.