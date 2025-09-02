---
description: Manages context across multiple agents and long-running tasks. Use when coordinating complex multi-agent workflows or when context needs to be preserved across multiple sessions. MUST BE USED for projects exceeding 10k tokens.
mode: subagent
model: anthropic/claude-opus-4-20250514
temperature: 0.1
tools:
  write: true
  edit: true
  bash: true
  read: true
  grep: true
  glob: true
---

