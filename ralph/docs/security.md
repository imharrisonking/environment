# Ralph Security Guide

This document explains Ralph's security model, what's exposed in autonomous mode, and best practices for safe usage.

## Security Model

Ralph is designed for autonomous development, which requires extensive system access. Understanding what Ralph needs and why is critical for safe usage.

### Why Ralph Needs Permissive Access

Autonomous development requires:

1. **File system access:** Read and write project files
2. **Execution permissions:** Run tests, build tools, git
3. **Network access:** Install packages, fetch documentation
4. **Git operations:** Commit, branch, merge for checkpointing

**Without these permissions, Ralph cannot:**
- Implement features (needs write access)
- Validate tests (needs execution)
- Install dependencies (needs network)
- Create checkpoints (needs git)

### Minimum Viable Access Principle

Ralph follows the "minimum viable access" principle:

**What it needs:**
- Full read/write access to project directory
- Git operations within the project
- Package installation for project dependencies
- Network access for documentation and libraries

**What it doesn't need:**
- Access outside the project directory
- System-wide configuration changes
- Deletion of git history
- Force push to main branch
- Access to secrets and credentials outside project

**Example agent permissions:**
```yaml
allow:
  - read: /project/**
  - write: /project/**
  - execute: /project/**/* (tests, builds)
  - git: /project/**
  - network: documentation, package registries

deny:
  - write: /etc/**
  - write: ~/.ssh/**
  - git: force push to main
  - delete: .git/**
```

## What's Exposed in Autonomous Mode

When Ralph runs autonomously, the following are exposed:

### Project Files

**Exposed:**
- All source code
- Configuration files
- Documentation
- Dependencies and lock files
- Tests and test data
- Generated files and builds

**Not exposed (by default):**
- Files outside project directory
- System configuration
- User credentials (if stored outside project)
- Other projects on the system

### Git Credentials

**Exposed:**
- Git credentials used for the project
- Commit history and metadata
- Branches and tags
- Remote repository access

**Risk:** If Ralph pushes to a public repository, sensitive code could be exposed.

**Mitigation:**
- Use private repositories
- Review commits before pushing
- Use work branches and review PRs
- Don't include secrets in code (use environment variables)

### API Keys and Secrets

**Exposed:**
- API keys in environment variables or .env files in the project
- Secrets committed to git (if present)
- Credentials in configuration files

**Risk:** Ralph might accidentally log, commit, or expose these.

**Mitigation:**
- Never commit secrets to git
- Use environment variables for secrets
- Use secret management services
- Review git history before pushing

### Network Access

**Exposed:**
- Package registry access (npm, pip, cargo, etc.)
- Documentation requests (docs for libraries)
- External API calls (if project integrates with them)

**Risk:**
- Phishing via malicious packages
- Data exfiltration through API calls
- Supply chain attacks

**Mitigation:**
- Use trusted package registries
- Pin dependency versions
- Review package integrity (SRI hashes, checksums)
- Monitor network activity during build

### System Execution

**Exposed:**
- Command execution in project directory
- Build tools (webpack, vite, etc.)
- Test runners
- Git operations

**Risk:**
- Malicious code execution in build tools
- Arbitrary command injection
- Compromised dependencies

**Mitigation:**
- Run in isolated VM or container
- Use work branches to limit damage
- Review build logs
- Pin dependency versions

## Your VM Setup

This Ralph implementation assumes VM isolation for security.

### Why VM Isolation

**VM provides:**
- Complete OS isolation from host
- Network isolation if needed
- Resource constraints (CPU, memory)
- Snapshots for rollback

**Benefits:**
- If Ralph does something bad, it's contained in the VM
- Can reset VM to clean state if needed
- Protects host system from harm
- Enables safe experimentation

### VM Configuration Recommendations

**Network:**
- Use host-only or NAT for development
- Disable bridge networking to public internet
- Use firewall rules to restrict outgoing traffic

**Resources:**
- Limit CPU cores (2-4 cores is usually enough)
- Limit memory (4-8GB)
- Limit disk space (20-50GB)

