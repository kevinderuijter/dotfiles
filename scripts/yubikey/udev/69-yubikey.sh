#!/usr/bin/env bash

#
# Author:       Kevin de Ruijter
# Date:         2024-06-09
# Description:  Udev rules for letting the console user access the Yubikey II
#               device node, needed for challenge/response to work correctly.
# Rules:        https://github.com/Yubico/yubikey-personalization/blob/master/69-yubikey.rules
#

# Log function
log() {
    local log_level=$1
    shift
    local log_message=$@
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$(basename "$0")] [$LOGFILE] [$timestamp] [$log_level] $log_message" | tee -a $LOGFILE
}

# Set the file for the log output.
if [ -z "$LOGFILE" ]; then
  LOGFILE="/tmp/$(basename "$0").log"
fi

# Show a message that logs are written to the log file.
log "INFO" "Logs are written to $LOGFILE"

# Check if the script is being run as root
if [[ $EUID -eq 0 ]]; then
   log "ERROR" "This script should not be run as root, please run it as a regular user."
   exit 1
fi

# Path to the UDEV rules template.
rules="$(dirname "$0" | xargs realpath)/69-yubikey.rules"
log "INFO" "Using UDEV rules template: $rules"

# Target folder for UDEV rules.
target=/usr/lib/udev/rules.d/69-yubikey.rules

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
if grep -qFf "$tempfile" "$target" 2>/dev/null; then
  log "WARNING" "UDEV rules already present in $target, skipping."
else
  # Append required PC/SC rules to the polkit 02-pcsc.rules.
  cat "$tempfile" | sudo tee -a "$target" > /dev/null
  log "INFO" "Appended UDEV rules to $target"
fi

# Set the appropriate permissions
sudo chmod 644 "$target"
log "INFO" "Set permissions on $target to 644"

# Reload Udev rules.
sudo udevadm control --reload
sudo udevadm trigger
log "INFO" "Reloaded UDEV rules"