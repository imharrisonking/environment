# Ralph Workflow

This document explains how the Ralph system works: the three phases, the loop mechanics, and the task lifecycle.

## The Three Phases

Ralph operates in three distinct phases:

### Phase 1: Requirements → Plan

**Goal:** Create a detailed, executable implementation plan.

**Inputs:**
- Requirements (JTBD format)
- Existing codebase (if any)
- Templates and patterns

**Process:**
1. Parse requirements into functional topics
2. Generate specifications for each topic
3. Break specifications into detailed tasks
4. Define acceptance criteria for each task
5. Order tasks by dependencies

**Output:** `IMPLEMENTATION_PLAN.md` containing:
- Project structure overview
- Task list with acceptance criteria
- Dependencies and ordering
- Technology choices and patterns

**Key principles:**
- Tasks should be atomic and complete independently
- Acceptance criteria must be verifiable
- Dependencies must be explicit
- Plan should be actionable without ambiguity

### Phase 2: Plan → Build (Outer Loop)

**Goal:** Execute tasks from the plan autonomously.

**Process (outer loop):**
```
for iteration in range(N):
    next_task = find_next_uncompleted_task(plan)
    if no_next_task:
        break  # All tasks complete

    execute_task(next_task)
    update_plan()
    commit_changes()
```

**Characteristics:**
- Iterative: Executes one task per loop iteration
- Stateful: Updates plan with progress and observations
- Autonomous: Decides which task to do next based on plan state
- Resilient: Handles errors and adjusts plan if needed

### Phase 3: Task Execution (Inner Loop)

**Goal:** Complete a single task from implementation to validation.

**Process (inner loop - see Task Lifecycle below):**
1. Orient: Understand context and goal
2. Select: Choose approach from plan options
3. Investigate: Explore code, libraries, patterns (if needed)
4. Implement: Write code, create files, update configs
5. Validate: Check acceptance criteria, run tests
6. Update: Mark task complete, add observations to plan
7. Commit: Create git commit

## Loop Mechanics

### Outer Bash Loop

The `loop.sh` script manages the outer iteration loop:

```bash
#!/bin/bash
N=$1  # Number of iterations

for i in $(seq 1 $N); do
    echo "Iteration $i/$N"
    opencode agent ralph-build
    # Updates IMPLEMENTATION_PLAN.md automatically
    # Creates git commit automatically
    echo "✓ Iteration complete"
done
```

**What happens each iteration:**
1. Calls OpenCode agent with the build prompt
2. Agent reads `IMPLEMENTATION_PLAN.md`
3. Agent finds and executes the next task
4. Agent updates the plan with progress
5. Agent creates a git commit
6. Loop continues or exits

**Key features:**
- Pure bash: Simple, debuggable, no complex state management
- File-based state: All state in `IMPLEMENTATION_PLAN.md`
- Incremental progress: Each iteration is checkpointed via git

### Inner Task Execution

The inner loop (within a single OpenCode agent call) follows the task lifecycle. This is where the actual development work happens.

**Single-task execution flow:**
```
1. Agent reads plan and identifies next uncompleted task
2. Agent orients: Reads code, understands current state
3. Agent investigates: Calls explore subagent if needed
4. Agent implements: Uses coder subagent for complex changes
5. Agent validates: Runs tests, checks acceptance criteria
6. Agent updates plan: Marks task complete, adds notes
7. Agent commits: Creates descriptive commit message
8. Agent returns: Control returns to outer loop
```

**Subagent delegation:**
Ralph uses the OpenCode `task` tool to spawn subagents for specialized work:

```javascript
task(
  title="Investigate React hook patterns",
  prompt="Find examples of useState with objects...",
  agent="explore"  // Fast exploration
)

task(
  title="Implement UserProfile component",
  prompt="Create React component with...",
  agent="coder"   // Focused implementation
)

task(
  title="Debug failing test",
  prompt="Fix the failing test in...",
  agent="general" // Full capability
)
```

**Why subagents?**
- Parallel execution for independent tasks
- Specialized capabilities (explore is fast, coder is focused)
- Clean separation of concerns
- Easier to debug (which subagent failed?)

## Task Lifecycle

