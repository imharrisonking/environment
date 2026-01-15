# Ralph Prompt Engineering

This document explains Ralph's prompt structure, key language patterns, and how to tune prompts for better autonomy.

## Prompt Structure

Ralph's prompts follow a consistent structure that provides context, instructions, and guardrails.

### Phase 0: Orientation

The first section of each prompt sets the stage and orients the agent.

**Example from PROMPT_build.md:**
```markdown
# Ralph Build Agent

You are an autonomous development agent. Your job is to execute tasks from a project plan, implementing software features and writing code.

## Context
- You are in a development environment with full read/write access
- There is an IMPLEMENTATION_PLAN.md file with tasks to complete
- You have access to specialized subagents for exploration and implementation
- You should work autonomously, making decisions as needed
```

**Purpose:**
- Establishes the agent's role
- Sets expectations for autonomy
- Provides context about the environment
- Clarifies what resources are available

**Key elements:**
- **Role**: Who the agent is (autonomous development agent)
- **Job**: What the agent should do (execute tasks from plan)
- **Context**: Environment and resources available
- **Expectations**: Level of autonomy (make decisions as needed)

### Main Instructions

The middle section provides detailed instructions for task execution.

**Example:**
```markdown
## Task Execution Workflow

For each task, follow these steps:

1. **Orient**: Read the task from IMPLEMENTATION_PLAN.md
   - Study the codebase to understand current state
   - Identify relevant files and patterns
   - Understand dependencies and constraints

2. **Select**: Choose the best approach
   - Review options from the plan
   - Evaluate tradeoffs
   - Select appropriate approach

3. **Investigate**: If needed, gather information
   - Use the explore subagent to search code patterns
   - Research library APIs and documentation
   - Understand best practices

4. **Implement**: Write the code
   - Use the coder subagent for complex changes
   - Follow existing patterns and conventions
   - Handle errors appropriately

5. **Validate**: Verify acceptance criteria are met
   - Run tests if available
   - Check functionality manually
   - Ensure edge cases are handled

6. **Update**: Update the plan
   - Mark task as complete
   - Add notes on implementation
   - Record any deviations

7. **Commit**: Checkpoint progress
   - Create descriptive git commit
   - Stage all changes
   - Create commit with clear message
```

**Purpose:**
- Provides clear, step-by-step instructions
- Defines the task lifecycle
- Establishes consistency across all tasks
- Guides the agent through each phase

**Key elements:**
- **Ordered steps**: Clear sequence of actions
- **Subagent usage**: When to use explore, coder, general
- **Validation**: How to verify completion
- **Checkpointing**: Git commits for safety

### Guardrails

The final section (with the "999..." pattern) provides safety rules and constraints.

**Example:**
```markdown
## 999... Important Constraints and Guardrails

**CRITICAL RULES (never break these):**

1. **Always read before write**: Study existing code before modifying it
2. **Never assume**: Investigate rather than guessing about code structure
3. **Always commit**: Create a git commit after each task
4. **Update plan**: Mark tasks complete and add notes to IMPLEMENTATION_PLAN.md
5. **Handle errors gracefully**: Don't leave broken code behind
6. **Use subagents**: Leverage explore and coder for specialized work

**Never:**
- Skip validation steps
- Commit without testing (when tests exist)
- Make assumptions about code patterns
- Delete files without understanding purpose
- Modify git history (use normal commits only)
- Checkout main branch when on work branch

**Always:**
- Study the codebase before implementing
- Follow existing patterns and conventions
- Write clear, maintainable code
- Add helpful comments for non-obvious code
- Use appropriate error handling
- Create descriptive commit messages
```

**Purpose:**
- Prevents common failure modes
- Establishes boundaries and constraints
- Reinforces critical behaviors
- Creates "rules of the road" for autonomous execution

**Key elements:**
- **Critical rules**: Must-follow constraints
- **Never**: Explicit prohibitions
- **Always**: Required behaviors
- **999...**: Marker that this is the most important section

