# This script finds the strongest access point in a network and connects to it with NetworkManager

# Prompt the user to enter the SSID
SSID=`kdialog --title "Access Point Connection" --inputbox "Please enter the SSID: "`

if [ -z "$SSID" ]; then
    kdialog --error "SSID cannot be empty"
    exit 1
fi

nmcli device wifi rescan

SSID_EXISTS=$(nmcli -t -f SSID device wifi list | awk -v ssid="$SSID" -F ':' '$1 == ssid {print $1}')

if [ -z "$SSID_EXISTS" ]; then
    kdialog --error "SSID '$SSID' not found in the list of available networks."
    exit 1
fi

# Check for the access point with the strongest signal
STRONGEST_BSSID=$(nmcli -f SSID,BSSID,SIGNAL device wifi list | grep "$SSID" | sort -k3 -nr | head -n1 | awk '{print $2}')

nmcli connection modify "$SSID" wifi.bssid "$STRONGEST_BSSID"
nmcli connection up "$SSID" --ask
