#!/usr/bin/env bash

#
# Author:       Kevin de Ruijter
# Date:         2024-06-09
# Description:  Script installs git hooks to current repository.
#

# Log function
log() {
   if [ -z "$LOGFILE" ]; then
      LOGFILE="/tmp/$(basename "$0").log"
   fi
    local log_level=$1
    shift
    local log_message=$@
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$(basename "$0")] [$LOGFILE] [$timestamp] [$log_level] $log_message" | tee -a $LOGFILE
}

configure() {
  # Get the absolute path for the parent directory of the script.
  directory=$(dirname "$0" | xargs realpath)
  
  # Copy the pre-push and verify-commit hooks to the .git/hooks directory.
  cp $directory/pre-push $PWD/.git/hooks/pre-push
  log "INFO" "Copied pre-push hook to $PWD/.git/hooks"
  
  # Copy the commit-msg hook to the .git/hooks directory.
  cp $directory/commit-msg $PWD/.git/hooks/commit-msg
  log "INFO" "Copied commit-msg hook to $PWD/.git/hooks"

  # Make all hooks executable.
  chmod +x ./.git/hooks/*
  log "INFO" "Made all hooks executable"

  # Check if webflow user GPG key is present.
  if ! gpg --list-keys | grep -q "web-flow"; then
    # Importing GitHub's webflow user GPG key.
    curl -s https://github.com/web-flow.gpg | gpg --import > /dev/null 2>&1
    log "INFO" "Imported GitHub's webflow user GPG key"
  fi
}

# Make sure the script is not run as root.
if [[ $EUID -eq 0 ]]; then
   log "ERROR" "This script should not be run as root, please run it as a regular user."
   exit 1
fi

# Asks the user for confirmation before copying hooks.
echo "Going to install Git Hooks to $PWD/.git/hooks"
echo
echo "The 'git verify-commit HEAD' requires your public GPG key to be present."
echo "If you have uploaded you public key to github, you can import it."
echo "This can be done using: curl https://github.com/username.gpg | gpg --import"
echo
read -p "Are you sure you want to continue? (y/n): " choice

case "$choice" in 
  yes|Yes|y|Y )
    configure
    ;;
  no|No|n|N )
    echo "Operation aborted."
    exit 1
    ;;
  * )
    echo "Invalid input. Please enter yes or no."
    exit 1
    ;;
esac