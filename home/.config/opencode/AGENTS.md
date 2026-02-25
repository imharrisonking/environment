# OpenCode Agents Reference

This directory contains custom agent definitions for OpenCode, including an **Autonomous Agent Harness** inspired by Geoffrey Huntley's [Ralf pattern](https://ghuntley.com/ralph/).

## Overview: The Autonomous Agent Harness

The harness consists of three specialized agents that work together in a loop to autonomously execute project work:

1. **Architect** - Deep discovery and specification generation
2. **Metis** - Translates strategy into prioritized execution plans
3. **Ralph** - Executes tasks iteratively with intelligent priority handling

### How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                     AUTONOMOUS AGENT LOOP                        │
│                                                                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐           │
│  │  Architect  │───▶│    Metis    │───▶│    Ralph    │           │
│  │  Discovery  │    │  Planning   │    │ Execution  │           │
│  └─────────────┘    └─────────────┘    └─────────────┘           │
│       │                  │                  │                   │
│       ▼                  ▼                  ▼                   │
│   docs/          specs/plan/       specs/prd.json               │
│   OVERVIEW.md    00-overview.md    + specs/state/               │
│   ARCHITECTURE   XX-phase.md       progress.md                   │
│   STATUS.md                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Memory Persistence:** Each iteration spawns a fresh OpenCode session. Memory persists via:
- Git history (commits)
- `specs/state/progress.md` (progress tracking)
- `specs/prd.json` (task status)

**See:** [Ralph README](/home/hking/environment/home/.config/opencode/ralph/README.md) for detailed documentation on the autonomous agent loop.

---

## Autonomous Agents

### Architect (`agent/architect.md`)

**Description**: Project discovery and specification agent. Conducts deep interviews to generate high-quality project documentation using a "SolidType-quality" foundation approach.

**When to Use**:
- Starting a new project (generate initial documentation)
- When `docs/` files are missing
- When `specs/plan/` is empty but `docs/` exists

**Mode**: Primary (uses `google/gemini-3-pro-preview` model)
**Tools**: bash, read, write, edit, glob, grep, webfetch, websearch, task, question, skill

**Core Workflow - The "Deep Context" Flow**:

**Phase 0: Memo Analysis (Context Loading)**
- Checks if `docs/MEMO.md` exists
- If yes, reads and extracts: Mission, Problem, Solution, MVP, ICP, GTM

**Phase 1: Overview Discovery (The Charter)**
- Calls `skill/generate-overview` to create `docs/OVERVIEW.md`
- Covers: Identity, Strategic Choices, Scope, Principles, User Journey, Testing

**Phase 2: Architecture Discovery (The Blueprint)**
- Calls `skill/generate-architecture` to create `docs/ARCHITECTURE.md`
- Covers: Stack, Structure, Data Flow, Decisions

**Phase 3: Status & Roadmap (The Strategy)**
- Calls `skill/generate-status` to create `docs/STATUS.md`
- Covers: Phasing Strategy, Key Milestones

**Phase 4: Execution Initialization (The Handoff)**
- Translates Strategy (`docs/`) into Actionable Specs (`specs/plan/`)
- Generates Master Plan via `skill/generate-master-plan` → `specs/plan/00-overview.md`
- Identifies next phase and conducts deep spec interview
- Generates Phase Spec via `skill/generate-spec` → `specs/plan/XX-[name].md`

**Key Characteristics**:
- Always reads `docs/` before generating `specs/`
- Never generates markdown manually - always uses skills
- Context-aware: Starts Phase 0/1 if `docs/OVERVIEW.md` is missing, Phase 4 if `docs/` exist but `specs/plan/` is empty

---

### Metis (`agent/metis.md`)

**Description**: Architecture & Planning agent. Generates the PRD and Execution Plan for Ralph. Responsible for translating the current active phase into a prioritized tactical execution plan.

**When to Use**:
- After Architect has created `specs/plan/` files
- When `specs/prd.json` needs to be generated or updated
- To plan work for the current active phase only

**Mode**: Primary
**Tools**: bash, read, write, edit, glob, grep, webfetch, websearch, task

**The Planning Loop (SolidType Strategy)**:

**1. Context Loading**
- Reads Vision: `docs/OVERVIEW.md` and `docs/ARCHITECTURE.md`
- Reads Master Plan: `specs/plan/00-overview.md` to find Active Phase and Pinned Decisions
- Reads Phase Spec: The specific `specs/plan/XX-name.md` file

**2. Gap Analysis**
- Compares Spec vs Reality: What is in the Spec but missing in code?
- Filters: Ignores requirements from future phases. Focuses ONLY on the Active Phase.

