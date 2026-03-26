#!/bin/bash
# ralph-linear: Linear-driven Ralph workflow
# Usage: ralph-linear <project-name> [max-iterations]
#
# State lives in Linear:
# - Project description = scope
# - Issues = tasks
# - "Progress" document = progress log

set -e

export OPENCODE_CONFIG="$HOME/.dotfiles/.config/opencode/ralph/opencode-ralph.json"

PROJECT_NAME="${1:?Usage: ralph-linear <project-name> [max-iterations]}"
MAX_ITER="${2:-50}"


rm -f .ralph-done

# Verify Linear MCP is active and connected
if ! opencode mcp list | grep "linear" | grep -qE "connected"; then
    echo "❌ Error: Linear MCP is not connected."
    exit 1
fi

echo "✅ Linear MCP is connected. proceeding..."

# Main loop
for ((i = 1; i <= MAX_ITER; i++)); do
	[ -f .ralph-done ] && echo "✅ Done." && exit 0
	echo "🔄 Iteration $i"
	opencode run -m github-copilot/claude-sonnet-4.6 "
Use Linear MCP to fetch project $PROJECT_NAME: description, issues, and Progress document related to the project.
Pick ONE incomplete issue (YOU HAVE TO CHOOSE ONLY ONE). Use priority and dependencies (Linear blockedBy) to decide.
Complete it. Run feedback loops (types, tests, lint).
Commit the change.
Mark the Linear issue as Done via MCP.
Append to the Progress Linear document from the project: task done, decisions, files changed.
If critical operational detail learned, update AGENTS.md.
If ALL issues complete, create .ralph-done file.
DO ONLY ONE TASK PER ITERATION.
NEVER GIT PUSH. ONLY COMMIT.
"
done
echo "🛑 Max iterations reached."
