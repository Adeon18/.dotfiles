#!/bin/bash
#
# A rice install script that replaces all of the inportant configs with the rice configs.
# ./install.sh -h for help

readonly DEP_FILE="dependencies.txt"
readonly SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

ignore_uninstalled=false
install_if_uninstalled=false
default=false
installed_dependancies=()

# Checks if a program is installed
# Arguments: program_name
# Returns: 0 if exists, 1 if does not
check_for_existance() {
  if (( $# == 0 )); then
    echo "ERROR: check_for_existance function needs a program name to run"
  fi

  if [[ $(command -v "$1") ]]; then
    return 0
  else
    return 1
  fi
}

# Manages the config files of all valid dependancies
# If links exists, relinks them if they are older than configs(useless, but let it be).
# If it does not, removes current config and links the needed one.
# If there is no config, creates everything needed for one.
# Arguments:
#   $1 a directory for the config
#   $2 config file name
# Returns:
#   none
manage_configs() {
  if (( $# < 2 )); then
    echo "ERROR: Not enough arguments for manage_configs call"
  fi

  echo -n "Setting configs for $1..."
  sleep 0.1
  local conf_path
  conf_path="${HOME}/.config/$1/$2"

  if ! [[ -d "${HOME}/.config/$1" ]]; then
    mkdir -p "${HOME}/.config/$1"
  fi
  if [[ -f "$conf_path" ]]; then
    if [[ -L "$conf_path" ]]; then
      # if [[ "${SCRIPT_DIR}/$1/$2" -nt "$conf_path" ]]; then
        rm "$conf_path"
        ln -s "${SCRIPT_DIR}/$1/$2" "$conf_path"
      # fi
    else
      rm "$conf_path"
      ln -s "${SCRIPT_DIR}/$1/$2" "$conf_path"
    fi
  else
    ln -s "${SCRIPT_DIR}/$1/$2" "$conf_path"
  fi

  echo "Done"
}

# Manage script options
if (( $# != 0 )); then
  case $1 in
    -i | --ignore-uninstalled)
      ignore_uninstalled=true
      ;;
    -I | --install-uninstalled)
      install_if_uninstalled=true
      ;;
    -h | --help)
      echo "Usage: ./install.sh [option]
    Options:
      -h      --help                  Show help message.
      -i      --ignore-uninstalled    Configure only installed dependancies.
      -h      --install-uninstalled   Install dependancies if uninstalled and configure all.
      -d      --default               Default installation, halts if sees an unisntalled dependancy."
      exit 0
      ;;
    -d | --default)
      default=true
      ;;
    *)
      echo "Invalid option: $1. Use ./install.sh -h to see available options."
      exit 0
      ;;
  esac
else
  echo "Please provide an option. To view all options run ./install.sh -h"
  exit 0
fi

# Manage dependancies
while read dependancy
do
  check_for_existance ${dependancy}
  if (( $? != 0 )); then
    if [[ "$default" == true ]]; then
      echo "Dependency ${dependancy} is NOT installed. Please install it and run the script again."
      exit 0
    elif [[ "$ignore_uninstalled" == true ]]; then
      echo "Ignoring ${dependancy} as it is NOT installed."
    elif [[ "$install_if_uninstalled" == true ]]; then
      echo "No dependancy ${dependancy}, here should be installation code... "
    fi
  else
    installed_dependancies+=(${dependancy})
    echo "Dependency ${dependancy} is installed"
  fi
  sleep 0.1
done < ${DEP_FILE}

echo "-----------"
# Connecting all the configs
for dep in "${installed_dependancies[@]}"
do
  if [[ "$dep" == "bspwm" ]] || [[ "$dep" == "sxhkd" ]] || [[ "$dep" == "dunst" ]]; then
    manage_configs "$dep" "${dep}rc"
  elif [[ "$dep" == "kitty" ]]; then
    manage_configs "$dep" "${dep}.conf"
    manage_configs "$dep" "current-theme.conf"
  elif [[ "$dep" == "rofi" ]]; then
    manage_configs "$dep" "config.rasi"
  elif [[ "$dep" == "polybar" ]]; then
    manage_configs "$dep" "config"
  elif [[ "$dep" == "neofetch" ]]; then
    manage_configs "$dep" "config.conf"
  fi
  sleep 0.2
done

echo "-----------"
echo "Everything has been configured! Enjoy!"