**3. Plan Generation (`specs/prd.json`)**
Outputs the Execution Plan with strict prioritization:
```json
{
  "project": "Project Name",
  "branchName": "ralph/phase-XX-name",
  "description": "Implementing Phase XX: [Title]",
  "userStories": [
    {
      "id": "US-001",
      "title": "Concise Title",
      "description": "As a [user], I want [feature]...",
      "priority": "high",  // "high" | "medium" | "low"
      "acceptanceCriteria": ["Criterion 1", "Criterion 2"],
      "passes": false,
      "notes": "Ref specs/plan/XX-name.md"
    }
  ]
}
```

**4. Prioritization Logic**
- **HIGH**: Blockers, Core Infrastructure, Database Schema, "Hello World" of the feature
- **MEDIUM**: Core Logic, Main UI components
- **LOW**: Polish, Edge cases, Nice-to-haves

**Stop Condition**: Outputs `<promise>PLAN COMPLETE</promise>` when `specs/prd.json` covers all remaining work for the Current Phase.

---

### Ralph (`agent/ralph.md`)

**Description**: Execution agent that implements tasks from `specs/prd.json` in a loop with intelligent priority handling. Coordinates specialized sub-agents (Boomerang) to handle complex coding tasks.

**When to Use**:
- After Metis has generated `specs/prd.json`
- To execute implementation tasks iteratively
- To track progress and handle dependencies

**Mode**: Primary
**Tools**: Comprehensive bash/read/write permissions, task orchestration, bash access for agent-browser CLI

**Core Constraint: SINGLE TASK ITERATION**
- An ITERATIVE agent running inside a loop
- Implements EXACTLY ONE user story per session
- After verifying and committing ONE story, MUST EXIT

**Task Selection Logic - Intelligent Priority**:

**1. First Priority: Check `specs/state/progress.md` for Blockers**
- Checks for blocked, completed, or failed tasks before selecting any task
- If a task is blocked, checks if blocker can be completed quickly first

**2. Second Priority: Respect `specs/prd.json` Priority Field**
- `critical`: Essential for project to work
- `high`: Important but not blocking
- `medium`: Nice-to-have but not urgent
- `low`: Optional

**3. Third Priority: Follow Project Phase**
- Focuses on tasks relevant to active phase from `specs/plan/00-overview.md`

**4. Smart Prioritization**
- If a medium task is unblocked but a high task is blocked, do the medium task first
- If a low task unblocks a critical task, do the low task first
- Goal: progress, not perfection

**Primary Interaction Loop**:
1. Check for blockers in `specs/state/progress.md`
2. Pick the next high-priority task from `specs/prd.json`
3. Execute via Boomerang (orchestrating coder/build/dev-browser sub-agents)
4. Verify the changes
5. Update `specs/state/progress.md` with completion status

**Key Characteristics**:
- **Read-only**: Uses Boomerang to orchestrate sub-agents for all file modifications
- **Verification**: Checks work often - verifies changes before marking tasks done
- **Dependency checking**: Uses `specs/state/progress.md` to check for blocked tasks
- **Resilience**: Attempts to fix failures (e.g., pre-commit hooks) or escalates to user

---

## Available Sub-Agents

### Coder (`coder.md`)

**Description**: Implementation-focused subagent for coding tasks delegated by an orchestrator agent.

**When to Use**: Invoked automatically by orchestration agent for specific coding tasks. Also can be used directly for focused implementation work.

**Mode**: Subagent (typically invoked by Ralph)
**Temperature**: 0.2 (very focused, minimal creativity)
**Tools**: bash, edit, write, read, glob, grep

**Key Characteristic**: Stays focused on assigned task, doesn't expand scope unless necessary. Provides clear summaries of changes, decisions, and notes for orchestrator.

---

### Build (`build.md`)

**Description**: Default development agent with all tools enabled. Full development work capability.

**When to Use**:
- General development tasks
- Default agent for most coding work
- When no specialized agent is more appropriate

**Mode**: Primary
**Tools**: write, edit, bash, webfetch enabled

---

### Plan (`plan.md`)

**Description**: Restricted planning/analysis agent; no writes by default. Read-only analysis capabilities.

**When to Use**:
- Analyzing codebases without making changes
- Planning before implementation
- Research and documentation tasks
- Reviewing code structure

