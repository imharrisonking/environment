---
name: playwright-arm
description: Browser automation via Playwright MCP for ARM Linux with Chromium from /snap/bin/chromium. Use for website navigation, form filling, screenshots, scraping, testing web apps, and automating browser workflows. Trigger phrases include "go to [url]", "click on", "fill out the form", "take a screenshot", "scrape", "automate", "test the website", "log into", or any browser interaction request.
license: MIT
compatibility: OpenCode
metadata:
  mcp_server: playwright
  arm_linux: true
  chromium_path: /snap/bin/chromium
---

# Playwright ARM Skill

Browser automation skill configured for ARM Linux using the Playwright MCP server with custom Chromium binary.

## Prerequisites

Ensure your `~/.config/opencode/config.json` contains the MCP configuration:

```json
{
  "mcp": {
    "playwright": {
      "type": "local",
      "command": [
        "npx",
        "@playwright/mcp@latest",
        "--executable-path",
        "/snap/bin/chromium",
        "--isolated"
      ],
      "enabled": true
    }
  }
}
```

## Available Tools

This skill provides access to Playwright MCP tools:

- **playwright_browser_navigate** - Navigate to a URL
- **playwright_browser_click** - Click elements on the page
- **playwright_browser_type** - Type text into inputs
- **playwright_browser_snapshot** - Get accessibility snapshot
- **playwright_browser_take_screenshot** - Capture screenshots
- **playwright_browser_select_option** - Select dropdown options
- **playwright_browser_fill_form** - Fill multiple form fields
- **playwright_browser_wait_for** - Wait for elements or time
- **playwright_browser_evaluate** - Run JavaScript on the page
- And more...

## Typical Workflow

1. **Navigate** to the target URL using `playwright_browser_navigate`
2. **Snapshot** the page using `playwright_browser_snapshot` to discover elements
3. **Interact** with elements using `playwright_browser_click`, `playwright_browser_type`, etc.
4. **Verify** results with screenshots or `playwright_browser_evaluate`
5. **Close** the browser when done with `playwright_browser_close`

## Tips

- Use `playwright_browser_snapshot` to get an accessibility tree view of the page
- Elements in snapshots have refs that you can use with other tools
- Use `playwright_browser_take_screenshot` with `fullPage: true` for complete page captures
- Chain commands for efficient workflows (navigate → wait → interact)
- `playwright_browser_evaluate` is useful for extracting data via JavaScript
