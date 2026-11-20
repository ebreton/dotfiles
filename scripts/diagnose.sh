#!/bin/bash
set -eu

sw_vers
uname -m
printf 'Shell de connexion déclaré : %s\n' "${SHELL:-inconnu}"
for tool in brew git chezmoi starship gh shellcheck pyenv poetry python3 code; do
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
fi
if command -v gh >/dev/null 2>&1; then
    printf 'Transport gh pour GitHub : '
    gh config get git_protocol --host github.com
fi
if command -v poetry >/dev/null 2>&1; then
    printf 'Poetry virtualenvs.in-project : '
    poetry config virtualenvs.in-project
fi
