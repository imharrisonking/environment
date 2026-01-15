# Getting Started with Ralph

This guide walks you through your first autonomous development project with Ralph, step by step.

## Phase 0: Prerequisites

Before using Ralph, ensure you have:

1. **OpenCode CLI installed and configured**
   ```bash
   opencode --version
   opencode agents list  # Verify agents are available
   ```

2. **Git initialized and configured**
   ```bash
   git init
   git config user.name "Your Name"
   git config user.email "your.email@example.com"
   git remote add origin https://github.com/your-repo.git
   ```

3. **Ralph scripts available**
   ```bash
   ls /path/to/ralph/loop.sh
   ```

4. **A dedicated project directory**
   - Ralph is designed for autonomous development in isolated environments
   - Use a clean project or a dedicated feature branch

## Phase 1: Define Requirements

Ralph needs clear requirements to create an effective plan. Use the JTBD (Jobs To Be Done) format.

### Example: Building a User Profile App

```
As a user, I need to:
1. View my profile information (name, email, bio, avatar)
2. Edit my profile fields
3. Upload a new avatar image
4. Save changes to a backend API
5. See validation errors for invalid inputs
```

**Requirements should:**
- Be specific about what the system should do
- Include acceptance criteria (what "done" looks like)
- Avoid implementation details (let Ralph figure out the how)
- Include edge cases and error scenarios

**Save your requirements:**
```bash
cat > requirements.txt << 'EOF'
As a user, I need a web application that:
1. Displays user profile information (name, email, bio, avatar)
2. Allows editing all profile fields
3. Supports avatar image upload
4. Saves changes to a REST API endpoint
5. Validates inputs and shows errors
6. Provides loading states during save operations
EOF
```

## Phase 2: Generate the Plan

Once requirements are defined, have Ralph create a detailed implementation plan.

```bash
# Navigate to your project
cd /path/to/your/project

# Run Ralph in plan mode
/path/to/ralph/loop.sh plan
```

**What happens:**
1. Ralph reads `requirements.txt` (or prompts you to provide requirements)
2. Analyzes the codebase (if existing)
3. Generates `IMPLEMENTATION_PLAN.md` with:
   - Project structure
   - Component breakdown
   - Detailed tasks (step-by-step)
   - Acceptance criteria per task
   - Dependencies between tasks

**Example output:**
```
Reading requirements from requirements.txt...
Analyzing codebase...
Generating implementation plan...

✓ IMPLEMENTATION_PLAN.md created with 12 tasks
Next: Run 'loop.sh 20' to start building
```

**Review the plan:**
```bash
cat IMPLEMENTATION_PLAN.md
```

**What to look for:**
- Are all requirements addressed?
- Is the task breakdown reasonable?
- Are acceptance criteria clear?
- Is the order logical (dependencies first)?

**Adjust if needed:**
- Edit `IMPLEMENTATION_PLAN.md` directly
- Or rerun `loop.sh plan` with refined requirements

## Phase 3: Build from the Plan

With a solid plan in place, let Ralph execute tasks autonomously.

```bash
# Start the build loop (20 iterations)
/path/to/ralph/loop.sh 20
```

**What happens in each iteration:**
1. Ralph reads `IMPLEMENTATION_PLAN.md` to find the next uncompleted task
2. Orients itself (studies the codebase, understands context)
3. Investigates (if needed, explores code patterns, libraries)
4. Implements (writes code, updates configs, creates files)
5. Validates (runs tests, checks if acceptance criteria are met)
6. Updates (marks task as complete in the plan)
7. Commits (creates a git commit for the work)
8. Repeats until all tasks are complete or iterations run out

**Watch the output:**
```
Iteration 1/20
→ Next task: Set up project structure
→ Orienting: Reading package.json, src/...
→ Implementing: Creating src/components/, src/lib/...
→ Validating: Checking structure...
→ Updated plan: Task 1 complete
→ Committing: "feat: set up project structure"
✓ Iteration complete

Iteration 2/20
→ Next task: Create UserProfile component
→ Orienting: Reading existing components...
...
```

