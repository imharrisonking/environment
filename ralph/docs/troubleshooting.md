# Ralph Troubleshooting Guide

This document covers common issues, their causes, and solutions when using Ralph for autonomous development.

## Ralph Going in Circles

### Symptoms

- Ralph attempts the same task repeatedly
- Task is marked as in progress but never completes
- Multiple commits for the same task
- Build loop doesn't make progress

### Causes

**1. Ambiguous acceptance criteria**

*Example:*
```
Task: "Improve performance"
```

This is too vague. Ralph can't determine when it's done.

**2. Contradictory constraints**

*Example:*
```
Task: "Make the component faster but don't change the code"
```

Impossible to satisfy both constraints.

**3. Missing dependencies**

*Example:*
```
Task: "Implement UserProfile component using UserContext"
```

But UserContext hasn't been created yet.

**4. Implementation approach fails repeatedly**

*Example:*
- Plan says: "Use library X for feature Y"
- Library X doesn't actually support feature Y
- Ralph keeps trying to make it work

### Solutions

**For ambiguous acceptance criteria:**

```bash
# Stop the loop (Ctrl+C)
# Add specific acceptance criteria to IMPLEMENTATION_PLAN.md

### Task 5: Improve performance
**Acceptance Criteria:**
- Component renders in under 50ms (measure with React DevTools Profiler)
- Page load time reduced by 20% (measure with Lighthouse)
- No regressions in functionality (all tests pass)

# Resume building
/path/to/ralph/loop.sh 5
```

**For contradictory constraints:**

```bash
# Identify and resolve contradiction
# Edit plan to remove or clarify constraints

### Task 6: Optimize database queries
**Acceptance Criteria:**
- Queries complete in under 100ms (measured with EXPLAIN ANALYZE)
- Maintain existing API contracts (no breaking changes)
- Note: Code changes allowed if necessary

# Restart loop
/path/to/ralph/loop.sh 5
```

**For missing dependencies:**

```bash
# Check which tasks are blocking
cat IMPLEMENTATION_PLAN.md | grep -A 5 "In Progress"

# Add missing dependency tasks if needed
# Or reorganize task order in the plan

# Restart loop
/path/to/ralph/loop.sh 10
```

**For failing implementation approach:**

```bash
# Reset to before the failed attempts
git log --oneline
git reset --hard <good-commit-hash>

# Edit plan to try different approach
### Task 3: Implement authentication
**Approach:**
- Use passport.js instead of writing custom auth
- Implement JWT-based session management

# Resume
/path/to/ralph/loop.sh 10
```

## Wrong Implementations

### Symptoms

- Code doesn't match requirements
- Tests pass but functionality is wrong
- Wrong technology or pattern used
- Implementation works but is overly complex

### Causes

**1. Requirements misunderstood**

*Example:*
- Requirement: "User can upload avatar image"
- Ralph built: "User can upload any file"

**2. Pattern applied incorrectly**

*Example:*
- Plan said: "Use MVC pattern"
- Ralph built: Monolithic architecture

**3. Wrong library chosen**

*Example:*
- Plan said: "Use React for UI"
- Ralph built: Vue.js implementation

### Solutions

**For misunderstood requirements:**

```bash
# Reset to last good state
git reset --hard <commit-before-wrong-implementation>

# Clarify requirements in plan
### Task 2: Implement avatar upload
**Clarification:**
- Must be image files only (jpg, png, webp)
- Max file size: 5MB
- Must show preview before upload
- Must handle upload errors gracefully

# Regenerate plan or edit manually
/path/to/ralph/loop.sh plan

# Resume
/path/to/ralph/loop.sh 10
```

**For incorrect patterns:**

```bash
# Identify the deviation
git diff <good-commit> HEAD

# Add explicit pattern guidance to plan
### Task 4: Architecture setup
**Pattern:**
- Use MVC pattern:
  - Model: src/models/
  - View: src/components/
  - Controller: src/controllers/
- All components must be React functional components

# Reset and restart
git reset --hard <good-commit>
/path/to/ralph/loop.sh 10
```

**For wrong library:**

```bash
# Remove wrong implementation
git reset --hard <before-wrong-library>

# Explicitly specify correct library
### Task 1: Set up project
**Tech Stack:**
- React 18 for UI (use create-react-app or Vite)
- TypeScript for type safety
- Tailwind CSS for styling
- NOT Vue.js, NOT Angular

# Restart
/path/to/ralph/loop.sh 5
```

