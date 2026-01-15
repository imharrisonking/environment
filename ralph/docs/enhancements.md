# Ralph Enhancements

This document describes advanced features and enhancements that extend Ralph's capabilities beyond the core workflow.

## Work Branches Support

### What

Work branches allow Ralph to build on feature branches instead of directly on main. This isolates changes and enables code review before merging.

### Why

**Benefits:**
- **Isolation**: Main branch stays stable and clean
- **Easy rollback**: Discard work branch if unsatisfied with results
- **Code review**: Create pull requests for review before main integration
- **Parallel development**: Multiple developers can work on different features simultaneously
- **Safety**: Prevents accidental breakage of production code

**Example scenario:**
```
Without work branches:
  main: [ Ralph builds ] → Code potentially broken → Hard to fix

With work branches:
  main: [ Stable ]
  feature/auth: [ Ralph builds ] → Review → Merge if good → Discard if bad
```

### When to Use

Use work branches when:
- Working on production repositories
- Multiple developers on the team
- Code review is required before merge
- Building experimental features
- Main branch must stay stable
- Using CI/CD pipelines with branch protection rules

**Don't use work branches when:**
- Prototyping in an isolated sandbox
- Quick experiments that won't be merged
- Single developer on a personal project
- Repository is already isolated (dedicated sandbox)

### How to Use

**Step 1: Create work branch from main**
```bash
# Start from clean main
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/user-profiles
```

**Step 2: Generate or copy plan**
```bash
# Option A: Generate new plan on main and copy
git checkout main
/path/to/ralph/loop.sh plan
cp IMPLEMENTATION_PLAN.md /tmp/plan-backup.md

# Option B: Copy existing plan
git checkout feature/user-profiles
cp /tmp/plan-backup.md IMPLEMENTATION_PLAN.md
```

**Step 3: Build on work branch**
```bash
# Use --work flag for work mode
/path/to/ralph/loop.sh 20 --work

# Or manually (if script doesn't support --work)
# Just build on the current branch
/path/to/ralph/loop.sh 20
```

**Step 4: Review and merge**
```bash
# Review changes
git diff main
git log main..HEAD

# Run tests and checks
npm test
npm run lint

# If satisfied, merge to main
git checkout main
git merge feature/user-profiles
git push origin main

# If not satisfied, discard work branch
git checkout main
git branch -D feature/user-profiles
```

### Implementation

**In `loop.sh`:**
```bash
#!/bin/bash

WORK_MODE=false

# Parse arguments
if [ "$2" = "--work" ]; then
    WORK_MODE=true
fi

# Use appropriate prompt template
if [ "$WORK_MODE" = true ]; then
    PROMPT_FILE="PROMPT_plan_work.md"
else
    PROMPT_FILE="PROMPT_plan.md"
fi

# Run OpenCode with appropriate prompt
opencode agent ralph-build --prompt $PROMPT_FILE
```

**In `PROMPT_plan_work.md`:**
```markdown
# Ralph Build Agent (Work Branch Mode)

You are building on a feature branch, not main. Important rules:

1. Never checkout main branch during execution
2. Always work on the current feature branch
3. All commits go to the feature branch
4. User will review and merge when complete

Task execution rules:
- Orient: Study the feature branch state
- Select: Choose approach suitable for feature branch
- Implement: Build on current branch
- Validate: Ensure tests pass on branch
- Update: Mark tasks complete in plan
- Commit: Create commits on feature branch (not main)
```

## Acceptance-Driven Backpressure

### What

Acceptance-driven backpressure uses acceptance criteria from the plan to automatically generate tests, ensuring implementation meets requirements before marking tasks complete.

### Why

**Benefits:**
- **Verification**: Automatically validates implementation against requirements
- **Quality assurance**: Prevents incomplete or incorrect implementations
- **Documentation**: Acceptance criteria become executable tests
- **Early feedback**: Catch issues before they propagate
- **Traceability**: Clear link from requirements to tests

**Example:**
```
Acceptance criteria:
  - User can upload avatar image (max 5MB)
  - Image preview shown before upload

Generated tests:
  - test_upload_max_5mb.js
  - test_show_preview.js

Implementation only marked complete if tests pass.
```

