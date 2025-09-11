#!/bin/bash

# Rofi power menu with same style as Windows+D
options="🔒 Lock\n🚪 Logout\n💤 Suspend\n❄️ Hibernate\n🔄 Reboot\n⚡ Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" \
    -theme-str 'window { width: 60%; }' \
    -theme-str 'listview { columns: 6; lines: 1; fixed-height: true; }' \
    -theme-str 'element { orientation: vertical; padding: 12px; spacing: 6px; border-radius: 20px; }' \
    -theme-str 'element-text { font: "Fira Code SemiBold 12"; vertical-align: 0.5; horizontal-align: 0.5; }')

case $chosen in
    "🔒 Lock")
        $HOME/.config/hypr/scripts/LockScreen.sh
        ;;
    "🚪 Logout")
        loginctl kill-session $XDG_SESSION_ID
        ;;
    "💤 Suspend")
        systemctl suspend
        ;;
    "❄️ Hibernate")
        systemctl hibernate
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "⚡ Shutdown")
        systemctl poweroff
        ;;
esac