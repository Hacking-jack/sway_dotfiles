#!/bin/bash

# List of options
options="Shutdown\nReboot\nLock\nLogout"

# Pipe to Wofi
choice=$(echo -e "$options" | wofi --dmenu --prompt "Power Menu")

case $choice in
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Lock) swaylock ;;
  Logout) swaymsg exit ;;
esac
