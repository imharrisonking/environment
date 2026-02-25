---
name: context7
description: Search and retrieve up-to-date documentation and code examples for any programming library or framework. Provides the highest quality and freshest context for APIs, libraries, and SDKs. Use when you need comprehensive library documentation, best practices, or real-world implementation examples.
license: MIT
compatibility: OpenCode
metadata:
  mcp_server: context7
  mcp_url: https://mcp.context7.com/mcp
---

# Context7 Skill

Intelligent documentation search and retrieval for programming libraries, frameworks, and APIs. Provides curated, high-quality code examples and official documentation.

## Prerequisites

Ensure your `~/.config/opencode/config.json` contains the MCP configuration:

```json
{
  "mcp": {
    "context7": {
      "type": "remote",
      "url": "https://mcp.context7.com/mcp",
      "enabled": true
    }
  }
}
```

## Available Tools

This skill provides access to Context7 documentation search:

- **context7_query-docs** - Retrieve and query up-to-date documentation and code examples
  - `libraryId`: Exact Context7-compatible library ID (e.g., '/mongodb/docs', '/vercel/next.js')
  - `query`: Your specific question or task (be specific and include relevant details)

- **context7_resolve-library-id** - Resolve package/product name to Context7-compatible library ID
  - `query`: Your original question or task (used for relevance ranking)
  - `libraryName`: Library name to search for

## Workflow

### Step 1: Resolve Library ID (Required First)
Before querying docs, you MUST call `context7_resolve-library-id` to get the exact library ID, UNLESS the user explicitly provides a library ID in the format `/org/project` or `/org/project/version`.

Example:
```
libraryName: "React"
query: "How to use useEffect with cleanup functions"
```

### Step 2: Query Documentation
Once you have the library ID, use `context7_query-docs` to search:

Example:
```
libraryId: "/facebook/react"
query: "How to use useEffect with cleanup functions"
```

## When to Use

Use this skill when you need:

1. **Library documentation** - Official API references, guides, and tutorials
2. **Code examples** - Real-world implementation patterns and best practices
3. **Unfamiliar APIs** - Learning how to use new libraries or frameworks
4. **Best practices** - Understanding recommended patterns and conventions
5. **Troubleshooting** - Finding solutions to library-specific issues
6. **Version-specific features** - Documentation for specific library versions

## Good Queries vs Bad Queries

### Good Queries (Specific and detailed)
- ✅ "How to set up authentication with JWT in Express.js"
- ✅ "React useEffect cleanup function examples"
- ✅ "Python pandas dataframe filtering multiple conditions"
- ✅ "Next.js partial prerendering configuration"

### Bad Queries (Too vague)
- ❌ "auth"
- ❌ "hooks"
- ❌ "data manipulation"
- ❌ "configuration"

## Tips

- **Be specific**: Include relevant context, what you're trying to achieve, and any constraints
- **Use examples**: Mention specific functions or components you're working with
- **Adjust token count**: The default 5000 tokens is good for most queries. Use 1000-3000 for focused questions, 10000-20000 for comprehensive documentation
- **Library ID format**: Valid formats include `/org/project` or `/org/project/version` (e.g., `/vercel/next.js/v14.3.0`)
- **Relevance matters**: The resolver uses your query to find the most relevant match, so describe your goal clearly
- **Search limit**: Don't call the resolver more than 3 times per question. Use the best result you have after that

## Common Use Cases

- "How do I implement OAuth2 with NextAuth.js in Next.js App Router?"
- "What's the best way to handle state in React using Zustand?"
- "How to configure TypeScript strict mode in a create-react-app project?"
- "Examples of using Prisma with PostgreSQL transactions"
- "How to deploy a FastAPI application with Docker?"
