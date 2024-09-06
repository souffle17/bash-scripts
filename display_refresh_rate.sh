#!/bin/bash
# This script toggles the refresh rate of the main display

DISPLAY_NAME=$(xrandr | grep " connected primary" | awk '{ print $1 }')

#if [ "$DESKTOP_SESSION" = plasma ]; then
if true; then
    CURRENT_RATE=$(kscreen-doctor -o | grep -Eo '[[:digit:]]+\*' | grep -Eo '[[:digit:]]+')

    CURRENT_RES=$(kscreen-doctor -o | grep -Eo '[[:digit:]]+x[[:digit:]]+@[[:digit:]]+\*' | grep -Eo '[[:digit:]]+x[[:digit:]]+')
    
    NEW_RATE=$((165 + 60 - $((CURRENT_RATE))))

    kscreen-doctor output."$DISPLAY_NAME".mode."$CURRENT_RES"@"$NEW_RATE" 

    kdialog --title "Display Config" --msgbox "Display $DISPLAY_NAME set to $CURRENT_RES@$NEW_RATE"
else
    # TODO
    true
fi