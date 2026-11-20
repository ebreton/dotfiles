#!/bin/bash
set -euo pipefail

if [ "$(uname -s)" != Darwin ]; then
    printf 'macOS is required.\n' >&2
    exit 1
fi

case ${1:-} in
    ''|--preview)
        cat <<'SETTINGS'
Finder: show the path and status bars, use list view.
Dock: hide recent applications.
Run with --apply to write these user preferences and restart Finder and Dock.
SETTINGS
        ;;
    --apply)
        defaults write com.apple.finder ShowPathbar -bool true
        defaults write com.apple.finder ShowStatusBar -bool true
        defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
        defaults write com.apple.dock show-recents -bool false
        killall Finder 2>/dev/null || true
        killall Dock 2>/dev/null || true
        ;;
    *) printf 'Usage: %s [--preview|--apply]\n' "$0" >&2; exit 2 ;;
esac
