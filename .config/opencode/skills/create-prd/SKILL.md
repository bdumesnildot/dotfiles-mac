---
name: create-prd-linear
description: "Create a Product Requirements Document (PRD) for linear orchestration. Creates PRDs with user stories that will be converted to linear a fresh linear project with issues. Triggers on: create a prd, write prd for, plan this feature, requirements for."
---

# PRD Generator for Linear

Create PRDs that translate directly into Linear projects for agentic execution.

---

## Prerequisites

- Linear MCP must be enabled and operational
- If Linear MCP unavailable, inform user and halt
- Be extremely concise

---

## Workflow Overview

1. Gather requirements via clarifying questions
2. Create Linear project with PRD as description
3. Create Linear issues for each task
4. Create Progress document for tracking

**Important:** Do NOT implement. Only create artifacts.

---

## Step 1: Clarifying Questions

Ask questions one set at a time with lettered options for quick responses (e.g., "1A, 2C").

### Core Areas to Cover

- **Problem/Goal:** What problem does this solve?
- **Core Functionality:** What are the key actions?
- **Scope/Boundaries:** What should it NOT do?
- **Success Criteria:** How do we know it's done?
- **Integration:** How does it fit with existing features?
- **Quality Gates:** What commands must pass? (REQUIRED)

### Question Format

```
1. What is the primary goal?
   A. Option one
   B. Option two
   C. Option three

2. What quality commands must pass?
   A. pnpm typecheck && pnpm lint
   B. npm run typecheck && npm run lint
   C. bun run typecheck && bun run lint
   D. Other: [specify]
```

### Adaptive Questioning

After each response:

- Ask follow-ups if answers reveal complexity
- Move to new area if current is clear
- Proceed to Step 2 when sufficient context (typically 2-4 rounds)

---

## Step 2: Create Linear Project

Create a Linear project using MCP with:

- **Name:** Feature name (e.g., "Dark Mode for Admin TUI")
- **Team:** Attach to team Benoit (id: a6de754c-c383-4138-9fbb-3ca0886c6ffc), DO NOT attach to team Pragma web (id: 5b263ca9-9797-463c-900e-2b2a13206971)
- **Status:** Planned
- **Members:** benoit
- **Description:** Full PRD content (see structure below)

### Project Description Structure

```markdown
## Objective

Brief description of the feature and the problem it solves.

**Success Metrics:**

- Metric 1
- Metric 2

## Quality Gates

Commands that must pass for every task:

- `pnpm typecheck` - Type checking
- `pnpm lint` - Linting

## Definitions

Term definitions if needed.

## Feature Scope

### In Scope

- Feature 1
- Feature 2

### Out of Scope

- Non-goal 1
- Non-goal 2

## Technical Considerations

- Known constraints or dependencies
- Integration points
- Performance requirements

## Open Questions

- Remaining questions needing clarification
```

---

## Step 3: Create Linear Issues

For each task, create a Linear issue:

- **Team:** Attach to team Benoit (id: a6de754c-c383-4138-9fbb-3ca0886c6ffc), DO NOT attach to team Pragma web (id: 5b263ca9-9797-463c-900e-2b2a13206971)
- **Project:** Newly created project
- **Status:** Backlog
- **Priority:** Based on task importance and order
- **Labels:** Apply relevant labels
- **blockedBy:** Link dependencies using Linear's blockedBy feature if relevant

### Issue Structure

```markdown
[User story: As a [user], I want [feature] so that [benefit].]

## Acceptance Criteria

- [ ] Specific verifiable criterion
- [ ] Another criterion
- [ ] File path or code pattern reference if known

## Implementation Notes

- Relevant technical context
- Reference to existing patterns
```

### Task Guidelines

Each task must be:

- **Atomic:** Completable in ONE agent iteration with ONE commit
- **Independent:** Can be worked on without other incomplete tasks (use blockedBy for true dependencies)
- **Verifiable:** Acceptance criteria are machine-checkable where possible
- **Explicit:** Include file paths and code patterns when known

**Note:** Quality gates are defined once in project description. Agents run them automatically per ralph-linear workflow.

---

## Step 4: Create Progress Document

Create a Linear document named "Progress" in the project.

### Content

```markdown
# Progress Log

This document tracks implementation progress for the project.

## Usage

After completing each issue:

1. Add entry below with: task done, decisions made, files changed
2. Update if critical operational details learned

## Log

[Entries added during implementation]
```

---

## Example Flow

**User:** Create a PRD for adding dark mode to the TUI

**Assistant:** I'll help create a PRD. A few questions:

1. Primary goal?
   A. Reduce eye strain
   B. Match system theme
   C. Visual customization

2. Should setting persist?
   A. Yes, config file
   B. Session only
   C. Follow system preference

**User:** 1A, 2A

**Assistant:** A couple more:

3. Which components?
   A. All TUI components
   B. Main execution view only
   C. Main view + settings

4. Quality commands?
   A. pnpm typecheck && pnpm lint
   B. npm run typecheck && npm run lint
   C. Other: [specify]

**User:** 3A, 4A

**Assistant:** Creating Linear artifacts...

[Creates project "Dark Mode for Admin TUI" with PRD description]
[Creates issues: Theme config, Color palette, Apply to components, Settings toggle]
[Creates Progress document]

Done. Project URL: [link]

---

## Checklist

Before creating Linear artifacts:

- [ ] Asked clarifying questions with lettered options
- [ ] Asked about quality gates (REQUIRED)
- [ ] Tasks are atomic (one commit each)
- [ ] Tasks use blockedBy for dependencies
- [ ] Acceptance criteria are verifiable
- [ ] Quality gates in project description only (not per-issue)
