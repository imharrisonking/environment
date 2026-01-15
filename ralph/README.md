# Ralph Wiggum - Autonomous Development System

Ralph is a technique for autonomous software development using AI agents. It breaks down complex development projects into a loop of planning and building tasks, executed iteratively until the project is complete.

## What is Ralph Wiggum?

Ralph Wiggum is a prompt engineering technique that enables LLMs to autonomously plan and build software through iterative task execution. The system:

1. **Plans**: Creates a detailed implementation plan from requirements
2. **Builds**: Executes tasks from the plan, updating progress iteratively
3. **Iterates**: Observes, refines, and repeats until completion

Inspired by Ralph Wiggum's simple, straightforward approach, the technique provides clear guardrails and structured workflows that enable autonomous development without constant human supervision.

## When to Use Ralph

Ralph is ideal for:
- **Autonomous development projects**: Building complete features or systems with minimal human intervention
- **Multi-file refactoring**: Large-scale code changes across many files
- **Complex integrations**: Projects requiring multiple components to work together
- **Research-heavy tasks**: Projects that need exploration before implementation
- **Long-running builds**: Projects that benefit from an autonomous build loop

## When NOT to Use Ralph

Ralph is overkill for:
- **Simple fixes**: Quick bug fixes or small changes (use Build agent directly)
- **Quick experiments**: Proof-of-concept code that doesn't need robust planning
- **One-off scripts**: Simple utility scripts or automation
- **Tasks needing tight control**: When you need to direct every step precisely
- **Time-sensitive projects**: When you need immediate results without iteration

## OpenCode Integration

This implementation adapts Ralph for the OpenCode CLI with key differences:

- **No stdin interaction**: Uses OpenCode's API instead of terminal stdin
- **Simplified permissions**: No `--dangerously-skip-permissions` flag (uses configured agent permissions)
- **Enhanced agents**: Supports Boomerang orchestration and specialized subagents (explore, coder, general)
- **Work branch support**: Plan-work mode for safer development on feature branches
- **VM isolation**: Assumes VM-based development environment for security

See [opencode-integration.md](docs/opencode-integration.md) for details.

## Quick Start

### Step 1: Setup

```bash
cd /path/to/your/project
# Ensure OpenCode is installed and configured
# Ensure git is initialized and credentials are set up
```

### Step 2: Plan

```bash
# Define your requirements in JTBD format
echo "I need a web app that displays user profiles and allows editing" > requirements.txt

# Generate the implementation plan
/path/to/ralph/loop.sh plan
```

This creates `IMPLEMENTATION_PLAN.md` with detailed tasks.

### Step 3: Build

```bash
# Execute tasks autonomously (20 iterations, or adjust as needed)
/path/to/ralph/loop.sh 20
```

Watch as Ralph executes tasks, updates the plan, and iterates until complete.

## File Structure

```
ralph/
├── agent/                  # OpenCode agent configurations
│   ├── AGENTS.md          # Subagent definitions
│   └── config/            # Agent permissions and settings
├── docs/                   # Documentation (this directory)
│   ├── getting-started.md
│   ├── workflow.md
│   ├── opencode-integration.md
│   ├── security.md
│   ├── troubleshooting.md
│   ├── enhancements.md
│   └── prompt-engineering.md
├── templates/              # Project template files
│   ├── AGENTS.md.example
│   ├── IMPLEMENTATION_PLAN.md
│   └── .gitignore
├── loop.sh                 # Main orchestration script
├── PROMPT_build.md        # Task execution prompt
├── PROMPT_plan.md         # Planning prompt
└── PROMPT_plan_work.md    # Planning prompt (work branch mode)
```

**Project files created by Ralph:**
- `IMPLEMENTATION_PLAN.md`: Shared state tracking progress and next tasks
- `AGENTS.md`: Project-specific agent definitions (from templates)

## Security Note

Ralph requires extensive system access to function autonomously. This implementation assumes:

- **VM isolation**: Development environment is already isolated (no Docker containerization)
- **Dedicated projects**: Used for isolated, sandboxed development work
- **Work branches**: Plan-work mode for safer development on feature branches
- **Minimum viable access**: Only grants permissions needed for the task

See [security.md](docs/security.md) for comprehensive security guidance.

## Documentation

- **[Getting Started](docs/getting-started.md)**: Step-by-step tutorial for first-time users
- **[Workflow](docs/workflow.md)**: How the loop mechanics and task lifecycle work
- **[OpenCode Integration](docs/opencode-integration.md)**: CLI differences and agent configuration
- **[Security](docs/security.md)**: Security model and best practices
- **[Troubleshooting](docs/troubleshooting.md)**: Common issues and solutions
- **[Enhancements](docs/enhancements.md)**: Advanced features like work branches and backpressure
- **[Prompt Engineering](docs/prompt-engineering.md)**: Tuning prompts and guardrails

## Contributing

Ralph is a prompt engineering technique, not code. The core contributions are:
- Refining prompt patterns for better autonomy
- Adding guardrails to prevent failure modes
- Developing enhancements like work branches and backpressure
- Improving documentation and examples

Share your learnings, prompt iterations, and successful patterns with the community.