**Snapshots:**
- Take snapshot before running Ralph
- Enables quick rollback if things go wrong
- Useful for testing different approaches

### Alternative: Docker

If you don't have VM isolation, Docker can provide similar protection:

```bash
# Create development container
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  --network host \
  node:18 bash

# Run Ralph inside container
cd /workspace
/path/to/ralph/loop.sh plan
/path/to/ralph/loop.sh 20
```

**Docker benefits:**
- Lightweight compared to full VM
- Fast startup and teardown
- Isolated filesystem
- Resource constraints

**Docker limitations:**
- Not as complete isolation as VM
- Still shares host kernel
- Some system operations not possible

## Escape Hatches

When Ralph goes wrong, you need ways to stop and recover.

### Immediate Stop: Ctrl+C

**When to use:**
- Ralph is doing something unexpected
- Build loop is going in circles
- You notice a critical error

**How:**
```bash
# Press Ctrl+C to interrupt the loop
# Ralph stops immediately

# Check what happened
git log --oneline -10
cat IMPLEMENTATION_PLAN.md
```

**After stopping:**
- Review recent commits
- Check the plan state
- Decide whether to continue, reset, or regenerate plan

### Reset: Git Reset

**When to use:**
- Ralph built the wrong thing
- Tests are failing consistently
- Implementation is fundamentally flawed

**How:**
```bash
# Reset to last known good state
git log --oneline
git reset --hard <commit-hash>

# View the commit history to find the good state
git reflog
```

**Best practices:**
- Always reset to a known good commit
- Keep a backup of the plan before major resets
- Reset with --hard, not --soft (you want clean state)

### Regenerate Plan: New Plan from Scratch

**When to use:**
- Plan is fundamentally wrong
- Requirements changed significantly
- Ralph is stuck in a loop and can't proceed

**How:**
```bash
# Backup current plan
cp IMPLEMENTATION_PLAN.md IMPLEMENTATION_PLAN.md.bak

# Regenerate from current requirements
/path/to/ralph/loop.sh plan

# Review new plan
cat IMPLEMENTATION_PLAN.md

# Manually merge completed tasks from backup if needed
```

### Delete Everything: Nuclear Option

**When to use:**
- Project is hopelessly broken
- Too many bad commits to untangle
- Want to start completely fresh

**How:**
```bash
# Clone repository again
cd ..
git clone <repo-url> project-new
cd project-new

# Or reset to initial commit
git reset --hard $(git rev-list --max-parents=0 HEAD)
```

**Warning:** This loses all work. Only use as last resort.

## Best Practices

### 1. Use Dedicated Projects

**Why:** Ralph needs extensive permissions. Using it for dedicated, isolated projects limits exposure.

**How:**
- Create separate repositories for Ralph-generated code
- Don't mix hand-written and autonomous code in the same repo
- Use separate VMs or containers for different projects

**Example:**
```
Good:
  /projects/ralph-generated/my-app/
  /projects/ralph-generated/auth-service/

Bad:
  /production-app/  # Mixed hand-written + Ralph
  /shared-libs/     # Multiple developers + Ralph
```

### 2. Review Before Merge

**Why:** Ralph makes mistakes. You should review code before it reaches production.

**How:**
```bash
# Use work branches
git checkout -b feature/ralph-work
/path/to/ralph/loop.sh 20

# Review changes
git diff main
git log main..HEAD

# Only merge when satisfied
git checkout main
git merge feature/ralph-work
```

**Review checklist:**
- [ ] Code follows project conventions
- [ ] No security vulnerabilities introduced
- [ ] Tests pass
- [ ] No unintended side effects
- [ ] Commit messages are accurate

### 3. Use Work Branches

**Why:** Work branches isolate changes from main, making it easier to discard or modify.

**How:**
```bash
# Create work branch
git checkout -b feature/awesome-feature

# Copy plan from main
git checkout main
/path/to/ralph/loop.sh plan
cp IMPLEMENTATION_PLAN.md /tmp/plan.md

# Apply to work branch
git checkout feature/awesome-feature
cp /tmp/plan.md IMPLEMENTATION_PLAN.md

# Build on work branch
/path/to/ralph/loop.sh 20 --work
```

