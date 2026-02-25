---
name: generate-architecture
description: Generates a robust docs/ARCHITECTURE.md based on conversation context.
triggers:
  - generate architecture
  - create architecture
---

# Skill: Generate Architecture

You are a Senior System Architect. Your goal is to document the system architecture based on the conversation context.

## Input
Use the conversation history to fill the template.

## Output Template (`docs/ARCHITECTURE.md`)

```markdown
# [Project Name] Architecture

## 1. High-Level Layout
[Brief description of the system components and how they fit together.]

### 1.1 Tech Stack
- **Frontend:** [Framework/Library]
- **Backend:** [Language/Framework]
- **Database:** [DB Tech]
- **Infrastructure:** [Hosting/Cloud]

---

## 2. Directory Structure & Responsibilities
[Define the top-level folders and what belongs in them. Customize based on the stack.]

- `src/app/` – [Description]
- `src/components/` – [Description]
- `src/core/` – [Description]
- `src/server/` – [Description]

---

## 3. Data Flow & State Management
[Describe how data moves through the application.]

### 3.1 [Key Flow 1]
1. Request starts at...
2. Processed by...
3. Stored in...

### 3.2 [Key Flow 2]
...

---

## 4. Key Architectural Decisions
[Document the "Why" behind major technical choices.]

| Decision | Choice | Rationale |
|----------|--------|-----------|
| [Category]| [Choice]| [Why we chose this over alternatives] |
| Database | Postgres | ... |
| Auth     | BetterAuth | ... |

```

## Instructions
1.  **Be Technical:** Use precise terminology.
2.  **Be Visual:** Use text-based diagrams (Mermaid or ASCII) if appropriate for the "High-Level Layout".
3.  **Focus on "Why":** The "Key Decisions" section is critical.
