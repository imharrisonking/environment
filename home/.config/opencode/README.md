# OpenCode Configuration

This directory contains OpenCode configuration for dotfiles repository.

## Structure

### Managed by Git (via this repo)

- `config.json` - Main OpenCode configuration
- `AGENTS.md` - Agent instructions for this directory
- `rules/` - Rule files (skill-locations, etc.)
- `command/` - Slash commands
- `skills/` - Agent skills
- `agent/` - Custom agent definitions
- `tool/` - Custom tools
- `package.json` - Dependencies

### NOT Managed by Git (user-managed)

- `plugin/` - User-managed plugin directory

## Agent Reference

This configuration includes several specialized agents:

- **Boomerang** - Orchestration agent for parallel task delegation
- **Coder** - Implementation-focused subagent
- **Build** - Default development agent
- **Plan** - Read-only analysis and planning
- **Playwright-UI** - Browser automation for ARM Linux

See `AGENTS.md` for complete agent documentation.

## Skill Reference

Custom skills included in this configuration:

- **beads** - Persistent task memory with dependency tracking
- **code-search** - Guidance on ast-grep vs ripgrep
- **python-scripts** - UV shebang templates for standalone Python scripts
- **context7** - API and library documentation search
- **grep-app** - Real-world code examples from GitHub
- **playwright-arm** - Browser automation for ARM Linux
- **websearch** - Real-time web search using Exa AI

Each skill directory contains `SKILL.md` with detailed instructions and may include supporting documentation in `references/` subdirectories.

## Custom Tools

TypeScript tools available for agents:

- **cursor-agent** - Calls external cursor-agent CLI
- **delegate** - Boomerang orchestration (task, parallel, children tools)

Tools use `@opencode-ai/plugin` and `@opencode-ai/sdk` packages.

## Slash Commands

Custom slash commands:

- `/rams` - Accessibility and visual design review

## Rules

Configuration rules:

- **skill-locations.md** - Guidelines for skill file placement

## Plugin Management

Plugins are **NOT** managed by this repository. Install manually to `~/.config/opencode/plugin/`.

**Important:** Local plugins must be explicitly registered in `config.json` `plugins` array.
Auto-discovery from `~/.config/opencode/plugin/` does NOT work for local plugins.

### Installing Plugins

```bash
cd ~/.config/opencode/plugin/

# Fix permissions if needed (git may create read-only directory)
chmod u+w ~/.config/opencode/plugin

# Clone desired plugins
git clone https://github.com/username/plugin.git plugin-name
```

### Registering Plugins

After cloning, add plugins to `config.json`:

```jsonc
{
  "plugin": [
    // ... npm plugins ...
    "./plugin/<plugin-name>"
  ]
}
```

### Building TypeScript Plugins

For TypeScript plugins, run `bun run build` in the plugin directory:

```bash
cd ~/.config/opencode/plugin/plugin-name
bun run build
```

**Note:** Do NOT run `bun install` inside plugin directories. Plugins use the global
`@opencode-ai/plugin` dependency from `~/.config/opencode/node_modules/`.

## Dependencies

Install dependencies from this directory:

```bash
cd ~/.config/opencode
bun install
```

This installs `@opencode-ai/plugin` and `@opencode-ai/sdk` packages needed by custom tools.

## Modifying Configuration

To modify configurations in this repository:

1. Edit files in `~/.config/dotfiles/config/opencode/`
2. Commit changes to git
3. Run `hey rebuild` (if using nix-darwin)
4. Changes take effect immediately

### Adding New Tools

1. Create tool file in `tool/` directory (TypeScript)
2. Update `package.json` if new dependencies are needed
3. Run `bun install` to install/update dependencies

### Adding New Skills

1. Create skill directory in `skill/` or `skills/`
2. Add `SKILL.md` with proper frontmatter
3. Optionally add `references/` subdirectory with supporting docs

### Adding New Commands

1. Create markdown file in `command/` directory
2. Add frontmatter with description
3. Follow command execution conventions

## Agent Workflows

### Boomerang Orchestration Pattern

When using Boomerang:

1. Boomerang decomposes task into subtasks
2. Uses `task` tool to spawn child sessions
3. Child sessions work in parallel using `coder`, `explore`, or `general` agents
4. Results synthesized when all children complete
5. Navigate with `ctrl+right`/`ctrl+left`

### Parallel Task Execution

Boomerang can delegate multiple tasks simultaneously:

```
parallel([
  { title: "Task 1", prompt: "...", agent: "coder" },
  { title: "Task 2", prompt: "...", agent: "explore" }
])
```

## Development

### Adding Agent Definitions

Agents are defined as markdown files with frontmatter:

```yaml
---
description: Agent description
mode: primary|subagent
temperature: 0.0-1.0
tools:
  bash: true|false
  edit: true|false
  # ... etc
---

# Agent instructions
```

### Tool Development

Tools are TypeScript files using `@opencode-ai/plugin`:

```typescript
import { tool } from "@opencode-ai/plugin"

export const myTool = tool({
  description: "Tool description",
  args: {
    param: tool.schema.string().describe("Description"),
  },
  async execute(args, ctx) {
    // Tool implementation
    // ctx contains session context (sessionID, etc.)
    return "result"
  },
})
```

Use `ctx.sessionID` to access current session information when needed.

## Troubleshooting

### Tools not appearing

1. Check `config.json` for proper configuration
2. Verify `bun install` has been run
3. Restart OpenCode application

### Skills not loading

1. Check skill directory structure (`SKILL.md` present?)
2. Verify frontmatter is valid YAML
3. Check for syntax errors in skill file

### Agents not available

1. Verify agent files exist in `agent/` directory
2. Check `AGENTS.md` for documentation
3. Restart OpenCode if new agents added

## References

- [OpenCode Documentation](https://opencode.ai/docs/)
- [OpenCode Agents](https://opencode.ai/docs/agents/)
- [OpenCode Skills](https://opencode.ai/docs/skills/)
- [OpenCode Tools](https://opencode.ai/docs/tools/)