**Benefits:**
- Main branch stays stable
- Easy to discard work if unsatisfied
- Enables code review via pull requests
- Parallel development possible

### 4. Never Commit Secrets

**Why:** Ralph might accidentally expose credentials or API keys.

**How:**
- Use environment variables for secrets
- Use secret management services (AWS Secrets Manager, HashiCorp Vault)
- Add secrets to .gitignore
- Use git-secrets to prevent accidental commits

**Example .gitignore:**
```
.env
.env.local
secrets.yml
credentials.json
**/secrets/**
```

**Example .git-secrets configuration:**
```bash
# Install git-secrets
brew install git-secrets  # macOS
sudo apt install git-secrets  # Linux

# Configure to block common secret patterns
git secrets --register-aws
git secrets --add 'password.*=.*'
git secrets --add 'api_key.*=.*'

# Scan history
git secrets --scan
```

### 5. Monitor Build Logs

**Why:** Spot errors and unintended actions early.

**How:**
```bash
# Run with log monitoring
/path/to/ralph/loop.sh 20 2>&1 | tee build.log

# Or watch in real-time
/path/to/ralph/loop.sh 20 &
tail -f build.log
```

**What to watch for:**
- Unexpected file deletions
- Errors that repeat
- Network requests to unknown hosts
- Suspicious command executions

### 6. Limit Iterations Initially

**Why:** Start small to ensure Ralph is on the right track before committing to a long build.

**How:**
```bash
# Start with 5 iterations to see if things go well
/path/to/ralph/loop.sh 5

# Review progress
cat IMPLEMENTATION_PLAN.md
git log --oneline

# If looks good, continue with more iterations
/path/to/ralph/loop.sh 15
```

**Benefits:**
- Early detection of issues
- Saves time if Ralph goes off the rails
- Builds confidence in the approach

### 7. Use Checksums for Critical Files

**Why:** Detect if Ralph unintentionally modifies important files.

**How:**
```bash
# Before starting
sha256sum package.json package-lock.json > checksums.txt

# After Ralph completes
sha256sum -c checksums.txt
```

**If checksums fail:**
- Investigate what changed
- Reset if modifications were unintended

### 8. Pin Dependency Versions

**Why:** Prevent supply chain attacks and ensure reproducibility.

**How:**
```bash
# Lock file already pins versions
# But verify it's checked into git
git add package-lock.json  # or requirements.txt, Cargo.lock, etc.
git commit -m "chore: lock dependency versions"
```

**Benefits:**
- Reproducible builds
- Prevents surprise updates
- Makes it easier to audit dependencies

### 9. Regular Security Audits

**Why:** Ralph might introduce vulnerabilities over time.

**How:**
```bash
# Run security scanners
npm audit
snyk test
bandit .  # Python
# Or project-specific tools

# Scan for secrets
git secrets --scan

# Check for known vulnerable dependencies
npm audit fix
```

**Schedule:**
- After each major Ralph session
- Before merging to main
- Regularly (e.g., weekly) for active projects

### 10. Document Decisions

**Why:** Track why Ralph made certain decisions for future reference.

**How:**
- Keep IMPLEMENTATION_PLAN.md notes
- Document deviations from the plan
- Record workarounds and fixes

**Example:**
```markdown
### Task 5: Implement authentication
**Status:** ✅ Complete
**Notes:**
- Chose JWT over OAuth because we don't need third-party login
- Added custom refresh token rotation for better security
- Used bcrypt with cost factor 12 for password hashing
**Deviations from plan:**
- Added rate limiting (not in original plan)
- Used custom middleware instead of passport.js library
```

## Summary

Ralph requires extensive permissions, which means security is paramount:

1. **Understand what's exposed:** Project files, git credentials, network access
2. **Use isolation:** VM or Docker to contain potential damage
3. **Have escape hatches:** Ctrl+C, git reset, regenerate plan
4. **Follow best practices:** Dedicated projects, review before merge, work branches
5. **Monitor and audit:** Watch build logs, run security scanners, verify changes

Remember: Ralph is autonomous, not trustworthy. Always verify its work before it reaches production.
