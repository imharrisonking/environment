# OpenCode Agents Reference

This directory contains custom agent definitions for OpenCode.

## Available Agents

### Boomerang (`boomerang.md`)

**Description**: Orchestration agent that decomposes complex tasks and delegates to specialized subagents working in parallel.

**When to Use**:
- Task has 3+ independent components that can run in parallel
- Task requires different specialized approaches (exploration, coding, review)
- Task is complex enough to benefit from divide-and-conquer
- User explicitly asks for parallel work

**Model**: Claude Sonnet 4.5
**Temperature**: 0.3 (more focused)
**Tools**: All tools enabled (bash, edit, write, read, glob, grep, task, todowrite, todoread)

**Example Usage**: "Add authentication to this Express app" → Boomerang will break this into exploration, implementation, and testing tasks, delegate to parallel subagents.

---

### Coder (`coder.md`)

**Description**: Implementation-focused subagent for coding tasks delegated by Boomerang orchestrator.

**When to Use**: Invoked automatically by Boomerang for specific coding tasks. Also can be used directly for focused implementation work.

**Mode**: Subagent (typically invoked by Boomerang)
**Temperature**: 0.2 (very focused, minimal creativity)
**Tools**: bash, edit, write, read, glob, grep

**Key Characteristic**: Stays focused on assigned task, doesn't expand scope unless necessary. Provides clear summaries of changes, decisions, and notes for orchestrator.

---

### Cursor (`cursor.md`)

**Description**: Uses external GPT-5 (Cursor) for deep research, second opinions, or bug fixing help.

**When to Use**:
- Need a different AI perspective on a problem
- Deep research requiring GPT-5
- Second opinion on an issue or bug
- External consultation beyond current conversation context

**Model**: GPT-5 (via external cursor-agent CLI)
**Tool**: `cursor-agent` bash command

**Usage**: Runs `cursor-agent -p "PROMPT"` to get fresh perspective from external GPT-5 instance.

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

### Playwright-UI (`playwright-ui.md`)

**Description**: Browser automation via Playwright MCP for ARM Linux with Chromium. For website navigation, form filling, screenshots, scraping, testing web apps, and automating browser workflows.

**When to Use**:
- Frontend/UI checks, interactive website inspections
- Localhost port inspection, browser console logs
- Any mention of "playwright"
- Website navigation, form filling, taking screenshots
- Scraping, automating browser workflows

**Tools**: Playwright MCP browser tools

---

## Agent Selection Guidelines

1. **Simple task** → Use **Build** agent directly
2. **Complex parallelizable task** → Use **Boomerang** to orchestrate
3. **Need research only** → Use **Plan** agent
4. **Different AI perspective** → Use **Cursor** agent
5. **Browser interaction** → Use **Playwright-UI** agent

## Task Tool (for Boomerang)

Boomerang uses the `task` tool to spawn child sessions with specified agents:

```typescript
task(
  title="Brief title",
  prompt="Detailed task instructions",
  agent="coder|explore|general", // Defaults to "coder"
  wait=true // Wait for result (default: true)
)
```

## Subagent Types

- **coder**: Focused implementation (Coder agent)
- **explore**: Fast codebase exploration
- **general**: Full-capability agent

## Parallel Task Execution

Use `parallel` tool for multiple independent tasks:

```typescript
parallel([
  { title: "Task 1", prompt: "...", agent: "coder" },
  { title: "Task 2", prompt: "...", agent: "explore" }
])
```

All tasks start simultaneously, results collected when complete.

## Session Navigation

Child sessions created by Boomerang are navigable:
- `ctrl+right` → Navigate to child session
- `ctrl+left` → Navigate back to parent session
