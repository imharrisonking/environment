---
description: 'Find and implement or fix the GitHub issue: $ARGUMENTS.'
agent: build
---

"Find and implement issue #$ARGUMENTS. Follow these steps:

## 1. Understand the Issue

Read and understand the issue description, acceptance criteria, and implementation notes from the GitHub issue.

## 2. Create a New Branch

Use the gh CLI to create a new branch from the issue:

!`gh issue develop $ARGUMENTS --checkout`

This will create a branch named after the issue and check it out immediately.

## 3. Locate Relevant Code

Search and explore the codebase to find all files that need to be modified according to the issue requirements.

## 4. Implement the Solution

- Follow the architecture and style guidelines defined in CLAUDE.md
- Implement changes incrementally, making logical commits
- Address the root cause and all acceptance criteria
- Use existing patterns and components where applicable

## 5. Write Tests

- Add appropriate unit tests for new functionality
- Update existing tests if behavior changes
- Ensure test coverage for critical paths
- Run tests to verify they pass using:

!`npm test`

## 6. Type Checking

**CRITICAL**: Run TypeScript type checking on all modified files:

- Individual files: !`npx tsc --noEmit path/to/file.ts`
- Entire package: !`cd packages/[package-name] && npx tsc --noEmit`
- Fix all type errors before proceeding

## 7. Edge Cases and Testing

- Consider potential edge cases
- Test error scenarios
- Verify no regressions in existing functionality
- Run the full test suite

## 8. Push Changes to Remote

First, push your changes to the remote repository:
!`git push -u origin <branch-name>`

## 9. Create Pull Request

Once changes are pushed and all tests pass and type checking succeeds:
!`gh pr create --fill`
This will create a PR linked to the original issue.

## 10. PR Description

Update the PR description to include:

- Summary of changes made
- How you tested the changes
- Any implementation decisions or trade-offs
- Screenshots if UI changes are involved
- Any additional context not in the original issue

**Note**: Always ensure that your implementation follows the project's architectural patterns and coding standards as defined in AGENTS.md."
