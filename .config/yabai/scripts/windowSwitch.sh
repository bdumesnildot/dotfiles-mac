#!/bin/bash
PATH="/opt/homebrew/bin:$PATH"

debug_log_file_path="/Users/bdumesnildot/.config/yabai/scripts/debug/windowSwitch.log"
echo "" > "$debug_log_file_path"
echo "windowSwitch - $(date)" >> "$debug_log_file_path"

space_list=$(yabai -m query --spaces)
spaces_id_array=($(echo "$space_list" | jq -r '.[].id'))
number_of_spaces=${#spaces_id_array[@]}
cur_space=$(yabai -m query --spaces --space)
cur_space_id=$(echo "$cur_space" | jq -r '.id')
cur_space_index=$(echo "$cur_space" | jq -r '.index')

window_list=$(yabai -m query --windows)
cur_window=$(yabai -m query --windows --window)
cur_window_id=$(echo "$cur_window" | jq -r '.id')

echo "\nSPACES =====================" >> "$debug_log_file_path"
echo "cur_space_id: $cur_space_id"  >> "$debug_log_file_path"
echo "space_list: $space_list"  >> "$debug_log_file_path"

echo "\nWINDOWS =====================" >> "$debug_log_file_path"
echo "cur_window_id: $cur_window_id" >> "$debug_log_file_path"

echo "\nLOGS FROM LOGIC =====================" >> "$debug_log_file_path"

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

# find the nex space where .windows is not empty
function find_next_space_with_win() {
  start_index=$1
  cur_index=$(loop_space_index "$start_index")
  cur_space=$(echo "$space_list" | jq --argjson index "$cur_index" '.[] | select(.index == $index)')
  # while current space has no window or current index is not the start index
  while [ "$(echo "$cur_space" | jq '.windows')" = "[]" ] && [ "$cur_index" -ne "$start_index" ]; do
    cur_index=$(loop_space_index "$cur_index")
    cur_space=$(echo "$space_list" | jq --argjson index "$cur_index" '.[] | select(.index == $index)')
  done
  echo "$cur_space"
}

# Set the focus to a new window
next_space_with_win=$(find_next_space_with_win "$cur_space_index")
next_win_id=$(echo "$next_space_with_win" | jq '[."first-window"][0]')
if [[ $next_win_id == 0 ]]; then
    next_win_id=$(echo "$next_space_with_win" | jq ."windows[0]")
fi

echo "cur_space: $cur_space" >> "$debug_log_file_path"
echo "next_space_with_win: $next_space_with_win" >> "$debug_log_file_path"
echo "cur_window: $cur_window" >> "$debug_log_file_path"
echo "next_win: $(yabai -m query --windows --window "$next_win_id")" >> "$debug_log_file_path"

if echo "$cur_space" | jq '[."type"]' | grep -qi "float"; then
    echo "==> layout float case" >> "$debug_log_file_path"
    yabai -m window --focus "$next_win_id"
else
    echo "==> layout bsp case" >> "$debug_log_file_path"
    yabai -m window --focus next 2>/dev/null || yabai -m window --focus "$next_win_id" 2>/dev/null
fi

# echo "current window: $(yabai -m query --windows --window )" >> "$debug_log_file_path"

# Log to console
cur_window_name=$(yabai -m query --windows --window | jq -r '.app')
echo "Yabai switch to window: $cur_window_name"