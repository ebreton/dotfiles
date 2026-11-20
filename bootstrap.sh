#!/bin/bash
set -euo pipefail

usage() {
    printf 'Usage: %s [plan|install|apply] [--development]\n' "$0"
    printf '  plan      Review packages and dotfile changes (default)\n'
    printf '  install   Install packages and initialize chezmoi if necessary\n'
    printf '  apply     Deploy dotfiles and configure Git and GitHub CLI\n'
}

action=${1:-plan}
case $action in
    -h|--help) usage; exit 0 ;;
    plan|install|apply) ;;
    *) usage >&2; exit 2 ;;
esac
development=false
case ${2:-} in
    '') ;;
    --development)
        if [ "$action" = apply ]; then usage >&2; exit 2; fi
        development=true
        ;;
    *) usage >&2; exit 2 ;;
esac
if [ "$#" -gt 2 ]; then usage >&2; exit 2; fi

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
if [ "$(uname -s)" != Darwin ] || ! xcode-select -p >/dev/null 2>&1; then
    printf 'macOS with Apple Command Line Tools is required. See README.md.\n' >&2
    exit 1
fi

case $(uname -m) in
    arm64) brew=/opt/homebrew/bin/brew ;;
    x86_64) brew=/usr/local/bin/brew ;;
    *) printf 'Unsupported architecture.\n' >&2; exit 1 ;;
esac
if [ ! -x "$brew" ]; then
    printf 'Homebrew is required. See README.md.\n' >&2
    exit 1
fi
brew_setup="$("$brew" shellenv bash)"
eval "$brew_setup"
export HOMEBREW_NO_AUTO_UPDATE=1

manifests=("$root/Brewfile")
if "$development"; then
    manifests+=("$root/brew/Brewfile.development")
fi

if [ "$action" = plan ]; then
    for manifest in "${manifests[@]}"; do
        printf '\n--- %s ---\n' "$manifest"
        cat "$manifest"
    done
    if command -v chezmoi >/dev/null 2>&1; then
        chezmoi --source "$root" --no-pager diff
    else
        printf '\nInstall chezmoi to preview the dotfile diff.\n'
    fi
    exit 0
fi

if [ "$action" = install ]; then
    for manifest in "${manifests[@]}"; do
        "$brew" bundle install --no-upgrade --file "$manifest"
    done
fi

# Chezmoi supports multiple formats. Let it resolve the selected config file.
config_file="$(chezmoi execute-template '{{ .chezmoi.configFile }}')"
if [ ! -f "$config_file" ]; then
    chezmoi --source "$root" init
fi
configured_source="$(chezmoi execute-template '{{ .chezmoi.workingTree }}')"
if [ ! -d "$configured_source" ] ||
   [ "$(cd -- "$configured_source" && pwd -P)" != "$root" ]; then
    printf 'chezmoi sourceDir must point to %s. Review %s.\n' "$root" "$config_file" >&2
    exit 1
fi

if [ "$action" = install ]; then
    printf 'Packages ready. Review ./bootstrap.sh plan before ./bootstrap.sh apply.\n'
    exit 0
fi

git_bin="${brew%/bin/brew}/bin/git"
if [ ! -x "$git_bin" ] || ! command -v gh >/dev/null 2>&1; then
    printf 'Homebrew Git and GitHub CLI are required. Run ./bootstrap.sh install.\n' >&2
    exit 1
fi

chezmoi apply
# Git expands the tilde when resolving the include.
# shellcheck disable=SC2088
git_include='~/.config/git/dotfiles.inc'
if ! "$git_bin" config --global --fixed-value --get-all include.path "$git_include" >/dev/null; then
    "$git_bin" config --global --add include.path "$git_include"
fi
gh config set git_protocol ssh --host github.com
