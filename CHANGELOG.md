# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Table of Contents

- [Changelog](#changelog)
  - [Table of Contents](#table-of-contents)
  - [\[0.0.2\] - 2024-06-14](#002---2024-06-14)
    - [Added](#added)
    - [Changed](#changed)
  - [\[0.0.1\] - 2024-06-14](#001---2024-06-14)
    - [Added](#added-1)

## [0.0.2] - 2024-06-14

### Added

- [~/.gitconfig](dotfiles/.gitconfig)
- [~/.aliasrc](dotfiles/.aliasrc)
- [~/.config/atuin/config.toml](dotfiles/.config/atuin/config.toml)
- [~/.config/lscolors.sh](dotfiles/.config/lscolors.sh)
- [~/.vimrc](dotfiles/.vimrc)

### Changed

- Source [~/.config/lscolors.sh](dotfiles/.config/lscolors.sh) in [~/.bashrc](dotfiles/.bashrc)

## [0.0.1] - 2024-06-14

### Added

- YubiKey configuration [script](scripts/yubikey/yubikey.sh) for Ubuntu 24.04.
  - [Polkit](scripts/yubikey/polkit/): configuration of Polkit rules for accessing PC/SC devices.
  - [Udev](scripts/yubikey/udev/): configuration of Udev rules for accessing Yubico Yubikey II device.
  - [GnuPG](scripts/yubikey/gnupg/): configuration of .gnupg/scdaemon.conf for preventing CCID conflicts.
  - [Bashrc](dotfiles/.bashrc): specify TTY in $GPG_TTY.
- [Script](scripts/github/hooks/hooks.sh) to install and enforce [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) git hooks
that can be installed using.
  - [commit-msg](scripts/github/hooks/commit-msg)
    - Check if the commit is signed.
    - Check if the commit conforms to conventional commits.
  - [pre-push](scripts/github/hooks/pre-push)
    - Check if the branch name conforms to naming conventions.
    - Check if the tag conforms to [semantic versioning](https://semver.org/spec/v2.0.0.html).