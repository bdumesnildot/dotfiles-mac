#!/bin/bash
PATH="/opt/homebrew/bin:$PATH"

current_layout=$(yabai -m query --spaces --space | jq -r '.type')

if [ "$current_layout" = "bsp" ]; then
    yabai -m query --windows --space | jq '.[].id' | xargs -I{} yabai -m window {} --toggle zoom-fullscreen
    yabai -m space --layout float
    echo "Yabai toggle from bsp to float"
else
    yabai -m space --layout bsp
    echo "Yabai toggle from float to bsp"
fi
