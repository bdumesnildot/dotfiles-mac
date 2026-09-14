---
description: Start an agent session on a Linear issue inside a T3 worktree.
argument-hint: <linear-issue-id-or-url>
model: claude-sonnet-5
---

# Work on Linear Issue

Goal: pick up a Linear issue in this worktree — fetch the issue, align the branch name to it, then decide whether to start planning or gather more context first.

Input: `$ARGUMENTS`

## Assumptions

- This runs inside a T3 worktree that was already created for this thread. T3's `runOnWorktreeCreate` project script (e.g. `worktree-setup.sh`) has already linked `.env` and installed deps. This command does not create or set up the worktree — it only operates inside one that exists.

## Hard rules

- Never commit or push.
- Never rename the branch while on `main`/`master`, or if it would strand uncommitted work.

## Procedure

1. Validate input.
   - Require exactly one arg: `$ARGUMENTS`.
   - If empty, stop with `INPUT_INVALID`.

2. Resolve the issue identifier.
   - If `$ARGUMENTS` is a URL (e.g. `https://linear.app/<workspace>/issue/<ID>/<slug>`), extract `<ID>`.
   - Otherwise treat `$ARGUMENTS` as the identifier directly (e.g. `LIN-123`).

3. Fetch the issue.
   - Call `mcp__claude_ai_Linear__get_issue` with the resolved id, `includeRelations: true`.
   - If not found, stop with `ISSUE_NOT_FOUND`.

4. Rename the local branch to match the issue.
   - Check `git branch --show-current` and `git status --porcelain` first.
   - If current branch is `main` or `master`, stop with `ON_DEFAULT_BRANCH` (wrong place to run this — should be inside the dedicated worktree).
   - Run `git branch -m <gitBranchName>` using the branch name returned by the issue fetch.
   - If that branch name already exists, stop with `BRANCH_NAME_CONFLICT` instead of forcing it — report the conflict and let the user decide.

5. Evaluate readiness — lightly, not a deep dive.
   - Read the issue's title, description, comments, and any linked attachments/relations.
   - Skim the codebase areas the issue points at, just enough to judge scope.
   - Judge: clear acceptance criteria? scope identifiable? no open questions blocking a plan?

6. Branch on the evaluation.
   - **Enough context:** say briefly why, then start planning the implementation (enter plan mode).
   - **Not enough context:** list exactly what's missing (e.g. no acceptance criteria, ambiguous scope, unresolved design question). Suggest running `/grill-me` to interview the user and fill in the Linear issue before any planning starts. Do not start planning.

<current-branch>
`!git rev-parse --abbrev-ref HEAD`
</current-branch>

<git-status>
`!git status -s`
</git-status>
</content>
