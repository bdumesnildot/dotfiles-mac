---
name: prod-hotfix-pragma-web
description: Prepare production hotfix from PR number for `popina/pragma-web`. Backport one merged PR from `main` to `production` safely with strict validation and user confirmation at each step. Exclude `.changeset/**` from hotfix.
---

# Production Hotfix Runbook (`popina/pragma-web`)

Backport one merged PR from `main` to `production` safely.

## Rules

- Input must be one numeric PR id.
- Repo must be `popina/pragma-web`.
- No commit/push/PR without explicit `yes`.
- Exclude `.changeset/**` from hotfix.

## 1) Validate input

```bash
PR=<number>
test -n "$PR" && [[ "$PR" =~ ^[0-9]+$ ]] || { echo "INPUT_INVALID"; exit 1; }
```

## 2) Validate repository

```bash
git remote -v
```

Must be exactly:

```text
origin  git@github.com:popina/pragma-web.git (fetch)
origin  git@github.com:popina/pragma-web.git (push)
```

If not, stop: `REPO_MISMATCH`.

## 3) Prepare clean `production` base

```bash
test -z "$(git status --porcelain)" || { echo "DIRTY_TREE"; exit 1; }
git fetch origin production --prune
git switch production 2>/dev/null || git switch -c production --track origin/production
git merge --ff-only origin/production
BR="hotfix/pr-$PR-$(date +%Y%m%d)"
git switch -c "$BR"
```

## 4) Validate PR with GitHub CLI

```bash
gh auth status -h github.com || { echo "GH_AUTH_REQUIRED"; exit 1; }

gh pr view "$PR" --repo popina/pragma-web \
  --json number,title,url,state,baseRefName,headRefName,mergeable,files,commits
```

Checks:

- PR must be merged.
- `baseRefName` must be `main`.

Else stop: `PR_NOT_MERGED_ON_MAIN`.

## 5) Apply PR commits (no commit yet)

```bash
SHAS=$(gh pr view "$PR" --repo popina/pragma-web --json commits --jq '.commits[].oid')
git cherry-pick -n $SHAS || { echo "APPLY_CONFLICT"; git status -s; echo "Run: git cherry-pick --abort"; exit 1; }
git restore --staged --worktree .changeset 2>/dev/null || true
```

## 6) Validate changed scope

- Identify impacted workspaces from changed files in `apps/*` and `packages/*`.
- Run lint + typecheck for impacted workspaces only.
- If unclear mapping, run repo-level fallback checks and note fallback.
- If any fail, stop: `VALIDATION_FAILED` (no commit).

## 7) Review and ask before commit

```bash
git status -s
git diff --name-only
```

Propose message format:

```text
hotfix/<short-why>
```

Ask: `Create commit now? (yes/no)`

## 8) Commit only on explicit `yes`

```bash
git commit -m "hotfix/<short-why>"
git show --stat --oneline -1
```

If `no`: stop cleanly (no commit).

## 9) Optional push + PR (explicit `yes` only)

Ask: `Push branch and open PR to production now? (yes/no)`

If yes:

```bash
git push -u origin "$BR"
gh pr create --repo popina/pragma-web \
  --base production \
  --head "$BR" \
  --title "hotfix/<short-title>" \
  --body "Backport of #$PR

What changed:
- <short file/area summary>

Why:
- <production reason>"
```

## 10) End state

Report one of:

- Local hotfix commit only.
- Branch pushed + PR opened to `production`.
