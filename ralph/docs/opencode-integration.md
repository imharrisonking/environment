# OpenCode Integration

This document explains how Ralph integrates with the OpenCode CLI, including differences from the original implementation, agent configuration, and model usage.

## CLI Differences from Original Ralph

The original Ralph implementation assumed standard Claude Code or Anthropic's API. This OpenCode integration has key differences:

### No stdin Interaction

**Original:**
```bash
# Original Ralph piped prompt to Claude via stdin
cat PROMPT.md | claude --stdin
```

**OpenCode:**
```bash
# OpenCode uses API calls, no stdin
opencode agent ralph-build
```

**Implications:**
- No need to pipe prompts
- Prompt templates are loaded from files by the agent
- Cleaner interaction model
- Better error handling

### No --dangerously-skip-permissions Flag

**Original:**
```bash
# Original required this flag to allow autonomous execution
claude --dangerously-skip-permissions < PROMPT.md
```

**OpenCode:**
```bash
# Permissions are configured in agent config
# No flag needed
opencode agent ralph-build
```

**Implications:**
- Security is configured via `agent/config/permissions.yml`
- Permissions are explicit and auditable
- No global "dangerous" flags
- Safer by default

### Enhanced Agent System

**Original:**
- Single LLM agent handling everything
- Manual subagent spawning via additional API calls

**OpenCode:**
- Rich agent ecosystem (Build, Plan, Explore, Coder, Boomerang)
- Built-in `task` tool for subagent delegation
- Specialized agents for different work types

**Implications:**
- Faster exploration (explore agent)
- Focused implementation (coder agent)
- Parallel task execution (Boomerang orchestration)
- Better separation of concerns

### Work Branch Support

**Original:**
- No explicit work branch mode

**OpenCode:**
- `--work` flag for plan-work mode
- Separate prompts for plan vs plan-work scenarios
- Safer development on feature branches

## Ralph Agent Configuration

Ralph uses OpenCode's agent system with specific configurations for autonomy.

### Agent Definition

Located at `ralph/agent/AGENTS.md`:

```markdown
# Ralph Build Agent

## Permissions
- read: All files in project
- write: All files in project
- execute: bash commands, git operations

## Tools
- bash: Execute shell commands
- edit: Edit files
- write: Create files
- read: Read files
- task: Delegate to subagents
- glob: Find files
- grep: Search code

## Model
- github-copilot/claude-sonnet-4.5
```

### Permissions Configuration

Located at `ralph/agent/config/permissions.yml`:

```yaml
permissions:
  # File access
  file_read: all
  file_write: all
  file_create: all
  file_delete: all

  # Command execution
  bash_execute: all
  git_operations: all

  # Network
  network_access: all

  # Subagent delegation
  task_spawn: all

# Restrictions (what NOT to allow)
restrictions:
  - No modifications outside project directory
  - No deletion of git history
  - No force push to main branch
```

**Why these permissions?**
- Ralph needs full read/write access to the project
- Git operations are needed for checkpointing
- Network access for documentation and package installation
- Subagent delegation for specialized work

**Best practices:**
- Run in isolated VM or container
- Use work branches to protect main
- Review commits before pushing to remote
- Restrict to dedicated projects only

## Task Tool for Subagent Delegation

Ralph uses OpenCode's `task` tool to spawn subagents for specialized work.

### Subagent Types

| Type | Purpose | Model | Speed | Capabilities |
|------|---------|-------|-------|--------------|
| `explore` | Fast codebase exploration | opencode/glm-4.7-free | Fast | Read, grep, glob only |
| `coder` | Focused implementation | opencode/glm-4.7-free | Medium | Read, write, edit, bash |
| `general` | Full capability tasks | github-copilot/claude-sonnet-4.5 | Slow | All tools enabled |

### When to Use Each

**Explore agent:**
- Searching for code patterns
- Finding examples in the codebase
- Quick file exploration
- No writes needed

```javascript
task(
  title="Find useState patterns",
  prompt="Search for useState usage with arrays...",
  agent="explore"
)
```

**Coder agent:**
- Implementing specific features
- Writing focused code changes
- Following existing patterns
- Well-defined scope

```javascript
task(
  title="Implement UserProfile component",
  prompt="Create UserProfile.tsx with these props...",
  agent="coder"
)
```

**General agent:**
- Complex debugging
- Multi-step refactoring
- Tasks requiring full capability
- Unknown complexity

```javascript
task(
  title="Debug failing authentication flow",
  prompt="Fix the auth issue where tokens aren't persisting...",
  agent="general"
)
```

### Parallel Task Execution

Ralph can delegate multiple tasks in parallel using Boomerang's `parallel` tool:

```javascript
parallel([
  { title: "Task 1", prompt: "...", agent="coder" },
  { title: "Task 2", prompt: "...", agent="explore" },
  { title: "Task 3", prompt: "...", agent="coder" }
])
```

**When to use parallel:**
- Independent tasks that don't depend on each other
- Exploration + implementation that can happen simultaneously
- Testing + development that can run in parallel

**Benefits:**
- Faster overall execution
- Better utilization of LLM capabilities
- Can catch issues earlier (testing runs in parallel)

## Model Usage

Ralph uses different models for different purposes to optimize cost and quality.

### Main Agent Model

