#!/bin/bash
set -euo pipefail

if [ "$(uname -s)" != Darwin ]; then
    printf 'macOS is required.\n' >&2
    exit 1
fi

if [ ! -d /Applications/iTerm.app ] && [ ! -d "$HOME/Applications/iTerm.app" ]; then
    printf 'iTerm2 is not installed. Skipping its preferences.\n'
    exit 0
fi

domain=com.googlecode.iterm2
profile="$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"
guid="$(plutil -extract Profiles.0.Guid raw -o - "$profile")"

if [ "$(defaults read "$domain" 'Default Bookmark Guid' 2>/dev/null || true)" = "$guid" ] &&
   [ "$(defaults read "$domain" PromptOnQuit 2>/dev/null || true)" = 0 ]; then
    printf 'iTerm2: Dotfiles is the default profile and quit confirmation is disabled.\n'
    exit 0
fi

# Check the GUI session without sending iTerm2 any events.
running="$(osascript -l JavaScript -e 'ObjC.import("AppKit"); $.NSRunningApplication.runningApplicationsWithBundleIdentifier("com.googlecode.iterm2").count')"
if [ "$running" != 0 ]; then
    printf 'Quit iTerm2 when your sessions are safe to close, then run ./scripts/iterm2-preferences.sh from Terminal.\n' >&2
    exit 1
fi

defaults write "$domain" 'Default Bookmark Guid' -string "$guid"
defaults write "$domain" PromptOnQuit -bool false

if [ "$(defaults read "$domain" 'Default Bookmark Guid')" != "$guid" ] ||
   [ "$(defaults read "$domain" PromptOnQuit)" != 0 ]; then
    printf 'Could not verify the iTerm2 preferences.\n' >&2
    exit 1
fi
printf 'iTerm2: Dotfiles selected as default and quit confirmation disabled.\n'
