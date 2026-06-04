---
name: to-prd
description: Turn the current conversation context into a PRD. Synthesizes conversation and codebase understanding into a structured Product Requirements Document. Use when user wants to create a PRD from current context or mentions "to prd", "create prd", "write prd".
---

# PRD Generator

Synthesize current conversation context and codebase understanding into a structured PRD. Do NOT interview the user — work with what you already know.

---

## Process

1. **Explore the codebase** to understand current state if not already done
   - Use project's domain vocabulary throughout PRD
   - Respect existing ADRs in relevant areas
   - Identify existing patterns and conventions

2. **Define testing seams** where feature will be tested
   - Prefer existing seams over new ones
   - Use highest seam possible
   - If new seams needed, propose at highest point

   Check with user that seams match expectations.

3. **Write and publish PRD** using template below

---

## PRD Template

### Problem Statement

The problem from the user's perspective.

### Solution

The solution from the user's perspective.

### User Stories

Extensive numbered list of user stories:

```
1. As a [role], I want [feature], so that [benefit]
2. As a [role], I want [feature], so that [benefit]
...
```

Cover all aspects of the feature comprehensively.

### Implementation Decisions

List of key decisions made:

- Modules to build/modify
- Interface changes
- Technical clarifications
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

**Note:** Avoid specific file paths or code snippets (they become outdated quickly).

**Exception:** If prototype produced a snippet that encodes a decision more precisely than prose (state machine, reducer, schema, type shape), inline it within the relevant decision. Note it came from prototype. Trim to decision-rich parts only.

### Testing Decisions

- Description of what makes a good test (test external behavior, not implementation details)
- Which modules will be tested
- Prior art for tests (similar tests in codebase)
- Testing seams identified earlier

### Quality Gates

Commands that must pass for every task:

```bash
pnpm typecheck  # Type checking
pnpm lint       # Linting
pnpm test       # Tests
```

Adjust based on project's tooling.

### Out of Scope

Things explicitly NOT included in this PRD.

### Further Notes

Any additional context or considerations.

---

## Output

Present PRD as markdown document. If user has issue tracker integration (Linear, GitHub Issues, etc.), offer to publish it there.