## Key Language Patterns

Certain language patterns help guide Ralph's behavior effectively.

### "Study, Don't Assume"

**Pattern:**
```markdown
Always study the codebase before implementing:
- Read existing components to understand patterns
- Check if similar functionality already exists
- Look at how other files handle similar problems
- Don't assume you know the structure without reading
```

**Why this works:**
- Encourages investigation over guessing
- Reduces errors from incorrect assumptions
- Promotes learning from existing code
- Ensures consistency with established patterns

**Example:**
```markdown
Bad: "Create a UserProfile component using class components"

Good: "Study the existing components to understand the project's pattern.
If they use class components, use class components. If they use functional
components with hooks, use functional components with hooks. Follow the
existing pattern."
```

### "Ultrathink"

**Pattern:**
```markdown
Before implementing, use "ultrathink" mode:
- Consider multiple approaches
- Evaluate tradeoffs (complexity, performance, maintainability)
- Identify potential edge cases
- Choose the best approach based on context
- Document your reasoning in the plan
```

**Why this works:**
- Encourages thorough consideration
- Promotes better decision-making
- Reduces rush-to-code errors
- Creates a record of reasoning

**Example:**
```markdown
Task: Implement user authentication

Ultrathink approach:
- Option 1: Build custom JWT auth → Fast to implement, but reinventing wheel
- Option 2: Use Passport.js → Proven library, good security, but requires learning
- Option 3: Use Auth0 → Best security, but external dependency

Decision: Option 2 (Passport.js)
Reasoning: Good balance of security and control. Well-documented. Community support.
```

### "Capture the Why"

**Pattern:**
```markdown
When making decisions, always capture the "why" in IMPLEMENTATION_PLAN.md:
- What approach was chosen
- Why it was chosen (tradeoffs considered)
- What alternatives were rejected and why
- What constraints influenced the decision
```

**Why this works:**
- Creates a decision trail
- Helps future understanding
- Enables informed revisions
- Documents tradeoffs

**Example:**
```markdown
### Task 7: Implement error handling
**Approach chosen**: Custom error middleware
**Why**: Needed specific error format for API responses. Default Express error
  handling doesn't provide enough control over error response structure.
**Alternatives considered**:
- Default Express errors: Too generic, wrong format
- Third-party error library: Overkill for this use case
**Constraints**:
- Must match API contract (specific error JSON format)
- Must support error codes for frontend handling
```

### "Use Subagents Explicitly"

**Pattern:**
```markdown
Leverage subagents for specialized work:
- Use "explore" agent for code searches and pattern finding
- Use "coder" agent for focused implementation
- Use "general" agent for complex, multi-step tasks

Always specify which subagent to use and why.
```

**Why this works:**
- Encourages delegation
- Uses appropriate tools for each task
- Faster execution (explore agent is quick)
- Better separation of concerns

**Example:**
```markdown
Task: Find and implement user authentication patterns

First, use explore agent to research:
```
task(
  title="Find authentication patterns",
  prompt="Search the codebase for existing authentication patterns.
  Look for JWT usage, session management, auth middleware.",
  agent="explore"
)
```

Then, use coder agent to implement:
```
task(
  title="Implement JWT authentication",
  prompt="Create auth middleware using patterns found in the codebase.
  Follow the established conventions.",
  agent="coder"
)
```

## When to Modify Prompts

Modify prompts when you observe specific failures or undesirable behaviors.

### Scenario 1: Ralph Goes in Circles

**Symptom:**
- Same task attempted repeatedly
- Task never marked complete
- No progress in plan

**Fix:** Add more specific guardrails

```markdown
## Added to prompt:

**If a task fails 3 times:**
- Stop and reassess the approach
- Check if acceptance criteria are unclear
- Add a note to the plan explaining the issue
- Move to the next task if possible
- Don't keep trying the same approach
```

### Scenario 2: Wrong Implementation Approach

**Symptom:**
- Ralph uses wrong library or pattern
- Code doesn't match requirements
- Inconsistent with project conventions

**Fix:** Add explicit pattern guidance

```markdown
## Added to prompt:

