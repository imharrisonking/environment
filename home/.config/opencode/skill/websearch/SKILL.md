---
name: websearch
description: Real-time web search using Exa AI. Use when you need up-to-date information beyond knowledge cutoff, current events, recent data, or need to search the web for specific information. Supports configurable result counts and content retrieval from relevant websites.
license: MIT
compatibility: OpenCode
metadata:
  mcp_server: websearch
  mcp_url: https://mcp.exa.ai/mcp?tools=web_search_exa
---

# WebSearch Skill

Real-time web search powered by Exa AI, providing up-to-date information and live content crawling capabilities.

## Prerequisites

Ensure your `~/.config/opencode/config.json` contains the MCP configuration:

```json
{
  "mcp": {
    "websearch": {
      "type": "remote",
      "url": "https://mcp.exa.ai/mcp?tools=web_search_exa",
      "enabled": true
    }
  }
}
```

## Available Tools

This skill provides access to web search capabilities:

- **websearch** - Search the web using Exa AI with configurable options
  - `query`: Web search query (required)
  - `numResults`: Number of search results to return (default: 8)
  - `livecrawl`: Live crawl mode - 'fallback' (backup if cached unavailable) or 'preferred' (prioritize live crawling)
  - `type`: Search type - 'auto' (balanced), 'fast' (quick results), 'deep' (comprehensive search)
  - `contextMaxCharacters`: Maximum context length for optimization (default: 10000)

- **websearch_web_search_exa** - Alternative interface for web searches with similar parameters

## When to Use

Use this skill when you need:

1. **Current events** - News, recent developments, time-sensitive information
2. **Live data** - Real-time information that changes frequently
3. **External research** - Looking up documentation, tutorials, examples from the web
4. **Trending topics** - Understanding what's popular or current
5. **Verification** - Checking if information is still accurate or up-to-date
6. **Alternative perspectives** - Finding diverse sources and viewpoints

## Search Strategies

### Basic Search
```
query: "React hooks examples"
```

### Comprehensive Search
```
query: "Node.js performance optimization techniques"
type: "deep"
numResults: 10
```

### Quick Search
```
query: "Python list comprehension syntax"
type: "fast"
numResults: 3
```

### Live Crawling (Fresh Content)
```
query: "today's stock market trends"
livecrawl: "preferred"
```

## Tips

- Use `type: "deep"` for thorough research when you need comprehensive results
- Use `type: "fast"` for quick lookups when you just need a few relevant links
- Set `livecrawl: "preferred"` when you need the most current content
- Adjust `numResults` based on how many sources you want to explore (3-15 is typical)
- The `contextMaxCharacters` parameter helps balance between depth and token usage
- Results are ranked by relevance, so the first few results are typically most useful

## Common Use Cases

- Finding the latest library documentation
- Researching current best practices and patterns
- Looking up error messages and solutions
- Finding examples and tutorials
- Checking for recent updates or breaking changes