**Model:** `github-copilot/claude-sonnet-4.5`

**Why:**
- Best reasoning and planning capabilities
- Good at understanding complex requirements
- Reliable task selection and prioritization
- Strong at orchestration and subagent delegation

**Usage:**
- Planning phase (generating IMPLEMENTATION_PLAN.md)
- Outer loop task selection
- Orchestration and decision-making
- Complex validation and quality checks

### Subagent Models

**Model:** `opencode/glm-4.7-free`

**Why:**
- Fast and cost-effective
- Good for focused tasks
- Suitable for exploration and implementation
- Free tier reduces costs

**Usage:**
- Explore agent: Fast code searches
- Coder agent: Focused implementation
- Simple, well-defined tasks

### Model Selection Strategy

```javascript
// Planning - use best model
if (phase === "plan") {
  model = "github-copilot/claude-sonnet-4.5";
}

// Task execution - use main model for orchestration
if (phase === "build") {
  orchestrator_model = "github-copilot/claude-sonnet-4.5";

  // Subagents use cheaper model
  subagent_model = "opencode/glm-4.7-free";
}

// Complex debugging - use best model
if (task.complexity === "high") {
  model = "github-copilot/claude-sonnet-4.5";
}
```

### Cost Optimization

- **Main tasks:** 60% of cost (orchestration, planning)
- **Subagent exploration:** 20% of cost
- **Subagent implementation:** 20% of cost

**Tips to reduce costs:**
- Use explore agent for code searches (cheaper than having main agent search)
- Limit exploration iterations (set max depth)
- Use coder agent for straightforward implementation
- Only use general agent for complex tasks

## When to Use Boomerang vs Ralph

Ralph and Boomerang are both orchestration agents, but serve different purposes.

### Ralph

**Use for:**
- Autonomous development projects
- Long-running build loops
- Projects with many sequential tasks
- When you want "set it and forget it"

**Characteristics:**
- Sequential task execution
- Single task at a time
- Stateful (tracks progress in plan)
- Optimized for autonomy

**Example:**
```bash
# Build entire feature autonomously
/path/to/ralph/loop.sh 50
```

### Boomerang

**Use for:**
- Complex tasks with 3+ independent components
- Tasks requiring different specialized approaches
- When you need parallel execution
- When you want to orchestrate specific subtasks

**Characteristics:**
- Parallel task execution
- Decomposes into 3-5 independent tasks
- Stateless (no persistent plan)
- Optimized for coordination

**Example:**
```bash
# Orchestrating a complex refactoring
boomerang "Refactor auth system with:
- Update authentication service
- Migrate database schema
- Update UI components
- Add tests"
```

### Comparison

| Aspect | Ralph | Boomerang |
|--------|-------|-----------|
| Execution | Sequential | Parallel |
| State | Stateful (plan) | Stateless |
| Scope | Long-running projects | One-off complex tasks |
| Autonomy | High | Medium |
| Granularity | Many small tasks | 3-5 large tasks |
| Best for | Autonomous builds | Coordination-heavy tasks |

### Decision Guide

**Use Ralph when:**
- Task requires 10+ sequential steps
- You want minimal supervision
- Task is implementation-heavy
- You have a clear plan or requirements

**Use Boomerang when:**
- Task has independent components
- You need different specialized approaches
- Task requires parallel work
- One-off coordination rather than continuous development

**Example scenarios:**

```bash
# Ralph - building a complete feature
ralph loop.sh 30

# Boomerang - complex refactoring with independent parts
boomerang "Refactor the payment system"
```

## OpenCode CLI Tools

Ralph leverages OpenCode's tool ecosystem:

| Tool | Purpose | Ralph Usage |
|------|---------|-------------|
| `bash` | Execute shell commands | Git operations, tests, build |
| `read` | Read files | Orienting, code study |
| `write` | Create files | Implementing new files |
| `edit` | Edit files | Modifying existing code |
| `glob` | Find files | Project navigation |
| `grep` | Search code | Code exploration |
| `task` | Delegate to subagents | Explore, coder, general agents |

### Tool Permissions

Ralph's agent configuration enables all tools needed for autonomous development:

```yaml
tools:
  - bash:    # Git, tests, npm, etc.
  - read:    # Study codebase
  - write:   # Create new files
  - edit:    # Modify existing files
  - glob:    # Find files by pattern
  - grep:    # Search code content
  - task:    # Subagent delegation
```

### Custom Tools

Ralph can be extended with custom tools in `agent/tools/`:

```bash
ralph/agent/tools/
├── test-runner.sh    # Custom test execution
├── deploy.sh         # Deployment automation
└── audit.sh          # Code quality checks
```

These tools can be called via bash by Ralph for project-specific automation.

## Summary

OpenCode integration gives Ralph:

1. **Simpler interaction:** No stdin, direct API calls
2. **Safer permissions:** Explicit configuration, no dangerous flags
3. **Rich agent ecosystem:** Explore, coder, general subagents
4. **Work branch support:** Safer development on feature branches
5. **Optimal model usage:** Main agent for orchestration, cheap models for subagents
6. **Flexible orchestration:** Ralph for autonomy, Boomerang for parallelism

The combination of Ralph's prompt engineering with OpenCode's agent system creates a powerful autonomous development platform.
