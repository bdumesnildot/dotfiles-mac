---
name: to-linear-prd
description: "Convert PRD to Linear orchestration artifacts. Creates Linear project, issues, and progress document from an existing PRD. Use when you have a PRD and want to create Linear project structure."
---

# Linear PRD Orchestrator

Convert existing PRD into Linear project with issues and tracking. Delegates PRD creation to `/create-prd` skill.

---

## Prerequisites

- Linear MCP must be enabled and operational
- If Linear MCP unavailable, inform user and halt
- Be extremely concise

---

## Workflow Overview

1. Get PRD content (use `/create-prd` skill if needed)
2. Create Linear project with PRD as description
3. Create Linear issues for each task
4. Create Progress document for tracking

**Important:** Do NOT implement. Only create artifacts.

---

## Step 1: Get PRD

If PRD doesn't exist, invoke `/create-prd` skill first.

If PRD exists (from conversation or file), proceed to Step 2.

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

**User:** Create Linear project for my dark mode PRD

**Assistant:** [Reviews PRD from conversation or asks for it]

Creating Linear artifacts...

[Creates project "Dark Mode for Admin TUI" with PRD description]
[Creates issues: Theme config, Color palette, Apply to components, Settings toggle]
[Creates Progress document]

Done. Project URL: [link]

---

## Checklist

Before creating Linear artifacts:

- [ ] PRD exists (or invoked `/create-prd`)
- [ ] Tasks are atomic (one commit each)
- [ ] Tasks use blockedBy for dependencies
- [ ] Acceptance criteria are verifiable
- [ ] Quality gates in project description only (not per-issue)