### How It Works

**Phase 1: Extract acceptance criteria**
```markdown
### Task: Implement avatar upload
**Acceptance Criteria:**
1. Only accept image files (jpg, png, webp)
2. Max file size: 5MB
3. Show preview before upload
4. Handle upload errors gracefully
5. Display loading state during upload
```

**Phase 2: Generate test from each criterion**
```javascript
// Generated test 1
test('only accepts image files', async () => {
  const pdfFile = new File(['pdf'], 'test.pdf', { type: 'application/pdf' })
  // Test that pdf upload is rejected
})

// Generated test 2
test('rejects files larger than 5MB', async () => {
  const largeFile = new File(['x'.repeat(6 * 1024 * 1024)], 'large.jpg', { type: 'image/jpeg' })
  // Test that large file is rejected
})

// Generated test 3
test('shows image preview before upload', async () => {
  const imageFile = new File(['image'], 'test.jpg', { type: 'image/jpeg' })
  // Test that preview is displayed
})
```

**Phase 3: Run tests during validation**
```bash
# Ralph validates task
npm run tests -- avatar-upload.test.ts

# Only if all tests pass, mark task complete
```

### Implementation

**In task lifecycle (validation phase):**

```markdown
## Validation Phase

For each task:

1. Extract acceptance criteria from IMPLEMENTATION_PLAN.md
2. Generate test cases for each criterion
3. Run tests
4. If all tests pass → Mark task complete
5. If any tests fail → Implement fixes and retry
```

**Example agent prompt:**
```markdown
When validating a task:

1. Read the task's acceptance criteria from the plan
2. For each acceptance criterion:
   - Generate a test case
   - Save test file in tests/ directory
   - Run the test
3. If all tests pass:
   - Mark task as complete in IMPLEMENTATION_PLAN.md
   - Proceed to next task
4. If any tests fail:
   - Fix the implementation
   - Re-run tests
   - Don't mark task complete until all tests pass
```

**Benefits of acceptance-driven backpressure:**
- Tasks don't complete until requirements are met
- Tests are automatically generated from requirements
- No need to manually write tests for every task
- Clear audit trail: test → acceptance criterion → requirement

### When to Use

Use acceptance-driven backpressure when:
- Requirements are clear and specific
- Acceptance criteria can be verified automatically
- Project has test framework (Jest, pytest, etc.)
- Quality assurance is critical
- Multiple stakeholders review implementation

**Don't use when:**
- Requirements are ambiguous or subjective
- Acceptance criteria are not testable
- Project lacks test infrastructure
- Prototyping and experimentation phase

## Non-Deterministic Backpressure

### What

Non-deterministic backpressure uses an LLM-as-judge to evaluate subjective quality aspects (code clarity, maintainability, adherence to patterns) that can't be automatically tested.

### Why

**Benefits:**
- **Quality control**: Evaluates non-functional requirements
- **Code standards**: Ensures consistent style and patterns
- **Maintainability**: Promotes readable, understandable code
- **Best practices**: Validates use of idiomatic patterns
- **Human-like judgment**: Captures subjective aspects of quality

**Example:**
```
Automated tests: ✅ All pass
LLM-as-judge: ❌ Code is too complex, should be refactored

Result: Task not complete, Ralph refactors code.
```

### Examples of Subjective Criteria

**Code clarity:**
- Is the code easy to understand?
- Are variable names descriptive?
- Is logic straightforward or convoluted?

**Maintainability:**
- Is code modular and well-organized?
- Are functions focused and single-purpose?
- Is duplicate code avoided?

**Pattern adherence:**
- Does code follow project conventions?
- Are idiomatic patterns used (e.g., React hooks properly)?
- Is code style consistent?

**Error handling:**
- Are errors handled gracefully?
- Are error messages helpful?
- Are edge cases considered?

### Implementation

**Phase 1: Generate code for task**
```javascript
// Ralph writes implementation
function processUserData(user) {
  const processed = user.data.map(item => transform(item))
  return filtered.filter(i => i.valid)
}
```

