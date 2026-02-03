#!/usr/bin/env bash
set -euo pipefail

lock_cmd=""
if command -v swaylock >/dev/null 2>&1; then
  lock_cmd="swaylock -f"
elif command -v hyprlock >/dev/null 2>&1; then
  lock_cmd="hyprlock"
fi

choices=()
[ -n "$lock_cmd" ] && choices+=("Lock")
choices+=("Suspend" "Reboot" "Poweroff" "Logout")

selection=$(printf "%s\n" "${choices[@]}" | wofi --show dmenu --prompt "Power Menu" --insensitive || true)

case "$selection" in
  "Lock")
    [ -n "$lock_cmd" ] && eval "$lock_cmd" &
    ;;
  "Suspend")
    systemctl suspend
    ;;
  "Reboot")
    systemctl reboot
    ;;
  "Poweroff")
    systemctl poweroff
    ;;
  "Logout")
    hyprctl dispatch exit
    ;;
  *)
    exit 0
    ;;

esac
