---
name: create-prd
description: "Create a Product Requirements Document (PRD) through interactive clarifying questions. Can use grill-me skill for thorough exploration. Triggers on: create a prd, write prd for, plan this feature, requirements for."
---

# PRD Creator

Create comprehensive PRDs through clarifying questions. Gather requirements interactively before synthesizing into structured document.

---

## Process

1. **Gather requirements** through clarifying questions
   - Invoke `/grill-me` skill for thorough exploration
   - Ask questions one at a time with lettered options for quick responses (e.g., "1A, 2C")
   - Cover all core areas (see below)

2. **Explore codebase** to understand current state
   - Use project's domain vocabulary
   - Identify existing patterns
   - Respect ADRs in relevant areas

3. **Define testing seams** where feature will be tested
   - Prefer existing seams
   - Use highest seam possible
   - Check with user on seam choices

4. **Generate PRD** using template below

---

## Step 1: Clarifying Questions

Ask questions one set at a time with lettered options for quick responses.

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
- Consider using `/grill-me` for complex features
- Proceed to PRD generation when sufficient context (typically 2-4 rounds)

---

## PRD Template

### Problem Statement

The problem from the user's perspective.

### Solution

The solution from the user's perspective.

**Success Metrics:**

- Metric 1
- Metric 2

### User Stories

Extensive numbered list covering all aspects:

```
1. As a [role], I want [feature], so that [benefit]
2. As a [role], I want [feature], so that [benefit]
...
```

### Implementation Decisions

Key decisions made:

- Modules to build/modify
- Interface changes
- Technical clarifications
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

**Note:** Avoid specific file paths or code snippets (become outdated quickly).

**Exception:** If prototype produced decision-encoding snippet (state machine, reducer, schema, type), inline it with note it's from prototype. Trim to decision-rich parts.

### Testing Decisions

- What makes a good test (test external behavior, not implementation)
- Which modules will be tested
- Testing seams identified
- Prior art for tests in codebase

### Quality Gates

Commands that must pass:

```bash
pnpm typecheck  # Type checking
pnpm lint       # Linting
pnpm test       # Tests
```

Adjust based on project's tooling.

### Feature Scope

#### In Scope

- Feature 1
- Feature 2

#### Out of Scope

- Non-goal 1
- Non-goal 2

### Technical Considerations

- Known constraints or dependencies
- Integration points
- Performance requirements

### Open Questions

- Remaining questions needing clarification

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

**Assistant:** [Generates PRD with gathered requirements]

---

## Output

Present PRD as markdown document. Offer to:

- Save to file
- Publish to issue tracker if integration available
- Create Linear project using `/to-linear-prd` skill
