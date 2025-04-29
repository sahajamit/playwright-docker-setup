FROM mcr.microsoft.com/playwright:v1.42.0-jammy

# Set working directory
WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create simple script to start Playwright in debugging mode for remote connection
RUN echo '#!/bin/bash' > /app/start-playwright.sh && \
    echo 'cd /app' >> /app/start-playwright.sh && \
    echo 'echo "Starting Playwright server with Chromium..."' >> /app/start-playwright.sh && \
    echo 'npx playwright install chromium' >> /app/start-playwright.sh && \
    echo 'export DEBUG="pw:browser*"' >> /app/start-playwright.sh && \
    echo 'npx playwright run-server --port=9222 --host=0.0.0.0' >> /app/start-playwright.sh && \
    chmod +x /app/start-playwright.sh

# Create directory for screenshots
RUN mkdir -p /screenshots
VOLUME /screenshots

# Start Chrome directly in debugging mode as an alternative approach
RUN echo '#!/bin/bash' > /app/start-chrome-debug.sh && \
    echo 'cd /app' >> /app/start-chrome-debug.sh && \
    echo 'echo "Starting Chrome in debug mode..."' >> /app/start-chrome-debug.sh && \
    echo 'google-chrome --no-sandbox --disable-setuid-sandbox --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222' >> /app/start-chrome-debug.sh && \
    chmod +x /app/start-chrome-debug.sh

# Expose Playwright server port
EXPOSE 9222

CMD ["/app/start-playwright.sh"] 