#!/usr/bin/env bash
# T3 Code project script (runOnWorktreeCreate).
# Links the main checkout's .env into a freshly created worktree, then installs deps.
set -euo pipefail

common_dir=$(git rev-parse --path-format=absolute --git-common-dir)
main_checkout=$(dirname "$common_dir")

link_env() {
  if [ "$main_checkout" = "$PWD" ]; then
    echo "main checkout, nothing to link"
    return
  fi

  if [ ! -f "$main_checkout/.env" ]; then
    echo "no .env in $main_checkout, skipped"
    return
  fi

  if [ -e .env ] || [ -L .env ]; then
    echo ".env already present, left untouched"
    return
  fi

  ln -s "$main_checkout/.env" .env
  echo "linked .env -> $main_checkout/.env"
}

link_env

if [ ! -f package.json ]; then
  echo "no package.json, skipping pnpm install"
  exit 0
fi

if ! command -v pnpm >/dev/null 2>&1; then
  echo "pnpm not found, skipping install"
  exit 0
fi

echo "running pnpm install"
pnpm install