**Technology constraints:**
- Use React 18 with functional components and hooks
- Use TypeScript with strict mode
- Use Tailwind CSS for styling
- Do NOT use class components
- Do NOT use inline styles
- Do NOT use deprecated libraries
```

### Scenario 3: Not Using Subagents

**Symptom:**
- Agent tries to do everything itself
- Slow execution
- Inefficient code exploration

**Fix:** Reinforce subagent usage

```markdown
## Added to prompt:

**MANDATORY: Use subagents**
- Always use "explore" agent for code searches (it's faster)
- Always use "coder" agent for implementation (it's more focused)
- Only use "general" agent for complex, ambiguous tasks

**Example workflow:**
1. Use explore to find patterns
2. Use coder to implement based on patterns
3. Only use general if steps 1-2 fail
```

### Scenario 4: Poor Commit Messages

**Symptom:**
- Vague commit messages ("update", "fix")
- Missing context
- Hard to understand history

**Fix:** Add commit message guidelines

```markdown
## Added to prompt:

**Commit message format:**
```
type(scope): description

Examples:
feat(auth): implement JWT authentication
fix(components): fix UserProfile validation bug
refactor(utils): extract date formatting function
test(user): add unit tests for UserService
docs(readme): update installation instructions
```

**Rules:**
- Use conventional commit format
- Scope should be relevant (auth, components, utils, etc.)
- Description should be specific
- If task spans multiple changes, summarize scope
```

### Scenario 5: Not Updating Plan

**Symptom:**
- Tasks marked complete but no notes
- Missing observations about implementation
- Plan doesn't reflect actual progress

**Fix:** Emphasize plan updates

```markdown
## Added to prompt:

**After each task, update IMPLEMENTATION_PLAN.md:**

Add a notes section:
```markdown
**Notes:**
- What was implemented
- How it was implemented (approach used)
- Any deviations from the plan
- Issues encountered and how resolved
- Dependencies discovered
- Performance considerations
```

Example update:
```markdown
### Task 3: Implement UserProfile component
**Status:** ✅ Complete
**Notes:**
- Created UserProfile.tsx with ProfileHeader and ProfileFields subcomponents
- Used useState for edit mode toggle
- Added email validation with regex pattern
- Avatar upload uses FileReader for preview
- File size limit enforced (5MB max)
**Next:** Task 4 - Create UserProfileForm component
```
```

## Tuning Like a Guitar

Prompt tuning is like tuning a guitar: start simple, observe, make adjustments, and iterate.

### Step 1: Start Simple

Begin with the core prompt structure:

```markdown
# Role
You are an autonomous development agent.

# Task
Execute tasks from IMPLEMENTATION_PLAN.md

# Steps
1. Orient: Study codebase
2. Implement: Write code
3. Validate: Check it works
4. Update: Mark task complete
5. Commit: Save progress

# Constraints
Don't break existing functionality
Follow project patterns
```

### Step 2: Run and Observe

Execute Ralph with the simple prompt:

```bash
/path/to/ralph/loop.sh 10
```

**What to watch for:**
- Does Ralph complete tasks?
- Are there errors?
- Does it go in circles?
- Is the quality acceptable?
- Are commits being created?
- Is the plan being updated?

### Step 3: Identify Issues

Common issues you might observe:

```
Issue: Ralph uses wrong library
Issue: Ralph doesn't use subagents
Issue: Ralph skips validation
Issue: Ralph creates vague commits
Issue: Ralph doesn't update plan
```

### Step 4: Add Guardrails

For each issue, add specific guardrails to the prompt:

```markdown
# For: Using wrong library
**Library constraints:**
- Use React 18, NOT Vue
- Use Tailwind, NOT Bootstrap
- Use Express.js for API, NOT Koa

# For: Not using subagents
**Subagent usage:**
- Use "explore" for code searches
- Use "coder" for implementation
- Use "general" for complex tasks

# For: Skipping validation
**Validation rules:**
- Always run tests before marking task complete
- Check acceptance criteria
- Verify functionality works

# For: Vague commits
**Commit format:**
type(scope): description
Example: feat(auth): implement JWT auth
```

### Step 5: Iterate

Rerun and observe again:

```bash
/path/to/ralph/loop.sh 10
```

**Did issues improve?**
- If yes → Keep the guardrail
- If no → Adjust the guardrail or remove it
- If new issues emerged → Add new guardrails

### Step 6: Stabilize

After several iterations, you'll reach a stable state:

```bash
# Ralph works reliably
# Tasks complete correctly
# Quality is acceptable
# Few errors or issues
```

At this point, the prompt is "tuned" for your project.

## Signs Beyond Prompts

Sometimes issues aren't solved by prompts alone. Use these additional "signs."

### AGENTS.md Signs

**Issue:** Subagents not doing the right thing

**Fix:** Adjust AGENTS.md to clarify subagent roles

```markdown
# In AGENTS.md

## Explore Agent
Purpose: Fast codebase exploration and pattern finding
Capabilities: Read, grep, glob only (no writes)
Not for: Implementation, refactoring

## Coder Agent
Purpose: Focused implementation of specific features
Capabilities: Read, write, edit, bash
Not for: Exploration, complex debugging

## General Agent
Purpose: Full capability for complex tasks
Capabilities: All tools
Use for: Debugging, refactoring, ambiguous tasks
```

### Utility Scripts Signs

**Issue:** Repetitive manual tasks

**Fix:** Create utility scripts to automate

```bash
# In ralf/utilities/

# test-runner.sh - Runs tests and reports results
# deploy.sh - Deployment automation
# audit.sh - Security and quality checks
```

Then reference in prompt:

```markdown
**Use utilities:**
- Run tests: ./ralph/utilities/test-runner.sh
- Check security: ./ralph/utilities/audit.sh
```

### Code Pattern Signs

**Issue:** Ralph doesn't follow project patterns

**Fix:** Create a patterns reference file

```markdown
# In PATTERNS.md

## Component Pattern
```typescript
export const ComponentName = ({ prop }: Props) => {
  // hooks
  const [state, setState] = useState(initialValue)

  // handlers
  const handleClick = () => {}

  // render
  return <div>...</div>
}
```

## API Pattern
```typescript
export const apiFunction = async (params: Params): Promise<Result> => {
  try {
    const response = await fetch(url, options)
    const data = await response.json()
    return data
  } catch (error) {
    throw new ApiError(error)
  }
}
```
```

Reference in prompt:

```markdown
**Follow patterns in PATTERNS.md:**
- Component pattern: Functional components with hooks
- API pattern: Try-catch with custom error types
- Always check PATTERNS.md before implementing
```

### Backpressure Test Signs

**Issue:** Quality issues slip through

**Fix:** Add backpressure tests (see [enhancements.md](enhancements.md))

```markdown
# In IMPLEMENTATION_PLAN.md

### Task 5: Implement user registration
**Backpressure tests:**
- test_registration_validation.js
- test_password_complexity.js
- test_duplicate_email.js

**Validation:**
- Must pass all backpressure tests before marking complete
```

## Summary

Prompt engineering for Ralph:

1. **Structure**: Orientation → Instructions → Guardrails (with "999..." marker)
2. **Patterns**: Study don't assume, ultrathink, capture the why, use subagents
3. **Tuning**: Start simple, observe, add guardrails, iterate
4. **Beyond prompts**: AGENTS.md, utilities, code patterns, backpressure tests

**Key principles:**
- Be specific about what to do and what not to do
- Use examples to illustrate desired behavior
- Add guardrails reactively (when you observe issues)
- Trust iteration: tuning is an ongoing process
- Remember that prompts aren't everything - use signs and utilities too

The best prompts emerge from observation and iteration, not from perfect initial design.
