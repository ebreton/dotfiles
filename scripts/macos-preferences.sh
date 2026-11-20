#!/bin/bash
set -euo pipefail

if [ "$(uname -s)" != Darwin ]; then
    printf 'macOS is required.\n' >&2
    exit 1
fi

mode=${1:---preview}
if [ "$#" -gt 1 ] || { [ "$mode" != --preview ] && [ "$mode" != --apply ]; }; then
    printf 'Usage: %s [--preview|--apply]\n' "$0" >&2
    exit 2
fi

preference() {
    local domain="$1" key="$2" expected="$3" type="$4" value="$5"
    local current
    if ! current="$(defaults read "$domain" "$key" 2>/dev/null)"; then
        current='(unavailable)'
    fi

    if [ "$current" = "$expected" ]; then
        printf '%s %s: %s (already set)\n' "$domain" "$key" "$current"
    elif [ "$mode" = --preview ]; then
        printf '%s %s: %s -> %s (would change)\n' "$domain" "$key" "$current" "$expected"
    else
        defaults write "$domain" "$key" "$type" "$value"
        if ! current="$(defaults read "$domain" "$key")" || [ "$current" != "$expected" ]; then
            printf 'Could not verify %s %s: expected %s, read %s\n' "$domain" "$key" "$expected" "$current" >&2
            return 1
        fi
        printf '%s %s: %s (written and verified)\n' "$domain" "$key" "$current"
        changed=true
    fi
}

restart_if_changed() {
    if "$changed" && ! killall "$1" 2>/dev/null; then
        printf 'Could not restart %s. Reopen it or sign out and back in to refresh the UI.\n' "$1" >&2
    fi
}

changed=false
preference com.apple.finder ShowPathbar 1 -bool true
preference com.apple.finder ShowStatusBar 1 -bool true
preference com.apple.finder FXPreferredViewStyle Nlsv -string Nlsv
restart_if_changed Finder

changed=false
preference com.apple.dock show-recents 0 -bool false
restart_if_changed Dock
