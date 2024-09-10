#!/bin/bash
# This script toggles the refresh rate of the main display

DISPLAY_NAME=$(xrandr | grep " connected" | awk '{ print $1 }')

if [ "$DESKTOP_SESSION" = plasma ]; then
    CURRENT_RATE=$(kscreen-doctor -o | grep -Eo '[[:digit:]]+\*' | grep -Eo '[[:digit:]]+')

    CURRENT_RES=$(kscreen-doctor -o | grep -Eo '[[:digit:]]+x[[:digit:]]+@[[:digit:]]+\*' | grep -Eo '[[:digit:]]+x[[:digit:]]+')
    
    NEW_RATE=$((165 + 60 - $((CURRENT_RATE))))

    kscreen-doctor output."$DISPLAY_NAME".mode."$CURRENT_RES"@"$NEW_RATE" 

    kdialog --title "Display Config" --msgbox "Display $DISPLAY_NAME set to $CURRENT_RES@$NEW_RATE"
else
    # xrandr
    CURRENT_RES=$(xrandr | grep -Eo '.*\*' | awk '{ print $1 }')
    NEW_RATE=$(xrandr | grep -E '.*\*' | grep -Eo '[[:digit:]]*\.[[:digit:]]* \+' | grep -Eo '[[:digit:]]*\.[[:digit:]]*')
    if [[ $NEW_RATE =~ [0-9|\.]* ]]; then
        xrandr --output "$DISPLAY_NAME" --mode "$CURRENT_RES" --rate "$NEW_RATE"
        zenity --title "Display Config" --info --text "Display $DISPLAY_NAME set to $CURRENT_RES@$NEW_RATE" 
    else
        zenity --title "Display Config" --error --text "Could not use xrandr to change refresh rate"
    fi	
fi
