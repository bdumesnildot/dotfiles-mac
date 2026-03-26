---
description: Prepare production hotfix from PR number.
model: opencode/mimo-v2-pro-free
---

**important** use your skill `prod-hotfix-pragma-web` for this procedure.

# Hotfix Prod

Goal: backport one merged PR from `main` into `production` as a local hotfix commit.

Input PR number: `$ARGUMENTS`

## Hard rules

- NEVER push/create PR without explicit user yes.
- Only valid repo: `popina/pragma-web`.
- Commit only after explicit user yes.
- Ignore `.changeset/**` changes.

## Procedure

1. Validate input.
   - Require exactly one arg: `$1`.
   - `$1` must be numeric.
   - If invalid, stop with `INPUT_INVALID`.

2. Validate repository.
   - Run `git remote -v`.
   - Must match exactly:

```text
origin  git@github.com:popina/pragma-web.git (fetch)
origin  git@github.com:popina/pragma-web.git (push)
```

- If mismatch, stop with `REPO_MISMATCH`.

3. Prepare production base.
   - Require clean tree first: `git status --porcelain` must be empty, else stop `DIRTY_TREE`.
   - `git fetch origin production --prune`.
   - If branch `production` exists: `git switch production`.
   - Else: `git switch -c production --track origin/production`.
   - Sync strictly: `git merge --ff-only origin/production`.
   - Create working branch from production: `git switch -c hotfix/pr-$1-$(date +%Y%m%d)`.

4. Fetch and evaluate PR with `gh`.
   - Run `gh auth status -h github.com`, stop on failure (`GH_AUTH_REQUIRED`).
   - Run `gh pr view $1 --repo popina/pragma-web --json number,title,url,state,baseRefName,headRefName,mergeable,files,commits`.
   - PR must be merged and based on `main`, else stop `PR_NOT_MERGED_ON_MAIN`.
   - Briefly explain impact/risk from changed files.

5. Apply PR changes.
   - Get commit SHAs: `gh pr view $1 --repo popina/pragma-web --json commits --jq '.commits[].oid'`.
   - Apply all commits without committing: `git cherry-pick -n <sha1> <sha2> ...`.
   - If conflict, stop with `APPLY_CONFLICT`, show conflicted files, suggest `git cherry-pick --abort`.
   - Remove changesets: `git restore --staged --worktree .changeset` (if present).

6. Validate impacted scope.
   - Detect impacted workspaces from changed paths under `apps/*` and `packages/*`.
   - Run typecheck and lint for impacted workspaces only.
   - If mapping unclear, run repo-level fallback checks and say fallback used.
   - On failure, stop with `VALIDATION_FAILED` and do not commit.

7. Review and ask before commit.
   - Show concise review: `git status -s` + changed file summary.
   - Propose commit message prefixed by `hotfix/`.
   - Explain what was applied and that `.changeset/**` was excluded.
   - Ask explicit question: `Create commit now? (yes/no)`.

8. Commit only on explicit yes.
   - If user says yes: create commit with proposed message.
   - Show result with `git show --stat --oneline -1`.
   - If user says no: stop cleanly with no commit.

9. Optional push + PR (only after commit).
   - Ask explicit question: `Push branch and open PR to production now? (yes/no)`.
   - If user says yes:
     - Push branch: `git push -u origin hotfix/pr-$1-$(date +%Y%m%d)`.
     - Create PR with `gh` targeting `production` from current branch.
     - Title should be concise, prefixed `hotfix/`.
     - Body must include:
       - Origin PR mention: `Backport of #$1`.
       - What changed (short file/area summary).
       - Why/purpose for production.
   - If user says no: stop cleanly, local commit only.

10. End procedure.

- Re-state final state: pushed+PR opened, or local-only if declined.

<current-branch>
`!git rev-parse --abbrev-ref HEAD`
</current-branch>

<git-remote>
`!git remote -v`
</git-remote>

<git-status>
`!git status -s`
</git-status>
