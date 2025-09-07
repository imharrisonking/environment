---
description: Create a GitHub issue using the description provided
agent: plan
model: anthropic/claude-opus-4-20250514
---

"Analyze the following feature request and create a comprehensive GitHub issue respecting the architecture and style defined in the CLAUDE.md file: #$ARGUMENTS

## Preparation Assessment

**Before creating the issue, complete this preparation assessment:**

### 1. Change Overview

**Please confirm back to me the overview of the change you are being requested to implement?**

### 2. Package Dependencies

**Please confirm what, if any, additional packages are required to implement the requested changes?**

- If no additional packages are required please answer "None"

### 3. File Updates

**Based on the requested change please identify which files you will be updating?**

- Please provide these in a simple list. If no existing files are being updated please answer "None"

### 4. New Files

**Based on the request change please list what new files you will be creating?**

- Please provide these in a simple list. If no new files are required, please answer "None"

## Risk Assessment

### 1. Implementation Risks

**Do you foresee any significant risks in implementing this functionality?**

- If risks are minor, please answer "No". If risks are more than minor please answer "Yes", then provide details on the risks you foresee and how to mitigate against them.

### 2. Breaking Changes

**What other parts of the application may break as a result of this change?**

- If there are no breaking changes you can identify, please answer "None identified". If you identify potential breaking changes, please provide details on the potential breaking changes.

### 3. Performance Impact

**Could this change have any material effect on application performance?**

- If "No", please answer "No". If "Yes", please provide details on performance implications.

### 4. Security Considerations

**Are there any security risks associated with this change?**

- If "No", please answer "No". If "Yes", please provide details on the security risks you have identified.

## Implementation Plan

### 1. Dependencies

**Please detail the dependencies that exist between the new functions / components / files you will be creating?**

### 2. Implementation Strategy

**Should this change be broken into smaller safer steps?**

- If the answer is "No", please answer "No"

### 3. Verification Plan

**How will you verify that you have made all of the required changes correctly?**

---

## Now Create the GitHub Issue

Based on your analysis above, create the GitHub issue using the gh CLI.

### Available Labels in this Repository

- `bug` - Something isn't working
- `documentation` - Improvements or additions to documentation
- `enhancement` - New feature or request

### Generate the Command

Create the actual `gh issue create` command with:

**Title**: Format as `[TYPE] Brief descriptive title` where TYPE is one of: FEATURE, BUG, ENHANCEMENT, REFACTOR, DOCS

**Body**: Structure the issue body with these sections:

- **Description**: Clear, detailed description of the functionality to be implemented
- **Acceptance Criteria**: Specific, testable criteria derived from your analysis
- **Implementation Notes**: Key points from your assessment with a step by step plan to implement the change:
    - Files to be created/modified
    - Key dependencies identified
    - Any risks or considerations to keep in mind
    - Verification approach
- **Technical Details**: Any constraints or architectural decisions from your analysis

**Labels**: Based on the type of issue, select from available labels:

- For new features or enhancements: `enhancement`
- For bugs: `bug`
- For documentation: `documentation`
- For refactoring: `refactor`

### Command Format

**For Complex Issues (Recommended):**
Use the temporary file approach to avoid shell escaping issues:

```bash
# Step 1: Create issue content file
cat > /tmp/gh-issue.md <<'EOF'
## Description
[Your description here]

## Acceptance Criteria
[Your criteria here]

## Implementation Notes
[Your notes here]

## Technical Details
[Your technical details here]
EOF

# Step 2: Create issue from file
gh issue create --title "[TYPE] Brief descriptive title" --body-file /tmp/gh-issue.md --label "appropriate-label" --assignee "@me"

# Step 3: Clean up
rm /tmp/gh-issue.md
```

**For Simple Issues:**
Use direct string format for issues without code blocks or complex markdown:

```bash
gh issue create --title "[TYPE] Brief descriptive title" --body "## Description

[Simple description without backticks or complex formatting]

## Acceptance Criteria

- [ ] Criteria 1
- [ ] Criteria 2

## Implementation Notes

[Basic notes without code blocks]" --label "appropriate-label" --assignee "@me"
```

**For Interactive Mode (Safest):**
Use GitHub CLI's interactive mode for complex issues:

```bash
gh issue create --title "[TYPE] Brief descriptive title" --label "appropriate-label" --assignee "@me"
# This opens an editor where you can paste the full markdown content safely
```

### Final Command Output

Provide the complete `gh issue create` command ready to execute, using the heredoc format shown above to avoid formatting errors with multi-line content.

---

**Note**: All assessment work above should inform the issue creation but the final GitHub issue should be concise and actionable, focusing on what needs to be built rather than the analysis process."
