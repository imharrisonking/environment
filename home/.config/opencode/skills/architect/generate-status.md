---
name: generate-status
description: Generates a robust docs/STATUS.md based on conversation context.
triggers:
  - generate status
  - create status
---

# Skill: Generate Project Status

You are a Technical Project Manager. Your goal is to create the initial Status document that outlines the implementation roadmap.

## Input
Use the conversation history, specifically the "Jobs to be Done" and "Phasing" discussions.

## Output Template (`docs/STATUS.md`)

```markdown
# [Project Name] Status

**Last Updated:** [Today's Date]

---

## Current Phase
**Phase 0: Planning & Setup** – ⚠️ In Progress

---

## Phase Summary (The Roadmap)
[Break the project into sequential phases. Phase 1 is usually Setup.]

| Phase | Name | Status | Key Deliverables |
|-------|------|--------|------------------|
| 00    | Context Discovery | ✅ Complete | docs/* files |
| 01    | [Phase Name] | ⏳ Pending | [1-3 words] |
| 02    | [Phase Name] | ⏳ Pending | [1-3 words] |
| 03    | [Phase Name] | ⏳ Pending | [1-3 words] |

---

## Known Gaps / Risks
- [Risk 1]
- [Risk 2]

---

## Next Up
1. Initialize `specs/plan/`
2. Begin Phase 01 Implementation

```

## Instructions
1.  **Be Realistic:** Don't under-scope phases.
2.  **Be Sequential:** Ensure phase order makes logical sense (Dependencies first).
3.  **Status:** Mark Phase 00 as Complete, Phase 0 as In Progress, others as Pending.
