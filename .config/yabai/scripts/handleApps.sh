#!/bin/bash

debug_log_file_path="/Users/bdumesnildot/.config/yabai/scripts/debug/handleApps.log"
app_name="$1"

echo "" > "$debug_log_file_path"
echo "=====================> $(date)" >> "$debug_log_file_path"
echo "app_name: $app_name" >> "$debug_log_file_path"
# echo "first check: $(pgrep -f "$app_name")"

# Check if the application is running
if pgrep -f "$app_name" > /dev/null; then
    pid_array=($(pgrep -f "$app_name")) # array of all running apps' PIDs
    app_array=($(yabai -m query --windows | jq '.[].app' | sort | uniq)) # array of all running apps
    apps_data=$(yabai -m query --windows) # yabai object of all running apps
    target_app_data=$(echo "$apps_data" | jq --argjson filter "$pid_array" '.[] | select(.pid | IN($filter))') # yabai objects of the target app windows
    target_app_id_array=($(echo "$target_app_data" | jq -r '.id')) # array of all target app's IDs

    echo "app_array: ${app_array[@]}" >> "$debug_log_file_path"
    echo "pid_array: ${pid_array[@]}" >> "$debug_log_file_path"
    echo "apps_data: $apps_data" >> "$debug_log_file_path"
    echo "target_app_data: $target_app_data" >> "$debug_log_file_path"
    echo "target_app_id_array: ${target_app_id_array[@]}" >> "$debug_log_file_path"

    # If the application is running but has no window,
    if [ "${#target_app_id_array[@]}" -eq 0 ]; then
        # echo "==> No window case"
        open -a "$app_name"

    # If the application has only one window,
    elif [ "${#target_app_id_array[@]}" -eq 1 ]; then
        # echo "==> Single window case"

        # Check if the application is visible in any space
        if echo "$target_app_data" | jq '.["is-visible"]' | grep -qi "true"; then
            # Check if the application is focused
            if echo "$target_app_data" | jq '.["has-focus"]' | grep -qi "true"; then
                # If the application is focused, minimize it
                yabai -m window --minimize "$(echo "$target_app_data" | jq -r '.id')"
            else
                # If the application is not focused, focus it
                yabai -m window --focus "$(echo "$target_app_data" | jq -r '.id')"
            fi
        else
            # If the application is not visible, open it in the current space
            open -a "$app_name"
        fi

    # If the application has multiple windows,
    else
        # echo "==> Multiple windows case"

        target_app_visible_and_focused_id_array=($(echo "$target_app_data" | jq '. | select(.["is-visible"] == true and .["has-focus"] == true) | .id'))
        target_app_visible_and_not_focused_id_array=($(echo "$target_app_data" | jq '. | select(.["is-visible"] == true and .["has-focus"] == false) | .id'))
        target_app_not_visible_id_array=($(echo "$target_app_data" | jq '. | select(.["is-visible"] == false) | .id'))

        # echo "target_app_visible_and_focused_id_array: ${target_app_visible_and_focused_id_array[@]}"
        # echo "target_app_visible_and_not_focused_id_array: ${target_app_visible_and_not_focused_id_array[@]}"
        # echo "target_app_not_visible_id_array: ${target_app_not_visible_id_array[@]}"

        # If the application has a focused window, minimize it
        if [ "${#target_app_visible_and_focused_id_array[@]}" -gt O ]; then
            # echo "==> Focused window case"
            yabai -m window --minimize "${target_app_visible_and_focused_id_array[0]}"

        # If the application has a visible but not focused window, focus the first one
        elif [ "${#target_app_visible_and_not_focused_id_array[@]}" -gt 0 ]; then
            # echo "==> Visible but not focused window case"
            yabai -m window --focus "${target_app_visible_and_not_focused_id_array[0]}"

        # If the application has windows but none are visible, open the first one
        elif [ "${#target_app_not_visible_id_array[@]}" -gt 0 ]; then
            # echo "==> Not visible window case"
            yabai -m window --focus "${target_app_not_visible_id_array[0]}"
        else 
            # echo "==> No window case"
            open -a "$app_name"
        fi
    fi

# If the application is not running, open it in the current space
else
    # echo "==> Not running case"
    open -a "$app_name"
fi
