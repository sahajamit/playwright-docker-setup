package dev.amitrawat;

import com.microsoft.playwright.*;

import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PlaywrightRemoteDemo {
    
    public static void main(String[] args) {
        try (Playwright playwright = Playwright.create()) {
            // Connect to the Playwright server running in Docker
            // Use "ws://localhost:9222" format for connecting to Playwright server
            String wsEndpoint = "ws://localhost:9222";
            
            try {
                System.out.println("Connecting to Playwright server at: " + wsEndpoint);
                
                // Connect to the browser in Docker via WebSocket
                Browser browser = playwright.chromium().connect(wsEndpoint);
                System.out.println("Successfully connected to browser: " + browser.version());
                
                // Create a new browser context
                BrowserContext context = browser.newContext();
                System.out.println("Browser context created");
                
                // Create a new page
                Page page = context.newPage();
                System.out.println("Browser page created");
                
                // Navigate to target URL
                page.navigate("https://amitrawat.dev/");
                System.out.println("Page loaded");
                
                // Take a screenshot
                String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
                String screenshotPath = "screenshot_" + timestamp + ".png";
                page.screenshot(new Page.ScreenshotOptions().setPath(Paths.get(screenshotPath)).setFullPage(true));
                System.out.println("Screenshot saved to: " + screenshotPath);
                
                // Get and print page title
                String title = page.title();
                System.out.println("Page title: " + title);
                
                // Close everything
                page.close();
                context.close();
                browser.close();
                System.out.println("Test completed successfully");
                
            } catch (PlaywrightException e) {
                System.err.println("Failed to connect or run Playwright test: " + e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }
        }
    }
} 