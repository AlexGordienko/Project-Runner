#!/usr/bin/env bash

# Written by Alex Gordienko - 2022
# Based on the boilerplate of Maciej Radzikowski (https://gist.github.com/m-radzikowski/53e0b39e9a59a1518990e76c2bff8038)

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# Grab system aliases
shopt -s expand_aliases
source ~/.bash_aliases

# Local Variables
file_path=""

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]
This script handles setting up your workspace for all Preston Lab projects.
Available options:
-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-c, --current   Print current supported projects.
-p, --project   The name of the project you are trying to activate.
EOF
  exit
}

current_projects() {
  msg "${BLUE}----------------------------${NOFORMAT}"
  msg "Current Supported Projects:"
  msg "- ${GREEN}Project 1${NOFORMAT}"
  msg "- ${YELLOW}TODO: project 2${NOFORMAT}"
  msg "${BLUE}----------------------------${NOFORMAT}"
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

setup_colors

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -c | --current) current_projects ;;
    -p | --project)
      project="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${project-}" ]] && die "Missing required parameter: project"
  # [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"

# script logic here

case "${project}" in
  "project-name")
    msg "Setting up your workspace for ${GREEN}Project Name${NOFORMAT}."
    msg "Opening Application"
    # Open Logic
    ;;

  "unfinished-project")
    msg "${YELLOW}This project has not been defined yet. ${NOFORMAT}"
    ;;

  *)
    msg "${RED}There is no such project defined. ${NOFORMAT}"
    ;;
esac
