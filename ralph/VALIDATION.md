# Ralph Infrastructure Validation Guide

This guide provides step-by-step instructions to manually validate that the Ralph infrastructure is working correctly.

## Overview

The validation process involves creating a simple test project and using Ralph to:
1. Analyze the project and create an implementation plan
2. Execute the plan to build/modify the project

## Prerequisites

- Ralph infrastructure installed at `/home/hking/environment/ralph/`
- Node.js and npm installed (for running the test project)
- Terminal access to run commands

## Step 1: Set Up a Test Project

Create or navigate to a test directory:

```bash
cd /tmp/ralph-test-project/
```

The test project should have the following structure:
```
ralph-test-project/
├── AGENTS.md              # Project-specific agent configuration
├── package.json           # Node.js package configuration
├── src/
│   └── hello.js          # Initial implementation (can be empty/minimal)
└── specs/
    └── simple-hello.md   # Specification to implement
```

**What each file contains:**

- **specs/simple-hello.md**: Describes what needs to be built (e.g., "print hello world")
- **src/hello.js**: Minimal starting implementation
- **AGENTS.md**: Project-specific build/test commands and patterns
- **package.json**: Standard Node.js package file

## Step 2: Run Planning Mode

Use Ralph's planning mode to analyze the project and create an implementation plan:

```bash
../ralph/loop.sh plan
```

**What happens:**
1. Ralph reads all specifications from the `specs/` directory
2. Ralph analyzes the current codebase
3. Ralph reads AGENTS.md for project context
4. Ralph creates a detailed implementation plan

**Expected Output:**
- Console output showing analysis progress
- A new file created: `IMPLEMENTATION_PLAN.md`

## Step 3: Review the Implementation Plan

Check the generated plan:

```bash
cat IMPLEMENTATION_PLAN.md
```

**What to expect in IMPLEMENTATION_PLAN.md:**
- Analysis of the specification requirements
- Understanding of current implementation state
- Specific tasks needed to implement the requirements
- Test strategy and verification steps
- Any changes needed to AGENTS.md (build/test commands)

The plan should be:
- Specific and actionable
- Clear about what needs to change
- Include verification steps

## Step 4: Run Building Mode

Execute the implementation plan:

```bash
../ralph/loop.sh 3
```

**What happens:**
1. Ralph reads IMPLEMENTATION_PLAN.md
2. Ralph executes each task in the plan
3. Ralph makes changes to files, creates new files, etc.
4. Ralph updates AGENTS.md with discovered patterns
5. Ralph may create/update test files

**Expected Output:**
- Detailed progress of each task execution
- File modifications logged to console
- Updated code that meets specification requirements
- Possibly updated test files

## Step 5: Verify the Implementation

Run the implemented solution:

```bash
npm start
```

**Expected Output:**
```
Hello, World!
```

You should also verify:
- [ ] The program runs without errors
- [ ] The program prints "Hello, World!" to console
- [ ] The program exits successfully (exit code 0)

To check exit code:
```bash
npm start
echo $?
# Should output: 0
```

## Step 6: Review What Changed

Compare the before and after state:

```bash
git diff --no-index /tmp/ralph-test-project.backup /tmp/ralph-test-project
```

Or if you have git initialized:
```bash
git diff
```

**Typical changes might include:**
- Improved implementation in src/hello.js
- Updated AGENTS.md with operational notes
- Possibly added test files
- Updated package.json with new scripts

## Troubleshooting

### Planning Mode Fails

**Symptoms:** Error during `loop.sh plan` execution

**Check:**
- Verify specs/ directory contains valid .md files
- Verify AGENTS.md exists
- Check file permissions

**Solution:** Ensure all required files are present and readable.

### Implementation Plan is Empty or Incomplete

**Symptoms:** IMPLEMENTATION_PLAN.md doesn't contain actionable tasks

**Check:**
- Review the specification file for clarity
- Ensure spec has clear acceptance criteria
- Check if AGENTS.md provides enough context

**Solution:** Improve specification clarity or add more context to AGENTS.md.

### Building Mode Fails

**Symptoms:** Error during `loop.sh 3` execution

**Check:**
- Verify IMPLEMENTATION_PLAN.md exists and is valid
- Check file permissions (read/write access)
- Review error messages for specific issues

**Solution:** Fix the underlying issue and re-run. If needed, manually correct the plan.

### Program Doesn't Run Correctly

**Symptoms:** `npm start` produces unexpected output or errors

**Check:**
- Verify Node.js is installed: `node --version`
- Check the implementation file for syntax errors
- Review console error messages

**Solution:** Debug the implementation or re-run planning/building mode.

## Success Criteria

Ralph infrastructure validation is successful if:

✅ Planning mode creates a coherent IMPLEMENTATION_PLAN.md
✅ The plan addresses all acceptance criteria from the spec
✅ Building mode executes without errors
✅ The resulting program meets the specification requirements
✅ The program runs correctly (`npm start` prints "Hello, World!")
✅ AGENTS.md is updated with discovered patterns

## Next Steps

After validating with a simple test project, try:

1. **More Complex Specs**: Create specifications with multiple requirements
2. **Different Languages**: Test with TypeScript, Python, or other languages
3. **Multiple Files**: Build projects with multiple components
4. **Real Projects**: Use Ralph on actual development work

## Additional Resources

- Ralph README: `/home/hking/environment/ralph/README.md`
- Spec Templates: `/home/hking/environment/ralph/templates/`
- Example Specs: Check the templates directory for examples
