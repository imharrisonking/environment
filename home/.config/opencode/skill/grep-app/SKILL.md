---
name: grep-app
description: Find real-world code examples from over a million public GitHub repositories. Search for actual code patterns (not keywords) to see how developers use libraries, frameworks, and APIs in production. Perfect for finding implementation examples, best practices, and real-world usage patterns.
license: MIT
compatibility: OpenCode
metadata:
  mcp_server: grep_app
  mcp_url: https://mcp.grep.app
---

# Grep App Skill

Search over a million public GitHub repositories to find real-world code examples and implementation patterns. See how developers actually use libraries and frameworks in production code.

## Prerequisites

Ensure your `~/.config/opencode/config.json` contains the MCP configuration:

```json
{
  "mcp": {
    "grep_app": {
      "type": "remote",
      "url": "https://mcp.grep.app",
      "enabled": true
    }
  }
}
```

## Available Tools

This skill provides access to code search across GitHub:

- **grep_app_searchGitHub** - Find real-world code examples from public repositories
  - `query`: Literal code pattern to search for (actual code that would appear in files)
  - `language`: Filter by programming language (array: ['TypeScript', 'Python', etc.)
  - `repo`: Filter by repository (e.g., 'facebook/react', 'vercel/ai')
  - `path`: Filter by file path (e.g., 'src/components/Button.tsx', 'README.md')
  - `matchCase`: Case-sensitive search (default: false)
  - `matchWholeWords`: Match whole words only (default: false)
  - `useRegexp`: Interpret query as regular expression (default: false)

## When to Use

Use this skill when you need:

1. **Implementation examples** - See how others use specific APIs or libraries
2. **Real-world patterns** - Find production code patterns, not just tutorials
3. **Syntax questions** - Unsure about correct syntax, parameters, or configuration
4. **Best practices** - See what experienced developers do in production
5. **Library usage** - How to integrate unfamiliar packages or frameworks
6. **Code examples** - Find complete, working examples of specific functionality

## Important: Search for Code, Not Keywords

### Good Queries (Actual code patterns)
- ✅ `'useState('` - Find React useState hook usage
- ✅ `'import React from'` - Find React imports
- ✅ `'async function'` - Find async function definitions
- ✅ `'(?s)try {.*await'` - Multi-line pattern (use regexp)
- ✅ `'getServerSession'` - Specific function usage

### Bad Queries (Keywords or questions)
- ❌ 'react tutorial'
- ❌ 'best practices'
- ❌ 'how to use'
- ❌ 'authentication implementation'

## Search Strategies

### Basic Code Search
```
query: "useState("
language: ["TypeScript", "TSX"]
```

### Specific Repository
```
query: "ErrorBoundary"
repo: "facebook/react"
language: ["TSX"]
```

### File Path Filtering
```
query: "route.ts"
path: "/route.ts"
language: ["TypeScript"]
```

### Regular Expressions
```
query: "(?s)useState\\(.*loading"
useRegexp: true
language: ["TypeScript", "TSX"]
```

### Multiple Languages
```
query: "CORS("
language: ["Python", "JavaScript", "TypeScript"]
matchCase: true
```

## Tips

- **Be literal**: Search for actual code you'd see in files, not descriptions
- **Use language filters**: Specify languages to get relevant results
- **Filter by repo**: Find patterns in specific repositories you trust
- **Use regex for patterns**: `useRegexp: true` with `(?s)` prefix for multi-line patterns
- **Case sensitivity**: Use `matchCase: true` when case matters (e.g., for class names)
- **Whole words**: Use `matchWholeWords: true` to avoid partial matches
- **Path filtering**: Narrow results to specific file types or directories

## Common Use Cases

- "How do developers handle authentication in Next.js apps?"
  - Query: `'getServerSession'`, Language: `['TypeScript', 'TSX']`

- "What are common React error boundary patterns?"
  - Query: `'ErrorBoundary'`, Language: `['TSX']`

- "Show me real useEffect cleanup examples"
  - Query: `'(?s)useEffect\\(\\(\\) => {.*removeEventListener'`, `useRegexp: true`

- "How do developers handle CORS in Flask applications?"
  - Query: `'CORS('`, Language: `['Python']`, `matchCase: true`

- "Find MongoDB connection patterns in Express apps"
  - Query: `'mongoose.connect'`, Language: `['JavaScript', 'TypeScript']`

## Workflow Tips

1. Start with a specific code pattern (e.g., function name or import)
2. Filter by language to narrow results
3. Use repo filters if you want examples from trusted sources
4. Adjust with regex for more complex patterns
5. Combine filters for precise searches (language + repo + path)
