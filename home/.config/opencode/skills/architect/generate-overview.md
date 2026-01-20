---
name: generate-overview
description: Generates a robust, "Technical Charter" style docs/OVERVIEW.md.
triggers:
  - generate overview
  - create overview
---

# Skill: Generate Project Overview (SolidType Style)

You are an expert Technical Product Owner. Your goal is to synthesize the conversation into a deep "Technical Charter" for the project.

## Input
Use the conversation history to fill the template. You must have detailed answers for "Why", "Scope breakdown", and "Foundations" before running this.

## Output Template (`docs/OVERVIEW.md`)

```markdown
# [Project Name] – Project Overview

## 1. Vision & Core Identity
[1-2 paragraphs defining the project.]

At its core, [Project Name] is:
- **[Attribute 1]**: [Description, e.g., "A local-first PWA..."]
- **[Attribute 2]**: ...
- **[Attribute 3]**: ...

### Why [Key Technology/Approach]?
[Explanation of a major strategic choice, e.g., "Why Supabase?" or "Why Local-First?"]
- **Reason 1**: ...
- **Reason 2**: ...

---

## 2. Scope and Non-Goals (v1)

### In Scope
**[Category 1: e.g., Core Features]**
- [Item]
- [Item]

**[Category 2: e.g., Technical Constraints]**
- [Item]
- [Item]

**[Category 3: e.g., Platforms]**
- Web (Mobile Responsive)
- [Other]

### Out of Scope (for now)
- [Explicit Exclusion 1]
- [Explicit Exclusion 2]

---

## 3. Foundational Principles
[The "Laws" of this project. e.g., "Float64 everywhere", "Offline by default", "Mobile First".]

### 3.1 [Principle Name]
[Description of how this principle affects development.]

### 3.2 [Principle Name]
...

---

## 4. User Journey & Experience
[High-level workflow description]

1. **[Stage 1]**: User does X...
2. **[Stage 2]**: System responds Y...

---

## 5. Testing & Quality Philosophy
[How do we ensure quality? e.g., "TDD", "Visual Regression", "90% Coverage"]
- **Unit Tests**: Focus on...
- **Integration**: Focus on...

---

## 6. Inspirations & References
[Existing apps or papers we are learning from]
- **[Reference 1]**: [What we are taking from it]
- **[Reference 2]**: ...
```

## Instructions
1.  **Be Technical:** This is not a marketing brochure; it is a developer charter.
2.  **Be Specific:** "Fast" is bad. "Sub-100ms response time" is good.
3.  **Use Context:** If the user mentioned specific competitors or tech, include them in "Why" or "Inspirations".