## OpenCode CLI Errors

### Symptoms

- `opencode: command not found`
- `opencode agent ralph-build: agent not found`
- Permission errors
- Model not available

### Causes

**1. OpenCode not installed**

**2. Agent not configured**

**3. Permissions insufficient**

**4. Model not available or configured**

### Solutions

**For "opencode not found":**

```bash
# Install OpenCode
npm install -g @opencode/cli

# Verify installation
opencode --version

# Try again
/path/to/ralph/loop.sh plan
```

**For "agent not found":**

```bash
# Check if agent is registered
opencode agents list

# If ralph-build is missing, register it
cd /path/to/ralph
opencode agent register agent/AGENTS.md

# Verify
opencode agents list | grep ralph
```

**For permission errors:**

```bash
# Check agent permissions
cat /path/to/ralph/agent/config/permissions.yml

# If using Docker/VM, ensure proper file permissions
sudo chown -R $USER:$USER /path/to/project

# Or add necessary permissions to agent config
```

**For model not available:**

```bash
# List available models
opencode models list

# If models missing, configure in agent config
# Edit agent/config/permissions.yml

models:
  main: github-copilot/claude-sonnet-4.5
  subagents: opencode/glm-4.7-free

# Or use a different available model
```

## Git Push Failures

### Symptoms

- `git push` fails after Ralph completes
- Authentication errors
- Merge conflicts
- Protected branch rejections

### Causes

**1. Git credentials not configured**

**2. Force push to protected branch**

**3. Remote conflicts**

**4. Branch protection rules**

### Solutions

**For authentication errors:**

```bash
# Configure git credentials
git config --global credential.helper store
git push  # Will prompt for credentials

# Or use SSH keys
ssh-keygen -t ed25519 -C "your.email@example.com"
# Add to GitHub/GitLab
git remote set-url origin git@github.com:user/repo.git
```

**For protected branch rejections:**

```bash
# Use work branch instead
git checkout -b feature/ralph-work
/path/to/ralph/loop.sh 20 --work

# Create PR for code review
# Merge to main after review
```

**For remote conflicts:**

```bash
# Pull before pushing
git checkout main
git pull origin main

# If conflicts:
git checkout -b feature/ralph-work
git merge main
# Resolve conflicts
git push origin feature/ralph-work
# Create PR
```

**For branch protection:**

```bash
# Don't bypass protection - work on feature branch
git checkout -b feature/my-feature
# Ralph builds on this branch
# Create PR for review
# Merge after approval
```

## Tests Failing Repeatedly

### Symptoms

- Same tests fail every iteration
- Tests pass locally but fail in CI
- Tests fail for unknown reasons

### Causes

**1. Tests in plan but implementation not complete**

**2. Test fixtures or setup incorrect**

**3. Environment differences**

**4. Race conditions or flaky tests**

### Solutions

**For tests in plan but implementation incomplete:**

```bash
# Check if test task is before implementation task
cat IMPLEMENTATION_PLAN.md | grep -B 5 "test"

# Reorder tasks: implementation before testing
# Or add explicit dependency notes

### Task 3: Write tests
**Dependencies:**
- Must complete Task 2 (implementation) first
```

**For incorrect test setup:**

```bash
# Check test configuration
cat jest.config.js  # or pytest.ini, etc.

# Add setup instructions to plan
### Task 4: Configure test environment
**Acceptance Criteria:**
- Jest configuration includes setup files
- Test database initialized before tests
- Mocked API responses configured
```

**For environment differences:**

```bash
# Ensure consistent environment
# Use Docker for consistency
docker-compose.yml:
  services:
    app:
      environment:
        - NODE_ENV=test
    db:
      image: postgres:15
```

**For flaky tests:**

```bash
# Identify flaky tests
npm test -- --repeat=10

# Add specific test instructions to plan
### Task 5: Fix flaky tests
**Acceptance Criteria:**
- All tests pass 10 times in a row
- No race conditions in async code
- Proper cleanup in afterEach blocks
```

## Plan Divergence

### Symptoms

- Ralph is working on tasks not in the plan
- Plan state doesn't match actual progress
- Tasks skipped or out of order

### Causes

**1. Plan not updated after changes**

**2. Manual edits to plan**

**3. Tasks discovered during implementation**

