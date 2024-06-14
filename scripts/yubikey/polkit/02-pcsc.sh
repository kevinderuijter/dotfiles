#!/usr/bin/env bash

#
# Author:       Kevin de Ruijter
# Date:         2024-06-09
# Description:  This script creates Polkit rules required to access PC/SC 
#               devices like a YubiKey. This is required for things like GnuPG
#               cards to work.
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

# Check if the script is being run as root
if [[ $EUID -eq 0 ]]; then
   log "ERROR" "This script should not be run as root, please run it as a regular user."
   exit 1
fi

# Path to the polkit PC/SC rules template.
rules="$(dirname "$0" | xargs realpath)/02-pcsc.rules"
log "INFO" "Using Polkit PC/SC rules template: $rules"

# Target folder for Polkit rules.
target=/usr/share/polkit-1/rules.d/02-pcsc.rules

# Create temporary file to replace placeholder with current user.
# This is to prevent replacing anything unintended already in target file.
tempfile=$(mktemp)
log "INFO" "Temporary file created: $tempfile"

# Write the rules to the tempfile.
cp "$rules" "$tempfile"
log "INFO" "Copied rules to temporary file: $tempfile"

# Replace placeholder with the current user
sudo sed -i "s/placeholder/$USER/g" "$tempfile"
log "INFO" "Replaced placeholder with current user: $USER"

# Check if the content of tempfile is already present in $target
if test -f $target && grep -qFf "$tempfile" "$target"; then
  log "WARNING" "Polkit PC/SC rules already present in $target, skipping."
else
  # Append required PC/SC rules to the polkit 02-pcsc.rules.
  cat "$tempfile" | sudo tee -a "$target" > /dev/null
  log "INFO" "Appended Polkit PC/SC rules to $target"
fi

# Set the appropriate permissions
sudo chmod 644 "$target"
log "INFO" "Set permissions on $target to 644"

# Reload Polkit rules.
sudo systemctl daemon-reload
sudo systemctl restart polkit
log "INFO" "Reloaded Polkit rules"


