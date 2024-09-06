#!/bin/bash
# This script finds the strongest access point in a network, connects to it with NetworkManager, and locks the BSSID

# DE-specific dialog boxes
if [ "$DESKTOP_SESSION" = plasma ]; then
    DIALOG_COMMAND="kdialog"
    DIALOG_ENTRY_ARGUMENT="--inputbox"
    DIALOG_ERROR_ARGUMENT="--error"
else
    DIALOG_COMMAND="zenity"
    DIALOG_ENTRY_ARGUMENT="--entry --text"
    DIALOG_ERROR_ARGUMENT="--error --text"
fi

# Prompt the user to enter the SSID
SSID=$($DIALOG_COMMAND --title "Access Point Connection" $DIALOG_ENTRY_ARGUMENT "Please enter the SSID: ")

if [ -z "$SSID" ]; then
    $DIALOG_COMMAND $DIALOG_ERROR_ARGUMENT "SSID cannot be empty"
    exit 1
fi

nmcli device wifi rescan

SSID_EXISTS=$(nmcli -t -f SSID device wifi list | awk -v ssid="$SSID" -F ':' '$1 == ssid {print $1}')

if [ -z "$SSID_EXISTS" ]; then
    $DIALOG_COMMAND $DIALOG_ERROR_ARGUMENT "SSID '$SSID' not found in the list of available networks."
    exit 1
fi

# Check for the access point with the strongest signal
STRONGEST_BSSID=$(nmcli -f SSID,BSSID,SIGNAL device wifi list | grep "$SSID" | sort -k3 -nr | head -n1 | awk '{print $2}')

nmcli connection modify "$SSID" wifi.bssid "$STRONGEST_BSSID"
nmcli connection up "$SSID" --ask
