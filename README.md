# Dotfiles

Welcome to my dotfiles repository.

## Table of Contents

- [Dotfiles](#dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Dotfiles](#dotfiles-1)
  - [YubiKey](#yubikey)
  - [GitHub](#github)

## Dotfiles

The following dotfiles are included.

- [~/.gitconfig](dotfiles/.gitconfig)
- [~/.aliasrc](dotfiles/.aliasrc)
- [~/.config/atuin/config.toml](dotfiles/.config/atuin/config.toml)
- [~/.config/lscolors.sh](dotfiles/.config/lscolors.sh)
- [~/.vimrc](dotfiles/.vimrc)

## YubiKey

I've had trouble accesing my YubiKey from an SSH session on my virtual Ubuntu 24.04 machine.  
Some of the errors that occured were:

- Unable to load resident keys: device not found.
- ERROR: Failed to connect to YubiKey.
- OpenPGP card not available: No such device

The following solutions are executed by the script.

- [Polkit](scripts/yubikey/polkit/): configuration of Polkit rules for accessing PC/SC devices.
- [Udev](scripts/yubikey/udev/): configuration of Udev rules for accessing Yubico Yubikey II device.
- [GnuPG](scripts/yubikey/gnupg/): configuration of .gnupg/scdaemon.conf for preventing CCID conflicts.
- [Bashrc](dotfiles/.bashrc): specify TTY in $GPG_TTY.

## GitHub

To enforce [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) I've created a few git hooks
that can be installed using [hooks.sh](scripts/github/hooks/hooks.sh).

- [commit-msg](scripts/github/hooks/commit-msg)
  - Check if the commit is signed.
  - Check if the commit conforms to conventional commits.
- [pre-push](scripts/github/hooks/pre-push)
  - Check if the branch name conforms to naming conventions.
  - Check if the tag conforms to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
