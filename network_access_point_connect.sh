# This script finds the strongest access point in a network and connects to it with NetworkManager

# Prompt the user to enter the SSID
SSID=`kdialog --title "Access Point Connection" --inputbox "Please enter the SSID: "`

if [ -z "$SSID" ]; then
    echo "SSID cannot be empty"
    exit 1
fi

nmcli device wifi rescan

# Check for the access point with the strongest signal
STRONGEST_BSSID=$(nmcli -f SSID,BSSID,SIGNAL device wifi list | grep "$SSID" | sort -k3 -nr | head -n1 | awk '{print $2}')

nmcli connection modify "$SSID" wifi.bssid "$STRONGEST_BSSID"
nmcli connection up "$SSID" --ask
