#!/usr/bin/env bash
#
# Use wofi/zenity to change power profile via power-profiles-daemon.
#
# Adapted for Sway (swaymsg) from the original i3/rofi version.
# Inspired from i3pystatus wiki:
# https://github.com/enkore/i3pystatus/wiki/Shutdown-Menu
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# power-profiles-daemon implementation:
# needs package power-profiles-daemon installed and the service running, see:
# https://wiki.archlinux.org/title/CPU_frequency_scaling#power-profiles-daemon
# used in waybar custom module / i3blocks together with: ppd-status


#######################################################################
#                            BEGIN CONFIG                             #
#######################################################################

# wofi options. Styling (colors, borders, etc.) goes in
# ~/.config/wofi/style.css and ~/.config/wofi/config, not here.
WOFI_PROMPT="Power Profile"
WOFI_OPTIONS=(--insensitive --cache-file /dev/null)

# Zenity options (fallback)
ZENITY_TITLE="Power Profiles"
ZENITY_TEXT="Set Profile:"
ZENITY_OPTIONS=(--column= --hide-header)

#######################################################################
#                             END CONFIG                              #
#######################################################################

# Whether to ask for user's confirmation
enable_confirmation=false

# Preferred launcher if both are available
preferred_launcher="wofi"

usage="$(basename "$0") [-h] [-c] [-p name] -- display a menu to change power profile.

where:
    -h  show this help text
    -c  ask for user confirmation
    -p  preferred launcher (wofi or zenity)

This script depends on:
  - systemd,
  - power-profiles-daemon,
  - sway (swaymsg),
  - wofi or zenity."

# Check whether the user-defined launcher is valid
launcher_list=(wofi zenity)
function check_launcher() {
  if [[ ! "${launcher_list[@]}" =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
    echo "Supported launchers: ${launcher_list[*]}"
    exit 1
  else
    # Get array with unique elements and preferred launcher first
    # Note: uniq expects a sorted list, so we cannot use it
    i=1
    launcher_list=($(for l in "$1" "${launcher_list[@]}"; do printf "%i %s\n" "$i" "$l"; let i+=1; done \
      | sort -uk2 | sort -nk1 | cut -d' ' -f2- | tr '\n' ' '))
  fi
}

# Parse CLI arguments
while getopts "hcp:" option; do
  case "${option}" in
    h) echo "${usage}"
       exit 0
       ;;
    c) enable_confirmation=true
       ;;
    p) preferred_launcher="${OPTARG}"
       check_launcher "${preferred_launcher}"
       ;;
    *) exit 1
       ;;
  esac
done

# Check whether a command exists
function command_exists() {
  command -v "$1" &> /dev/null 2>&1
}

# systemctl and powerprofilesctl required
if ! command_exists systemctl || ! command_exists powerprofilesctl ; then
  exit 1
fi

# default_menu_options defined as an associative array
typeset -A default_menu_options

# The default options with keys/commands
default_menu_options=(
  [" Performance"]="powerprofilesctl set performance"
  [" Balanced"]="powerprofilesctl set balanced"
  [" Power Saver"]="powerprofilesctl set power-saver"
  [" Cancel"]=""
)

# The menu that will be displayed
typeset -A menu
menu=()

# Only add power profiles that are available to menu
for key in "${!default_menu_options[@]}"; do
  grep_arg=${default_menu_options[${key}]##* }
  if [[ "${grep_arg}" == "" ]] || powerprofilesctl list | grep -q "$grep_arg"; then
    menu[${key}]=${default_menu_options[${key}]}
  fi
done
unset grep_arg
unset default_menu_options

menu_nrows=${#menu[@]}

# Menu entries that may trigger a confirmation message
menu_confirm=""

launcher_exe=""
launcher_options=()

function prepare_launcher() {
  if [[ "$1" == "wofi" ]]; then
    launcher_exe="wofi"
    launcher_options=(--dmenu --prompt "${WOFI_PROMPT}" --lines "${menu_nrows}" "${WOFI_OPTIONS[@]}")
  elif [[ "$1" == "zenity" ]]; then
    launcher_exe="zenity"
    launcher_options=(--list --title="${ZENITY_TITLE}" --text="${ZENITY_TEXT}" \
        "${ZENITY_OPTIONS[@]}")
  fi
}

for l in "${launcher_list[@]}"; do
  if command_exists "${l}" ; then
    prepare_launcher "${l}"
    break
  fi
done

# No launcher available
if [[ -z "${launcher_exe}" ]]; then
  exit 1
fi

launcher=("${launcher_exe}" "${launcher_options[@]}")
selection="$(printf '%s\n' "${!menu[@]}" | sort | "${launcher[@]}")"

# Trim trailing whitespace/newline that wofi sometimes adds
selection="${selection%$'\n'}"
selection="$(echo -n "${selection}" | sed 's/[[:space:]]*$//')"

function ask_confirmation() {
  if [ "${launcher_exe}" == "wofi" ]; then
    confirmed="$(printf 'Yes\nNo\n' | wofi --dmenu --prompt "${selection}?" --lines 2 "${WOFI_OPTIONS[@]}")"
    confirmed="$(echo -n "${confirmed}" | sed 's/[[:space:]]*$//')"
    [ "${confirmed}" == "Yes" ] && confirmed=0 || confirmed=1
  elif [ "${launcher_exe}" == "zenity" ]; then
    zenity --question --text "Are you sure you want to ${selection,,}?"
    confirmed=$?
  fi

  if [ "${confirmed}" == 0 ]; then
    swaymsg -q exec "${menu[${selection}]}"
  fi
}

if [[ -n "${selection}" && -n "${menu[${selection}]+x}" ]]; then
  if [[ -n "${menu[${selection}]}" ]]; then
    if [[ "${enable_confirmation}" = true && \
          ${menu_confirm} =~ (^|[[:space:]])"${selection}"($|[[:space:]]) ]]; then
      ask_confirmation
    else
      swaymsg -q exec "${menu[${selection}]}"
    fi
  fi
fi
