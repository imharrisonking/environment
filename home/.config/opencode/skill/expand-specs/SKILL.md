---
name: expand-specs
description: Generate individual spec files from topics in project_spec.md
triggers:
  - expand specs
  - generate spec files
  - create topic specs
  - write specs
---

# Expand Specs Skill

Generate individual specification files for each topic listed in `specs/project_spec.md`.

## Precondition

`specs/project_spec.md` must exist with topics listed under JTBDs.

## Workflow

### 1. Parse project_spec.md

Read the file and extract all topics from the "Topics of Concern" tables.

For each topic:
- Check if the spec file already exists using `glob`
- If exists → skip (already done)
- If not → interview and generate

### 2. For Each Pending Topic

Conduct a focused mini-interview:

**A. Confirm Understanding**
"For [topic], I see it's about [description]. Is that right? Anything to add?"

**B. Requirements**
"What are the key requirements for this topic?"
- Functional requirements
- Non-functional requirements (if any)

**C. Acceptance Criteria**
"How will we know this is done? What should we verify?"
- Specific, testable criteria
- Always include "Typecheck passes"
- For UI topics: "Verify in browser using dev-browser"

**D. Dependencies**
"Does this depend on any other topics?"

### 3. Generate Spec File

Create `specs/[topic-name].md` using hyphenated lowercase naming:
- "Login Flow" → `specs/login-flow.md`
- "Board Management" → `specs/board-management.md`
- "OAuth with BetterAuth" → `specs/oauth-better-auth.md`

Use this template:

```markdown
# [Topic Name]

> Part of: [JTBD Title]
> Index: `specs/project_spec.md`

## Overview
[Brief description of this topic]

## Requirements

### Functional Requirements
- FR-1: [Requirement]
- FR-2: [Requirement]

### Non-Functional Requirements
- NFR-1: [If any - performance, security, etc.]

## Acceptance Criteria
- [ ] [Specific, verifiable criterion]
- [ ] [Another criterion]
- [ ] Typecheck passes
- [ ] [If UI] Verify in browser using dev-browser

## Dependencies
- [Other specs this depends on, or "None"]

## Open Questions
- [Unresolved items, or "None"]

---
*Topic of: [JTBD Title]*
*See also: `specs/project_spec.md`*
```

### 4. Update Specification Index

After creating each spec file:
1. Read `specs/project_spec.md`
2. Verify the topic is listed in the Specification Index
3. If not listed, add it with the correct file path and description
4. Write updated file

### 5. Context Management

If context fills up:
- Complete current spec file
- Save and update index
- Output: "Created N spec files. Continue with `/expand-specs` in a new session for remaining topics."

## After Completion

When all topics have spec files:

"All specs generated! Your specification files:

| File | Topic |
|------|-------|
| specs/project_spec.md | Master index |
| specs/[topic].md | [Topic] |
| ... | ... |

Next step: Run `./specs/plan-loop.sh` to have Metis create the execution plan."