**Mode**: Primary
**Permission**: edit/ask, write/ask (doesn't make changes by default)
**Tools**: Comprehensive bash permissions for file reading, searching, checking

---

### Dev-Browser (`dev-browser.md`)

**Description**: Browser automation via agent-browser CLI for web testing, form filling, screenshots, and data extraction. For website navigation, form filling, screenshots, scraping, testing web apps, and automating browser workflows.

**When to Use**:
- Frontend/UI checks, interactive website inspections
- Localhost port inspection, browser console logs
- Any mention of "playwright", "frontend", "ui", "browser"
- Website navigation, form filling, taking screenshots
- Scraping, automating browser workflows

**Tools**: bash access for agent-browser CLI commands

---

## Agent Hints
- For frontend/UI checks, interactive website inspections, localhost ports, and browser console logs, use `@dev-browser` with agent-browser CLI.
- Any mention of "playwright", "browser", or browser automation should invoke `@dev-browser`.

## Agent Selection Guidelines

1. **Simple task** → Use **Build** agent directly
2. **Complex parallelizable task** → Use **Boomerang** to orchestrate
3. **Need research only** → Use **Plan** agent
4. **Different AI perspective** → Use **Cursor** agent
5. **Browser interaction** → Use **Dev-Browser** agent

## Agent Skills

### Architect Skills (`skills/architect/`)

The Architect agent uses specialized skills to generate project documentation. These skills are designed to create high-quality, "SolidType-style" documentation that forms the foundation for autonomous development.

#### `generate-overview`

**Description**: Generates a robust, "Technical Charter" style `docs/OVERVIEW.md`.

**When Used**: Phase 1 of Architect's workflow.

**Output Template Structure**:
```markdown
# [Project Name] – Project Overview

## 1. Vision & Core Identity
[1-2 paragraphs defining the project and its core attributes]

## 2. Scope and Non-Goals (v1)
### In Scope
- Core Features
- Technical Constraints
- Platforms

### Out of Scope (for now)
- Explicit exclusions

## 3. Foundational Principles
[The "Laws" of this project]

## 4. User Journey & Experience
[High-level workflow description]

## 5. Testing & Quality Philosophy
[How we ensure quality]

## 6. Inspirations & References
[Existing apps or papers we are learning from]
```

**Key Output**: `docs/OVERVIEW.md`

---

#### `generate-architecture`

**Description**: Generates a robust `docs/ARCHITECTURE.md` based on conversation context.

**When Used**: Phase 2 of Architect's workflow.

**Output Template Structure**:
```markdown
# [Project Name] Architecture

## 1. High-Level Layout
[Brief description of system components and how they fit together]

### 1.1 Tech Stack
- Frontend
- Backend
- Database
- Infrastructure

## 2. Directory Structure & Responsibilities
[Define top-level folders and responsibilities]

## 3. Data Flow & State Management
[Describe how data moves through the application]

## 4. Key Architectural Decisions
[Document the "Why" behind major technical choices]
```

**Key Output**: `docs/ARCHITECTURE.md`

---

#### `generate-status`

**Description**: Generates a robust `docs/STATUS.md` based on conversation context.

**When Used**: Phase 3 of Architect's workflow.

**Output Template Structure**:
```markdown
# [Project Name] Status

**Last Updated:** [Today's Date]

## Current Phase
[Current phase status]

## Phase Summary (The Roadmap)
| Phase | Name | Status | Key Deliverables |
|-------|------|--------|------------------|
| 00    | Context Discovery | ✅ Complete | docs/* files |
| 01    | [Phase Name] | ⏳ Pending | [1-3 words] |

## Known Gaps / Risks
[List risks and gaps]

## Next Up
[Next steps]
```

**Key Output**: `docs/STATUS.md`

---

#### `generate-master-plan`

**Description**: Generates `specs/plan/00-overview.md`, the tactical Master Plan.

**When Used**: Phase 4 of Architect's workflow (first step).

**Purpose**: Translates strategic context (`docs/`) into a tactical Execution Map for the Builder.

**Output Template Structure**:
```markdown
# Development Plan - Overview

## 1. North Stars
[1-2 Guiding Principles derived from OVERVIEW.md]

## 2. Pinned Decisions (Immutable)
[Locked decisions to prevent tech-choice loops]
| Category | Decision | Rationale |
|----------|----------|-----------|
| Stack | [Tech choice] | [Brief reason] |
| Database | [DB choice] | [Brief reason] |

## 3. Phase Overview (The Roadmap)
| Phase | Focus | Status |
|-------|-------|--------|
| 01    | [Phase Name] | **Active** |
| 02    | [Phase Name] | Pending |

## 4. Current Focus: Phase 01
**Goal:** [Brief summary]
**Spec File:** `specs/plan/01-[name].md`
```

**Key Output**: `specs/plan/00-overview.md`

---

#### `generate-spec`

**Description**: Generates a detailed Phase Spec (e.g. `specs/plan/01-setup.md`).

**When Used**: Phase 4 of Architect's workflow (final step).

**Purpose**: Creates detailed implementation specifications for a specific phase that will be converted to tasks by Metis.

**Output Template Structure**:
```markdown
# Phase [XX]: [Name]

## 1. Goals
- [Goal 1]
- [Goal 2]

## 2. Proposed Changes
### 2.1 Data Model / Schema
[Define interfaces or DB schema changes]

### 2.2 UI/UX Workflow
[User interaction flow]

## 3. User Stories (The Backlog)
[Stories to be converted to tasks by Metis]
- [ ] **US-[XX].1**: [Title]
    - *Criteria:* [Acceptance Criteria]

## 4. Testing Plan
- [ ] **Unit:** Verify...
- [ ] **Integration:** Verify...
- [ ] **Manual:** Check...
```

**Key Output**: `specs/plan/XX-[name].md`

---

## Agent Selection Guidelines

1. **Simple task** → Use **Build** agent directly
2. **Complex parallelizable task** → Use **Boomerang** to orchestrate
3. **Need research only** → Use **Plan** agent
4. **Different AI perspective** → Use **Cursor** agent
5. **Browser interaction** → Use **Dev-Browser** agent

## Session Navigation

Child sessions created by Boomerang are navigable:
- `ctrl+right` → Navigate to child session
- `ctrl+left` → Navigate back to parent session

## Build & Run

The autonomous agent harness uses a loop-based approach for building projects:

### Ralph Loop (Autonomous Execution)
```bash
# Run Ralph to execute tasks from specs/prd.json
./ralph/build-loop.sh [max_iterations]
```

Ralph will:
1. Create a feature branch (from PRD `branchName`)
2. Pick the highest priority story where `passes: false`
3. Implement that single story
4. Run quality checks (typecheck, tests)
5. Commit if checks pass
6. Update `specs/prd.json` to mark story as `passes: true`
7. Append learnings to `specs/state/progress.md`
8. Repeat until all stories pass or max iterations reached

### Metis Loop (Planning)
```bash
# Run Metis to generate/ update specs/prd.json
./ralph/plan-loop.sh
```

Metis will:
1. Read the current phase spec from `specs/plan/XX-[name].md`
2. Generate or update `specs/prd.json` with prioritized tasks
3. Output `<promise>PLAN COMPLETE</promise>` when done

### Architect (Documentation)
The Architect agent is run interactively to generate project documentation:
- Phase 0-3: Generate `docs/` files (OVERVIEW, ARCHITECTURE, STATUS)
- Phase 4: Generate `specs/plan/` files (Master Plan and Phase Specs)

## Validation

Quality checks are critical for the autonomous loop to work correctly. Define validation commands in your project's `AGENTS.md`:

### Common Validation Patterns
```bash
# TypeScript type checking
npm run typecheck

# Linting
npm run lint

# Testing
npm run test

# Build verification
npm run build
```

### Ralph's Verification Workflow
After each task completion, Ralph:
1. Reads modified files to ensure they match requirements
2. Runs tests defined in `AGENTS.md` or `specs/plan/00-overview.md`
3. Checks the output to ensure it works as expected
4. Updates `specs/state/progress.md` with completion status

## Operational Notes

### Critical Success Factors

1. **Small, Atomic Tasks**
   - Each PRD item must fit in one context window
   - Right-sized stories: Add a column, update a component, add a filter
   - Avoid: "Build entire dashboard", "Add authentication"

2. **AGENTS.md Updates**
   - After each iteration, Ralph updates `AGENTS.md` with learnings
   - OpenCode reads these files automatically
   - Future iterations benefit from discovered patterns and gotchas

3. **Feedback Loops**
   - Typecheck catches type errors
   - Tests verify behavior
   - CI must stay green (broken code compounds across iterations)

4. **Browser Verification**
   - Frontend stories must include "Verify in browser using dev-browser agent"
   - Ralph uses dev-browser to navigate, interact, and confirm changes work

### Memory Between Iterations
Each iteration spawns a fresh session. Memory persists via:
- Git history (commits from previous iterations)
- `specs/state/progress.md` (learnings and context)
- `specs/prd.json` (which stories are done)

### Debugging the Loop
```bash
# See which stories are done
cat specs/prd.json | jq '.userStories[] | {id, title, passes}'

# See learnings from previous iterations
cat specs/state/progress.md

# Check git history
git log --oneline -10
```

### Stop Conditions
Ralph outputs `<promise>COMPLETE</promise>` when all stories have `passes: true`.
Metis outputs `<promise>PLAN COMPLETE</promise>` when `specs/prd.json` covers all work for the current phase.
