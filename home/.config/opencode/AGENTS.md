# OpenCode Agents Reference

This directory contains custom agent definitions for OpenCode.

## Available Agents

### Coder (`coder.md`)

**Description**: Implementation-focused subagent for coding tasks delegated by an orchestrator agent.

**When to Use**: Invoked automatically by orchestration agent for specific coding tasks. Also can be used directly for focused implementation work.

**Mode**: Subagent (typically invoked by Ralph)
**Temperature**: 0.2 (very focused, minimal creativity)
**Tools**: bash, edit, write, read, glob, grep

**Key Characteristic**: Stays focused on assigned task, doesn't expand scope unless necessary. Provides clear summaries of changes, decisions, and notes for orchestrator.

---

### Build (`build.md`)

**Description**: Default development agent with all tools enabled. Full development work capability.

**When to Use**:
- General development tasks
- Default agent for most coding work
- When no specialized agent is more appropriate

**Mode**: Primary
**Tools**: write, edit, bash, webfetch enabled

---

### Plan (`plan.md`)

**Description**: Restricted planning/analysis agent; no writes by default. Read-only analysis capabilities.

**When to Use**:
- Analyzing codebases without making changes
- Planning before implementation
- Research and documentation tasks
- Reviewing code structure

**Mode**: Primary
**Permission**: edit/ask, write/ask (doesn't make changes by default)
**Tools**: Comprehensive bash permissions for file reading, searching, checking

---

### Dev-Browser (`dev-browser.md`)

**Description**: Browser automation via Playwright MCP for ARM Linux with Chromium. For website navigation, form filling, screenshots, scraping, testing web apps, and automating browser workflows.

**When to Use**:
- Frontend/UI checks, interactive website inspections
- Localhost port inspection, browser console logs
- Any mention of "playwright", "frontend", "ui", "browser"
- Website navigation, form filling, taking screenshots
- Scraping, automating browser workflows

**Tools**: Playwright MCP browser tools

---

## Agent Selection Guidelines

1. **Simple task** → Use **Build** agent directly
2. **Complex parallelizable task** → Use **Boomerang** to orchestrate
3. **Need research only** → Use **Plan** agent
4. **Different AI perspective** → Use **Cursor** agent
5. **Browser interaction** → Use **Dev-Browser** agent


## Session Navigation

Child sessions created by Boomerang are navigable:
- `ctrl+right` → Navigate to child session
- `ctrl+left` → Navigate back to parent session
