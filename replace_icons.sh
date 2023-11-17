#!/usr/bin/env bash

# This script replaces icons for applications in the /Applications directory with custom icons.
# It uses the fileicon command line tool (https://github.com/mklement0/fileicon) to set the custom icon for each application.
# It provides options to run in slow mode, force reset dock and finder, and reduce output to a minimum.
# The script iterates through each icon in the icons directory and sets the custom icon for the corresponding application.
# If an error occurs while setting the icon, it is logged in the error_log.txt file.
# At the end, the script displays the total number of icons changed and any errors encountered.

set -u -o pipefail

version='v0.0.1'

slowly=0
force_reset=0
quiet=0

project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
icons_dir="$project_dir/icons"

RED="\033[0;31m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
GREEN="\033[0;32m"
WHITE="\033[1;37m"

ITALIC="\033[3m"
BOLD="\033[1m"
NOCOLOR="\033[0m"

# Function to print the help message
function print_help {
  local project_dir=$1
  echo
  echo -e "${CYAN}Usage:${NOCOLOR} ${YELLOW}$0 [OPTIONS]${NOCOLOR}"
  echo
  echo -e "${CYAN}Options:${NOCOLOR}"
  echo -e "${YELLOW}${ITALIC} -h, --help${NOCOLOR}                  ${GREEN}Show this help message and exit.${NOCOLOR}"
  echo -e "${YELLOW}${ITALIC} -v, --version${NOCOLOR}               ${GREEN}Show the version and exit.${NOCOLOR}"
  echo -e "${YELLOW}${ITALIC} -i, --icons-folder <path>${NOCOLOR}   ${GREEN}Path to the icons folder.${NOCOLOR}"
  echo -e "                             ${GREEN}Default: ${ITALIC}${WHITE}$project_dir/icons${NOCOLOR}"
  echo -e "${YELLOW}${ITALIC} -f, --force-reset${NOCOLOR}           ${GREEN}Force dock and finder to restart after replacing the icons.${NOCOLOR}"
  echo -e "${YELLOW}${ITALIC} -s, --slow ${NOCOLOR}                 ${GREEN}Run in slow mode.${NOCOLOR}"
  echo -e "                             ${GREEN}It will ask the user for input after each icon is replaced.${NOCOLOR}"
  echo -e "${YELLOW}${ITALIC} -q, --quiet${NOCOLOR}                 ${GREEN}Reduce the output to a minimum.${NOCOLOR}"
  echo
}

# Parse command line options
while (( "$#" )); do
  case "$1" in
    -v|--version)
      echo -e "${YELLOW}$version${NOCOLOR}"
      exit 0
      ;;
    -f|--force-reset)
      force_reset=1
      ;;
    -s|--slow)
      echo -e "${YELLOW}Running in slow mode${NOCOLOR}"
      slowly=1
      ;;
    -q|--quiet)
      quiet=1
      ;;
    -i|--icons-folder)
      shift
      # check if the argument is provided
      if [ $# -eq 0 ]; then
        echo
        echo -e "${RED}missing <path> argument for -i option${NOCOLOR}"
        print_help $project_dir
        exit 1
      fi
      icons_dir="$1"
      ;;
    -h|--help)
      print_help $project_dir
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      print_help $project_dir
      exit 1
      ;;
  esac
  shift
done

total_icons_changed=0
total_errors=0

# Clear error log file
echo "" > "$project_dir/error_log.txt"
echo "Replacing icons ... "
echo "Please wait ... (depending on the number of icons, this may take a while)"

# Iterate through each icon file in the icons directory
for file in "$icons_dir"/*; do
    filename=$(basename "${file%.*}")
    extension="${file##*.}"

    full_custom_icon_path="$icons_dir/${filename}.${extension}"

    app_path="/Applications/${filename}.app"
    app_resources_path="$app_path/Contents/Resources"

    # Check if the application resources directory exists
    if [ -d "${app_resources_path}" ]; then
        if [ $quiet -eq 0 ]; then
            echo -e "${YELLOW}Setting custom icon for \"$filename\" ...${NOCOLOR}"
        fi
        output=$(fileicon set "$app_path" "$full_custom_icon_path" 2>&1)

        # If an error occurs while setting the icon, log it in the error_log.txt file
        if [ $? -ne 0 ]; then
            if [ $quiet -eq 0 ]; then
                echo -e "${RED}$output${NOCOLOR}"
            fi
            echo "$(date) $output" >> "$project_dir/error_log.txt"
            total_errors=$((total_errors+1))
        else
            total_icons_changed=$((total_icons_changed+1))
        fi
    fi

    # If running in slow mode, ask for user input before continuing to the next icon
    if [ $slowly -eq 1 ]; then
        read -p "Press [Enter] key to continue ..."
    fi
done

# If force reset option is enabled, restart dock and finder
if [ $force_reset -eq 1 ]; then
    echo "Restarting dock and finder ..."
    killall Dock
    killall Finder
fi

# Display the total number of icons changed and any errors encountered
echo -e "____________________________"
echo -n -e "${YELLOW}Total icons changed: $total_icons_changed${NOCOLOR}"
if [ $total_errors -eq 0 ]; then
    echo -e "\033[32m (no errors)${NOCOLOR}"
else
    echo -e "\n${RED}Total errors: $total_errors (see error_log.txt)${NOCOLOR}\n"
fi