Each task goes through seven stages. These stages are encoded in the prompt and executed by the agent.

### 1. Orient

**Goal:** Understand the current state of the project.

**Actions:**
- Read the implementation plan to understand the task
- Study existing code and structure
- Identify relevant files and patterns
- Understand dependencies and constraints

**Example internal monologue:**
> "I need to implement a UserProfile component. Let me see what's already in the codebase. I see there's a components folder with Button and Input components. The project uses React with TypeScript. I should follow the existing patterns."

### 2. Select

**Goal:** Choose the best approach from the plan's options.

**Actions:**
- Review the task's approach options (from the plan)
- Evaluate tradeoffs (complexity, performance, maintainability)
- Select the most appropriate approach
- Document the choice (in the plan)

**Example:**
> Plan says:
> - Option 1: Create a single UserProfile component with all fields
> - Option 2: Break into smaller components (ProfileHeader, ProfileFields)
>
> Selected: Option 2 - better for reuse and testing.

### 3. Investigate (Optional)

**Goal:** Gather information needed for implementation.

**Actions:**
- Call explore subagent to search code patterns
- Research library APIs and documentation
- Look at similar implementations in other projects
- Understand edge cases and error handling

**When to investigate:**
- Using a new library or framework
- Implementing a complex algorithm
- Unsure about best practices
- Task requires research before implementation

**Example:**
```bash
# Agent spawns explore subagent
task(
  title="Research React file upload patterns",
  prompt="Find examples of file upload components in React using FormData...",
  agent="explore"
)

# Explore agent returns:
# - Example 1: Uses FileReader with preview
# - Example 2: Direct upload with progress bar
# - Best practice: Validate file size before upload
```

### 4. Implement

**Goal:** Write the code to complete the task.

**Actions:**
- Create or modify files
- Follow existing patterns and conventions
- Write clear, maintainable code
- Handle errors appropriately

**Approaches:**
- **Direct implementation**: For simple tasks, agent writes code directly
- **Coder delegation**: For complex tasks, spawn coder subagent
- **Iterative refinement**: Implement, test, refine within the task

**Example:**
```bash
# Agent spawns coder subagent
task(
  title="Implement UserProfile component",
  prompt="Create src/components/UserProfile.tsx with:
  - Props for user data and onEdit callback
  - Display fields: name, email, bio, avatar
  - Edit button toggles form view
  - Follow patterns from existing Button and Input components",
  agent="coder"
)
```

### 5. Validate

**Goal:** Verify acceptance criteria are met.

**Actions:**
- Run tests (if available)
- Manual verification of behavior
- Check code quality and style
- Ensure edge cases are handled

**Validation types:**
- **Automated**: Run test suite, linting
- **Manual**: Check behavior in browser, verify outputs
- **Review**: Code quality, style, maintainability

**Example:**
```bash
npm test -- UserProfile.test.ts
npm run lint src/components/UserProfile.tsx
# Check: Component renders correctly, props work, edit toggles form
```

### 6. Update

**Goal:** Update the plan with progress and observations.

**Actions:**
- Mark task as complete
- Add notes on implementation decisions
- Record any deviations from the plan
- Update dependencies if discovered

**Example update to IMPLEMENTATION_PLAN.md:**
```markdown
### Task 3: Create UserProfile component
**Status:** ✅ Complete
**Notes:**
- Implemented with ProfileHeader and ProfileFields subcomponents
- Uses useState for edit mode toggle
- Added input validation for email format
- Avatar preview implemented using FileReader
**Next:** Task 4 - Create UserProfileForm component
```

### 7. Commit

**Goal:** Checkpoint progress in git history.

**Actions:**
- Create descriptive commit message
- Stage all relevant changes
- Create commit
- Optionally push to remote

**Commit message format:**
```
type(scope): description

Example: feat(components): create UserProfile component
```

**Why commit each task?**
- Checkpoint for rollback if needed
- Clear history of what was done
- Easy to review progress
- Prevents losing work if loop fails

## IMPLEMENTATION_PLAN.md as Shared State

The implementation plan is the single source of truth for:
- What needs to be done (tasks)
- What's been done (completed tasks)
- How things were done (notes and observations)
- What's next (next task to execute)

