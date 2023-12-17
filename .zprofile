# Load linuxbrew environment variables.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Prevent LC_CTYPE: cannot change locale (UTF-8).
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
