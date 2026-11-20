#!/bin/bash
set -eu

sw_vers
uname -m
printf 'Shell de connexion déclaré : %s\n' "${SHELL:-inconnu}"
for tool in brew git chezmoi starship gh shellcheck pyenv python3 code; do
    if tool_path="$(command -v "$tool")"; then
        printf '%-10s %s\n' "$tool" "$tool_path"
    else
        printf '%-10s absent\n' "$tool"
    fi
done
if command -v chezmoi >/dev/null 2>&1; then
    printf 'Source chezmoi : '
    chezmoi execute-template '{{ .chezmoi.workingTree }}'
    printf '\n'

    profile="$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"
    if [ -f "$profile" ]; then
        if chezmoi verify "$profile"; then
            printf 'Profil iTerm2 Dotfiles : conforme au dépôt\n'
        else
            printf 'Profil iTerm2 Dotfiles : écart ou erreur de vérification\n'
            printf 'Pour examiner le diff : chezmoi diff "%s"\n' "$profile"
        fi
    elif [ -d /Applications/iTerm.app ] || [ -d "$HOME/Applications/iTerm.app" ]; then
        printf 'Profil iTerm2 Dotfiles : fichier local absent\n'
    fi
fi
if command -v gh >/dev/null 2>&1; then
    printf 'Transport gh pour GitHub : '
    gh config get git_protocol --host github.com
fi
