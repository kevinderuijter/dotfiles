#!/usr/bin/env bash

# This script sets up the YubiKey II permissions and GnuPG settings.
# - Create UDEV rules for YubiKey II.
# - Create Polkit rules for PC/SC devices.
# - Install SmartCard daemon.
# - Copy GnuPG settings.

# Exit on error.
set -e

# Log function
log() {
    local log_level=$1
    shift
    local log_message=$@
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$(basename "$0")] [$LOGFILE] [$timestamp] [$log_level] $log_message" | tee -a $LOGFILE
}

# Check if the script is being run on Ubuntu.
# If not, show a warning message.
if grep -q "Ubuntu" /etc/os-release || ! test -f /etc/os-release; then
    log "WARNING" "This script has only been tested on Ubuntu 24.04 LTS."
    # Ask the user if they want to continue.
    read -p "Do you want to continue? [y/N]: " answer
    if [[ ! $answer =~ ^[Yy]$ ]]; then
        log "INFO" "Exiting the script."
        exit 0
    fi
fi

# Set the file for the log output.
if [ -z "$LOGFILE" ]; then
    LOGFILE="/tmp/$(basename "$0").log"
fi

# Show a message that logs are written to the log file.
log "INFO" "Logs are written to $LOGFILE"

# Check if the script is being run as root
if [[ $EUID -eq 0 ]]; then
   echo "[ERROR] This script must not be run as root" 
   exit 1
fi

# Get the absolute path for the parent directory of the script.
directory=$(dirname "$(realpath "$0")")

# Get the path to the dotfiles directory relative of the script.
dotfolder=$(dirname "$directory")

# Create UDEV rules for YubiKey II.
log "INFO" "Creating UDEV rules for YubiKey II"
chmod 700 $dotfolder/yubikey/udev/69-yubikey.sh
$dotfolder/yubikey/udev/69-yubikey.sh

# Create Polkit rules for PC/SC devices.
log "INFO" "Creating Polkit rules for PC/SC devices"
chmod 700 $dotfolder/yubikey/polkit/02-pcsc.sh
$dotfolder/yubikey/polkit/02-pcsc.sh

# Install SmartCard daemon.
log "INFO" "Installing scdaemon and pcscd."
sudo apt-get install -yqq scdaemon pcscd
sudo systemctl daemon-reload

# Copy GnuPG settings.
log "INFO" "Copying GnuPG scdaemon.conf"
mkdir -p $HOME/.gnupg
cp $dotfolder/yubikey/gnupg/scdaemon.conf $HOME/.gnupg/scdaemon.conf

# Set safe permissions for .gnupg folder.
log "INFO" "Settings correct permissions on $HOME/.gnupg"
chmod 700 $HOME/.gnupg