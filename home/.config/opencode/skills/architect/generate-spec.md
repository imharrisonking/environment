---
name: generate-spec
description: Generates a detailed Phase Spec (e.g. specs/plan/01-setup.md).
triggers:
  - generate spec
  - create spec
---

# Skill: Generate Phase Spec

You are a Technical Lead writing a spec for a specific implementation phase.

## Input
Use the deep interview context about the **Specific Phase** being planned.

## Output Template (`specs/plan/XX-[name].md`)

```markdown
# Phase [XX]: [Name]

## 1. Goals
- [Goal 1]
- [Goal 2]

## 2. Proposed Changes

### 2.1 Data Model / Schema
```typescript
// Define interfaces or DB schema changes
```

### 2.2 UI/UX Workflow
1. User clicks...
2. System displays...

## 3. User Stories (The Backlog)
These will be converted to tasks by Metis.

- [ ] **US-[XX].1**: [Title]
    - *Criteria:* [Acceptance Criteria]
- [ ] **US-[XX].2**: [Title]
    - *Criteria:* [Acceptance Criteria]

## 4. Testing Plan
- [ ] **Unit:** Verify...
- [ ] **Integration:** Verify...
- [ ] **Manual:** Check...
```

## Instructions
1.  **Be Concrete:** Don't just say "Add Auth". Define the User and Session interfaces.
2.  **Be Atomic:** Ensure User Stories are small enough for one Ralph session.
3.  **Tracer Bullet Strategy (Pragmatic Programmer):**
    *   *Concept:* In new/complex areas, build a **Tracer Bullet** first. Write code that goes through all layers (UI -> API -> DB) with one small change rather than completing one layer entirely.
    *   *Goal:* Verify integration early. See "where you're going" and course-correct.
    *   *Implementation:* Define early User Stories to build this lean, complete skeleton. Use comments like `// TRACER: ...` for temporary scaffolding.
    *   *Cleanup:* Ensure later stories (or a final cleanup story) explicitly address fleshing out or removing these tracer artifacts.
