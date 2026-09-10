#!/bin/bash
PATH="/opt/homebrew/bin:$PATH"

debug_log_file_path="/Users/bdumesnildot/.config/yabai/scripts/debug/monitorSwitch.log"
echo "" > "$debug_log_file_path"
echo "windowSwitch - $(date)" >> "$debug_log_file_path"

space_list=$(yabai -m query --spaces)
spaces_id_array=($(echo "$space_list" | jq -r '.[].id'))
number_of_spaces=${#spaces_id_array[@]}
cur_space=$(yabai -m query --spaces --space)
cur_space_id=$(echo "$cur_space" | jq -r '.id')
cur_space_index=$(echo "$cur_space" | jq -r '.index')

cur_window=$(yabai -m query --windows --window)
cur_window_id=$(yabai -m query --windows --window | jq '.id')

# Debug logs
echo "\nSPACES =====================" >> "$debug_log_file_path"
echo "space_list: $space_list" >> "$debug_log_file_path"
echo "cur_space_id: $cur_space_id" >> "$debug_log_file_path"
echo "\nWINDOWS =====================" >> "$debug_log_file_path"
echo "cur_window $cur_window" >> "$debug_log_file_path"

# loop on spaces
function loop_space_index() {
  start_index=$1
  next_space_index=$start_index
  if [ "$start_index" -eq "$number_of_spaces" ]; then
    next_space_index=1
  else
    (( next_space_index = start_index + 1 ))
  fi
  echo "$next_space_index"
}

# Move the window to the next space
next_space_index=$(loop_space_index "$cur_space_index")
yabai -m window --display "$next_space_index"

# Focus the moved window
yabai -m window --focus "$cur_window_id"

current_layout=$(yabai -m query --spaces --space | jq '.type')
echo "current_layout: $current_layout" >> "$debug_log_file_path"

# If the current layout is not bsp, switch to bsp
if [ "$current_layout" != "\"bsp\"" ]; then
  yabai -m config layout bsp
fi

# Swap the moved window with the last focused window
yabai -m window --swap last

# Log to console
echo "Switched to next monitor (id: $next_space_index)"