**Phase 2: LLM-as-judge evaluates quality**

```javascript
// Evaluation prompt to LLM
const evaluationPrompt = `
Evaluate this code for quality:

${code}

Criteria:
1. Clarity: Is the code easy to understand?
2. Maintainability: Is it modular and well-organized?
3. Pattern adherence: Does it follow React/TypeScript best practices?
4. Error handling: Are errors handled properly?

Rate each criterion from 1-5.
If any criterion < 3, explain why and suggest improvements.
`;

// LLM response
{
  "clarity": 2,
  "maintainability": 3,
  "patterns": 4,
  "errorHandling": 1,
  "issues": [
    "Variable names not descriptive",
    "No error handling for transform()",
    "Unclear what transform() does"
  ],
  "suggestions": [
    "Rename 'item' to 'userDataItem'",
    "Add try-catch around transform()",
    "Add comment explaining transform logic"
  ]
}
```

**Phase 3: Apply feedback if needed**

```javascript
if (evaluation.score < 3) {
  // Ralph refactors based on feedback
  function processUserData(user) {
    try {
      const transformedItems = user.data.map(item => transformUserDataItem(item))
      return transformedItems.filter(item => item.isValid)
    } catch (error) {
      console.error('Error processing user data:', error)
      return []
    }
  }
}
```

### Implementation in Ralph

**Add to task validation prompt:**

```markdown
## Quality Evaluation (LLM-as-Judge)

After implementation passes automated tests:

1. Read the implemented code
2. Evaluate against quality criteria:
   - Code clarity (1-5)
   - Maintainability (1-5)
   - Pattern adherence (1-5)
   - Error handling (1-5)
3. If all scores >= 3:
   - Mark task as complete
4. If any score < 3:
   - Refactor code based on feedback
   - Re-evaluate
   - Don't mark complete until quality is acceptable
```

**Configuration in AGENTS.md:**

```markdown
## Quality Criteria

### Code Clarity
- Variable and function names are descriptive
- Logic is straightforward and easy to follow
- Comments explain non-obvious behavior

### Maintainability
- Functions are focused and single-purpose
- Code is modular and reusable
- Duplicated code is eliminated

### Pattern Adherence
- Follows project conventions (React hooks, TypeScript patterns)
- Uses idiomatic language features
- Consistent with existing codebase

### Error Handling
- Errors are caught and handled gracefully
- Error messages are helpful for debugging
- Edge cases are considered
```

### When to Use

Use non-deterministic backpressure when:
- Code quality is important
- Multiple developers will maintain the code
- Project has established patterns and conventions
- Long-lived codebase (not throwaway prototype)
- Subjective quality aspects matter

**Don't use when:**
- Prototyping or rapid experimentation
- Time-critical delivery (evaluation takes time)
- Code is intended to be temporary
- Project has no established patterns

**Cost consideration:**
- LLM-as-judge adds API costs
- Use selectively (e.g., only for critical paths)
- Can disable for non-critical tasks

## Writing Good Acceptance Criteria

Good acceptance criteria are the foundation of both acceptance-driven and non-deterministic backpressure.

### Functional Requirements

**Good example:**
```
User can create a new todo item by:
- Entering text in input field
- Pressing Enter or clicking "Add" button
- Todo appears in the list
- Input field is cleared
- Focus returns to input field
```

**Bad example:**
```
Create todo functionality.
```

**Why good is better:**
- Specific actions listed
- Clear expected behavior
- Each criterion is testable

### Performance Requirements

**Good example:**
```
Page loads in under 2 seconds on:
- Desktop (Chrome on 100Mbps connection)
- Mobile (Safari on 4G connection)
- Measured with Lighthouse performance score >= 90
```

**Bad example:**
```
Fast page load.
```

**Why good is better:**
- Specific metrics (2 seconds)
- Defined test conditions
- Measurement method specified

### Edge Cases

**Good example:**
```
Handle edge cases:
- Empty input (show error, don't create todo)
- Duplicate todo (allow, but warn user)
- Very long input (truncate with ellipsis)
- Special characters (preserve, don't escape)
```

**Bad example:**
```
Handle errors.
```

