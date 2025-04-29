FROM mcr.microsoft.com/playwright:v1.42.0-jammy

# Create directory for screenshots
RUN mkdir -p /screenshots

# Set working directory
WORKDIR /app

# Expose the port for the Playwright server
EXPOSE 9222

# Start Playwright server when container starts
CMD ["npx", "playwright", "run-server", "--port=9222"] 