**Structure:**
```markdown
# Implementation Plan

## Project Overview
Brief description, tech stack, key patterns

## Task List
### Task 1: [Name]
**Status:** ✅ Complete / 🔄 In Progress / ⏳ Pending
**Acceptance Criteria:**
- Criteria 1
- Criteria 2
**Notes:**
- Observations from implementation
- Deviations from plan
**Next:** Task X

## Completed Tasks
Summary of all completed tasks with notes

## Remaining Tasks
Summary of all remaining tasks in priority order
```

**Why file-based state?**
- Simple: No database or API needed
- Transparent: Easy to read and edit manually
- Debuggable: You can inspect and modify if needed
- Portable: Works in any git repo

## When to Regenerate the Plan

The initial plan is a starting point. Regenerate if:

### 1. Requirements Change
**Scenario:** Stakeholders add new features or change existing ones.

**Action:**
```bash
# Update requirements.txt
# Rerun planning
/path/to/ralph/loop.sh plan
```

### 2. Ralph Goes in Circles
**Scenario:** Same task is attempted repeatedly but never completes.

**Cause:** Ambiguous acceptance criteria, contradictory constraints.

**Action:**
- Add specific acceptance criteria to the plan
- Clarify constraints and approach
- Rerun planning with refined requirements

### 3. Wrong Technology Choice
**Scenario:** Plan uses a library that's deprecated or doesn't fit.

**Action:**
- Manually edit IMPLEMENTATION_PLAN.md to swap technology
- Or rerun planning with updated constraints

### 4. Performance Issues Discovered
**Scenario:** Implementation is too slow or inefficient.

**Action:**
- Add optimization tasks to the plan manually
- Or rerun planning with performance requirements

### 5. Fundamental Misunderstanding
**Scenario:** Ralph built the wrong thing entirely.

**Action:**
- Reset git to before the misdirection
- Update requirements to be more specific
- Regenerate plan

**How to regenerate:**
```bash
# Save current progress
cp IMPLEMENTATION_PLAN.md IMPLEMENTATION_PLAN.md.bak

# Regenerate from current requirements
/path/to/ralph/loop.sh plan

# Merge completed tasks if needed
# (Manual step: copy completed tasks from backup to new plan)
```

## Work Branch Workflow

For safer development, Ralph supports work branch mode:

### What is plan-work mode?

**Plan mode:** Plan on main, build on main (simple, but risky)
**Work mode:** Plan on main, build on feature branch (safer)

### When to use work mode?

- New features that shouldn't break main
- Experimental approaches
- Multiple developers working on different features
- Production repositories where main must stay stable

### How it works

1. **Create work branch from main:**
   ```bash
   git checkout -b feature/awesome-feature
   ```

2. **Generate plan on main (or copy from main):**
   ```bash
   git checkout main
   ~/ralph/loop.sh plan
   cp IMPLEMENTATION_PLAN.md ~/plan-backup.md
   ```

3. **Copy plan to work branch:**
   ```bash
   git checkout feature/awesome-feature
   cp ~/plan-backup.md IMPLEMENTATION_PLAN.md
   ```

4. **Build on work branch:**
   ```bash
   ~/ralph/loop.sh 20 --work
   ```

5. **Review and merge:**
   ```bash
   git checkout main
   git merge feature/awesome-feature
   ```

### Benefits

- **Isolation:** Main branch stays clean until merge
- **Easy rollback:** Discard work branch if things go wrong
- **Parallel development:** Multiple work branches for different features
- **Code review:** Merge PR allows review before main integration

### Implementation

The `loop.sh` script supports `--work` flag to use `PROMPT_plan_work.md` instead of `PROMPT_plan.md` for planning, which includes instructions to build on the current branch rather than main.

## Summary

The Ralph workflow is:

1. **Plan:** Requirements → detailed task list with acceptance criteria
2. **Build:** Outer loop iterates through tasks
3. **Execute:** Each task goes through orient → select → investigate → implement → validate → update → commit
4. **State:** IMPLEMENTATION_PLAN.md tracks progress
5. **Iterate:** Adjust plan, add tasks, regenerate as needed

The beauty is in the simplicity: a bash loop, a plan file, and an AI agent that knows how to follow instructions.
