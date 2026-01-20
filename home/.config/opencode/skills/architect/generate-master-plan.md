---
name: generate-master-plan
description: Generates specs/plan/00-overview.md, the tactical Master Plan.
triggers:
  - generate master plan
  - create master plan
---

# Skill: Generate Master Plan

You are the Lead Architect. Your goal is to translate the strategic context (`docs/`) into a tactical Execution Map.

## Input
Use `docs/STATUS.md` (Roadmap), `docs/OVERVIEW.md` (North Stars), and `docs/ARCHITECTURE.md` (Tech Stack).

## Output Template (`specs/plan/00-overview.md`)

```markdown
# Development Plan - Overview

> **Essential Reading**: Before working, read [`docs/OVERVIEW.md`](../../docs/OVERVIEW.md) for the vision and [`docs/ARCHITECTURE.md`](../../docs/ARCHITECTURE.md) for the system design.

---

## 1. North Stars
[1-2 Guiding Principles derived from OVERVIEW.md. e.g. "Local-first data integrity", "Pixel-perfect UI"]

## 2. Pinned Decisions (Immutable)
These decisions are **locked**. Do not change them without a major refactor.

| Category | Decision | Rationale |
|----------|----------|-----------|
| **Stack** | [e.g. Next.js App Router] | [Brief reason] |
| **Database**| [e.g. Supabase] | [Brief reason] |
| **Style** | [e.g. Tailwind] | [Brief reason] |
| **Auth** | [e.g. Clerk] | [Brief reason] |

---

## 3. Phase Overview (The Roadmap)
[Synced with docs/STATUS.md]

| Phase | Focus | Status |
|-------|-------|--------|
| **01** | [Phase Name] | **Active** |
| 02 | [Phase Name] | Pending |
| 03 | [Phase Name] | Pending |

---

## 4. Current Focus: Phase 01
**Goal:** [Brief summary of Phase 01 goals]
**Spec File:** `specs/plan/01-[name].md`
```

## Instructions
1.  **Be Tactical:** This is for the *Builder*. Keep it actionable.
2.  **Lock Decisions:** Use the "Pinned Decisions" table to prevent the "What stack are we using?" loop.
3.  **Sync:** Ensure the Phase list matches `docs/STATUS.md` exactly.
