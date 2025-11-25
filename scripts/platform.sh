#!/usr/bin/env bash

# Detect the current platform and export DOTFILES_PLATFORM so that other
# scripts can share the same logic without reimplementing detection.
dotfiles_detect_platform() {
    local uname_out="${1:-$(uname -s 2>/dev/null)}"
    local platform="generic"

    case "$uname_out" in
        Darwin*)
            platform="macos"
            ;;
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                platform="wsl"
            else
                platform="linux"
            fi
            ;;
    esac

    printf "%s" "$platform"
}

dotfiles_export_platform() {
    if [ -z "${DOTFILES_PLATFORM:-}" ]; then
        DOTFILES_PLATFORM="$(dotfiles_detect_platform)"
    fi
    export DOTFILES_PLATFORM
}

dotfiles_is_macos() {
    dotfiles_export_platform >/dev/null
    [ "${DOTFILES_PLATFORM:-}" = "macos" ]
}

dotfiles_is_wsl() {
    dotfiles_export_platform >/dev/null
    [ "${DOTFILES_PLATFORM:-}" = "wsl" ]
}

dotfiles_is_linux() {
    dotfiles_export_platform >/dev/null
    [ "${DOTFILES_PLATFORM:-}" = "linux" ]
}
