package dev.amitrawat;

import com.microsoft.playwright.*;

import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

public class PlaywrightRemoteDemo {
    
    public static void main(String[] args) {
        // Set environment variable to skip browser downloads
        System.setProperty("playwright.skip.browser.download", "true");
        
        // Create Playwright options with environment variables to skip browser download
        Map<String, String> env = new HashMap<>();
        env.put("PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD", "true");
        Playwright.CreateOptions options = new Playwright.CreateOptions()
                .setEnv(env);
        
        try (Playwright playwright = Playwright.create(options)) {
            // Connect to the Playwright server running in Docker
            String wsEndpoint = "ws://localhost:9222";
            
            try {
                System.out.println("Connecting to Playwright server at: " + wsEndpoint);
                
                // Connect to the browser in Docker via WebSocket
                Browser browser = playwright.chromium().connect(wsEndpoint);
                System.out.println("Successfully connected to browser: " + browser.version());
                
                // Create a new browser context
                BrowserContext context = browser.newContext();
                System.out.println("Browser context created.");
                
                // Create a new page
                Page page = context.newPage();
                System.out.println("Browser page created");
                
                // Navigate to target URL
                page.navigate("https://amitrawat.dev/");
                System.out.println("Navigated to https://amitrawat.dev/");
                
                // Get and print page title
                String title = page.title();
                System.out.println("Page title: " + title);
                
                // Take a screenshot
                String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
                String screenshotPath = "screenshot_connect_" + timestamp + ".png";
                page.screenshot(new Page.ScreenshotOptions().setPath(Paths.get(screenshotPath)).setFullPage(true));
                System.out.println("Screenshot saved to: " + screenshotPath);
                
                // Close everything
                page.close();
                System.out.println("Page closed.");
                context.close();
                System.out.println("Context closed.");
                browser.close();
                System.out.println("Disconnected Playwright client from the browser.");
                
                System.out.println("Test execution finished.");
                
            } catch (PlaywrightException e) {
                System.err.println("Failed to connect or run Playwright test: " + e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }
        }
    }
}