**4. Plan edited while Ralph is running**

### Solutions

**For plan not updated:**

```bash
# Stop the loop (Ctrl+C)

# Update plan to match actual state
# Mark completed tasks as done
# Remove tasks that weren't needed
# Add discovered tasks

# Resume
/path/to/ralph/loop.sh 5
```

**For manual plan edits causing issues:**

```bash
# Reset plan from git
git checkout HEAD~1 -- IMPLEMENTATION_PLAN.md

# Or restore from backup
cp IMPLEMENTATION_PLAN.md.bak IMPLEMENTATION_PLAN.md

# Resume
/path/to/ralph/loop.sh 5
```

**For discovered tasks:**

```bash
# Add them to the plan as new tasks
## Remaining Tasks
### Task 15: Fix discovered authentication bug
**Discovered:** While implementing logout, found token persistence issue
**Acceptance Criteria:**
- Token cleared from localStorage on logout
- User redirected to login after logout
```

**For concurrent plan edits:**

```bash
# NEVER edit plan while Ralph is running
# Always stop Ralph first (Ctrl+C)
# Make edits
# Restart Ralph
/path/to/ralph/loop.sh 10
```

## AGENTS.md Bloat

### Symptoms

- AGENTS.md grows very large
- Duplicate agent definitions
- Unused agent definitions
- Hard to maintain

### Causes

**1. Ralph adding redundant tasks and agents**

**2. Not cleaning up after completion**

**3. Plan changes not reflected in agents**

### Solutions

**Prevent bloat:**

```bash
# Add to loop.sh: Clean up after completion
# At end of loop.sh:
if grep -q "All tasks complete" IMPLEMENTATION_PLAN.md; then
  echo "Cleaning up agent definitions..."
  cp templates/AGENTS.md.example agent/AGENTS.md
  echo "✓ AGENTS.md reset to template"
fi
```

**Manual cleanup:**

```bash
# Reset to clean template
cp /path/to/ralph/templates/AGENTS.md.example agent/AGENTS.md

# Or manually remove unused agents
# Keep only essential agents
```

**Regular maintenance:**

```bash
# Add to git pre-commit hook
# .git/hooks/pre-commit:
if [ -f "AGENTS.md" ]; then
  # Warn if file is too large (>100 lines)
  if [ $(wc -l < AGENTS.md) -gt 100 ]; then
    echo "Warning: AGENTS.md is large. Consider cleanup."
  fi
fi
```

## General Debugging Tips

### Enable Verbose Output

```bash
# Run with verbose logging
/path/to/ralph/loop.sh 20 2>&1 | tee debug.log

# Search for errors
grep -i error debug.log
grep -i "failed" debug.log
```

### Check Plan State

```bash
# What's Ralph working on?
grep -A 10 "Next task" IMPLEMENTATION_PLAN.md

# What's completed?
grep -A 5 "Status: ✅" IMPLEMENTATION_PLAN.md

# What's remaining?
grep -A 5 "Status: ⏳" IMPLEMENTATION_PLAN.md
```

### Review Git History

```bash
# Recent commits
git log --oneline -10

# What changed in last commit?
git show HEAD

# Files modified in last 5 commits
git diff HEAD~5 HEAD --stat
```

### Check Environment

```bash
# OpenCode installed?
opencode --version

# Agents registered?
opencode agents list

# Git configured?
git config user.email
git config user.name

# Remote configured?
git remote -v
```

### When All Else Fails

1. **Reset and restart from scratch**
   ```bash
   cd ..
   rm -rf project
   git clone <repo> project
   cd project
   /path/to/ralph/loop.sh plan
   /path/to/ralph/loop.sh 20
   ```

2. **Ask for help**
   - Check [security.md](security.md) for common issues
   - Review [workflow.md](workflow.md) to understand the process
   - Open an issue with logs and plan state

3. **Simplify the problem**
   - Break requirements into smaller chunks
   - Run with fewer iterations
   - Start with a minimal viable project

## Summary

When Ralph misbehaves:

1. **Stop and assess**: Ctrl+C to stop, check plan state
2. **Identify cause**: Review git history, logs, and errors
3. **Choose solution**: Reset, edit plan, regenerate, or adjust
4. **Resume carefully**: Start with small number of iterations
5. **Monitor closely**: Watch the next few iterations for success

Ralph is autonomous, not infallible. Debugging and iteration are part of the process.