**Why good is better:**
- Specific edge cases listed
- Expected behavior defined
- Helps Ralph anticipate issues

### Quality Attributes

**Good example:**
```
Code quality requirements:
- TypeScript with no any types
- Functions <= 50 lines
- Cyclomatic complexity <= 10
- Test coverage >= 80%
- ESLint zero errors, zero warnings
```

**Bad example:**
```
Write good code.
```

**Why good is better:**
- Measurable quality metrics
- Clear standards
- Enables automated validation

### Security Requirements

**Good example:**
```
Security requirements:
- Input sanitized to prevent XSS
- File uploads limited to images (jpg, png, webp)
- Max file size: 5MB
- Viruses scanned (if possible)
- User uploaded files served from separate domain
```

**Bad example:**
```
Secure file upload.
```

**Why good is better:**
- Specific security controls listed
- Attack vectors addressed
- Implementation guidance provided

### Accessibility Requirements

**Good example:**
```
Accessibility requirements:
- All images have alt text
- Keyboard navigation works (tab, enter, escape)
- ARIA labels on form inputs
- Color contrast ratio >= 4.5:1
- Screen reader friendly
```

**Bad example:**
```
Accessible UI.
```

**Why good is better:**
- Specific accessibility standards
- WCAG compliance implied
- Testable criteria

### Template for Good Acceptance Criteria

```markdown
### Task: [Task Name]

**Functional Requirements:**
- [Specific functional behavior 1]
- [Specific functional behavior 2]
- [Edge case handling]

**Performance Requirements:**
- [Metric with specific value]
- [Test conditions]

**Quality Requirements:**
- [Specific quality metric]
- [Code style requirements]

**Security Requirements:**
- [Specific security control]
- [Attack prevention]

**Accessibility Requirements:**
- [WCAG standard]
- [Specific accessibility feature]

**Success Criteria:**
- [How to verify task is complete]
- [What tests must pass]
```

## When to Use Each Enhancement

### Decision Matrix

| Enhancement | When to Use | When NOT to Use |
|-------------|-------------|-----------------|
| **Work Branches** | Production repos, multiple devs, code review required | Isolated sandbox, single dev, prototype |
| **Acceptance-Driven Backpressure** | Clear requirements, automated test framework, critical quality | Ambiguous requirements, no test infra, prototype |
| **Non-Deterministic Backpressure** | Code quality important, long-lived codebase, team project | Rapid prototype, throwaway code, time-critical |

### Combination Examples

**Scenario 1: Production feature for team project**
```
Use: Work Branches + Acceptance-Driven Backpressure + Non-Deterministic Backpressure

Why:
- Work branches: Protect main, enable code review
- Acceptance-driven: Verify requirements met
- Non-deterministic: Ensure code quality
```

**Scenario 2: Internal tool for small team**
```
Use: Work Branches + Acceptance-Driven Backpressure

Why:
- Work branches: Basic isolation
- Acceptance-driven: Verify functionality
- Skip non-deterministic: Reduce cost, code quality less critical
```

**Scenario 3: Quick prototype for experiment**
```
Use: None (base Ralph)

Why:
- No work branches: Faster iteration in isolated sandbox
- No backpressure: Rapid experimentation
- Just get it working fast
```

**Scenario 4: Critical security feature**
```
Use: Work Branches + Acceptance-Driven Backpressure + Non-Deterministic Backpressure

Why:
- All enhancements needed
- Work branches: Extra caution
- Acceptance-driven: Verify security requirements
- Non-deterministic: Code quality for security
```

## Summary

Ralph enhancements extend the core workflow:

1. **Work Branches**: Isolate changes, enable code review, safer development
2. **Acceptance-Driven Backpressure**: Auto-generate tests from acceptance criteria, verify requirements
3. **Non-Deterministic Backpressure**: LLM-as-judge for subjective quality evaluation

**When to use enhancements:**
- Production code → Use all three
- Team project → Use work branches + acceptance-driven
- Internal tool → Use work branches
- Prototype → Use none (base Ralph)

The key is matching the enhancement to the context: not every project needs every enhancement.
