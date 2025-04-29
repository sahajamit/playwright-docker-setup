package dev.amitrawat;

import com.microsoft.playwright.*;

import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PlaywrightRemoteDemo {
    
    // URL of the site to navigate to
    private static final String TARGET_URL = "https://amitrawat.dev/";
    
    // CDP endpoint URL - this connects to Playwright server in Docker
    private static final String REMOTE_BROWSER_WS_ENDPOINT = "ws://localhost:9222/playwright"; 

    public static void main(String[] args) {
        try {
            System.out.println("Starting Playwright Remote Demo...");
            
            // Connect to remote Playwright server
            BrowserType.ConnectOptions connectOptions = new BrowserType.ConnectOptions()
                    .setWsEndpoint(REMOTE_BROWSER_WS_ENDPOINT);
            
            try (Playwright playwright = Playwright.create()) {
                System.out.println("Connecting to remote browser...");
                Browser browser = playwright.chromium().connect(connectOptions);
                
                // Create a new browser context
                BrowserContext context = browser.newContext();
                
                // Create a new page
                Page page = context.newPage();
                System.out.println("Browser page created");
                
                // Navigate to the target URL
                System.out.println("Navigating to: " + TARGET_URL);
                page.navigate(TARGET_URL);
                
                // Wait for the page to load completely
                page.waitForLoadState(LoadState.NETWORKIDLE);
                System.out.println("Page loaded successfully");
                
                // Take a screenshot to verify the page opened correctly
                String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
                String screenshotPath = "screenshot_" + timestamp + ".png";
                page.screenshot(new Page.ScreenshotOptions().setPath(Paths.get(screenshotPath)).setFullPage(true));
                System.out.println("Screenshot saved to: " + screenshotPath);
                
                // Get page title as further verification
                String title = page.title();
                System.out.println("Page title: " + title);
                
                // Close browser and context
                context.close();
                browser.close();
            }
            
            System.out.println("Demo completed successfully!");
            
        } catch (Exception e) {
            System.err.println("Error running Playwright demo: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 