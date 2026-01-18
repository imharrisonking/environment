---
description: Start a new project discovery interview with the Architect agent
---

# New Project Discovery

Invoke the Architect agent to begin Phase 1.1: Project Discovery.

## What Happens

The Architect will:
1. Interview you about your project vision and goals
2. Load context from documents/URLs you provide
3. Identify Jobs to Be Done (JTBD)
4. Generate `specs/project_spec.md`

## Providing Context

You can share:
- **Markdown files**: Paste content or provide file paths
- **URLs**: Links to references, docs, examples
- **Company docs**: Background on your organization
- **Existing code**: Architect can explore your current codebase

## Complete Workflow

```
/new-project              → Phase 1.1 → specs/project_spec.md (JTBD outline)
[clear context]
opencode --agent architect → Phase 1.2 → Updated with topics
[clear context if needed]
/expand-specs             → Phase 1.3 → specs/*.md files
./specs/plan-loop.sh      → Phase 2   → specs/prd.json
./specs/build-loop.sh     → Phase 3   → Implementation
```

## Example

```
> /new-project A mood board app for designers at my company Memo

Architect: Great! Let's explore this idea. First, can you share any docs about Memo I should review?
```