**Expected behavior:**
- Each iteration completes one or more tasks
- Commits are created automatically
- The plan updates to track progress
- Ralph may investigate before implementing (calling explore agent)
- Errors are handled automatically (retries, plan adjustments)

## Phase 4: Iterate and Refine

After the initial loop completes, assess progress and iterate as needed.

**Check progress:**
```bash
# View updated plan
cat IMPLEMENTATION_PLAN.md

# Check git history
git log --oneline

# Run tests (if applicable)
npm test
```

**Common scenarios:**

### Scenario 1: All tasks complete, tests pass
```bash
# You're done!
git push origin main
```

### Scenario 2: Some tasks incomplete
```bash
# Run more iterations
/path/to/ralph/loop.sh 10
```

### Scenario 3: Tasks complete, but tests fail
```bash
# Add failing tests as new tasks to the plan
# Example: Add to IMPLEMENTATION_PLAN.md under "Remaining Tasks"

### Task 13: Fix failing user profile validation tests
**Acceptance Criteria:**
- All tests in UserProfile.test.ts pass
- Validation errors display correctly for edge cases
- Form submission handles invalid data gracefully
```

Then:
```bash
/path/to/ralph/loop.sh 5
```

### Scenario 4: Wrong implementation approach
```bash
# Reset to last good commit
git log --oneline
git reset --hard <commit-hash>

# Update the plan with corrected approach
# Edit IMPLEMENTATION_PLAN.md

# Resume building
/path/to/ralph/loop.sh 10
```

## Example Commands

### Full first-time workflow
```bash
# 1. Create new project
mkdir my-awesome-app && cd my-awesome-app
git init

# 2. Define requirements
cat > requirements.txt << 'EOF'
As a user, I need a todo app that:
1. Creates, reads, updates, and deletes todos
2. Stores data in localStorage
3. Provides a clean UI with filtering
4. Marks todos as complete/incomplete
EOF

# 3. Generate plan
~/ralph/loop.sh plan

# 4. Build
~/ralph/loop.sh 20

# 5. Review and iterate
git log --oneline
cat IMPLEMENTATION_PLAN.md
npm test
```

### Using work branches (recommended)
```bash
# Create a feature branch
git checkout -b feature/user-profiles

# Plan on the work branch
~/ralph/loop.sh plan --work

# Build on the work branch
~/ralph/loop.sh 20 --work

# Review and merge when done
git checkout main
git merge feature/user-profiles
```

## Common First-Time Mistakes

### Mistake 1: Vague requirements
**Problem:** "Build a website" is too broad for Ralph to plan effectively.

**Solution:** Be specific about features and acceptance criteria:
```
Good: "Build a todo app with CRUD operations stored in localStorage"
Bad: "Build a website"
```

### Mistake 2: Not reviewing the plan
**Problem:** Ralph creates a plan, but you immediately start building without review.

**Solution:** Always review `IMPLEMENTATION_PLAN.md` before the build loop. Adjust if needed.

### Mistake 3: Too few iterations
**Problem:** Running `loop.sh 5` for a 20-task project.

**Solution:** Estimate: 1-2 iterations per task. Start with 20-30 for most projects.

### Mistake 4: No tests in the plan
**Problem:** Plan includes implementation tasks but no testing tasks.

**Solution:** Manually add testing tasks after generation, or ensure requirements include acceptance criteria that imply tests.

### Mistake 5: Ignoring errors
**Problem:** Build loop exits with errors, but you proceed anyway.

**Solution:** Check the output for errors. Fix the issue (or reset to a good commit) before continuing.

### Mistake 6: Not using version control
**Problem:** No git repository, so you can't reset when things go wrong.

**Solution:** Always use git with Ralph. It's your safety net.

### Mistake 7: Running in production directories
**Problem:** Running Ralph in a directory with critical code.

**Solution:** Always use a dedicated project, feature branch, or isolated VM environment.

## Next Steps

- Read [workflow.md](workflow.md) to understand how the loop mechanics work
- Review [security.md](security.md) for safe usage practices
- Check [enhancements.md](enhancements.md) for advanced features like work branches and backpressure
- See [prompt-engineering.md](prompt-engineering.md) for tuning Ralph to your needs

Happy autonomous building!
