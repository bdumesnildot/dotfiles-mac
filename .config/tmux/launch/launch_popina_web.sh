#!/bin/bash

# Name of the session to be created
SESSION_NAME="popina"

# ----------------------------------------------------
# WARNING: Checks if the session already exists
# ----------------------------------------------------
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo "The session '$SESSION_NAME' already exists. Attaching..."
  tmux attach-session -t "$SESSION_NAME"
  exit 0
fi

# ----------------------------------------------------
# 1. Session Creation (Window 1)
# ----------------------------------------------------
# Creates a new named session and the FIRST window detached.
# IMPORTANT: ~/.tmux.conf uses "set -g base-index 1" and "setw -g pane-base-index 1", so the first window will be at index 1, not 0.
tmux new-session -d -s "$SESSION_NAME" -n "home"
tmux send-keys -t "$SESSION_NAME:home" "cd ~" C-m

# ----------------------------------------------------
# 2. Creation of Subsequent Windows (Starting from index 1)
# ----------------------------------------------------

# Window 1: .dotFiles (Created at the next available index, likely 1)
tmux new-window -t "$SESSION_NAME":2 -n ".dotFiles"
tmux send-keys -t "$SESSION_NAME":2 "cd ~/.dotfiles" C-m

# Window 2: pragma-project-MAIN
tmux new-window -t "$SESSION_NAME":3 -n "pragma-project-MAIN"
tmux send-keys -t "$SESSION_NAME":3 "cd ~/dev/pragma-project-main" C-m

# Window 3: pragma-project-REVIEW
tmux new-window -t "$SESSION_NAME":4 -n "pragma-project-REVIEW"
tmux send-keys -t "$SESSION_NAME":4 "cd ~/dev/pragma-project-review" C-m

# Window 4: pragma-project-AGENT
tmux new-window -t "$SESSION_NAME":5 -n "pragma-project-AGENT"
tmux send-keys -t "$SESSION_NAME":5 "cd ~/dev/pragma-project-agent" C-m

# Window 5: pragma-project-DEV (The one that needs to be active)
tmux new-window -t "$SESSION_NAME":6 -n "pragma-project-DEV"
tmux send-keys -t "$SESSION_NAME":6 "cd ~/dev/pragma-project" C-m

# ----------------------------------------------------
# 3. Finalization and Attachment
# ----------------------------------------------------

# Selects the "pragma-project-DEV" window (index 5) to be active
tmux select-window -t "$SESSION_NAME":5

# Attaches the session to the terminal
echo "Session '$SESSION_NAME' created successfully. Attaching..."
tmux attach-session -t "$SESSION_NAME"